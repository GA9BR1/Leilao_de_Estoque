import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  reset() {
    this.element.reset()
  }
  changeCheckAnsweredTextAnsweredByAdm(){
    this.element.textContent = 'Marcar como não respondida'
  }
  changeCheckAnsweredTextAnsweredByUser(){
    this.element.textContent = 'Marcar como respondida'
  }
}