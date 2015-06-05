loadThriiiPagePile = function() {
  if ($("#thriii-page").length >= 1) {
    $('#pagepile').pagepiling({
      menu: '#menu',
      anchors: ['features', 'inventory', 'orders', 'fulfillment', 'accounting'],
      sectionsColor: ['#fafafa', '#fafafa', '#fafafa', '#fafafa', '#fafafa'],
      loopTop: false,
      loopBottom: true,
      navigation: {
        'textColor': '#323232',
        'bulletsColor': '#ccc',
        'position': 'right',
        'tooltips': ['features', 'inventory', 'orders', 'fulfillment', 'accounting']
      }
    });
  }
}

initSlideDeck = function() {
  if ($("#thriii-page").length >= 1) {
    $.each($('.skin-slidedeck dl.slidedeck'), function() { 
      $(this).slidedeck().vertical();
    });
  }
}

$("document").on("ready", loadThriiiPagePile(), initSlideDeck());
