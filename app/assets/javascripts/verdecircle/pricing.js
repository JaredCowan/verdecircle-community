$(".pricing-switcher label").on("click", function(e) {
  var $this           = $(this),
      $switchBtn      = $(".price-switch-btn"),
      $monthlyInput   = $("#monthly:checked"),
      $yearlyInput    = $("#yearly:checked"),
      $monthlyPricing = $(".controller__pages .monthly-pricing"),
      $yearlyPricing  = $(".controller__pages .yearly-pricing"),
      $pricingTable   = $(".has-options");

  switch($this[0].previousElementSibling.id) {
    case "monthly":
      $switchBtn.addClass("monthly").removeClass("yearly");
      $pricingTable.addClass("monthly").removeClass("yearly");
      $(".pricing-table").first().css({"opacity": 1});
      setTimeout(function() {
        $yearlyPricing.hide();
        $monthlyPricing.show();
      }, 170);
      break;
    case "yearly":
      $pricingTable.removeClass("monthly").addClass("yearly");
      $switchBtn.removeClass("monthly").addClass("yearly");
      $(".pricing-table").first().css({"opacity": 0.3});
      setTimeout(function() {
        $monthlyPricing.hide();
        $yearlyPricing.show();
      }, 170);
      break;
  }
});

// For screenreaders
$(".pricing-switcher input").on("click", function(e) {
  var $this           = $(this),
      $switchBtn      = $(".price-switch-btn"),
      $monthlyInput   = $("#monthly:checked"),
      $yearlyInput    = $("#yearly:checked"),
      $monthlyPricing = $(".controller__pages .monthly-pricing"),
      $yearlyPricing  = $(".controller__pages .yearly-pricing"),
      $pricingTable   = $(".has-options");

  switch($this[0].id) {
    case "monthly":
      $switchBtn.addClass("monthly").removeClass("yearly");
      $pricingTable.addClass("monthly").removeClass("yearly");
      $(".pricing-table").first().css({"opacity": 1});
      setTimeout(function() {
        $yearlyPricing.hide();
        $monthlyPricing.show();
      }, 170);
      break;
    case "yearly":
      $pricingTable.removeClass("monthly").addClass("yearly");
      $switchBtn.removeClass("monthly").addClass("yearly");
      $(".pricing-table").first().css({"opacity": 0.3});
      setTimeout(function() {
        $monthlyPricing.hide();
        $yearlyPricing.show();
      }, 170);
      break;
  }
});

var whatView = function() {
  var $monthlySwitch = $("#monthly"),
      $yearlySwitch  = $("#yearly"),
      currentView    = $(".pricing-switcher input:checked")[0].id,
      requestedView  = window.location.search.split("=").pop(),
      renderView     = requestedView === "year" ? "yearly" : "monthly",
      toggleView     = requestedView.length > 0 ? renderView : currentView;

  $("#" + toggleView).trigger("click");
}
$(document).one("page:load, ready", function() {
  whatView();
});

$(".pricing-switcher input").on("change", function() {
  whatView();
});
