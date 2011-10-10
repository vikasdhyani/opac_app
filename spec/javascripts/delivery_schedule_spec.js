describe("DeliverySchedule", function() {
  beforeEach(function() {
    loadFixtures("delivery_schedule.html");
    new Strata.DeliverySchedule($(".order_lists"), "/foobar")
  });

  describe("schedule delivery button", function() {
    it("makes an ajax call to get ", function() {
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
      expect($("#divForTestingShowScheduleForm .datePicker")).toExist();
      expect($(".datePicker")).toHaveClass("hasDatepicker");
    });
  });

  describe("cancel schedule delivery", function() {
    it("should hide new appointment form on clicking cancel", function() {
      $(".cancelSchedule").click();
      expect($("#divForTestingHideScheduleForm .scheduleDeliveryButton")).toExist();
    });
  });
});