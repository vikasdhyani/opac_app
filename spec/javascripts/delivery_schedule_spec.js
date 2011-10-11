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
      beforeEach(function() {
        $("#checkboxToBeSelected").click();
        $(".datePicker").val("02/Oct/2013");
        $("select").val("1000");
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
          expect(params.data.delivery_date).toEqual("02/Oct/2013");
          expect(params.data.delivery_slot_id).toEqual("1000");
          expect(params.data.delivery_orders).toEqual(["1234"]);
        });
        $(".submitButton").click();
        expect($.ajax).wasCalled();
      });
    });
  });
});