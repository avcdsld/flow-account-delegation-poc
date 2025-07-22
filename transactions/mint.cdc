import "NonFungibleToken"
import "ExampleNFT"

transaction(
    recipient: Address
) {

    /// local variable for storing the minter reference
    let minter: &ExampleNFT.NFTMinter

    /// Reference to the receiver's collection
    let recipientCollectionRef: &{NonFungibleToken.Receiver}

    prepare(signer: auth(BorrowValue) &Account) {

        // borrow a reference to the NFTMinter resource in storage
        self.minter = signer.storage.borrow<&ExampleNFT.NFTMinter>(from: ExampleNFT.MinterStoragePath)
            ?? panic("The signer does not store a ExampleNFT Collection object at the path "
                        .concat(ExampleNFT.MinterStoragePath.toString())
                        .concat("The signer must initialize their account with this collection first!"))

        // Borrow the recipient's public NFT collection reference
        self.recipientCollectionRef = getAccount(recipient).capabilities.borrow<&{NonFungibleToken.Receiver}>(
                ExampleNFT.CollectionPublicPath
        ) ?? panic("The account ".concat(recipient.toString()).concat(" does not have a NonFungibleToken Receiver at ")
                .concat(ExampleNFT.CollectionPublicPath.toString())
                .concat(". The account must initialize their account with this collection first!"))
    }

    execute {
        // Mint the NFT and deposit it to the recipient's collection
        let mintedNFT <- self.minter.mintNFT(name: "test", description: "test", thumbnail: "test", royalties: [])
        self.recipientCollectionRef.deposit(token: <-mintedNFT)
    }
}
