describe("DeliveryOrder", function() {
  beforeEach(function(){
    loadFixtures("delivery_order.html");
    new Strata.DeliveryOrder($(".order_lists"))
  });

  it("fetch notes when notes button is clicked", function(){
    spyOn($, "ajax").andCallFake(function(params) {
      expect(params.type).toEqual("GET");
      expect(params.url).toEqual("/delivery_orders/1234/delivery_notes");
    });
    $(".show_notes_button").click();
    expect($.ajax).wasCalled();
  });
});
