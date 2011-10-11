var Strata = Strata || {};

Strata.DeliverySchedule = Class.extend({
  init: function(container, new_path, submit_path) {
    this.container = container;
    this.new_path = new_path;
    this.submit_path = submit_path;

    var self = this;
    this.container.find(".scheduleDeliveryButton").live("click", function(event) { self.scheduleDeliveryButtonClicked(event); } );
    this.container.find(".cancelSchedule").live("click", function(event) { self.cancelScheduleClicked(event); } );
    this.container.find(".submitButton").live("click", function(event) { self.submitScheduleClicked(event); } );
  },

  cancelScheduleClicked: function(event) {
    var parent = $(event.target).parents(".scheduleDelivery");
    parent.html('<button class="scheduleDeliveryButton">Schedule</button>')
  },

  scheduleDeliveryButtonClicked: function(event) {
    var parent = $(event.target).parents(".scheduleDelivery");

    $.get(this.new_path, function(data){
      parent.html(data);
      parent.find(".datePicker").datepicker({ dateFormat: 'dd/M/yy' });
    });
  },

  validateSubmitScheduleParams: function(submitParams) {
    var errors = [];
    if($.isEmptyObject(submitParams.delivery_orders)) errors.push("Please select at least one order to schedule");
    if($.isEmptyObject(submitParams.delivery_slot_id)) errors.push("Please select a delivery slot to schedule");
    if($.isEmptyObject(submitParams.delivery_date)) errors.push("Please select a date to schedule");
    //if($.parse(delivery_date)) errors.push("Please select a date to schedule");
    return errors;
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
      $.post(this.submit_path, params);
    else
      parent.find(".scheduleErrorMessages").text(errors[0]);
  }
});
