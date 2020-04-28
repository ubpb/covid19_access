import { Controller } from "stimulus"
import axios from "axios"

export default class extends Controller {
  static targets = [ "output" ]

  intervalId = null

  connect() {
    var that = this
    const interval = this.data.get("interval") || 5000

    this.intervalId = setInterval(() => {
      this.loadPartial()
    }, interval);
  }

  disconnect() {
    if (this.intervalId != null) {
      clearInterval(this.intervalId)
    }
  }

  loadPartial() {
    const url = this.data.get("url")
    axios.get(url)
      .then(response => response.data)
      .then(html => this.outputTarget.innerHTML = html)
  }
}
