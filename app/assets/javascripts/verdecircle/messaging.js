$(function() {

  // Ajax POST methods for private messaging.
  // Element classes named after their respective routes.
  // =========================================================
  $(".untrash, .trash, .perm_trash").on("click", function(e) {
    e.preventDefault();

    // Path is assigned based on element click targets class.
    var routePath = e.currentTarget.className,
        $this     = $(this),
        $id       = $this.attr("data-id"),
        $el       = $this.closest("li");

    $.ajax({
       url: "/messages/" + $id + "/" + routePath,
       type: "POST",
       success: $el.remove()
    });

    return false;
  });
});
