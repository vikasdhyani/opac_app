describe("DeliveryOrder", function() {
  var deliveryOrder;

  describe("when no notes are visible", function() {
    beforeEach(function() {
      loadFixtures("delivery_order_with_no_notes_visible.html");
      deliveryOrder = new Strata.DeliveryOrder($(".order_lists"), "/foobar", "/submit/schedule");
    });

    it("fetch notes when notes button is clicked", function() {
      spyOn($, "ajax").andCallFake(function(params) {
        expect(params.type).toEqual("GET");
        expect(params.url).toEqual("/delivery_orders/1234/delivery_notes");
      });
      $(".show_notes_button").click();
      expect($.ajax).wasCalled();
    });

    it("writes the content returned into notes div with matching membership no", function() {
      spyOn($, "ajax").andCallFake(function(params) {
        params.success("foo");
      });
      $(".show_notes_button").click();
      expect($(".notes")).toHaveText("foo");
    });

    it("unhides the member's notes on clicking the view link", function() {
      spyOn($, "ajax").andCallFake(function(params) {
        params.success("foo");
      });
      $(".show_notes_button").click();
      expect($(".notes")).toBeVisible();
    });
  });

  describe("when notes are visible", function() {
    beforeEach(function() {
      loadFixtures("delivery_order_with_one_note_visible.html");
      deliveryOrder = new Strata.DeliveryOrder($(".order_lists"), "/foobar", "/submit/schedule");
    });

    it("hides the member's notes on clicking the hide link", function() {
      runs(function() {
        $(".hide_notes_button").click();
      });
      // FIXME: Remove this, and mock the clock instead
      waits(400);
      runs(function() {
        expect($(".notes")).toBeHidden();
      });
    });

    describe("adding notes", function() {
      it("adds a new note to existing delivery order when add notes button is clicked", function() {
        spyOn($, "ajax").andCallFake(function(params) {
          expect(params.type).toEqual("POST");
          expect(params.url).toEqual("/delivery_orders/4567/delivery_notes");
          expect(params.data.delivery_note.content).toEqual("foo")
        });

        $(".notesTextArea").text("foo");
        $(".add_notes_button").click();
        expect($.ajax).wasCalled();
      });

      it("reloads the index page after adding a new comment", function() {
        spyOn(Strata.DeliveryOrder, "refreshDeliveryOrders");
        spyOn($, "ajax").andCallFake(function(params) {
          params.success("foobar");
        });
        $(".notesTextArea").text("foo");
        $(".add_notes_button").click();
        expect($(".notes")).toHaveText("foobar");
        expect(Strata.DeliveryOrder.refreshDeliveryOrders).wasCalled();
      });

      it("disables the add notes button after adding a new comment", function() {
        spyOn($, "ajax");
        $(".notesTextArea").text("foo");
        $(".add_notes_button").click();
        expect($(".add_notes_button")).toBeDisabled();
      });

      it("does not fire a call if the comment is empty", function() {
        spyOn($, "ajax");
        $(".add_notes_button").click();
        expect($.ajax).wasNotCalled();
        expect($(".add_notes_button")).not.toBeDisabled();
      });

      it("enables the button if saving fails", function() {
        spyOn($, "ajax").andCallFake(function(params) {
          params.error("foobar");
        });
        $(".notesTextArea").text("foo");
        $(".add_notes_button").click();
        expect($(".add_notes_button")).not.toBeDisabled();
      });
    });
  });

  describe("when schedule is hidden", function() {
    beforeEach(function() {
      loadFixtures("delivery_order_with_schedule_hidden.html");
      deliveryOrder = new Strata.DeliveryOrder($(".order_lists"), "/foobar", "/submit/schedule");
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
      loadFixtures("delivery_order_with_schedule_visible.html");
      deliveryOrder = new Strata.DeliveryOrder($(".order_lists"), "/foobar", "/submit/schedule");
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
        tomorrow.setTime(tomorrow.getTime() + (1000 * 3600 * 24));
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

      it("show the data returned by server on successfully submitting", function() {
        spyOn($, "ajax").andCallFake(function(params) {
          params.success("foobar")
        });
        spyOn(Strata.DeliveryOrder, "refreshDeliveryOrders");
        $(".submitButton").click();
        expect($(".scheduleDelivery")).toHaveText("foobar");
        expect(Strata.DeliveryOrder.refreshDeliveryOrders).wasCalled();
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
          yesterday.setTime(yesterday.getTime() - (1000 * 3600 * 24));
          spyOn($, "ajax");
          $(".datePicker").val($.datepicker.formatDate(dateFormat, yesterday));
          $(".submitButton").click();
          expect($.ajax).not.wasCalled();
          expect($(".scheduleErrorMessages")).toHaveText("Please select a delivery date in future");
        });
      });
    });
  });

  describe("refreshing the table", function() {
    beforeEach(function() {
      loadFixtures("delivery_order_with_no_notes_visible.html");
    });

    it("fires an ajax call to fetch the table", function(){
      spyOn($, "ajax").andCallFake(function(params){
        expect(params.type).toEqual("GET");
        expect(params.url, "/delivery_orders/table/M1234");
      });
      Strata.DeliveryOrder.refreshDeliveryOrders($(".order_list"));
      expect($.ajax).wasCalled();
    });

    it("replaces the table with refresh data on success", function(){
      spyOn($, "ajax").andCallFake(function(params){
        params.success("foo");
      });
      Strata.DeliveryOrder.refreshDeliveryOrders($(".order_list"));
      expect($(".deliveryOrdersTable")).toHaveText("foo");
    });
  });
});