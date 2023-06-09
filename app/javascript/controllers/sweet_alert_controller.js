import { Controller } from "@hotwired/stimulus"
import Swal from 'sweetalert2'

export default class extends Controller {
  static targets = [ "confirmationLink" ]

  modalWithConfirmation(event) {
    event.preventDefault()
    const isModal = event.params.isModal
    if (isModal == true) {
      bootstrap.Modal.getOrCreateInstance(".modal").hide()
    }
    Swal.fire({
      title: event.params.title,
      text: event.params.text,
      input: 'text',
      showCloseButton: true,
      showCancelButton: true,
      confirmButtonText: event.params.confirm,
      cancelButtonText: event.params.cancel,
      customClass: {
        confirmButton: event.params.buttonType,
        cancelButton: event.params.cancelType,
        title: 'custom-swal-title',
        text: 'custom-swal-text',
        closeButton: 'custom-swal-close-button'
      },
      buttonsStyling: false,
      didOpen: function () {
        document.querySelector(".swal2-confirm").setAttribute("disabled", "")
        Swal.getInput().addEventListener('keyup', function (e) {
          if (e.target.value === event.params.input) {
            Swal.enableButtons()
          }
        })
      }
    }).then((confirmation) => {
      this.buttonManager(isModal, confirmation)
    })
  }

  modalWithoutConfirmation(event) {
    event.preventDefault()
    const isModal = event.params.isModal
    if (isModal == true) {
      bootstrap.Modal.getOrCreateInstance(".modal").hide()
    }
    Swal.fire({
      title: event.params.title,
      showCloseButton: true,
      showCancelButton: true,
      confirmButtonText: event.params.confirm,
      cancelButtonText: event.params.cancel,
      customClass: {
        confirmButton: event.params.buttonType,
        cancelButton: event.params.cancelType,
        title: 'custom-swal-title',
        text: 'custom-swal-text',
        closeButton: 'custom-swal-close-button'
      },
      buttonsStyling: false
    }).then((confirmation) => {
      this.buttonManager(isModal, confirmation)
    })
  }

  modalInformationWithText(event) {
    event.preventDefault()
    const isModal = event.params.isModal
    if (isModal == true) {
      bootstrap.Modal.getOrCreateInstance(".modal").hide()
    }
    Swal.fire({
      title: event.params.title,
      text: event.params.text,
      confirmButtonText: event.params.confirm,
      customClass: {
        confirmButton: event.params.buttonType,
        cancelButton: event.params.cancelType,
        title: 'custom-swal-title',
        text: 'custom-swal-text'
      },
      buttonsStyling: false
    })
  }

  buttonManager(isModal, confirmation) {
    if (isModal == true) {
      if (confirmation.isConfirmed) {
        this.confirmationLinkTarget.click()
      } else if (confirmation.dismiss === Swal.DismissReason.cancel) {
        bootstrap.Modal.getOrCreateInstance(".modal").show()
      }
    } else {
      if (confirmation.isConfirmed) {
        this.confirmationLinkTarget.click()
      }
    }
  }
}