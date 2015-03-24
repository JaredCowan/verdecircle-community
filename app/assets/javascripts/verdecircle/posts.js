$(function(e) {

  $("[data-toggle='popover']").on("shown.bs.popover", function(e) {
    var $this    = $(this),
        $popover = $(".popover"),
        $content = $(".popover .popover-content"),
        username = $this.data("user-name"),
        userId   = $this.data("user-id"),
        cardId   = $this.attr("id");

    $.ajax({
      type: 'GET',
      url: Routes.profile_page_path(username),
      dataType: 'json',
      error: function() {
        $content.html("Sorry, there was an error loading profile card for '" + username + "'.");
      },
      success: function(response) {
        var temp = "<h3>" + username + "</h3> <br> <img src='" + response['image_url'] + "'>";
        $this.addClass("loaded");
        $content.html(temp);
      }
    });
  });
});
