$(function(e) {

  /*
   * Definitely refactor this code. Just hacking and think I like it.
  */

  $("#user_username").on("blur", function(e) {

    var $this = $(this),
        $username,
        val;

    val = $this.val().replace(/([^a-z0-9]+)/gi, '')

    $username = val.toLowerCase()

    $this.val($username);
  });

  function alphanumeric(inputtxt) { 

    var $this    = $("#user_username"),
        usr = $("#user_username").val().replace(/([^a-z0-9]+)/gi, ''),
        letters  = /^[a-zA-Z]+$/;

    var htmlTemplate = "<div class='alert alert-danger username-error'>" + 
                         "Your username contains invalid characters. <br>" +
                         "We'll save it in the following format for you. <br>" + 
                         "Your new username: " + usr +
                       " </div>"


    if (letters.test(inputtxt)) {
      $(".username-error").remove();
      return true;
    } else {
        if ($(".username-error").length == 0 && $("#user_username").val().length != 0) {
          $(".user_username label[for='user_username']").after(htmlTemplate);
        } else if ($(".username-error").length = 1) {
          $(".username-error").replaceWith(htmlTemplate);
        }
      return false;
    }
  }

  $("#user_username").keyup(function(e) {
    var vlu = $("#user_username").val();
    alphanumeric(vlu); 
  });

}); // End File
