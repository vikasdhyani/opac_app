var Strata = Strata || {};

Strata.DeliveryOrder = Class.extend({
  init: function(container, new_appointment_path, create_appointment_path, delivery_schedules_path) {
    this.container = container;
    this.new_appointment_path = new_appointment_path;
    this.create_appointment_path = create_appointment_path;
    this.delivery_schedule_path = delivery_schedules_path;

    var self = this;
    this.container.find(".scheduleDeliveryButton").live("click", function(event) { self.scheduleDeliveryButtonClicked(event); } );
    this.container.find(".cancelSchedule").live("click", function(event) { self.cancelScheduleClicked(event); } );
    this.container.find(".submitButton").live("click", function(event) { self.submitScheduleClicked(event); } );
    this.container.find(".show_notes_button").live("click", function(event) { self.showNotesClicked(event); } );
    this.container.find(".hide_notes_button").live("click", function(event) { self.hideNotesClicked(event); } );
    this.container.find(".add_notes_button").live("click", function(event) { self.addNotesClicked(event); } );
    this.container.find(".selectAllCheckbox").live("click", function(event) { self.selectAllClicked(event); } );
  },

  displayComments: function(order_list, data) {
    var destination = order_list.find(".notes");
    var template = this.container.find("#deliveryNotesTemplate");
    Strata.DeliveryOrder.applyMustache(destination, template, data);
    destination.show(400);
  },

  displayCommentsHandler: function(order_list) {
    var self = this;
    return function(data) {
      self.displayComments(order_list, data);
    }
  },

  addCommentsSuccessfulHandler: function(order_list) {
    var self = this;
    return function(data) {
      self.displayComments(order_list, data);
      Strata.DeliveryOrder.refreshDeliveryOrders(order_list);
    }
  },

  showNotesClicked: function(event) {
    var delivery_order_id = $(event.target).parents("tr").attr("data-delivery-order");
    var order_list_div = $(event.target).parents(".order_list");
    $.get(Strata.PathHelpers.deliveryNotesPath(delivery_order_id), this.displayCommentsHandler(order_list_div), 'json');
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
    var order_list = addNotesDiv.parents(".order_list");

    $.ajax({
      type: "POST",
      url: Strata.PathHelpers.deliveryNotesPath(delivery_order_id),
      dataType: 'json',
      data: { delivery_note: { content: content } },
      success: this.addCommentsSuccessfulHandler(order_list),
      error: function(error) { addNotesDiv.find(".add_notes_button").attr("disabled", false); }
    });
  },

  cancelScheduleClicked: function(event) {
    var parent = $(event.target).parents(".scheduleDelivery");
    parent.html('<button class="scheduleDeliveryButton">Schedule</button>');
  },

  scheduleDeliveryButtonClicked: function(event) {
    var parent = $(event.target).parents(".scheduleDelivery");

    $.get(this.new_appointment_path, function(data){
      parent.html(data);
      parent.find(".datePicker").datepicker({ dateFormat: Strata.DeliveryOrder.DATE_FORMAT });
    });
  },

  selectAllClicked: function(event) {
    var checked = event.target.checked;
    var table = $(event.target).parents(".deliveryOrdersTable");
    table.find(".deliveryOrderCheckbox").attr("checked", checked);
  },


  validateSubmitScheduleParams: function(submitParams) {
    var errors = [];
    if($.isEmptyObject(submitParams.delivery_orders)) errors.push("Please select at least one order to schedule");
    if($.isEmptyObject(submitParams.delivery_slot_id)) errors.push("Please select a delivery slot to schedule");
    if($.isEmptyObject(submitParams.delivery_date))
      errors.push("Please select a date to schedule");
    else {
      var delivery_date = $.datepicker.parseDate(Strata.DeliveryOrder.DATE_FORMAT, submitParams.delivery_date);
      if(delivery_date < new Date()) errors.push("Please select a delivery date in future");
    }

    return errors;
  },

  submitScheduleSuccessfulHandler: function(order_list) {
    var self = this;

    return function(data) {
      order_list.find(".scheduleDelivery").html(data);
      Strata.DeliveryOrder.refreshDeliveryOrders(order_list);
      Strata.DeliveryOrder.refreshDeliverySchedulesTable(self);
    }
  },

  submitScheduleFailureHandler: function(order_list) {
    return function(jqXHR) {
      var json = $.parseJSON(jqXHR.responseText);
      order_list.find(".scheduleErrorMessages").html(json.errors.join("<br/>"));
    }
  },

  submitScheduleClicked: function(event) {
    var order_list = $(event.target).parents(".order_list");

    var delivery_orders = [];
    $.each(order_list.find(".deliveryOrderCheckbox"), function(index, checkbox) {
      if(checkbox.checked)
        delivery_orders.push($(checkbox).parents("tr").attr("data-delivery-order"));
    });

    var params = {
      delivery_date: order_list.find(".datePicker").val(),
      delivery_slot_id: order_list.find(".slotSelect").val(),
      delivery_orders: delivery_orders
    };

    var errors = this.validateSubmitScheduleParams(params);
    if($.isEmptyObject(errors))
      $.ajax({
        type: "POST",
        dataType: "JSON",
        url: this.create_appointment_path,
        data: params,
        success: this.submitScheduleSuccessfulHandler(order_list),
        error: this.submitScheduleFailureHandler(order_list)
      });
    else
      order_list.find(".scheduleErrorMessages").html(errors.join("<br/>"));
  },

  refreshDeliverySchedulesTable: function() {
    var self = this;
    $.get(this.delivery_schedule_path, function(data) {
      self.container.find(".scheduleTable").html(data);
    });
  }
});

Strata.DeliveryOrder.refreshDeliveryOrders = function(order_list) {
  var membership_no = order_list.attr("data-membership-no");
  $.get("/delivery_orders/table/" + membership_no, function(data) {
    order_list.find(".deliveryOrdersTable").html(data);
  });
};

// This is just done so that I can mock it, and get around a jasmine bug
Strata.DeliveryOrder.refreshDeliverySchedulesTable = function(deliveryOrder) {
  deliveryOrder.refreshDeliverySchedulesTable();
};

Strata.DeliveryOrder.applyMustache = function(destination, template, data) {
  destination.html($.mustache(template.html(), data));
};

Strata.DeliveryOrder.DATE_FORMAT = 'dd/M/yy';
