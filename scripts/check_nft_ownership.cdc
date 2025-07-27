import NonFungibleToken from "NonFungibleToken"
import ExampleNFT from "ExampleNFT"

// Script to check NFT ownership in both parent and child accounts
access(all) fun main(parentAddress: Address, childAddress: Address): {String: [UInt64]} {
    
    let result: {String: [UInt64]} = {}
    
    // Check parent's NFT collection
    if let parentCollection = getAccount(parentAddress)
        .capabilities.borrow<&ExampleNFT.Collection>(ExampleNFT.CollectionPublicPath) {
        result["parent"] = parentCollection.getIDs()
    } else {
        result["parent"] = []
    }
    
    // Check child's NFT collection
    if let childCollection = getAccount(childAddress)
        .capabilities.borrow<&ExampleNFT.Collection>(ExampleNFT.CollectionPublicPath) {
        result["child"] = childCollection.getIDs()
    } else {
        result["child"] = []
    }
    
    return result
}