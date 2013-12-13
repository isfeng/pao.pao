class Circle
	constructor: (img, x, y, easing)->
		@shape = new createjs.Shape()
		@shape.x = x
		@shape.y = y
		@shape.regX = @shape.regY = 40
		
		image = new Image
		image.src = img
		image.onload = ()->
			@shape.graphics.beginStroke("rgba(0,0,0,1)").beginBitmapFill(image).drawCircle(40, 40, 40).endStroke();
			
		@easing = easing;
		@vr = Math.PI * 2 / _.random(360, 420);
		@cosvr = Math.cos(@vr);
		@sinvr = Math.sin(@vr);
		
	draw: (stage)->
		stage.addChild(@shape)
		
	arround: ()->
		
	near: ()->

###
function Profile(img, x, y, easing) {
  this.shape = new createjs.Shape();
  var shape = this.shape;
  shape.x = x;
  shape.y = y;
  shape.regX = shape.regY = 40;

  var image = new Image();
  image.src = img;
  image.onload = function() {
    shape.graphics.beginStroke("rgba(0,0,0,1)").beginBitmapFill(image).drawCircle(40, 40, 40).endStroke();
  };

  this.easing = easing;
  this.vr = Math.PI * 2 / _.random(360, 420);
  this.cosvr = Math.cos(this.vr);
  this.sinvr = Math.sin(this.vr);

  // shape.addEventListener('click', handleMouseEvent);
}

Profile.prototype.draw = function(stage) {
  stage.addChild(this.shape);
};

Profile.prototype.arround = function(mouseX, mouseY, max_distance) {
  var dx = mouseX - this.shape.x;
  var dy = mouseY - this.shape.y;
  if (Math.sqrt(dx * dx + dy * dy) > max_distance) {
    this.shape.x += dx * this.easing;
    this.shape.y += dy * this.easing;
  } else if (Math.sqrt(dx * dx + dy * dy) < 120) {
    this.shape.x -= dx * this.easing;
    this.shape.y -= dy * this.easing;
  }
  var x1 = this.shape.x - mouseX;
  var y1 = this.shape.y - mouseY;
  var x2 = x1 * this.cosvr - y1 * this.sinvr;
  var y2 = y1 * this.cosvr + x1 * this.sinvr;
  this.shape.x = mouseX + x2;
  this.shape.y = mouseY + y2;
};

Profile.prototype.near = function(mouseX, mouseY) {
  var dx = mouseX - this.shape.x;
  var dy = mouseY - this.shape.y;
  return Math.sqrt(dx * dx + dy * dy) < 50;
};

###