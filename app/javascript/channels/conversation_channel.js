import consumer from "channels/consumer"

export default {
  subscribe(conversationId, callback) {
    return consumer.subscriptions.create(
      { channel: "ConversationChannel", conversation_id: conversationId },
      {
        connected() {},
        disconnected() {},
        received(data) {
          callback(data)
        }
      }
    )
  }
}
