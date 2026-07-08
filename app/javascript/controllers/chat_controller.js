import { Controller } from "@hotwired/stimulus"
import ConversationChannel from "channels/conversation_channel"

export default class extends Controller {
  static values = { conversationId: Number, currentChefId: Number }

  connect() {
    this.subscription = ConversationChannel.subscribe(this.conversationIdValue, (data) => {
      this.appendMessage(data)
    })

    this.element.addEventListener("message-added", (event) => {
      this.appendMessage(event.detail)
    })

    this.scrollToBottom()
    this.bindTypingEvents()
  }

  disconnect() {
    this.subscription?.unsubscribe()
    this.element.removeEventListener("message-added", this.handleMessageAdded)
  }

  bindTypingEvents() {
    const input = this.element.querySelector("input[name='message[body]']")
    if (!input) return

    input.addEventListener("focus", () => this.showTypingIndicator(false))
    input.addEventListener("input", () => this.showTypingIndicator(true))
  }

  showTypingIndicator(isTyping) {
    const indicator = document.getElementById("typing-indicator")
    if (!indicator) return

    indicator.style.display = isTyping ? "block" : "none"
  }

  appendMessage(data) {
    const list = document.getElementById("messages-list")
    if (!list) return

    const item = document.createElement("li")
    item.className = `message-bubble ${Number(data.sender_id) === this.currentChefIdValue ? "mine" : "their"}`
    item.innerHTML = `<strong>${data.sender_name}</strong><div>${data.body}</div><span>${data.created_at}</span>`
    list.appendChild(item)
    this.scrollToBottom()
    this.updateUnreadBadge(data)
  }

  updateUnreadBadge(data) {
    if (Number(data.sender_id) === this.currentChefIdValue) return

    const conversationLink = document.querySelector(`.chat-item[data-conversation-id="${this.conversationIdValue}"]`)
    if (!conversationLink) return

    conversationLink.classList.add("unread")

    const badge = conversationLink.querySelector(".unread-badge")
    if (badge) {
      const currentCount = Number(badge.textContent) || 0
      badge.textContent = currentCount + 1
    } else {
      const badgeElement = document.createElement("span")
      badgeElement.className = "unread-badge"
      badgeElement.textContent = "1"
      conversationLink.querySelector(".chat-item-top").appendChild(badgeElement)
    }
  }

  scrollToBottom() {
    const list = document.getElementById("messages-list")
    if (!list) return

    requestAnimationFrame(() => {
      list.scrollTop = list.scrollHeight
    })
  }
}
