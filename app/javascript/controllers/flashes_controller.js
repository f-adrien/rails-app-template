import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ['alert']

  connect() {
    if (this.hasAlertTarget) {
      this.sleep(3000).then(() => {
        if (this.hasAlertTarget)  {
          this.alertTarget.classList.replace('u-show', 'u-hide')
        }
      })
    }
  }

  sleep(ms) {
    return new Promise(resolve => setTimeout(resolve, ms));
  }
}
