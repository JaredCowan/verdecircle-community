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

$("document").on("ready", loadThriiiPagePile());
