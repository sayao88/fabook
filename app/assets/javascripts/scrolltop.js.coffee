ready = ->
  $(window).scroll ->
    element = $('#page-top-btn')
    visible = element.is(':visible')
    height = $(window).scrollTop()
    visible_place = if element.is('.visible-place-200') then 200 else 400
    if height > visible_place
      element.fadeIn() if !visible
    else
      element.fadeOut()
  $(document).on 'click', '#move-page-top', ->
    $('html, body').animate({ scrollTop: 0 }, 'slow')
    
$(document).ready(ready)
$(document).on('page:load', ready)