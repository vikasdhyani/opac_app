var Strata = Strata || {};
Strata.DATE_FORMAT = 'dd/M/yy';

Strata.DeliveryOrder = Class.extend({
  init: function(container, new_path, submit_path) {
    this.container = container;
    this.new_path = new_path;
    this.submit_path = submit_path;

    var self = this;
    this.container.find(".scheduleDeliveryButton").live("click", function(event) { self.scheduleDeliveryButtonClicked(event); } );
    this.container.find(".cancelSchedule").live("click", function(event) { self.cancelScheduleClicked(event); } );
    this.container.find(".submitButton").live("click", function(event) { self.submitScheduleClicked(event); } );
    this.container.find(".show_notes_button").live("click", function(event) { self.showNotesClicked(event); } );
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
  },

  cancelScheduleClicked: function(event) {
    var parent = $(event.target).parents(".scheduleDelivery");
    parent.html('<button class="scheduleDeliveryButton">Schedule</button>');
  },

  scheduleDeliveryButtonClicked: function(event) {
    var parent = $(event.target).parents(".scheduleDelivery");

    $.get(this.new_path, function(data){
      parent.html(data);
      parent.find(".datePicker").datepicker({ dateFormat: Strata.DATE_FORMAT });
    });
  },

  validateSubmitScheduleParams: function(submitParams) {
    var errors = [];
    if($.isEmptyObject(submitParams.delivery_orders)) errors.push("Please select at least one order to schedule");
    if($.isEmptyObject(submitParams.delivery_slot_id)) errors.push("Please select a delivery slot to schedule");
    if($.isEmptyObject(submitParams.delivery_date))
      errors.push("Please select a date to schedule");
    else {
      var delivery_date = $.datepicker.parseDate(Strata.DATE_FORMAT, submitParams.delivery_date);
      if(delivery_date < new Date()) errors.push("Please select a delivery date in future");
    }

    return errors;
  },

  submitSuccessfulHandler: function(parent) {
    return function(data) {
      parent.find(".scheduleDelivery").html(data);
    }
  },

  submitScheduleClicked: function(event) {
    var parent = $(event.target).parents(".order_list");

    var delivery_orders = [];
    $.each(parent.find(".deliveryOrderCheckbox"), function(index, checkbox) {
      if(checkbox.checked)
        delivery_orders.push($(checkbox).parents("tr").attr("data-delivery-order"));
    });

    var params = {
      delivery_date: parent.find(".datePicker").val(),
      delivery_slot_id: parent.find(".slotSelect").val(),
      delivery_orders: delivery_orders
    };

    var errors = this.validateSubmitScheduleParams(params);
    if($.isEmptyObject(errors))
      $.post(this.submit_path, params, this.submitSuccessfulHandler(parent));
    else
      parent.find(".scheduleErrorMessages").html(errors.join("<br/>"));
  }
});