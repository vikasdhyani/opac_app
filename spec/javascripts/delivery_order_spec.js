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

  it("writes the content returned into notes div with matching membership no", function(){
    spyOn($, "ajax").andCallFake(function(params) {
      params.success("foo");
    });
    $(".show_notes_button").click();
    expect($("#first_notes_for_test")).toHaveText("foo");
    expect($("#second_notes_for_test")).not.toHaveText("foo");
  });

  it("unhides the member's notes on clicking the view link", function(){
    spyOn($, "ajax").andCallFake(function(params) {
      params.success("foo");
    });
    $(".show_notes_button").click();
    expect($("#first_notes_for_test")).toBeVisible();
  });

  it("hides the member's notes on clicking the hide link", function(){
    runs(function(){
      $(".hide_notes_button").click();
    });
    // FIXME: Remove this, and mock the clock instead
    waits(400);
    runs(function(){
      expect($("#second_notes_for_test")).toBeHidden();
    });
  });

  it("adds a new note to existing delivery order when add notes button is clicked", function(){
    spyOn($, "ajax").andCallFake(function(params) {
      expect(params.type).toEqual("POST");
      expect(params.url).toEqual("/delivery_orders/4567/delivery_notes");
      expect(params.data.delivery_note.content).toEqual("foo")
    });

    $(".notesTextArea").text("foo");
    $(".add_notes_button").click();
    expect($.ajax).wasCalled();
  });

  it("reloads the index page after adding a new comment", function(){
    spyOn($, "ajax").andCallFake(function(params) {
      params.success("foobar");
    });
    $(".notesTextArea").text("foo");
    $(".add_notes_button").click();
    expect($("#second_notes_for_test")).toHaveText("foobar");
  });

});