describe("DeliverySchedule", function() {
  describe("when schedule is hidden", function() {
    beforeEach(function() {
      loadFixtures("delivery_schedule_with_schedule_hidden.html");
      new Strata.DeliverySchedule($(".order_lists"), "/foobar", "/submit/schedule")
    });

    it("makes an ajax call to get new form", function() {
      spyOn($, "ajax").andCallFake(function(params) {
        expect(params.url).toEqual("/foobar");
      });
      $(".scheduleDeliveryButton").click();
      expect($.ajax).wasCalled();
    });

    it("replaces the existing div", function() {
      spyOn($, "ajax").andCallFake(function(params) {
        params.success('<input class="datePicker"/>')
      });
      $(".scheduleDeliveryButton").click();
      expect($(".scheduleDelivery .datePicker")).toExist();
      expect($(".datePicker")).toHaveClass("hasDatepicker");
    });
  });

  describe("when schedule is visible", function() {
    beforeEach(function() {
      loadFixtures("delivery_schedule_with_schedule_visible.html");
      new Strata.DeliverySchedule($(".order_lists"), "/foobar", "/submit/schedule")
    });

    it("should hide new appointment form on clicking cancel", function() {
      $(".cancelSchedule").click();
      expect($(".scheduleDelivery .scheduleDeliveryButton")).toExist();
    });

    describe("submitting new form", function() {
      var tomorrow;
      var dateFormat = "dd/M/yy";

      beforeEach(function() {
        $("#checkboxToBeSelected").attr("checked", true);
        $("select").val("1000");
        tomorrow = new Date();
        tomorrow.setTime(tomorrow.getTime() + (1000*3600*24));
        $(".datePicker").val($.datepicker.formatDate(dateFormat, tomorrow));
      });

      it("on submitting new form, selected delivery orders should have chosen delivery schedule", function() {
        spyOn($, "ajax").andCallFake(function(params) {
          expect(params.url).toEqual("/submit/schedule");
        });
        $(".submitButton").click();
        expect($.ajax).wasCalled();
      });

      it("passes a list of delivery_order ids, date and delivery_slot id", function() {
        spyOn($, "ajax").andCallFake(function(params) {
          expect(params.data.delivery_date).toEqual($.datepicker.formatDate(dateFormat, tomorrow));
          expect(params.data.delivery_slot_id).toEqual("1000");
          expect(params.data.delivery_orders).toEqual(["1234"]);
        });
        $(".submitButton").click();
        expect($.ajax).wasCalled();
      });

      describe("validations", function() {
        it("should not fix the delivery schedule if no checkbox is selected", function() {
          spyOn($, "ajax");
          $("#checkboxToBeSelected").attr("checked", false);
          $(".submitButton").click();
          expect($.ajax).not.wasCalled();
          expect($(".scheduleErrorMessages")).toHaveText("Please select at least one order to schedule");
        });

        it("should not fix the delivery schedule if date is not selected", function() {
          spyOn($, "ajax");
          $(".datePicker").val("");
          $(".submitButton").click();
          expect($.ajax).not.wasCalled();
          expect($(".scheduleErrorMessages")).toHaveText("Please select a date to schedule");
        });

        it("should not fix the delivery schedule if delivery slot is not selected", function() {
          spyOn($, "ajax");
          $("select").val("");
          $(".submitButton").click();
          expect($.ajax).not.wasCalled();
          expect($(".scheduleErrorMessages")).toHaveText("Please select a delivery slot to schedule");
        });

        it("should not fix the delivery schedule if delivery slot is not selected", function() {
          var yesterday = new Date();
          yesterday.setTime(yesterday.getTime() - (1000*3600*24));
          spyOn($, "ajax");
          $(".datePicker").val($.datepicker.formatDate(dateFormat, yesterday));
          $(".submitButton").click();
          expect($.ajax).not.wasCalled();
          expect($(".scheduleErrorMessages")).toHaveText("Please select a delivery date in future");
        });
      });
    });
  });
});