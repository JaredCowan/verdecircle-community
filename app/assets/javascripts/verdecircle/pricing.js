$(".pricing-switcher label").on("click", function(e) {
  var $this           = $(this),
      $switchBtn      = $(".price-switch-btn"),
      $monthlyInput   = $("#monthly:checked"),
      $yearlyInput    = $("#yearly:checked"),
      $monthlyPricing = $(".controller__pages .monthly-pricing"),
      $yearlyPricing  = $(".controller__pages .yearly-pricing"),
      $pricingTable   = $(".pricing-table");

  switch($this[0].previousElementSibling.id) {
    case "monthly":
      $switchBtn.addClass("monthly").removeClass("yearly");
      $pricingTable.addClass("monthly").removeClass("yearly");
      setTimeout(function() {
        $yearlyPricing.hide();
        $monthlyPricing.show();
      }, 170);
      break;
    case "yearly":
      $pricingTable.removeClass("monthly").addClass("yearly");
      $switchBtn.removeClass("monthly").addClass("yearly");
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
      $pricingTable   = $(".pricing-table");

  switch($this[0].id) {
    case "monthly":
      $switchBtn.addClass("monthly").removeClass("yearly");
      $pricingTable.addClass("monthly").removeClass("yearly");
      setTimeout(function() {
        $yearlyPricing.hide();
        $monthlyPricing.show();
      }, 170);
      break;
    case "yearly":
      $pricingTable.removeClass("monthly").addClass("yearly");
      $switchBtn.removeClass("monthly").addClass("yearly");
      setTimeout(function() {
        $monthlyPricing.hide();
        $yearlyPricing.show();
      }, 170);
      break;
  }
});
