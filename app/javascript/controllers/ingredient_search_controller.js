import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["search", "item"]

  connect() {
    this.searchTarget.addEventListener("input", () => this.filter())
  }

  filter() {
    const query = this.searchTarget.value.trim().toLowerCase()

    this.itemTargets.forEach((item) => {
      const name = item.dataset.ingredientName
      const matches = name.includes(query)
      item.style.display = matches ? "block" : "none"
    })
  }
}
