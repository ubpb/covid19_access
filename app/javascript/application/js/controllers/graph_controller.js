import { Controller } from "stimulus"
import Chart from 'chart.js'

export default class extends Controller {
  static targets = [ "output" ]

  connect() {
    let ctx  = this.outputTarget
    let data = JSON.parse(this.data.get("data"))
    new Chart(ctx, data)
  }

}
