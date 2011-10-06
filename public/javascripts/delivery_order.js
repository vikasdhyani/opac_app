var Strata = Strata || {};

Strata.DeliveryOrder = Class.extend({
  init: function(container) {
    this.container = container;
    this.container.find(".show_notes_button").bind("click", this.showNotesClickedHandler() );
  },

  showNotesClickedHandler: function() {
    var self = this;
    return function(e) { self.showNotesClicked(e); }
  },

  showNotesClicked: function(event) {
    var delivery_order_id = $(event.target).attr("data-delivery-order");
    $.get("/delivery_orders/" + delivery_order_id + "/delivery_notes"); // FIXME: This is a hardcoded string
  }
});
