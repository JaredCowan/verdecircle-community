/* 
 * ProjectName v1.0.0 * 
 * Changed: Wednesday, February 18th, 2015, at 3:51:35 PM * 
*/ 

// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file.
// 
// Read Sprockets README (https:#github.com/sstephenson/sprockets#sprockets-directives) for details
// about supported directives.
//

//= require jquery_2
//= require jquery_ujs
//= require bootstrap
//= require jquery.turbolinks
//= require turbolinks
//= require nprogress
//= require nprogress-turbolinks
//= require rails_confirm_dialog
//= require jquery.scrollto
//= require js-routes

// Add error class to .avatar images if they fail to load
// See avatar.scss and _avatar.html.haml
//= require imagesloaded
//= require avatar.errors

$(function(e) {

  $("#user_username").keyup(function(e) {
    var $this = $(this)
    , val
    , $username;

    val = $this.val().replace(/([^a-z0-9]+)/gi, '')

    $username = val.toLowerCase()

    // $this.val($username);
  });
});

$(function() {

  $(".untrash").on("click", function(e) {
    e.preventDefault();
    $this = $(this),
    $id   = $this.attr("data-id"),
    $elm  = $this.closest("li");

    // console.log($this.closest("li"))
    $.ajax({
       url: "/messages/" + $id + "/untrash",
       type: "POST",
       success: $elm.remove()
    });

    return false; 
  });

  $(".trash").on("click", function(e) {
    e.preventDefault();
    $this = $(this),
    $id   = $this.attr("data-id"),
    $elm  = $this.closest("li");

    // console.log($this.closest("li"))
    $.ajax({
       url: "/messages/" + $id + "/trash",
       type: "POST",
       success: $elm.remove()
    });

    return false; 
  });

  $(".delete").on("click", function(e) {
    e.preventDefault();
    $this = $(this),
    $id   = $this.attr("data-id"),
    $elm  = $this.closest("li");

    // console.log($this.closest("li"))
    $.ajax({
       url: "/messages/" + $id + "/perm_trash",
       type: "POST",
       success: $elm.remove()
    });

    return false; 
  });
});
