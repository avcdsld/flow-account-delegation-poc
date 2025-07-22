import NonFungibleToken from "NonFungibleToken"
import ExampleNFT from "ExampleNFT"

// Backend transaction: Publish NFT collection capability for user to claim
// This provides limited access to only NFT operations, not full account access
transaction(recipientAddress: Address) {
    prepare(signer: auth(IssueStorageCapabilityController, PublishInboxCapability) &Account) {
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
    }
}