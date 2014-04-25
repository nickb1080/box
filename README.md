# Cubicle
_Layout HTML as a cube w/ CSS plus programmatic control

Forked from [Cube5](https://github.com/guille/Cube5)

Cube5 is entirely CSS(3) based, including the animations, so it only requires that you include the CSS snippet `cube5.css`.
The markup should look like this

	<div class="cube-container" id="demo-cube">
	  <div class="cube toFront">      
	    <div class="face top"><h3>Top</h3></div>
	    <div class="face front"><h3>Front</h3></div>
	    <div class="face bottom"><h3>Bottom</h3></div>
	    <div class="face left"><h3>Left</h3></div>
	    <div class="face right"><h3>Right</h3></div>
	    <div class="face rear"><h3>Rear</h3></div>      
	  </div>
	</div>

Notes
-----

If you change the width of the cube, make sure to adapt the values of `translateZ` to half the width.
