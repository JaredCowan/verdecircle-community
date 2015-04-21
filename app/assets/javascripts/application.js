/* 
 * ProjectName v1.0.0 * 
 * Changed: Wednesday, February 18th, 2015, at 3:51:35 PM * 
*/ 

/*!
 * Load jQuery first
 * require twitter/bootstrap/rails/confirm
 * require rails_confirm_dialog
*/
//= require jquery_2
//= require jquery_ujs
//= require jquery-ui

/*!
 * Bootstrap
*/
//= require depend/bootstrap/bootstrap
 
//=require jquery.turbolinks 
//=require turbolinks

//= require depend/pagepiling

//= require nprogress
//= require nprogress-turbolinks
//= require rails_confirm_dialog
//= require gritter
//= require jquery.scrollto

//= require js-routes

// Add error class to .avatar images if they fail to load
// See avatar.scss and _avatar.html.erb
//= require imagesloaded
//= require avatar.errors

//= require verdecircle/navbar
//= require verdecircle/messaging
//= require verdecircle/userscripts
//= require verdecircle/posts

/*!
 * common scripts load last!
*/
//= require verdecircle/commonscripts

// jQuery(function() {
//   if ($('#infinite-scrolling').size() > 0) {
//     var more_posts_url = $('.pagination .next a').attr('href');
//     $(window).on('scroll', function() {
//       return more_posts_url;
//     });
//     if (more_posts_url && $(window).scrollTop() > $(document).height() - $(window).height() - 60) {
//       $('.pagination').html('<img src="http://www.toidesignz.com/images/ajax-loader.gif" alt="Loading..." title="Loading..." />');
//       $.getScript(more_posts_url);
//     }
//     return;
//   }
// });

// $("img").error().replaceWith("<h5 class='alert alert-danger'>Sorry, that was an error loading image.</h5>")

// $(".report-link").on("click", function(e) {
//   var elmTarget = $(e.target),
//       elmId     = $(e.delegateTarget).attr("id");

//       console.log($(this).offsetParent().children().closest("ul").append("<li role='presentation'> <a role='menuitem' tabindex='-1' href='javascript:;'>Content Is Pointless</a> </li>"));
//   elmTarget.append("<ul style='top: 0; display: block;' class='dropdown-menu dropdown-menu-right' role='menu' aria-labelledby='reportDropdownMenu'> <li role='presentation' class='dropdown-header'>Reason For Reporting?</li> <li role='presentation'> <a role='menuitem' tabindex='-1' href='javascript:;'>Wrong Category</a> </li> <li role='presentation'> <a role='menuitem' tabindex='-1' href='javascript:;'>It's Spam</a> </li> <li role='presentation'> <a role='menuitem' tabindex='-1' href='javascript:;'>Content Is Pointless</a> </li> <li role='presentation'> <a role='menuitem' tabindex='-1' href='javascript:;'>I Don't Like It</a> </li> <li role='presentation'> <a role='menuitem' tabindex='-1' href='javascript:;'>Other</a> </li> </ul>");
// });

var ready = function() {
  scriptLoaded = "loaded"
  $('[data-toggle="popover"]').popover()
  $('[data-toggle="tooltip"]').tooltip()
  $("#pagepile-loading").fadeOut(1500, function() {
    $(this).remove();
  });
  formHasErrorWithFeedback();
  $("textarea.form-control")
    .on("keydown focus blur", function(e) {
      var $this     = $(this);
      $this[0].rows = $this[0].value.split("\n").length + 2;
      var lines = $this[0].value.split("\n");
      $.each(lines, function(i, v) {
        $this[0].rows += Math.floor(v.length / ($this.width() / 6.7825));
      });
  });

  $(".pricing-switcher label").on("click", function(e) {
    var $this           = $(this),
        $switchBtn      = $(".price-switch-btn"),
        $monthlyInput   = $("#monthly:checked"),
        $yearlyInput    = $("#yearly:checked"),
        $monthlyPricing = $(".pricing-head > .monthly-pricing"),
        $yearlyPricing  = $(".pricing-head > .yearly-pricing"),
        $pricingTable   = $(".pricing-table");

    switch($this[0].previousElementSibling.id) {
      case "monthly":
        $switchBtn.addClass("monthly").removeClass("yearly");
        $pricingTable.addClass("monthly").removeClass("yearly");
        setTimeout(function() {
          $yearlyPricing.hide();
          $monthlyPricing.show();
        }, 170);
        break;
      case "yearly":
        $pricingTable.removeClass("monthly").addClass("yearly");
        $switchBtn.removeClass("monthly").addClass("yearly");
        setTimeout(function() {
          $monthlyPricing.hide();
          $yearlyPricing.show();
        }, 170);
        break;
    }
    // console.log($yearlyPricing);
  });
}


$(document).on('page:load', ready);

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





