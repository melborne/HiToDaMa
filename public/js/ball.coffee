class window.Ball

  constructor: (@label, @radius, @x, @y, @spx, @spy, @color, @id=null, @fcolor=[255,255,255,255]) ->
    @on_collition=false
    
  FRICTION: -0.5 # toword walls
  SPRING: 0.4 # between balls
  GRAVITY: 0.35
  
  move: (p)->
    @spy += @GRAVITY
    @x += @spx
    @y += @spy
    if @x + @radius > p.width
      @x = p.width - @radius
      @spx *= @FRICTION
    else if @x - @radius < 0
      @x = @radius
      @spx *= @FRICTION
      
    if @y + @radius > p.height
      @y = p.height - @radius
      @spy *= @FRICTION
    # else if @y - @radius < 0
    #   @y = @radius
    #   @spy *= @FRICTION
      
    if mag(@spx, @spy) < 40 and @on_collition
      @spx = 0
      @spy = 0
      
    @on_collition = false
    
  collide: (others)->
    for o in others
      continue if this is o
      distance = dist(@x, @y, o.x, o.y)
      minDist = @radius + o.radius
      if distance <= minDist
        angle = Math.atan2(o.y-@y, o.x-@x)
        targetX = @x + Math.cos(angle) * minDist
        targetY = @y + Math.sin(angle) * minDist
        ax = (targetX - o.x) * @SPRING
        ay = (targetY - o.y) * @SPRING
        @spx -= ax
        @spy -= ay
        o.spx += ax
        o.spy += ay
        @on_collition = true
        
  display: (p)->
    p.fill(@color...)
    p.noStroke()
    p.ellipse(@x, @y, @radius*2, @radius*2)
    p.stroke(90)
    p.textAlign(p.CENTER)
    p.fill(@fcolor...)
    p.textSize(@radius)
    p.text(@label, @x, @y+@radius/3)
    @on_collition = false

window.dist = (x, y, ox, oy)->
  Math.sqrt( Math.pow(ox-x, 2) + Math.pow(oy-y, 2) )

window.mag = (x, y)->
  dist(0, 0, x, y)

window.random = (min, max) ->
  range = max - min
  parseInt(Math.random()*range) + min

window.rand_color = (min, max) ->
  [min_r, min_g, min_b, min_a] = min
  [max_r, max_g, max_b, max_a] = max
  [random(min_r, max_r), random(min_g, max_g), random(min_b, max_b), random(min_a, max_a)]

window.alphabet = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ'
window.iroha = 'いろはにほへとちりぬるをわかよたれそつねならむうゐのおくやまけふこえてあさきゆめみしゑひもせすん'
