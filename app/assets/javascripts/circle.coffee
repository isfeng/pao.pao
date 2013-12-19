class window.Circle
    constructor: (id, x, y, easing)->
        @id = id
        @friends = []
        @shape = new createjs.Shape
        @shape.x = x
        @shape.y = y
        @shape.regX = @shape.regY = 25
        
        @load_picture (response)=>
            image = new Image
            image.src = response.data.url
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
        @hitObj.addEventListener "click", @handle_click
    
    handle_click: (event)=>
        @show_friends()
         
    draw: (stage, max)->
        @stage = stage
        if(max)
            @max_distance = max
        else
            @max_distance = if @stage.canvas.width > @stage.canvas.height then @stage.canvas.width else @stage.canvas.height
            
        stage.addChild(@hitObj)
        stage.addChild(@shape)
        
    arround: (centerX, centerY)->
        if @friends.length > 0 
            friend.arround @hitObj.x, @hitObj.y for friend in @friends
        else
            dx = centerX - @shape.x;
            dy = centerY - @shape.y;
            
            if Math.sqrt(dx * dx + dy * dy) > @max_distance
                @shape.x += dx * @easing;
                @shape.y += dy * @easing;
            else if (Math.sqrt(dx * dx + dy * dy) < 75)              
                @shape.x -= dx * @easing;
                @shape.y -= dy * @easing;
    
            x1 = @shape.x - centerX;
            y1 = @shape.y - centerY;
            x2 = x1 * @cosvr - y1 * @sinvr;
            y2 = y1 * @cosvr + x1 * @sinvr;
            @hitObj.x = @shape.x = centerX + x2;
            @hitObj.y = @shape.y = centerY + y2;
            
    near: (mouseX, mouseY)->
        dx = mouseX - @shape.x;
        dy = mouseY - @shape.y;
        return Math.sqrt(dx * dx + dy * dy) < 50;

    load_picture: (callback)->
        FB.api('/'+@id+'/picture', callback);

    show_friends: ()=>
        return if @friends.length > 0
        FB.api '/'+@id+'/friends', (response)=>
            if(!response.error)
                _friends = response.data
                for friend in _friends
                    x = _.random(@shape.x-150, @shape.x+150)
                    y = _.random(@shape.y-150, @shape.y+150)                        
                    easing = _.random(1, 5) / 500
                    circle = new Circle(friend.id, x, y, easing)
                    @friends.push(circle)
                    circle.draw(@stage)
