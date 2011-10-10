var Strata = Strata || {};

Strata.DeliverySchedule = Class.extend({
  init: function(container, new_path) {
    this.container = container;
    this.new_path = new_path;

    var self = this;
    this.container.find(".scheduleDeliveryButton").live("click", function(event) { self.scheduleDeliveryButtonClicked(event); } );
    this.container.find(".cancelSchedule").live("click", function(event) { self.cancelScheduleClicked(event); } );
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
  }
});
