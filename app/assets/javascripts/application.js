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
//= 
//= require jquery-ui

/*!
 * Bootstrap
*/
//= require depend/bootstrap/bootstrap
//= require jquery.turbolinks

//= require turbolinks
//= require nprogress
//= require nprogress-turbolinks
//= require gritter

//= require jquery.scrollto

//= require js-routes

// Add error class to .avatar images if they fail to load
// See avatar.scss and _avatar.html.erb
//= require imagesloaded
//= require avatar.errors

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
