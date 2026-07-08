import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["message"]

  connect() {
    this.messageTargets.forEach((message) => {
      setTimeout(() => {
        message.classList.add("toast-hidden")
      }, 3200)
    })
  }
}
