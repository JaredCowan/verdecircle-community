$(function(e) {
  
  $("[data-hovercard]").on("mouseover", function(e) {
    var $this = $(this);
    $this.attr("data-content", "<img src='/images/loading.gif'>")
  });


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

  $("[data-hovercard]").on("shown.bs.popover", function(e) {
    var $this    = $(this),
        $popover = $(".popover"),
        $content = $(".popover .popover-content"),
        username = $this.data("hovercard"),
        loggedIn = (window.currentuser == undefined),
        protocol = window.location.protocol + "//",
        host     = window.location.host;

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
        if (!loggedIn) {
          var followButton = "<br><hr> <a href='javascript:;' class='btn btn-primary'>Follow</a>";
        } else {
          var followButton = "";
        }
        var temp = "<img class='img-responsive hovercard-img' src='/images/logo-name-vc.jpg'><div class='media'> <div class='media-left'> <a href='/u/" + response['username'] +"'> <img class='media-object' src='" + response['image_url'] +"'> </a> </div><div class='media-body'> <h4 class='media-heading'> <a href='/u/" + response['username'] +"'>"+ username + "</a></h4>" + followButton + "</div>";
        $this.addClass("loaded");
        $content.html(temp);
      }
    });
  });

  $('body').popover({
    selector: '[data-hovercard]',
    trigger: 'click hover',
    html: true,
    placement: 'auto',
    delay: {show: 50, hide: 400}
  });

  $(".report-dropdown .dropdown-menu").on("click", function(e) {
    e.stopPropagation();
    var elmTarget = $(e.target),
        $header   = $(e.delegateTarget.firstElementChild);

    if (!elmTarget.hasClass("dropdown-header")) {
      // console.log(window.currentuser);

  //     $.ajax({
  //       type: 'GET',
  //       url: Routes.profile_path(window.currentuser.username),
  //       dataType: 'json',
  //       beforeSend: function() {
  //         $header.html("<i class='fa fa-spinner fa-pulse'></i> Loading...");
  //       },
  //       error: function() {
  //         $header.text("Sorry, there was an error.");
  //         $header.nextAll().remove();
  //       },
  //       success: function(response) {
  //         $header.html("<i class='fa fa-check'></i> Thank-you for reporting.");
  //         $header.nextAll().remove();
  //       }
  //     });
    };
  });
});