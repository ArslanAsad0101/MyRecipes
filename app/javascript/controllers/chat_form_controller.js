import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  submit(event) {
    event.preventDefault()

    const form = event.currentTarget
    const formData = new FormData(form)
    const url = form.action

    fetch(url, {
      method: "POST",
      headers: {
        "X-CSRF-Token": document.querySelector("meta[name='csrf-token']").content,
        "Accept": "application/json"
      },
      body: formData
    })
      .then((response) => response.json())
      .then((data) => {
        if (data.success) {
          this.appendMessage(data.message)
          form.reset()
        }
      })
      .catch(() => {})
  }

  appendMessage(data) {
    const chatElement = document.querySelector("[data-controller='chat']")
    const list = document.getElementById("messages-list")
    if (!chatElement || !list || !data) return

    const item = document.createElement("li")
    item.className = `message-bubble ${Number(data.sender_id) === Number(chatElement.dataset.chatCurrentChefIdValue) ? "mine" : "their"}`
    item.innerHTML = `<strong>${data.sender_name}</strong><div>${data.body}</div><span>${data.created_at}</span>`
    list.appendChild(item)
    list.scrollTop = list.scrollHeight
  }
}
