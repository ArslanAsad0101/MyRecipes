import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["search", "select"]

  filter() {
    const query = this.searchTarget.value.trim().toLowerCase()
    const options = Array.from(this.selectTarget.options)

    options.forEach((option) => {
      const text = option.text.toLowerCase()
      option.hidden = query.length > 0 && !text.includes(query)
    })
  }
}
