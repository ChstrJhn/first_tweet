$(document).ready(function() {

$("#celebratin").find("img").hide();

$(".post_tweet").submit(function(event){
  event.preventDefault();
  var $button = $(this).children("#post_tweet_btn");
  $button.val("Updating..");
  $button.attr("disabled","true");

  $.ajax({
  	url: $(this).attr("action"),
  	method: $(this).attr("method"),
  	data: $(this).serialize()
  }).done(function(response){
     $("#latest_tweet").html("<p>You've posted a new tweet.<a id='timeline' href='/timeline'>View your timeline.</a></p>");
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



});
