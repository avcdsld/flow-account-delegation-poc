import "ExampleNFT"
import "NonFungibleToken"

transaction {

    prepare(signer: auth(BorrowValue, IssueStorageCapabilityController, PublishCapability, SaveValue, UnpublishCapability) &Account) {

        // Return early if the account already has a collection
        if signer.storage.borrow<&ExampleNFT.Collection>(from: ExampleNFT.CollectionStoragePath) != nil {
            return
        }

        // Create a new empty collection
        let collection <- ExampleNFT.createEmptyCollection(nftType: Type<@ExampleNFT.NFT>())

        // save it to the account
        signer.storage.save(<-collection, to: ExampleNFT.CollectionStoragePath)

        let collectionCap = signer.capabilities.storage.issue<&ExampleNFT.Collection>(ExampleNFT.CollectionStoragePath)
        signer.capabilities.publish(collectionCap, at: ExampleNFT.CollectionPublicPath)
    }
}
