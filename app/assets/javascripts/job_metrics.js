var send_daily_summary = function(t,metric,profile_id){
    var btn_text = $(t).text();
    $(t).text("Please wait... ");
    $.ajax({
        url:  "/home/send_daily_summary", 
        type: "POST",
        dataType: 'json',
        data: {metric_type: metric,profile:profile_id},
        success: function(data) {
            if(data.hasOwnProperty('errors')){
              $("#notice").html(data["errors"])         
            }
            else{
                $("#notice").html(data["message"])
                $(t).text(btn_text);
            }                    
        }
    });
}

var send_selecte_metrics = function(t,metric,profile_id){
    var btn_text = $(t).text();
    $(t).text("Please wait... ");
    var form = $("#summary_form").serialize()
    $.ajax({
        url:  "/profiles/"+profile_id, 
        type: "PUT",
        dataType: 'json',
        data: form,
        success: function(data) {
            if(data.hasOwnProperty('errors')){
              $("#notice").html(data["errors"])         
            }
            else{
                $("#notice").html(data["message"])
                $(t).text(btn_text);
            }                    
        }
    });
}

$(document).ready(function() {
  $("#summary_form").on('submit', function(e){
      e.preventDefault();
  });

  $("#profile_scheduler_attributes_id").on('change',function(ele){
    if($("#profile_scheduler_attributes_id").val()=="")
    {
        $("#time_fields").hide();
    }
    else{
        $("#time_fields").show();
    }
  })
});

