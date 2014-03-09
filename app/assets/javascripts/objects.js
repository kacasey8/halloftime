function Slider(object, maxLabel, minLabel, currentLabel, decrease, increase, input) {
	this.obj = object;
	this.maxTimeLabel = maxLabel;
	this.minTimeLabel = minLabel;
	this.currentLabel = currentLabel;
	this.decrease = decrease;
	this.increase = increase;
	this.input = input;

	this.maxMinutes = 360;
	this.minMinutes = 0;

	this.obj.slider({
		value:this.maxMinutes / 2
	});

	this.minTimeLabel.text(this.minMinutes / 60 + " hr");
	this.maxTimeLabel.text(this.maxMinutes / 60 + " hr");
	this.currentLabel.text(Math.floor(this.maxMinutes / 2 / 60) + " hr " + this.maxMinutes / 2 % 60 + " min");
	this.input.val(this.maxMinutes / 2);

	this.update = update;
	function update(max) {
		if (max >= 60) {
			this.decrease.removeAttr("disabled");
			this.maxMinutes = max;
			
			this.maxTimeLabel.text(this.maxMinutes / 60 + " hr");
			if (this.obj.slider("value") > this.maxMinutes) {
				this.obj.slider("value", this.maxMinutes);
				timeSlider.currentLabel.text(Math.floor(this.obj.slider("value") / 60) + " hr " + this.obj.slider("value") % 60 + " min");
			}
			this.obj.slider({
				change: function(event,ui) {},
				min:timeSlider.minMinutes,
				max:timeSlider.maxMinutes
			}); 

			if (max == 60) {
				this.decrease.attr("disabled", "disabled");
			}
		}
		else {
			this.decrease.attr("disabled", "disabled");
		}
	}

}

function Cell(row, column) {
	this.row = row;
	this.column = column;
}