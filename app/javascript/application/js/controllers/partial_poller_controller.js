import { Controller } from "stimulus"
import axios from "axios"

export default class extends Controller {
  static targets = [ "output" ]

  connect() {
    var that = this
    const interval = this.data.get("interval") || 5000

    setInterval(() => {
      this.loadStats()
    }, interval);
  }

  loadStats() {
    const url = this.data.get("url")
    axios.get(url)
      .then(response => response.data)
      .then(html => this.outputTarget.innerHTML = html)
  }
}
