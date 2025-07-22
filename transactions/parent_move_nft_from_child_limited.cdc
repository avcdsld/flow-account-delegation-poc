import NonFungibleToken from "NonFungibleToken"
import ExampleNFT from "ExampleNFT"

// Parent account transaction: Transfer NFT using limited capability
// This uses only the NFT collection capability, not full account access
transaction(nftID: UInt64) {
    
    let childNFTCap: Capability<auth(NonFungibleToken.Withdraw) &ExampleNFT.Collection>
    let parentCollection: &ExampleNFT.Collection
    
    prepare(signer: auth(Storage) &Account) {
        // Get the stored NFT collection capability (limited access)
        self.childNFTCap = signer.storage.copy<Capability<auth(NonFungibleToken.Withdraw) &ExampleNFT.Collection>>(
            from: /storage/childNFTCollectionCapability
        ) ?? panic("Child NFT collection capability not found in storage")
        
        // Get parent's NFT collection
        self.parentCollection = signer.storage.borrow<&ExampleNFT.Collection>(
            from: ExampleNFT.CollectionStoragePath
        ) ?? panic("Parent does not have an ExampleNFT Collection")
    }
    
    execute {
        // Borrow the child's NFT collection through the capability
        let childCollection = self.childNFTCap.borrow()
            ?? panic("Could not borrow child NFT collection capability")
        
        // Withdraw the NFT from child's collection
        let nft <- childCollection.withdraw(withdrawID: nftID)
        
        // Deposit the NFT into parent's collection
        self.parentCollection.deposit(token: <-nft)
    }
}