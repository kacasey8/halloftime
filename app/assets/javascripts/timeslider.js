var timeSlider;

$( document ).ready(function() {

	timeSlider = new Slider($("#slider"), $("#maxTimeLabel"), $("#minTimeLabel"), $("#currentLabel"), $("#decrease"), $("#increase"), $("#taskMinutes"));

	$("#slider").slider({
		change: function(event,ui) {},
		step: 15,
		min:timeSlider.minMinutes,
		max:timeSlider.maxMinutes,
		animate: "slow"
	}); 

	$( "#slider" ).on( "slide", function( event, ui ) {
		timeSlider.currentLabel.text(Math.floor(ui.value / 60) + " hr " + ui.value % 60 + " min");
		timeSlider.input.val(ui.value);
	} );

	$("#increase").click(function() {
		timeSlider.update(timeSlider.maxMinutes += 60);
	});

	$("#decrease").click(function() {
		timeSlider.update(timeSlider.maxMinutes -= 60);
	});
});

$( window ).load(function() {

});