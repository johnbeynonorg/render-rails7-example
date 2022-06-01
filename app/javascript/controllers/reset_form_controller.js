import { Controller } from "stimulus"

export default class extends Controller {
  reset() {
		console.log('cleared')
    this.element.reset()
  }
}
