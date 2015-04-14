$(function() {

  var originalLeave = $.fn.popover.Constructor.prototype.leave;
  $.fn.popover.Constructor.prototype.leave = function(obj){
    var self = obj instanceof this.constructor ?
      obj : $(obj.currentTarget)[this.type](this.getDelegateOptions()).data('bs.' + this.type)
    var container, timeout;

    originalLeave.call(this, obj);

    if(obj.currentTarget) {
      container = $(obj.currentTarget).siblings('.popover')
      timeout = self.timeout;
      container.one('mouseenter', function(){
        //We entered the actual popover – call off the dogs
        clearTimeout(timeout);
        //Let's monitor popover content instead
        container.one('mouseleave', function(){
          $.fn.popover.Constructor.prototype.leave.call(self, self);
        });
      })
    }
  };
  
  $("[data-hovercard]").on("mouseover", function(e) {
    var $this = $(this),
        $popover = $(".popover");
    $this.attr("data-content", "<img src='/images/loading.gif'>")
  });


  $("[data-hovercard]").on("show.bs.popover", function(e) {
    var $popover = $(".popover");
    $popover.length > 0 ? $popover.last().remove() : "";
  });

  $("[data-hovercard]").on("shown.bs.popover", function(e) {
    
    var $this    = $(this),
        $popover = $(".popover"),
        $content = $(".popover .popover-content"),
        username = $this.data("hovercard"),
        loggedIn = (window.currentuser == undefined),
        protocol = window.location.protocol + "//",
        host     = window.location.host,
        followButton,
        template;

    $.ajax({
      type: 'GET',
      url: Routes.profile_path(username),
      dataType: 'json',
      error: function() {
        $content.html("<i class='fa fa-exclamation-triangle'></i> Error.");
      },
      success: function(response) {
        $this.addClass("user-hovercard-parent");
        $(".popover").addClass("user-hovercard");
        followButton = loggedIn ? "" : "<br><hr> <a href='javascript:;' class='btn btn-primary'>Follow</a>";
        template = "<img class='img-responsive hovercard-img' src='/images/logo-name-vc.jpg'><div class='media'> <div class='media-left'> <a href='" + Routes.profile_path(username) + "'> <img class='media-object' src='" + response['image_url'] +"'> </a> </div><div class='media-body'> <h4 class='media-heading'> <a href='" + Routes.profile_path(username) + "'>" + username + "</a></h4>" + followButton + "</div>";
        $this.addClass("loaded");
        $content.html(template);
      }
    });
  });

  $('body').popover({
    selector: '[data-hovercard]',
    trigger: 'click hover',
    html: true,
    placement: 'bottom',
    delay: {show: 50, hide: 400}
  });

  $(".report-dropdown .dropdown-menu").on("click", function(e) {
    e.stopPropagation();
    var elmTarget = $(e.target);
  });

  $(".report-link").on("click", function(e) {
    e.preventDefault();
    var $this     = $(this),
        $header   = $(".report-dropdown.open .dropdown-header"),
        $dropdown = $(e.currentTarget.nextElementSibling),
        $list     = $(e.delegateTarget.nextElementSibling.children);

    var reportDropdown = [ "<li class='report-link-li' role='presentation'> <a role='menuitem' tabindex='-1' href='javascript:;'>Report Post</a> </li>"];
    // var reportDropdown = [ "<li class='report-link-li' role='presentation'> <a role='menuitem' tabindex='-1' href='" + Routes.report_path('18-post') + "'>Wrong Category</a> </li>", 
    //     "<li class='report-link-li' role='presentation'> <a role='menuitem' tabindex='-1' href='" + Routes.report_path('18-post') + "'>It's Spam</a> </li>", 
    //     "<li class='report-link-li' role='presentation'> <a role='menuitem' tabindex='-1' href='" + Routes.report_path('18-post') + "'>Content Is Pointless</a> </li>", 
    //     "<li class='report-link-li' role='presentation'> <a role='menuitem' tabindex='-1' href='" + Routes.report_path('18-post') + "'>I Don't Like It</a> </li>", 
    //     "<li class='report-link-li' role='presentation'> <a role='menuitem' tabindex='-1' href='" + Routes.report_path('18-post') + "'>Other</a> </li>"]

    // $(this).hasClass("list__rendered") ? "" : $dropdown.append(reportDropdown.join(""));
    $this.addClass("list__rendered");

    $(".report-dropdown .dropdown-menu .report-link-li > a").on("click", function(e) {
      e.preventDefault();
      var id = $this[0].dataset.postId;
      window.location.hash = "&soft=reported&type=post&id=" + id + "";
      reportLinkDropdown(e, id);
    });
    // console.log($(e.currentTarget.nextElementSibling));
  //   $.ajax({
  //     type: 'GET',
  //     url: Routes.ajax_path(),
  //     dataType: 'json',
      // beforeSend: function() {
      //   // $header.html("<i class='fa fa-spinner fa-pulse'></i> Sending...");
      // },
      // error: function() {
      //   // $header.html("<i class='fa fa-exclamation-triangle'></i> Error.");
      //   // $header.nextAll().remove();
      // },
      // success: function(response) {
        // console.log($(e.delegateTarget.nextElementSibling.children));
        // $header.html("<i class='fa fa-check'></i> Thank-you for reporting.");
        // $header.nextAll().remove();
        // $list.after(response.link);
      // }
    // });
  });

  function closeLayover() {
    $(".test-popup-btn").on("click", function(e) {
      window.location.hash = "_=_";
      $(".test-popup").fadeOut(200, function() {
        $("body").removeClass("dont-scroll-body");
        $("body").trigger("layover:removed");
        this.remove();
      });
    });
  }

  function closeLayoverById(id) {
    window.location.hash = "_=_";
    $(".test-popup").fadeOut(200, function() {
      $("body").removeClass("dont-scroll-body");
      $(id).trigger("layover:removed");
      this.remove();
    });
  }

  function ajaxReportData(object, header, id) {
    $(".list-group-item").on("click", function(e) {
      var targetDropdown = $("[data-post-id='" + id + "']")[0],
          postWrapper = $("#" + id + " > .dropdown"),
          li = $("#" + id + " > .dropdown .dropdown-menu .dropdown-header");
      $.ajax({
        type: 'GET',
        url: Routes.report_path(id),
        dataType: 'json',
        beforeSend: function() {
          closeLayoverById(targetDropdown);
          $(targetDropdown).on("layover:removed", function() {
            postWrapper.addClass("open");
          });
          li.nextAll().remove();
          li.html("<i class='fa fa-spinner fa-pulse'></i> Sending...");
        },
        error: function(response) {
          if (response.status == 302) {
            li.html("<i class='fa fa-exclamation-triangle'></i> " + response.responseJSON.reason + ".");
          } else {
            li.html("<i class='fa fa-exclamation-triangle'></i> Error.");
          }
        },
        success: function() {
          li.html("<i class='fa fa-check'></i> Thank-you for reporting.");
        }
      })
      .done(function(data) {
        $(".test-popup").remove();
      });
    });
  }

  function reportLinkDropdown(e, id) {
    e.preventDefault();
    var elmTarget = $(e.target),
        $header   = $(".report-dropdown.open .dropdown-header");
    var listAClass = "list-group-item",
      listHeadClass = "list-group-item-heading",
      listItemClass = "list-group-item-text";

  var reportList = ["<div class=\"list-group\">",
      "<a class=" + listAClass + " role='menuitem' tabindex='-1' href='javascript:;'><h4 class=" + listHeadClass + "> Wrong Category </h4><p class=" + listItemClass + "> You think they posted this in the wrong category. </p></a>",
      "<a class=" + listAClass + " role='menuitem' tabindex='-1' href='javascript:;'><h4 class=" + listHeadClass + "> Wrong Category </h4><p class=" + listItemClass + "> You think they posted this in the wrong category. </p></a>",
      "<a class=" + listAClass + " role='menuitem' tabindex='-1' href='javascript:;'><h4 class=" + listHeadClass + "> Wrong Category </h4><p class=" + listItemClass + "> You think they posted this in the wrong category. </p></a>",
      "<a class=" + listAClass + " role='menuitem' tabindex='-1' href='javascript:;'><h4 class=" + listHeadClass + "> Wrong Category </h4><p class=" + listItemClass + "> You think they posted this in the wrong category. </p></a>",
      "<a class=" + listAClass + " role='menuitem' tabindex='-1' href='javascript:;'><h4 class=" + listHeadClass + "> Wrong Category </h4><p class=" + listItemClass + "> You think they posted this in the wrong category. </p></a>",
      "<a class=" + listAClass + " role='menuitem' tabindex='-1' href='javascript:;'><h4 class=" + listHeadClass + "> Wrong Category </h4><p class=" + listItemClass + "> You think they posted this in the wrong category. </p></a>",
      "<a class=" + listAClass + " role='menuitem' tabindex='-1' href='javascript:;'><h4 class=" + listHeadClass + "> Wrong Category </h4><p class=" + listItemClass + "> You think they posted this in the wrong category. </p></a>",
      "<a class=" + listAClass + " role='menuitem' tabindex='-1' href='javascript:;'><h4 class=" + listHeadClass + "> Wrong Category </h4><p class=" + listItemClass + "> You think they posted this in the wrong category. </p></a>",
      "<a class=" + listAClass + " role='menuitem' tabindex='-1' href='javascript:;'><h4 class=" + listHeadClass + "> Wrong Category </h4><p class=" + listItemClass + "> You think they posted this in the wrong category. </p></a>",
      "<a class=" + listAClass + " role='menuitem' tabindex='-1' href='javascript:;'><h4 class=" + listHeadClass + "> Wrong Category </h4><p class=" + listItemClass + "> You think they posted this in the wrong category. </p></a>",
      "<a class=" + listAClass + " role='menuitem' tabindex='-1' href='javascript:;'><h4 class=" + listHeadClass + "> Wrong Category </h4><p class=" + listItemClass + "> You think they posted this in the wrong category. </p></a>",
      "<a class=" + listAClass + " role='menuitem' tabindex='-1' href='javascript:;'><h4 class=" + listHeadClass + "> Wrong Category </h4><p class=" + listItemClass + "> You think they posted this in the wrong category. </p></a>",
      "<a class=" + listAClass + " role='menuitem' tabindex='-1' href='javascript:;'><h4 class=" + listHeadClass + "> Wrong Category </h4><p class=" + listItemClass + "> You think they posted this in the wrong category. </p></a>",
      "<a class=" + listAClass + " role='menuitem' tabindex='-1' href='javascript:;'><h4 class=" + listHeadClass + "> Wrong Category </h4><p class=" + listItemClass + "> You think they posted this in the wrong category. </p></a>",
      "<a class=" + listAClass + " role='menuitem' tabindex='-1' href='javascript:;'><h4 class=" + listHeadClass + "> Wrong Category </h4><p class=" + listItemClass + "> You think they posted this in the wrong category. </p></a>",
      "<a class=" + listAClass + " role='menuitem' tabindex='-1' href='javascript:;'><h4 class=" + listHeadClass + "> Wrong Category </h4><p class=" + listItemClass + "> You think they posted this in the wrong category. </p></a>",
      "<a class=" + listAClass + " role='menuitem' tabindex='-1' href='javascript:;'><h4 class=" + listHeadClass + "> Wrong Category </h4><p class=" + listItemClass + "> You think they posted this in the wrong category. </p></a>",
      "<a class=" + listAClass + " role='menuitem' tabindex='-1' href='javascript:;'><h4 class=" + listHeadClass + "> Wrong Category </h4><p class=" + listItemClass + "> You think they posted this in the wrong category. </p></a>",
      "<a class=" + listAClass + " role='menuitem' tabindex='-1' href='javascript:;'><h4 class=" + listHeadClass + "> Wrong Category </h4><p class=" + listItemClass + "> You think they posted this in the wrong category. </p></a>",
      "<a class=" + listAClass + " role='menuitem' tabindex='-1' href='javascript:;'><h4 class=" + listHeadClass + "> Wrong Category </h4><p class=" + listItemClass + "> You think they posted this in the wrong category. </p></a>",
      "<a class=" + listAClass + " role='menuitem' tabindex='-1' href='javascript:;'><h4 class=" + listHeadClass + "> Wrong Category </h4><p class=" + listItemClass + "> You think they posted this in the wrong category. </p></a>",
      "<a class=" + listAClass + " role='menuitem' tabindex='-1' href='javascript:;'><h4 class=" + listHeadClass + "> Wrong Category </h4><p class=" + listItemClass + "> You think they posted this in the wrong category. </p></a>",
      "<a class=" + listAClass + " role='menuitem' tabindex='-1' href='javascript:;'><h4 class=" + listHeadClass + "> Wrong Category </h4><p class=" + listItemClass + "> You think they posted this in the wrong category. </p></a>",
      "<a class=" + listAClass + " role='menuitem' tabindex='-1' href='javascript:;'><h4 class=" + listHeadClass + "> Wrong Category </h4><p class=" + listItemClass + "> You think they posted this in the wrong category. </p></a>",
      "<a class=" + listAClass + " role='menuitem' tabindex='-1' href='javascript:;'><h4 class=" + listHeadClass + "> Wrong Category </h4><p class=" + listItemClass + "> You think they posted this in the wrong category. </p></a>",
      "<a class=" + listAClass + " role='menuitem' tabindex='-1' href='javascript:;'><h4 class=" + listHeadClass + "> It's Spam </h4> <p class=" + listItemClass + "> You think it doesn't belong on this site and it's spam </p></a></div>"];

    var _top = $(document).scrollTop(),
      _height = $(window).innerHeight() + 60;
    if ($(".test-popup").length > 0) {
      $(".test-popup").remove();
    }
    $("body").append("<div class='test-popup'><div class='test-popup-header'><a class='test-popup-btn btn btn-info' href='javascript:;'>Cancel</button></div><div class='test-popup-content'></div></div>")
    $("body").addClass("dont-scroll-body");
    closeLayover();
    var temp = ""
    for (var i = 0; i <= reportList.length - 1; i++) {
      temp += reportList[i];
    };
    $(".test-popup-content").html(temp);

    ajaxReportData($(".test-popup"), $header, id, e);
  }
});
