import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ['section', 'new_answer_form'];

  toggleSection() {
    this.new_answer_formTarget.classList.toggle('hidden');
    this.sectionTarget.classList.toggle('hidden');
  }
  
}