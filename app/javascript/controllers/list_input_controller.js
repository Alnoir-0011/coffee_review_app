import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="list-input"
export default class extends Controller {
  static targets = ['input', 'id', 'ids', 'area']

  connect() {
    document.addEventListener('autocomplete.change', (event) => {
      const listElement = document.createElement('li')
      listElement.classList.add('list-group-item', 'd-flex', 'justify-content-between');
      listElement.dataset.id = event.detail.value
      const listTextElement = document.createElement('span');
      listTextElement.textContent = event.detail.textValue;
      const deleteButton = document.createElement('button');
      deleteButton.classList.add('btn-close');
      deleteButton.type = 'button';
      deleteButton.dataset.action = 'list-input#delete';
      listElement.appendChild(listTextElement);
      listElement.appendChild(deleteButton);
      this.areaTarget.appendChild(listElement);
      const idArray = this.idsTarget.value.split(',');
      idArray.push(event.detail.value);
      this.idsTarget.value = idArray.join(',');
      this.inputTarget.value = '';
    })
  }

  delete(e) {
    const listElement = e.target.parentElement;
    const oldIds = this.idsTarget.value.split(',');
    const newIds = oldIds.filter(id => !(id === listElement.dataset.id)).join(',');
    this.idsTarget.value = newIds;
    this.areaTarget.removeChild(listElement);
  }
}
