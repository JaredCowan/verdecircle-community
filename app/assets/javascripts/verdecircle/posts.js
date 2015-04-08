$(function(e) {

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
        template = "<img class='img-responsive hovercard-img' src='/images/logo-name-vc.jpg'><div class='media'> <div class='media-left'> <a href='/u/" + response['username'] +"'> <img class='media-object' src='" + response['image_url'] +"'> </a> </div><div class='media-body'> <h4 class='media-heading'> <a href='/u/" + response['username'] +"'>"+ username + "</a></h4>" + followButton + "</div>";
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

  // $(".report-link").on("click", function(e) {
  //   e.preventDefault();
  //   var $header = $(".report-dropdown.open .dropdown-header"),
  //       $list   = $(e.delegateTarget.nextElementSibling.children);
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
  // });

  $(".report-dropdown .dropdown-menu a").on("click", function(e) {
    e.preventDefault();
    var id = this.href.split("/").pop();
    var elmTarget = $(e.target),
        $header   = $(".report-dropdown.open .dropdown-header")
    $.ajax({
      type: 'GET',
      url: Routes.report_path(id),
      dataType: 'json',
      beforeSend: function() {
        $header.html("<i class='fa fa-spinner fa-pulse'></i> Sending...");
      },
      error: function(response) {
        if (response.status == 302) {
          $header.html("<i class='fa fa-exclamation-triangle'></i> " + response.responseJSON.reason + ".");
        } else {
          $header.html("<i class='fa fa-exclamation-triangle'></i> Error.");
        }
        $header.nextAll().remove();
      },
      success: function() {
        $header.html("<i class='fa fa-check'></i> Thank-you for reporting.");
        $header.nextAll().remove();
      }
    });
  });
});