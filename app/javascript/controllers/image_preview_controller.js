import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="image-preview"
export default class extends Controller {
  static targets = ["field", "image"]

  preview() {
    const blob = window.URL.createObjectURL(this.fieldTarget.files[0])
    this.imageTarget.setAttribute('src', blob)
  }
}
