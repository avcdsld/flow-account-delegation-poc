import NonFungibleToken from "NonFungibleToken"
import ExampleNFT from "ExampleNFT"

// User transaction: Claim the published NFT collection capability
// This receives limited access to only NFT operations from the child account
transaction(providerAddress: Address) {
    prepare(signer: auth(ClaimInboxCapability, Storage) &Account) {
        // Claim the NFT collection capability from inbox
        let capability = signer.inbox.claim<auth(NonFungibleToken.Withdraw) &ExampleNFT.Collection>(
            "NFTCollectionCapability",
            provider: providerAddress
        ) ?? panic("NFT Collection capability not found")
        
        // Save the capability to storage with a specific path
        signer.storage.save(capability, to: /storage/childNFTCollectionCapability)
    }
}