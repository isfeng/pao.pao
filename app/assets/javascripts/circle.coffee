class window.Circle
	constructor: (img, x, y, easing)->
		@shape = new createjs.Shape
		@shape.x = x
		@shape.y = y
		@shape.regX = @shape.regY = 25
		
		image = new Image
		image.src = img
		image.onload = ()=>
			@shape.graphics.beginStroke("rgba(0,0,0,1)").beginBitmapFill(image).drawCircle(25, 25, 25).endStroke();
		
		@easing = easing;
		@vr = Math.PI * 2 / _.random(360, 420);
		@cosvr = Math.cos(@vr);
		@sinvr = Math.sin(@vr);
		
		@hitObj = new createjs.Shape
		@hitObj.x = x
		@hitObj.y = y
		@hitObj.regX = @hitObj.regY = 25
		@hitObj.graphics.beginFill('EEE').drawCircle(25, 25, 25)
		@hitObj.addEventListener "click", @handleClick
	
	handleClick: (event)->
		console.log event
		 
	draw: (stage)->
		stage.addChild(@hitObj)
		stage.addChild(@shape)
		
	arround: (mouseX, mouseY, max_distance)->
	    dx = mouseX - @shape.x;
	    dy = mouseY - @shape.y;
	    
	    if Math.sqrt(dx * dx + dy * dy) > max_distance
	      @shape.x += dx * @easing;
	      @shape.y += dy * @easing;
	    else if (Math.sqrt(dx * dx + dy * dy) < 120)
	      @shape.x -= dx * @easing;
	      @shape.y -= dy * @easing;

	    x1 = @shape.x - mouseX;
	    y1 = @shape.y - mouseY;
	    x2 = x1 * @cosvr - y1 * @sinvr;
	    y2 = y1 * @cosvr + x1 * @sinvr;
	    @hitObj.x = @shape.x = mouseX + x2;
	    @hitObj.y = @shape.y = mouseY + y2;

	near: (mouseX, mouseY)->
	    dx = mouseX - @shape.x;
	    dy = mouseY - @shape.y;
	    return Math.sqrt(dx * dx + dy * dy) < 50;
