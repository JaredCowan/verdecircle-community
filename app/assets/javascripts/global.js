/*!
 * Global file for verdecircle.com & community center + whatever else
*/

//= require depend/pagepiling
//= require depend/scroll
//= require verdecircle/load_posts

//= require nprogress
//= require nprogress-pjax
//= require nprogress-ajax
//= require rails_confirm_dialog
//= require depend/flash_notifs
//= require jquery.scrollto

//= require js-routes

// Add error class to .avatar images if they fail to load
// See avatar.scss and _avatar.html.erb
//= require imagesloaded
//= require avatar.errors

//= require verdecircle/report_link
//= require verdecircle/navbar
//= require verdecircle/messaging
//= require verdecircle/userscripts
//= require verdecircle/posts
//= require verdecircle/pricing
//= require verdecircle/thriii_page

/*!
 * common scripts load last!
*/
//= require verdecircle/commonscripts


var ready = function() {
  scriptLoaded = "loaded"
  $('[data-toggle="popover"]').popover()
  $('[data-toggle="tooltip"]').tooltip()
  $("#pagepile-loading").fadeOut(1500, function() {
    $(this).remove();
  });

  formHasErrorWithFeedback();

  $("textarea.form-control").on("keydown focus blur", function(e) {
    var $this     = $(this),
        _lines    = $this[0].value.split("\n"),
        _rows     = _lines.length + 2;
    $.each(_lines, function(i, v) {
      _rows += Math.floor(v.length / ($this.width() / 6.7825));
    });
  });
}

$(document).on('ready', ready);

if (typeof window.scriptLoaded === 'undefined') {
  $(document).ready(ready);
}

var formHasErrorWithFeedback = function() {
  $.each($(".has-error.has-feedback"), function(e){
    var $this     = $(this)
      errorTemplate = '<span class="glyphicon glyphicon-remove form-control-feedback" aria-hidden="true"></span><span id="inputError2Status" class="sr-only">(error)</span>';
    $this.append(errorTemplate);
  });
}


// $(".desktop input").on("mouseover", function(e) {
//   var $this  = $(this),
//       $label = $this.parent().find("label");
//   console.log($this, e);
//   $label.addClass("fancyplaceholder");
//   $this.on("mouseout", function(e) {
//     $label.removeClass("fancyplaceholder");
//   });
// });

$(".form-control").on("mouseover hover focus", function(e) {
  var $this  = $(this),
      $input = $this[0],
      $label = $this.parent().find("label");
  // console.log($this);
  $label.addClass("fancyplaceholderin");
  // $label.toggle( ":hover" );
  $this.on("focus", function() {
    // console.log($this);
  });
  setTimeout(function() {
    $this.toggleClass( "focused", $this.is( ":focus" ) );
  }, 0 );
  $this.on("mouseleave blur", function() {
    // console.log($input.value.length);
    if ($input.value.length === 0) {
        $label.removeClass("fancyplaceholderin");
      $label.addClass("fancyplaceholderout");
      // $this.animate({opacity: 1}, 600, function() {
      //   $label.removeClass("fancyplaceholderin");
      //   $label.removeClass("fancyplaceholderout");
      // });
      setTimeout(function() {
        $label.removeClass("fancyplaceholderout");
      }, 400 );
    }
  });
});

function ajaxLinkLoader() {
  $("a[data-remote]")
    .not("[data-loader='false']").on('ajax:before', function(e){
      $(e.currentTarget).find("i").remove();
      $(e.currentTarget).append(" <i class='fa fa-spinner fa-spin ajax-loader-icon'></i>");
    })
    .not("[data-loader='false']").on('ajax:error', function(e){
      $(e.currentTarget).find("i").remove();
      $(e.currentTarget).append(" <i class='fa fa-exclamation-triangle ajax-loader-icon'></i>");
    });
}

$(document).on("ready", ajaxLinkLoader);

