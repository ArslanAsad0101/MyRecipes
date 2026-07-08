import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static values = { recipeId: Number }

  connect() {
    this.likeButton = this.element.querySelector("[data-recipe-like-target='button']")
    this.counter = this.element.querySelector("[data-recipe-like-target='count']")
  }

  like(event) {
    event.preventDefault()

    fetch(`/recipes/${this.recipeIdValue}/recipe_likes`, {
      method: "POST",
      headers: {
        "Accept": "application/json",
        "X-CSRF-Token": document.querySelector("meta[name='csrf-token']").content,
      },
    })
      .then((response) => response.json())
      .then((data) => {
        if (data.likes_count !== undefined) {
          this.counter.textContent = data.likes_count
          this.likeButton.classList.add("liked")
          this.likeButton.disabled = true
        } else if (data.error) {
          alert(data.error)
        }
      })
      .catch(() => {
        alert("Unable to save like. Please try again.")
      })
  }
}
