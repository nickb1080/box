closestMultipleTo = ( num, mult ) ->
 return Math.round( num / mult ) * mult

class Box
  constructor : ( container, opts ) ->
    { @width, @height, @depth } = opts

    @container = $ container
    @container.css
      perspective : opts.perspective or 1000
      position : "relative"

    @box = @container.find ".box"
    @box.css
      width : "100%"
      height : "100%"
      transformStyle : "preserve-3d"

    @box.find ".face"
      .css "position", "absolute"

    @faces = do =>
      front : @container.find ".front"
      rear : @container.find ".rear"
      left : @container.find ".left"
      right : @container.find ".right"
      top : @container.find ".top"
      bottom : @container.find ".bottom"
          
    @rotation = 
      x : 0
      y : 0
      z : 0

    @setSize()
    @setCubeTransform()


  perspective : ( set ) ->
    if set
      return @container.css "perspective", set
    else
      return @container.css "perspective"


  setSize : ( opts ) ->
    { @width, @height, @depth } = opts if opts

    @container.css
      height: @height
      width: @width

    for face, el of @faces
      switch face
        when "front", "rear"
          el.css
            height: @height
            width: @width
        when "right", "left"
          el.css
            width: @depth
            height: @height
            left: ( @width / 2 ) - ( @depth / 2 )
        when "top", "bottom"
          el.css
            width: @width
            height: @depth
            top: ( @height / 2 ) - ( @depth / 2 )

    @faces.front.css "transform", "rotateY(0) translateZ( #{ @depth / 2 }px)"
    @faces.rear.css "transform", "rotateY(180deg) translateZ( #{ @depth / 2 }px )"
    @faces.right.css "transform", "rotateY( 90deg ) translateZ( #{ @width / 2 }px )"
    @faces.left.css "transform", "rotateY( -90deg ) translateZ( #{ @width / 2 }px )"
    @faces.top.css "transform", "rotateX( 90deg ) translateZ( #{ @height / 2 }px )"
    @faces.bottom.css "transform", "rotateX( -90deg ) translateZ( #{ @height / 2 }px )"

  setCubeTransform : ->
    @box.css "transform", "translateZ( #{ @depth / -2 }px ) rotateX( #{ @rotation.x }deg ) rotateY( #{ @rotation.y }deg ) rotateZ( #{ @rotation.z }deg )"


  turn : ( deg = 0, axis = "y" ) =>
    return if axis not in ["x", "y", "z"]
    @rotation[axis] += +deg
    @setCubeTransform()


  flip : =>
    @turn( 180 )


  showBack : =>
    unless @rotation.y % 180 is 0 and @rotation.y % 360 isnt 0
      tmp = closestMultipleTo( @rotation.y, 360 )
      unless tmp % 360
        if tmp > @rotation.y then tmp = tmp - 180 else tmp = tmp + 180
      @rotation.y = tmp
      @turn()


  showFront : =>
    unless @rotation.y % 360
      @rotation.y = closestMultipleTo( @rotation.y, 360 )
      @turn()


  onBack : =>
    return ( @rotation.y % 180 is 0 and @rotation.y % 360 isnt 0 ) 


  onFront : =>
    return ( @rotation.y % 360 is 0 )


this.Box = Box