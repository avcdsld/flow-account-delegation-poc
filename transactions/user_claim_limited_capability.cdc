import NonFungibleToken from "NonFungibleToken"
import ExampleNFT from "ExampleNFT"

// User transaction: Claim the published NFT collection capability and revoke capability
// This receives limited access to NFT operations and child account revocation
transaction(providerAddress: Address) {
    prepare(signer: auth(ClaimInboxCapability, Storage) &Account) {
        // Claim the NFT collection capability from inbox
        let nftCapability = signer.inbox.claim<auth(NonFungibleToken.Withdraw) &ExampleNFT.Collection>(
            "NFTCollectionCapability",
            provider: providerAddress
        ) ?? panic("NFT Collection capability not found")

        // Save the NFT capability to storage with a specific path
        signer.storage.save(nftCapability, to: /storage/childNFTCollectionCapability)
        
        // Claim the child account revoke capability from inbox
        let revokeCapability = signer.inbox.claim<auth(RevokeKey) &Account>(
            "ChildAccountRevokeCapability",
            provider: providerAddress
        ) ?? panic("Child account revoke capability not found")

        // Save the revoke capability to storage
        signer.storage.save(revokeCapability, to: /storage/childAccountRevokeCapability)
    }
}