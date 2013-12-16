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
        console.log event
        console.log @id
        @show_friends()
         
    draw: (stage)->
        @stage = stage
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
        for friend in @friends
            friend.arround @x, @y, 500

    near: (mouseX, mouseY)->
        dx = mouseX - @shape.x;
        dy = mouseY - @shape.y;
        return Math.sqrt(dx * dx + dy * dy) < 50;

    load_picture: (callback)->
        FB.api('/'+@id+'/picture', callback);

    show_friends: ()->
        console.log 'show_friends'
        console.log @id
        FB.api '/'+@id+'/friends', (response)=>
            console.log response
            _friends = response.data
            console.log response
            for friend in _friends
                do (friend) ->
                    x = _.random(0, @canvas.width - 0)
                    y = _.random(0, @canvas.height - 0)
                    easing = _.random(1, 5) / 500
                    circle = new Circle(friend.id, x, y, easing)
                    @friends.push(circle)
                    circle.draw(@stage)


