/* 
 * ProjectName v1.0.0 * 
 * Changed: Wednesday, February 18th, 2015, at 3:51:35 PM * 
*/ 

/*!
 * Load jQuery first
*/
//= require jquery_2
//= require jquery_ujs
//= require twitter/bootstrap/rails/confirm
//= require jquery-ui

/*!
 * Bootstrap
*/
//= require depend/bootstrap/bootstrap
//= require jquery.turbolinks

//= require turbolinks
//= require nprogress
//= require nprogress-turbolinks
//= require rails_confirm_dialog

//= require jquery.scrollto
//= require jquery-smooth-scroll

//= require js-routes

// Add error class to .avatar images if they fail to load
// See avatar.scss and _avatar.html.erb
//= require imagesloaded
//= require avatar.errors

//= require verdecircle/messaging
//= require verdecircle/userscripts

/*!
 * common scripts load last!
*/
//= require verdecircle/commonscripts
