import NonFungibleToken from "NonFungibleToken"
import ExampleNFT from "ExampleNFT"

// Backend transaction: Publish NFT collection capability and revoke capability for user to claim
// This provides limited access to only NFT operations and child account revocation
transaction(recipientAddress: Address) {
    prepare(signer: auth(IssueStorageCapabilityController, IssueAccountCapabilityController, PublishInboxCapability) &Account) {
        // Issue a capability for the NFT collection with Withdraw entitlement only
        let nftCap = signer.capabilities.storage.issue<auth(NonFungibleToken.Withdraw) &ExampleNFT.Collection>(
            ExampleNFT.CollectionStoragePath
        )
        
        // Publish the capability to the recipient's inbox
        signer.inbox.publish(
            nftCap,
            name: "NFTCollectionCapability",
            recipient: recipientAddress
        )

        // Issue a capability that allows revoking child account access
        // This capability provides access to manage child account capabilities
        let revokeCap = signer.capabilities.account.issue<auth(RevokeKey) &Account>()

        // Publish the revoke capability to the recipient's inbox
        signer.inbox.publish(
            revokeCap,
            name: "ChildAccountRevokeCapability",
            recipient: recipientAddress
        )
    }
}