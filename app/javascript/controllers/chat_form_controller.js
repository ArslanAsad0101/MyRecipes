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
          form.reset()
        }
      })
      .catch(() => {})
  }
}
