describe("DeliverySchedule", function() {
  beforeEach(function() {
    loadFixtures("delivery_schedule.html");
    new Strata.DeliverySchedule($(".order_lists"), "/foobar", "/submit/schedule")
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

  describe("submitting new form", function() {
    beforeEach(function(){
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