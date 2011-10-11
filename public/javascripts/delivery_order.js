var Strata = Strata || {};

Strata.DeliveryOrder = Class.extend({
  init: function(container) {
    this.container = container;

    var self = this;
    this.container.find(".show_notes_button").bind("click", function(event) { self.showNotesClicked(event); } );
    this.container.find(".hide_notes_button").live("click", function(event) { self.hideNotesClicked(event); } );
    this.container.find(".add_notes_button").live("click", function(event) { self.addNotesClicked(event); } );
  },

  // FIXME: This is a hardcoded string
  deliveryNotesPath: function(delivery_order_id) {
      return "/delivery_orders/" + delivery_order_id + "/delivery_notes";
  },

  displayCommentsHandler: function(order_list_div) {
    return function(data) {
      var destination = order_list_div.find(".notes");
      destination.html(data);
      destination.show(400);
    }
  },

  showNotesClicked: function(event) {
    var delivery_order_id = $(event.target).parents("tr").attr("data-delivery-order");
    var order_list_div = $(event.target).parents(".order_list");
    $.get(this.deliveryNotesPath(delivery_order_id), this.displayCommentsHandler(order_list_div));
  },

  hideNotesClicked: function(event) {
    $(event.target).parents(".notes").hide(400);
  },

  addNotesClicked: function(event) {
    var addNotesDiv = $(event.target).parents(".addNotes");
    var content = addNotesDiv.find(".notesTextArea").val();

    if (!content) return;

    addNotesDiv.find(".add_notes_button").attr("disabled", true);
    var delivery_order_id = addNotesDiv.attr("data-delivery-order");
    var order_list_div = addNotesDiv.parents(".order_list");

    $.ajax({
      type: "POST",
      url: this.deliveryNotesPath(delivery_order_id),
      data: { delivery_note: { content: content } },
      success: this.displayCommentsHandler(order_list_div),
      error: function(error) { addNotesDiv.find(".add_notes_button").attr("disabled", false); }
    });
  }
});
