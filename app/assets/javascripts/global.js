/*
 * Global file for verdecircle.com & community center + whatever else
 * First script loaded at bottom of page
*/
//= require depend/bootstrap/bootstrap-tagsinput
//= require depend/no-autocomplete
//= require depend/pagepiling
//= require depend/scroll
//= require verdecircle/load_posts
//= require nprogress
//= require rails_confirm_dialog
//= require depend/flash_notifs
//= require jquery.scrollto

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

/*
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

function hasInputMask() {
  $("[data-mask='phone']").inputmask({
    mask: '(999) 999-9999'
  });
}

$(document).on("ready", formHasErrorWithFeedback(),
                        ajaxLinkLoader(),
                        hasInputMask()
);

$(document).ajaxStop(function() {
  hasInputMask();
});
