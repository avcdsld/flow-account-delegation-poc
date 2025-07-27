import NonFungibleToken from "NonFungibleToken"
import ExampleNFT from "ExampleNFT"

// Parent account transaction: Move NFT from child account to parent account
// This transaction uses the stored account capability to access child's NFT collection
transaction(nftID: UInt64) {
    
    let childAccountCap: Capability<auth(Storage, Contracts, Keys, Inbox, Capabilities) &Account>
    let parentCollection: &ExampleNFT.Collection
    
    prepare(signer: auth(Storage) &Account) {
        // Get the stored child account capability
        self.childAccountCap = signer.storage.copy<Capability<auth(Storage, Contracts, Keys, Inbox, Capabilities) &Account>>(
            from: /storage/custodialAccountCapability
        ) ?? panic("Child account capability not found in storage")
        
        // Get parent's NFT collection
        self.parentCollection = signer.storage.borrow<&ExampleNFT.Collection>(
            from: ExampleNFT.CollectionStoragePath
        ) ?? panic("Parent does not have an ExampleNFT Collection")
    }
    
    execute {
        // Borrow the child account
        let childAccount = self.childAccountCap.borrow()
            ?? panic("Could not borrow child account capability")
        
        // Get child's NFT collection with Withdraw entitlement
        let childCollection = childAccount.storage.borrow<auth(NonFungibleToken.Withdraw) &ExampleNFT.Collection>(
            from: ExampleNFT.CollectionStoragePath
        ) ?? panic("Child does not have an ExampleNFT Collection")
        
        // Withdraw the NFT from child's collection
        let nft <- childCollection.withdraw(withdrawID: nftID)
        
        // Deposit the NFT into parent's collection
        self.parentCollection.deposit(token: <-nft)
    }
}