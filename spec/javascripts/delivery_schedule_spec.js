describe("DeliverySchedule", function() {
  beforeEach(function(){
    loadFixtures("delivery_schedule.html");
    new Strata.DeliverySchedule($(".order_lists"), "/foobar")
  });

  describe("scheduling delivery", function() {
    it("makes an ajax call to get ", function(){
      spyOn($, "ajax").andCallFake(function(params){
        expect(params.url).toEqual("/foobar");
      });
      $(".scheduleDeliveryButton").click();
      expect($.ajax).wasCalled();
    });

    it("replaces the existing div", function(){
      spyOn($, "ajax").andCallFake(function(params){
        params.success('<input class="datePicker"/>')
      });
      $(".scheduleDeliveryButton").click();
      expect($(".scheduleDelivery .datePicker")).toExist();
      expect($(".datePicker")).toHaveClass("hasDatepicker");
    });

  });
});