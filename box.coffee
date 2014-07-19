closestMultipleTo = ( num, mult ) ->
 return Math.round( num / mult ) * mult


getPrefixedStyle = do ->
  d = document.createElement "div"
  ( style ) ->
    capStyle = style.charAt(0).toUpperCase() + style.slice 1
    webkit = "webkit" + capStyle
    moz = "Moz" + capStyle
    ms = "ms" + capStyle
    o = "o" + capStyle 

    if d.style[webkit]?
      return webkit
    else if d.style[moz]?
      return moz
    else if d.style[ms]?
      return ms
    else if d.style[o]?
      return o
    else
      return style

# set CSS props on a node, or retreive a single property value.
# IMPORTANT: need to specify units if prop requires lenght; won't default to px like jQuery.
css = ( node, obj ) ->
  if typeof obj is "string"
    return node.style[getPrefixedStyle( obj )]
  else
    for key, val of obj
      node.style[getPrefixedStyle( key )] = val

# returns a regular array of matching elements.
querySelectorAll = ->
  if arguments[0] instanceof Node
    el = arguments[0]
    selector = arguments[1]
  else
    el = document
    selector = arguments[0]
  Array.prototype.slice.call el.querySelectorAll selector

# Box class
class Box
  constructor : ( container, opts ) ->
    { @width, @height, @depth } = opts

    @container = document.querySelector container
    css @container,
      perspective : opts.perspective or 1000
      position : "relative"

    @box = @container.querySelector ".box"
    css @box,
      width : "100%"
      height : "100%"
      transformStyle : "preserve-3d"

    # outline mitigates jagged 3d rendering in Firefox
    querySelectorAll( @box, ".face" ).forEach ( node ) ->
      css node,
        position: "absolute"
        outline: "1px solid transparent"

    @faces =
      front : @container.querySelector ".front"
      rear : @container.querySelector ".rear"
      left : @container.querySelector ".left"
      right : @container.querySelector ".right"
      top : @container.querySelector ".top"
      bottom : @container.querySelector ".bottom"
          
    @rotation = 
      x : opts.rotation?.x or 0
      y : opts.rotation?.y or 0
      z : opts.rotation?.z or 0

    @setSize()
    @setBoxTransform()


  perspective : ( set ) ->
    if set
      css @container perspective: set
    else
      css @container "perspective"


  setSize : ( opts ) =>
    { @width, @height, @depth } = opts if opts

    css @container, 
      height: @height + "px"
      width: @width + "px"

    for face, el of @faces
      switch face
        when "front", "rear"
          css el,
            height: @height + "px"
            width: @width + "px"
        when "right", "left"
          css el,
            width: @depth + "px"
            height: @height + "px"
            left: ( @width / 2 ) - ( @depth / 2 ) + "px"
        when "top", "bottom"
          css el,
            width: @width + "px"
            height: @depth + "px"
            top: ( @height / 2 ) - ( @depth / 2 ) + "px"

    css @faces.front, transform: "rotateY(0) translateZ( #{ @depth / 2 }px)"
    css @faces.rear, transform: "rotateY(180deg) translateZ( #{ @depth / 2 }px )"
    css @faces.right, transform: "rotateY( 90deg ) translateZ( #{ @width / 2 }px )"
    css @faces.left, transform: "rotateY( -90deg ) translateZ( #{ @width / 2 }px )"
    css @faces.top, transform: "rotateX( 90deg ) translateZ( #{ @height / 2 }px )"
    css @faces.bottom, transform: "rotateX( -90deg ) translateZ( #{ @height / 2 }px )"


  setBoxTransform : =>
    css @box, transform: "translateZ( #{ @depth / -2 }px ) rotateX( #{ @rotation.x }deg ) rotateY( #{ @rotation.y }deg ) rotateZ( #{ @rotation.z }deg )"


  turn : ( r ) =>
    r or= { y: 0 }
    for axis, deg of r
      console.log axis
      if axis in ["x", "y", "z"]
        @rotation[axis] += +deg
    @setBoxTransform()


  flip : =>
    @turn y: 180


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


root = ( if typeof exports isnt "undefined" and exports isnt null then exports else this )
root.Box = Box