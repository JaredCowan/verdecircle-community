$(function() {
  // $(".report-dropdown .dropdown-menu").on("click", function(e) {
  //   e.stopPropagation();
  // });

  $(".report-link").on("click", function(e) {
    e.preventDefault();
    var $this       = $(this),
        $header     = $(".report-dropdown.open .dropdown-header"),
        $dropdown   = $(e.currentTarget.nextElementSibling),
        $list       = $(e.delegateTarget.nextElementSibling.children),
        $parent     = $this.offsetParent().offsetParent(),
        $parentData = $parent.data("feed");

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
      history.pushState({}, null, "?soft=reported&type=post&id=" + id);
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
    $(".test-popup-btn").on("click", function() {
      var endUrl = {url: window.location.origin + window.location.pathname}
      history.pushState(endUrl.url, null, endUrl.url);
      $(".test-popup").fadeOut(200, function() {
        $("body").removeClass("dont-scroll-body");
        this.remove();
        $("body").trigger("layover:removed");
      });
    });
  }

  function closeLayoverById(id) {
    var endUrl = {url: window.location.origin + window.location.pathname}
    history.pushState(endUrl.url, null, endUrl.url);
    $(".test-popup").fadeOut(200, function() {
      $("body").removeClass("dont-scroll-body");
      $(id).trigger("layover:removed");
      this.remove();
    });
  }

  function ajaxReportData(object, header, id) {
    $("[data-ajax='report']").on("click", function(e) {
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
      "<a class=" + listAClass + " role='menuitem' data-ajax='report' tabindex='-1' href='javascript:;'><h4 class=" + listHeadClass + "> Wrong Category  </h4>  <p class=" + listItemClass + "> You think they posted this in the wrong category.       </p></a>",
      "<a class=" + listAClass + " role='menuitem' data-ajax='report' tabindex='-1' href='javascript:;'><h4 class=" + listHeadClass + "> It's Spam       </h4>  <p class=" + listItemClass + "> You think it doesn't belong on this site and it's spam. </p></a>",
      "<a class=" + listAClass + " role='menuitem' data-ajax='report' tabindex='-1' href='javascript:;'><h4 class=" + listHeadClass + "> Not Useful      </h4>  <p class=" + listItemClass + "> You think the question is not clear and/or not useful.  </p></a>",
      "<a class=" + listAClass + " role='menuitem' data-ajax='report' tabindex='-1' href='javascript:;'><h4 class=" + listHeadClass + "> Offensive       </h4>  <p class=" + listItemClass + "> You think content is offensive or distasteful.          </p></a>",
    "</div>"];

    var _top = $(document).scrollTop(),
      _height = $(window).innerHeight() + 60;
    if ($(".test-popup").length > 0) {
      $(".test-popup").remove();
    }
    $("body").append("<div class='test-popup'><div class='test-popup-header'><a class='test-popup-btn btn btn-info' href='javascript:;'>Cancel</a><h5 class='test-popup-header-text text-center'>Help Us Understand</h5></div><div class='test-popup-content'></div></div>")
    $("body").addClass("dont-scroll-body");
    closeLayover();
    var temp = ""
    for (var i = 0; i <= reportList.length - 1; i++) {
      temp += reportList[i];
    };
    $(".test-popup-content").html(temp);

    ajaxReportData($(".test-popup"), $header, id);
  }
});
