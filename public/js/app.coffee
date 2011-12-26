canvas = {
  balls: []
  bg_color: 255
  width: $("canvas").width()
  height: $(window).height()/1.2
}

balls = []

graph = (p) ->
  p.setup = ->
    p.size(canvas.width, canvas.height)
    p.background(canvas.bg_color)
    p.smooth()
    p.frameRate(20)
    show_counter(canvas.balls.length)

  p.draw = ->
    p.background(canvas.bg_color)
    show_counter(canvas.balls.length)
    for ball, i in canvas.balls
      ball.move(p)
      ball.collide(canvas.balls)
      ball.display(p)

  p.mousePressed = ->
    for ball in canvas.balls
      dd = dist(p.mouseX, p.mouseY, ball.x, ball.y)
      if dd < ball.radius
        ball.spx += random(-10, 10)
        ball.spy -= 20
        
  show_counter = (cnt)->
    p.fill(200)
    p.textSize(canvas.width/3)
    p.textAlign(p.CENTER)
    p.text(cnt, canvas.width/2, canvas.height*3/4)
    

spawn_ball = (id)->
  color = rand_color([0,0,0,180], [200, 200, 200, 180])
  fcolor = [color[0..2]..., 255]
  [x, y] = [random(0, canvas.width), random(0, canvas.height/2)]
  [spx, spy] = [random(-50, 50), random(-50, 50)]
  label = iroha[random(0, iroha.length)]
  canvas.balls.push new Ball(label, 40, x, y, spx, spy, color, id, fcolor)

erase_ball = (id)->
  pos = canvas.balls.map((v)->v.id).indexOf(id)
  canvas.balls.splice(pos, 1)

setup_pusher = (key, public, presence)->
  pusher = new Pusher(key)
  public = pusher.subscribe(public)
  presence = pusher.subscribe(presence)
  
  presence.bind 'pusher:subscription_succeeded', (members)->
    members.each (member)->
      spawn_ball(member.id)
    
  presence.bind 'pusher:member_added', (member)->
    spawn_ball(member.id)
    
  presence.bind 'pusher:member_removed', (member)->
    erase_ball(member.id)
    
  pusher

$ ->
  canvas.ctx = $("#canvas")[0]
  new Processing(canvas.ctx, graph)
  setup_pusher(Pusher.key, Pusher.public, Pusher.presence) if Pusher
