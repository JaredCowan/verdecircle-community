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
        clearTimeout(timeout);
        container.one('mouseleave', function(){
          $.fn.popover.Constructor.prototype.leave.call(self, self);
        });
      })
    }
  };
  
  $("body").popover({
    selector: '[data-hovercard]',
    trigger: 'click hover',
    html: true,
    placement: 'bottom',
    delay: {show: 100, hide: 400}
  });

  $("[data-hovercard]").on("mousemove", function(e) {
    var $this      = $(this),
        e          = e,
        $popover   = $(".popover"),
        $arrow     = $(".arrow"),
        winWidth   = window.innerWidth,
        width      = $this.width(),
        left       = $this.offset().left,
        posPopover = e.clientX < (winWidth / 2) ? ($this.position().left / left - 2) : (width - width * 2.7 / 1.39601),
        posMouse   = (function() { var x = (e.clientX < (winWidth / 2) ? (e.offsetX + 9) : (e.offsetX + width)); return x > 10 ? x : 16; })();

    $popover.css({
      left: posPopover + "px"
    });

    $arrow.css({
      left: posMouse + "px"
    });
  });

  $.each($("[data-hovercard]"), function() {
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
      beforeSend: function() {
        $this.addClass("user-hovercard-parent");
        $(".popover").addClass("user-hovercard");
      },
      error: function() {
        $content.html("<i class='fa fa-exclamation-triangle'></i> Error.");
      },
      success: function(response) {
        
        followButton = loggedIn ? "" : "<br><hr> <a href='javascript:;' class='btn btn-primary'>Follow</a>";
        template = "<img class='img-responsive hovercard-img' src='/images/logo-name-vc.jpg'><div class='media'> <div class='media-left'> <a href='" + Routes.profile_path(username) + "'> <img class='media-object' src='" + response['image_url'] +"'> </a> </div><div class='media-body'> <h4 class='media-heading'> <a href='" + Routes.profile_path(username) + "'>" + username + "</a></h4>" + followButton + "</div>";
        $this.addClass("loaded");
        $content.html(template);
      }
    });
  });
});
