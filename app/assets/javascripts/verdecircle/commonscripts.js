// Belongs to users private messaging index page for tabs
$(function() {
  if (document.location.pathname == Routes.conversations_path())
    var match = document.location.pathname + document.location.hash;

  if (match) {
      $(".nav-tabs a[href='" + match + "' ").tab("show");
  }

  // Change hash for page-reload
  $('.nav-tabs a').on('click', function (e) {
      window.location.hash = e.target.hash;
  });
});


$(function() {
  $(".embed-responsive-item").on("click", function() {
    console.log(this);
  });
});
