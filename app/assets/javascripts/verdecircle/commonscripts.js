// Belongs to users private messaging index page for tabs
$(function() {
  if (document.location.pathname == Routes.conversations_path())
    var match = document.location.pathname + document.location.hash;

  if (match) {
      $(".nav-tabs a[href='" + match + "' ").tab("show");
  }
});
