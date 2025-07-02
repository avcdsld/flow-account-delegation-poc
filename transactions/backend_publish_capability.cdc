// Backend transaction: Publish account capability for user to claim
// This transaction is executed by the backend service with the custodial wallet
transaction(recipientAddress: Address) {
    prepare(signer: auth(IssueAccountCapabilityController, PublishInboxCapability) &Account) {
        signer.inbox.publish(
            signer.capabilities.account.issue<auth(Storage, Contracts, Keys, Inbox, Capabilities) &Account>(),
            name: "custodialAccountCapability",
            recipient: recipientAddress
        )
    }
}
