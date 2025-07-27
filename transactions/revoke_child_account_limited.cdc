// User transaction: Revoke child account access
// This uses the stored revoke capability to remove all keys from the child account
transaction(childAddress: Address) {
    
    let revokeCapability: Capability<auth(RevokeKey) &Account>
    
    prepare(signer: auth(Storage) &Account) {
        // Copy the revoke capability from storage
        self.revokeCapability = signer.storage.copy<Capability<auth(RevokeKey) &Account>>(
            from: /storage/childAccountRevokeCapability
        ) ?? panic("Revoke capability not found in storage")
    }
    
    execute {
        // Borrow the account reference
        let account = self.revokeCapability.borrow()
            ?? panic("Could not borrow revoke capability")

        assert(account.address == childAddress, message: "Mismatched child address")

        // Get all public keys for the account
        let keys = account.keys
        
        // Revoke all keys
        keys.forEach(fun (key: AccountKey): Bool {
            if !key.isRevoked {
                keys.revoke(keyIndex: key.keyIndex)
            }
            return true
        })
    }
}