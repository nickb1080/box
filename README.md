# Cubicle
_Layout HTML as a cube w/ CSS plus programmatic control

Inspired by [Cube5](https://github.com/guille/Cube5)

Provides a Box class that can be used to build 3d boxes from HTML elements. There are some basic methods implemented already, will add more and document them soon.

```HTML
<div class="box-container">
  <div class="box">      
    <div class="face top"><h3>Top</h3></div>
    <div class="face front"><h3>Front</h3></div>
    <div class="face bottom"><h3>Bottom</h3></div>
    <div class="face left"><h3>Left</h3></div>
    <div class="face right"><h3>Right</h3></div>
    <div class="face rear"><h3>Rear</h3></div>      
  </div>
</div>
```

```javascript
var box = new Box(".box-container", {        
  width: 600,
  height: 300,
  depth: 40
});
```

Notes
-----
Requires jQuery, for now.
