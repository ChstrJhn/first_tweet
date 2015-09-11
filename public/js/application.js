$(document).ready(function() {

$("#celebratin").find("img").hide();
var interval;
var pause = 1000;

$(".post_tweet").submit(function(event){

  event.preventDefault();
  var $button = $(this).children("#post_tweet_btn");
  $button.val("Updating..");
  $button.attr("disabled","true");

  $.ajax({
    url: $(this).attr("action"),
  	method: $(this).attr("method"),
    dataType: 'json',
  	data: $(this).serialize(),
  }).done(function(response){

      console.log(response.jid);
      var jid = response.jid;
      checkStatus(jid);
      $("#latest_tweet").html("<p>Nice, your timeline will be updated soon.<a id='timeline' href='/timeline'>View your timeline.</a></p>");
      $button.val("Updated");
      $("#celebratin").find("img").show();

    });

  });

$("body").on("click", "#timeline", (function(event){
	event.preventDefault();
	console.log("hi");

	$.ajax({
		url: $(this).attr("href"),
		type: "GET",
		dataType: "html"
	}).done(function(response){

	  $("#latest_tweet").hide();
	  $("#celebratin").find("img").hide();
    $("#user_timeline").html(response);

	});

}));

function checkStatus(jid) {
  interval = setInterval(function(){
    $.ajax({
      type: "GET",
      url: "/status/" + jid
    }).done(function(response){
      if (response === true){
        $("#countdown").html("<p>Your tweet has flown!</p>");
      }
      else{
        $("#countdown").html("<p>Still waiting...</p>");
      }
    });
  },pause);
}


});
