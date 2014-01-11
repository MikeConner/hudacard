# stickyFooter = ->
#   $("footer").removeAttr "style"
#   unless window.innerHeight is document.body.offsetHeight
#     offset = window.innerHeight - document.body.offsetHeight
#     current = parseInt($("footer").css("margin-top"))
#     $("footer").css "margin-top": (current + offset) + "px"  if current + offset > parseInt($("footer").css("margin-top"))
# $(window).load ->
#   stickyFooter()

# $(window).resize ->
#   stickyFooter()



# Moves footer to bottom of page when the width of the browser changes.
# There is a delay so that this doesn't happen every pixel

stickyFooter = ->
  $("footer").removeAttr "style"
  unless window.innerHeight is document.body.offsetHeight
    offset = window.innerHeight - document.body.offsetHeight
    current = parseInt($("footer").css("margin-top"))
    $("footer").css "margin-top": (current + offset) + "px"  if current + offset > parseInt($("footer").css("margin-top"))
$(window).load ->
  stickyFooter()

$(window).resize ->
  delay (->
    stickyFooter()
  ), 500

delay = (->
  timer = 0
  (callback, ms) ->
    clearTimeout timer
    timer = setTimeout(callback, ms)
)()