import { Controller } from "@hotwired/stimulus";

export default class extends Controller {

  connect() {
    const TurboPreview = document.documentElement.hasAttribute("data-turbo-preview")
    if (!TurboPreview) {
      const options = {
        backdrop: this.data.get('backdrop') || true,
        keyboard: this.data.get('keyboard') || true
      }
      const modal = new bootstrap.Modal(this.element, options)
      modal.show()
    }
  }


  disconnect() {
    bootstrap.Modal.getOrCreateInstance(this.element).hide()
  }
}