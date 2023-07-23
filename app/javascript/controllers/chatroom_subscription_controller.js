import { Controller } from "@hotwired/stimulus"
import { createConsumer } from "@rails/actioncable"

// Connects to data-controller="chatroom-subscription"
export default class extends Controller {
  static values = { chatroomId: Number }
  static target = ["messages"];

  connect() {
    this.channel = createConsumer().subscriptions.create(
      { channel: "ChatroomChannel", id: this.chatroomIdValue },
      // { received: data => this.messagesTargets.insertAdjacentHTML("beforeend", data) }
      { received: data => this.insertMessageAndScroll(data) }
    )
    console.log(`Subscribed to the chatroom with the id ${this.chatroomIdValue}.`)
  }
  disconnect () {
console.log("Unsubscribed from the chatroom with the id ${this.chatroomIdValue}.`")
this.channel.unsubscribe()
  }


  insertMessageAndScroll(data) {
    this.messagesTarget.insertAdjacentHTML("beforeend", data)
    this.messagesTarget.scrollTo(0, this.messagesTarget.scrollHeight)
    //this.newmessageTarget.innerText = "";
  }
  resetForm(event) {
    event.target.reset()
  }


}
