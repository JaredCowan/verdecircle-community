/*!
  * ===========================================================
    * no-autocomplete.js 1.0.0
    *
    * MIT license
    *
    * Copyright (C) 2015 jaredlucascowan.com
    *
    * Fix for rails gem, simple_form not turning off auto-complete
    *
  * ==========================================================
*/

+function ($) {
  "use strict";

  $.fn.noAutocomplete = function(custom) {

    var $this   = $(this),
        options = $.extend(true, {
            toggle: "off",
            on:     "focus"
        }, custom);

    $this.bind(options.on, function() { 
      $this.attr("autocomplete", options.toggle);
    });

    return options;
  };

  $(document).one("ready ajaxStop DOMSubtreeModified", function() {
    $("[no_autocomplete]").noAutocomplete();
  });
}(jQuery);
