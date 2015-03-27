$(function(e) {

  $("[data-toggle='popover']").on("shown.bs.popover", function(e) {
    var $this    = $(this),
        $popover = $(".popover"),
        $content = $(".popover .popover-content"),
        username = $this.data("user-name"),
        userId   = $this.data("user-id"),
        postId   = $this.data("post-id"),
        cardId   = $this.attr("id");
        loggedIn = (window.currentuser == undefined)

    $.ajax({
      type: 'GET',
      url: Routes.post_path(postId),
      dataType: 'json',
      error: function() {
        $content.html("Sorry, there was an error loading profile card for '" + username + "'.");
      },
      success: function(response) {
        if (!loggedIn) {
          var followButton = "<br><hr> <a href='javascript:;' class='btn btn-primary'>Follow</a>";
        } else {
          var followButton = "";
        }
        var temp = "<h3>" + username + "</h3> <br> <img src='" + response['user']['image_url'] + "'>" + followButton;
        $this.addClass("loaded");
        $content.html(temp);
      }
    });
  });
});
