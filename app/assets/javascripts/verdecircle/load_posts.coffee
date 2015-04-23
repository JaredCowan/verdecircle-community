MAX_AUTOLOAD = 6
$ ->
  $('#posts-container').infinitePages
    #debug: true
    loading: ->
      $('#posts-container').infinitePages('pause') if this.href.split("/").pop() * 1 > MAX_AUTOLOAD
      $(this).html('<i class="fa fa-spinner fa-spin"></i> Loading &hellip;')
    error: ->
      $(this).html('<i class="fa fa-exclamation-triangle"></i> There was an error, please try again')
