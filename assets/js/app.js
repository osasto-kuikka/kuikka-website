// Brunch automatically concatenates all files in your
// watched paths. Those paths can be configured at
// config.paths.watched in "brunch-config.js".
//
// However, those files will only be executed if
// explicitly imported. The only exception are files
// in vendor, which are never wrapped in imports and
// therefore are always executed.

// Import dependencies
//
// If you no longer want to use a dependency, remember
// to also remove its path from "config.paths.watched".
import "phoenix_html"
import toMarkdown from "to-markdown"
import Socket from "./socket"

// Import local files
//
// Local files can be imported directly using relative
// paths "./socket" or full ones "web/static/js/socket".

// import socket from "./socket"

export default class App {
  constructor() {}
}

// Function that is run when pressing reply button
// Copies content from comment to new comment textarea
// and adds > on everyline for quote
window.onReply = function(id) {
  const el = document.getElementById(id)
  const to = document.getElementById("new-comment-content")
  if (el !== undefined) {
    let content = toMarkdown(`<blockquote>${el.innerHTML}</blockquote>`)
    to.innerText = content
  }
}

window.openModal = function(id) {
  const el = document.getElementById(id)
  if (el !== undefined) {
    el.className = "modal is-active"
  }
}

window.closeModal = function(id) {
  const el = document.getElementById(id)
  if (el !== undefined) {
    el.className = "modal"
  }
}

new App()
