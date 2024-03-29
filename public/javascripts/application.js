// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults

$('.toggle_history').live('click', function() {
	var history_id = this.id.split("_");
	history_id.shift();
	history_id = '#' + history_id.join("_");

	$(history_id).toggle();

	var isShown = ($(history_id).css("display") == "none" ? false : true);

	this.innerHTML = (isShown ? "Hide History" : "Show History");

	if ( isShown ) {
		$(history_id).data('jsp').reinitialise();
	}
});

$('.toggle_stock').live('click', function() {
	var stock_id = this.id.split("_");
	stock_id.shift();
	stock_id = '#' + stock_id.join("_");

	$(stock_id).toggle();

	var isShown = ($(stock_id).css("display") == "none" ? false : true);

	this.innerHTML = (isShown ? "Hide Stock" : "Show Stock");

	if ( isShown ) {
		$(stock_id).data('jsp').reinitialise();
	}
});

var IBTapp = {};
IBTapp.Charts = {};
IBTapp.ChartData = {};
IBTapp.panels = ['div_req_','div_ass_','div_can_','div_pro_','div_alt_'];

IBTapp.showPanel = function (paneId, panelId) {
	$.each(IBTapp.panels, function(index, value) {
		var id = '#' + value + paneId;
		$(id).hide();
	});

	$('#'+panelId).show(600, function() {
			
		if (panelId.indexOf('ass') > 0) {

			if (!IBTapp.Charts["stock"+paneId]) {
				IBTapp.Charts["stock"+paneId] = new $jit.BarChart({
				  injectInto: 'chart_ibtr_' + paneId,  
				  animate: true,  
				  orientation: 'vertical',  
				  barsOffset: 1,  
				  Margin: {top:5, left: 5, right: 5,bottom:5},
				  labelOffset: 5,
				  type: 'stacked',  
				  showAggregates:true, 
				  showLabels:true, 
				  Label: {type: 'HTML', size: 10, family: 'Arial', color: 'black'}, 
				  Tips: {enable: true,  
				    onShow: function(tip, elem) {  
				      tip.innerHTML = "<span class='tooltip'><b>  " + elem.name + "</b>: " + elem.value + "  </span>";
				    }  
				  }
				});
			}

			IBTapp.Charts["stock"+paneId].loadJSON(IBTapp.ChartData["infovis"+paneId]);
		}
    
    
	});
	$('#flash_'+paneId).html('');
};

IBTapp.showAltTitle = function (paneId, panelId, titleId, ibtrId) {
  IBTapp.showPanel(paneId, panelId);
  $.get('/titles/qryAltTitle?show=all&queryTitleId=' + titleId+ '&ibtrId=' + ibtrId,
  function(data) {
    $('#'+panelId+' #div_srch').html(data);
  });
}


IBTapp.showExactTitle = function (paneId, panelId, titleId, ibtrId) {
  IBTapp.showPanel(paneId, panelId);
  $.get('/titles/qryAltTitle?show=exact&queryTitleId=' + titleId+ '&ibtrId=' + ibtrId,
  function(data) {
    $('#'+panelId+' #div_srch').html(data);
  });
}
var IBTStatApp = {};
IBTStatApp.Charts = {};
IBTStatApp.ChartData = {};

IBTStatApp.showChart = function(panelId, bartype, show_aggregate){

  $('#'+panelId).show(600, function() {

  if (!IBTStatApp.Charts["ibtr"+panelId]) {
    IBTStatApp.Charts["ibtr"+panelId] = new $jit.BarChart({
      injectInto: panelId+'_chart_stat',  
      animate: true,  
      orientation: 'vertical',  
      barsOffset: 1,  
      Margin: {top:5, left: 5, right: 5,bottom:5},
      labelOffset: 5,
      type: bartype,  
      showAggregates:show_aggregate, 
      showLabels:true, 
      Label: {type: 'HTML', size: 10, family: 'Arial', color: 'black'}, 
      Tips: {enable: true,  
        onShow: function(tip, elem) {  
          tip.innerHTML = "<span class='tooltip'><b>  " + elem.name + "</b>: " + elem.value + "  </span>";
        }  
      }
    });
  }
  
  IBTStatApp.Charts["ibtr"+panelId].loadJSON(IBTStatApp.ChartData["infovis"+panelId]);
	});	
}

var IBThist ={}
IBThist.hide = function (paneId, panelId) {
		var id = '#' + paneId;
		$(id).hide(600);

}
IBThist.show = function (paneId, panelId) {
		var id = '#' +  paneId;
		$(id).show(600);
}
IBThist.showhide = function (showId, hideId) {

		var hideid = '#' +  hideId;
		$(hideid).hide(600);
    var showid = '#' +  showId;
		$(showid).show(600);
}
IBTapp.initSearchForm = function (option, onload) {
	if (option == 'respondent_id' || option == 'branch_id') {
		$('.ibtrSearch #branchVal').show();
		$('.ibtrSearch #searchText').hide();
	} else {
		$('.ibtrSearch #branchVal').hide();
		$('.ibtrSearch #searchText').show();
	}
};

$('.ibtrSearch #searchBy').live('change', function() {IBTapp.initSearchForm($('.ibtrSearch #searchBy').val(), false);});

IBTStatApp.initStatForm = function (option, onload) {
	if (option == 'On' || option == 'Range') {
		$('.ibtrStat #div_start_date').show();
     
    if (option == 'Range'){
      $('.ibtrStat #div_end_date').show();
		}
    else
    {
      $('.ibtrStat #div_end_date').hide();
    }
	} else {
		$('.ibtrStat #div_start_date').hide();
		$('.ibtrStat #div_end_date').hide();
	}
};

$('.ibtrStat #Created').live('change', function() {IBTStatApp.initStatForm($('.ibtrStat #Created').val(), false);});

$('#authors th a, #authors .pagination a, #authors td a').live('click', function() {
	$.getScript(this.href);
	return false;
});

$('#new_signup input[name="signup[payment_mode]"]:radio').live('change', function() {
	$('#new_signup #signup_check_div').hide();
	$('#new_signup #signup_card_div').hide();
	$('#new_signup #signup_card_no').val('');
	$('#new_signup #signup_check_no').val('');
	$('#new_signup input[name="signup[payment_mode]"]:radio:checked ~ span').show();
});

$('#new_signup #signup_coupon_id').live('change', function() {
	$.get('/signups/compute?' + 'signup_months=' + $('#signup_signup_months').val() + '&plan_id=' + $('#signup_plan_id').val() + '&coupon_id=' + $(this).val(),
		function(data) {
			$('#new_signup #payment_div').html(data);
		});

	if ( $(this).val() != '' )
		$('#new_signup #signup_coupon_no_div').show();
	else {
		$('#new_signup #signup_coupon_no_div').hide();
	};
});

var ConsignmentApp = {};
ConsignmentApp.addGood = function(goodstable) {
	alert('not implemented');
}

ConsignmentApp.removeGood = function(link) {
	$(link).prev("input[type='hidden']").val(true);
	$(link).parents("tr").hide();
};

ConsignmentApp.receiveGood = function(link) {
	$(link).prev("input[type='hidden']").val('deliver');
	$(link).parents("tr").hide();
};


function modifyMode(modeId, branch_id, start_date, end_date){
    var mode = 'T';
    if(modeId.indexOf("Un-Processed") != -1){
        mode = 'U'
    }else if(modeId.indexOf("Processed") != -1){
        mode = 'P'
    }else if(modeId.indexOf("Error") != -1){
        mode = 'E'
    }
    
    $.get('/report_details?' + 'branch_id=' + branch_id + '&modifyMode=' + mode +
        '&start_date=' + start_date + '&end_date=' + end_date,
            function(data){
               $('#signups_report_details').html(data);
            });
}

$('#refresh_signups_report').live('click', function(){
    $('#signups_report').submit();

    return false;
});

$('#signups_report').live('submit', function(){
    // flush msg box
    $('#signups_report_msg').html("");

    var start_date_month = $('#start_date_2i').val();
    if(start_date_month < 10){
        start_date_month = '0' + start_date_month.toString();
    }

    var start_date_yr = $('#start_date_1i').val().substr(2, 4);
    var end_date_yr = $('#end_date_1i').val().substr(2, 4);
        
    var start_date = $('#start_date_3i').val() + '-' +
        start_date_month + '-' + start_date_yr;

    var end_date_month = $('#end_date_2i').val();
    if(end_date_month < 10){
        end_date_month = '0' + end_date_month.toString();
    }
    var end_date = $('#end_date_3i').val() + '-' +
        end_date_month + '-' + end_date_yr;

    // make the report_details js call
    var branch_id = $('#branch_id').val();
    modifyMode('T', branch_id, start_date, end_date);

    return false;
});

$('#nm_reversal a').live('click', function(){
    var card_number = $(this).attr('card_number');
    var nm_reversal = '#nm_reversal_' + card_number;
    var nm_reversal_confirm = '#nm_reversal_confirm_' + card_number;
    var nm_reversal_cancel = '#nm_reversal_cancel_' + card_number;
    $(nm_reversal).hide(400);
    $(nm_reversal_confirm).show(1000);
    $(nm_reversal_cancel).show(1000);

    return false;
});

$('#nm_reversal_confirm a').live('click', function(){
    var card_number = $(this).attr('card_number');
    $.get('/newMemberReversal?' + 'card_number=' + card_number,
        function(){
            $('#signups_report').submit();

            var report_msg = '<font color="green"><b>' +
                "New Member Reversal done for : " +
                card_number + '</b></font>'
            $('#signups_report_msg').html(report_msg);
        });       

    return false;
});

$('#nm_reversal_cancel a').live('click', function(){
    var card_number = $(this).attr('card_number');
    var nm_reversal = '#nm_reversal_' + card_number;
    var nm_reversal_confirm = '#nm_reversal_confirm_' + card_number;
    var nm_reversal_cancel = '#nm_reversal_cancel_' + card_number;
    $(nm_reversal_confirm).hide(400);
    $(nm_reversal_cancel).hide(400);
    $(nm_reversal).show(1000);

    return false;
});

var Sessionapp = {};
Sessionapp.Charts = {};
Sessionapp.ChartData = {};
current_node_id="801_jb";
function split_data(){
  children=[];
  jbClc={"id": Sessionapp.ChartData["infovis"].id,
        "name" : Sessionapp.ChartData["infovis"].name,
        "children":[],
        "data":Sessionapp.ChartData["infovis"].data}
  
  $.each(Sessionapp.ChartData["infovis"].children, function(index, value) {
      child={"id":value.id,
             "name":value.name,
             "data":value.data,
             "children":[]}
      children_1 = [];
      children_1[0] = jbClc;
      $.each(value.children, function(idx, val) {
          child_1={"id": val.id,
            "name" : val.name,
            "children":val.children,//todo
            "data":val.data}
          children_1_1=[];
            $.each(val.children,function(i,v){
              child_1_1 = {"id": v.id,
                    "name" : v.name,
                    "children":[],
                    "data":v.data}
              children_1_1[i] = child_1_1;
            });
            Sessionapp.ChartData[val.id]={
              "id":val.id,
              "name" : val.name,
            "children":children_1_1,
            "data":val.data};
          children_1[idx+1]=child_1;
      });
      Sessionapp.ChartData[value.id]={
        "id":value.id,
        "name" : value.name,
      "children":children_1,
      "data":value.data};
      children[index] = child;
    });
    Sessionapp.ChartData["801_jb"]={"id": Sessionapp.ChartData["infovis"].id,
      "name" : Sessionapp.ChartData["infovis"].name,
      "children":children,
      "data":Sessionapp.ChartData["infovis"].data}
      
}

Sessionapp.showPanel = function () {
w = 600;
h= 600;
split_data();

  var ht = new $jit.Hypertree({  
    //id of the visualization container  
    injectInto: 'infovis',  
    //canvas width and height  
    width: w,  
    height: h,  
    levelsToShow : 2,
    //Change node and edge styles such as  
    //color, width and dimensions.  
    Node: {  
        //dim: 40,  
        //color: "#f00",
        overridable: true,
          type: 'star',
          color: '#ccb',
          lineWidth: 1,
          height: 5,
          width: 5,
          dim: 40,
          transform: true    
    },  
    Edge: {  
        lineWidth: 2,  
        color: "#088"  ,
        overridable: false,
          type: 'hyperline',
        //  color: '#ccb',
          //lineWidth: 1
    },
    duration: 700,
    fps: 30,
    //transition: Trans.Quart.easeInOut,
    clearCanvas: true,
    withLabels: true,  
    onBeforePlotNode:function(node) {
        
        if(node.selected) {  
          //node.setData('color', '#f00');  
        } else {  
          //node.setData('color','#ccb');  
        }  
    },
    onBeforeCompute: function(node){  
    },  
    //Attach event handlers and add text to the  
    //labels. This method is only triggered on label  
    //creation  
    onCreateLabel: function(domElement, node){  
        domElement.innerHTML = node.name;  
        

        $jit.util.addEvent(domElement, 'click', function () {  
          
        
            ht.onClick(node.id, {  
                onComplete: function() {  
                    ht.controller.onComplete();  
                }  
            });  
        });  
    },  
    //Change node styles when labels are placed  
    //or moved.  
    onPlaceLabel: function(domElement, node){  
        var style = domElement.style;  
        style.display = '';  
        style.cursor = 'pointer';  
        if (node._depth <= 1) {  
            style.fontSize = "1em";  
            style.color = "#1a1a1a";
        } else if(node._depth == 2){ 
            style.fontSize = "0.8em";  
            style.color = "#555";  
    
        } else {  
            style.display = 'none';  
        }  
    
        var left = parseInt(style.left);  
        var w = domElement.offsetWidth;  
        style.left = (left - w / 2) + 'px';  
    },  
      
    onComplete: function(){  
          
        //Build the right column relations list.  
        //This is done by collecting the information (stored in the data property)   
        //for all the nodes adjacent to the centered node.  
        var node = ht.graph.getClosestNodeToOrigin("current");  
        var html = "<h4>" + node.name + "</h4><b>Connections:</b>";  
        html += "<ul>";  
        node.eachAdjacency(function(adj){  
            var child = adj.nodeTo;  
            if (child.data) {  
                var rel = (child.data.band == node.name) ? child.data.relation : node.data.relation;  
                html += "<li>" + child.name + " " + "<div class=\"relation\">(relation: " + rel + ")</div></li>";  
                
            }
            
        });  
        html += "</ul>";  
        //$jit.id('inner-details').innerHTML = html;  
        
        current_node_id = node.id;
        if (node.data.subdomain != 'city'){
          url = '/auth/'+node.data.subdomain;
          //$(location).attr('href',url);
          document.location.replace(url);
        }
        else
        {
          ht.loadJSON(Sessionapp.ChartData[current_node_id], 1);  
          ht.refresh(); 
        }
          
    }  
  }
  );  
  //load JSON data.  
  
  ht.loadJSON(Sessionapp.ChartData[current_node_id], 1);  
  //compute positions and plot.  
  ht.refresh(); 
 }
 
 $('.pagination.ajax a').live('click', function() {

	var panelId = $(this).parents("div")[4].id;
  
  $.get(this.href,
    function(data) {
      $('#'+panelId+' #div_srch').html(data);
    });
  return false;
})