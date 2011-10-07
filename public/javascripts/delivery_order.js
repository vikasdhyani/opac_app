var Strata = Strata || {};

Strata.DeliveryOrder = Class.extend({
  init: function(container) {
    this.container = container;
    this.container.find(".show_notes_button").bind("click", this.showNotesClickedHandler() );
    this.container.find(".hide_notes_button").live("click", this.hideNotesClickedHandler() );
    this.container.find(".add_notes_button").live("click", this.addNotesClickedHandler() );
  },

  showNotesClickedHandler: function() {
    var self = this;
    return function(e) { self.showNotesClicked(e); }
  },

  // FIXME: This is a hardcoded string
  deliveryNotesPath: function(delivery_order_id) {
      return "/delivery_orders/" + delivery_order_id + "/delivery_notes";
  },

  showNotesClicked: function(event) {
    // FIXME: Identify a parent to put this attribute on
    var delivery_order_id = $(event.target).attr("data-delivery-order");
    var membership_no = $(event.target).attr("data-membership-no");
    var self = this;

    $.get(this.deliveryNotesPath(delivery_order_id), function(data){
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
  },

  addNotesClickedHandler: function() {
    var self = this;
    return function(e) { self.addNotesClicked(e); }
  },

  addNotesClicked: function(event) {
    var addNotesDiv = $(event.target).parents(".addNotes");
    var delivery_order_id = addNotesDiv.attr("data-delivery-order");
    var membership_no = addNotesDiv.attr("data-membership-no");

    var content = addNotesDiv.find(".notesTextArea").val();
    var data = { delivery_note: { content: content } };

    var self = this;

    $.post(this.deliveryNotesPath(delivery_order_id), data, function(data){
      var destination = self.container.find(".notes[data-membership-no=\""+ membership_no + "\"]");
      destination.html(data);
      destination.show(400);
    });
  }
});
