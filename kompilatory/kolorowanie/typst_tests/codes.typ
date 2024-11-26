#set page(
  "a4", margin: (x: 1.6cm, y: 1.9cm), numbering: none,
)

#let to_string(content) = {
  if content.has("text") {
    content.text
  } else if content.has("children") {
    content.children.map(to_string).join("")
  } else if content.has("body") {
    to_string(content.body)
  } else if content == [ ] {
    " "
  }
}

#let func(body) = text(raw(body), fill: rgb("#f00"))
#let proc(body) = text(raw(body), fill: rgb("#0f0"))

#func("abc")#proc("def")

#func(to_string([-- {{{ helpers]))

#proc("\"plug#begin\"")

#func(to_string([```-- {{{ helpers```]))
