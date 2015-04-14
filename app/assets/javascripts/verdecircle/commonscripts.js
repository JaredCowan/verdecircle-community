// Belongs to users private messaging index page for tabs
$(function() {
  if (document.location.pathname == Routes.conversations_path())
    var match = document.location.pathname + document.location.hash;

  if (match) {
      $(".nav-tabs a[href='" + match + "' ").tab("show");
  }

  // Change hash for page-reload
  $('.nav-tabs a').on('click', function (e) {
      window.location.hash = e.target.hash;
  });
});



// $(function() {
//   var pusher = new Pusher('136065ba56ec3683eddd');
//   var notifications = pusher.subscribe('notifications');
//   u = window.currentuser;
  
  // $("<li> <time class='cbp_tmtime'><span>" + o.created_at + "</span></time> <div class='cbp_tmicon cbp_tmicon-phone'> </div> <div class='cbp_tmlabel'> <h2>" + o.userdata + "</h2>" + o.action + " a " + o.targetable_type.toLowerCase() + "</div> </li>").prependTo( ".cbp_tmtimeline li:first");
  // notifications.bind('activity', function(data) {
  //   o = data
  //   jQuery(function() { 
  //     jQuery.gritter.add({ image: '/assets/success.png', title: 'Success', text: "" + o.userdata + " " + o.action + " a " + o.targetable_type.toLowerCase() + "." });
  //   });
  // });

  // notifications.bind('message', function(data) {
  //   o = data
  //     jQuery(function() { 
  //       jQuery.gritter.add({ image: '/assets/success.png', title: 'Success', text: "" + o.userdata + " sent you a new message." });
  //     });
  // });
// });
