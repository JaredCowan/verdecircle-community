function mobileNavbar() {
  var didScroll,
      lastScrollTop     = 0,
      intCount          = 0,
      openCount         = 0,
      delta             = 5,
      $body             = $("body"),
      docHeight         = $(document).innerHeight(),
      $navbar           = $('.navbar-fixed-top'),
      $navbarDropDowns  = $('.navbar-fixed-top .collapse'),
      openNavDropdowns  = function() { return $('.navbar-fixed-top .collapse.in'); },
      navbarHeight      = $navbar.outerHeight(),
      isDropdownOpen    = function() { return $navbarDropDowns.hasClass("in"); },
      $background       = "<div class='navbar-background' style='display: none; position: absolute; top: 0; bottom: 0; right: 0; left: 0; height: " + docHeight + "px; z-index: 1000; background-color: #000; opacity: .8;'></div>";

  $(window).scroll(function(event){
    didScroll = true;
  });

  setInterval(function() {
    if (didScroll) {
      isDropdownOpen() ? "" : hasScrolled();
      didScroll = false;
    }
  }, 250);

  // Callbacks for opening and hiding navbar collapse menu on mobile
  $navbarDropDowns
    .on("show.bs.collapse", function(e) {
      intCount += 1;
      $(".navbar-background").length === 0 ? $body.append($background)           : "";
      openNavDropdowns().length      === 0 ? $(".navbar-background").fadeIn(300) : "";
      openNavDropdowns().length       >= 1 ? openNavDropdowns().collapse("hide") : "";
    })
    .on("shown.bs.collapse", function(e) {
      openCount += 1;
      $(".navbar-background").on("click", function(e) {
        openNavDropdowns().collapse("hide");
      });
      bodyCanScroll();
    })
    .on("hidden.bs.collapse", function(e) {
      openCount -= 1;
      bodyCanScroll();
    })
    .on("hide.bs.collapse", function(e) {
      intCount -= 1;
      hideBackground();
      bodyCanScroll();
    });

  $(".navbar-toggle").on("click", function(e) {
    setTimeout(function(){
      // console.log("intCount: " + intCount);
    }, 310);
    setTimeout(function(){
      // console.log("openCount: " + openCount);
    }, 370);
  })

  // If any navbar menu is open. Don't allow body to scroll.
  function bodyCanScroll() {
    switch(isDropdownOpen()) {
      case true:
        $body.addClass("dont-scroll-body");
        break;
      case false:
        $body.removeClass("dont-scroll-body");
        break;
      default:
        $body.removeClass("dont-scroll-body");
    }
  }

  function hideBackground(e) {
    if (intCount === 0) {
      $(".navbar-background").fadeOut(170, function() {
        this.remove();
      });
    }
  }

  function hasScrolled() {
    var _scrollTop = $(this).scrollTop();

    // Make sure they scroll more than delta
    Math.abs(lastScrollTop - _scrollTop) <= delta ? false : "";

    // If they scrolled down and are past the navbar, add class .nav-up.
    if (_scrollTop > lastScrollTop && _scrollTop > navbarHeight){
      // Scroll Down
      $navbar.removeClass('nav-down').addClass('nav-up');
    } else {
      // Scroll Up
      if(_scrollTop + $(window).height() < $(document).height()) {
        $navbar.removeClass('nav-up').addClass('nav-down');
      }
    }

    lastScrollTop = _scrollTop;
  }
};

$(document).on("ready page:load", mobileNavbar);
