var Strata = Strata || {};

Strata.DeliveryOrder = Class.extend({
  init: function(container) {
    this.container = container;
    this.container.find(".show_notes_button").bind("click", this.showNotesClickedHandler() );
    this.container.find(".hide_notes_button").live("click", this.hideNotesClickedHandler() );
  },

  showNotesClickedHandler: function() {
    var self = this;
    return function(e) { self.showNotesClicked(e); }
  },

  showNotesClicked: function(event) {
    var delivery_order_id = $(event.target).attr("data-delivery-order");
    var membership_no = $(event.target).attr("data-membership-no");
    var self = this;
    // FIXME: This is a hardcoded string
    $.get("/delivery_orders/" + delivery_order_id + "/delivery_notes", function(data){
      var destination = self.container.find(".notes[data-membership-no=\""+ membership_no + "\"]");
      destination.html(data);
      destination.show(400);
    });
  },

  hideNotesClickedHandler: function() {
    var self = this;
    return function(e) { self.hideNotesClicked(e); }
  },

  hideNotesClicked: function(event) {
    $(event.target).parents(".notes").hide(400);
  }
});
