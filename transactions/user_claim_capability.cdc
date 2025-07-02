// User transaction: Claim the published account capability
// This transaction is executed by the user's self-custodial wallet
transaction(providerAddress: Address) {
    prepare(signer: auth(ClaimInboxCapability, Storage) &Account) {
        let capability = signer.inbox.claim<auth(Storage, Contracts, Keys, Inbox, Capabilities) &Account>(
            "custodialAccountCapability",
            provider: providerAddress
        ) ?? panic("Capability not found")
        
        signer.storage.save(capability, to: /storage/custodialAccountCapability)
    }
}
