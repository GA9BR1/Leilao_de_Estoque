import { Controller } from "@hotwired/stimulus"
import SlimSelect from 'slim-select'

// Connects to data-controller="slim"
export default class extends Controller {
  connect() {
    new SlimSelect({
      select: this.element,
      settings: {
        placeholderText: 'Selecione os itens',
        closeOnSelect: false,
        hideSelected: true,
        searchText: 'Sem resultados',
        searchPlaceholder: 'Digite o código ou nome do item',
        searchHighlight: true
      }
    })
  }
}
