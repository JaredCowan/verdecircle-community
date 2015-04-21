$(".pricing-switcher label").on("click", function(e) {
  var $this           = $(this),
      $switchBtn      = $(".price-switch-btn"),
      $monthlyInput   = $("#monthly:checked"),
      $yearlyInput    = $("#yearly:checked"),
      $monthlyPricing = $(".pricing-head > .monthly-pricing"),
      $yearlyPricing  = $(".pricing-head > .yearly-pricing"),
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