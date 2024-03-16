import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="clip"
export default class extends Controller {
  static targets = ["source"]

  connect(){
    if(!("clipboard" in navigator)){
      this.element.classList.add('d-none')
    }
  }

  copy(){
    navigator.clipboard.writeText(this.sourceTarget.value)
    alert(I18n.message.copied_to_clipboard)
  }
}
