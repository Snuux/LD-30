local ophysics = {}
ophysics.create = {}
ophysics.objects = {}

local world

function ophysics.initPhysics(w)
  world = w
end

function ophysics.getAllObjects()
  return ophysics.objects
end

function ophysics.create.rectangle(x, y, w, h, bType, ox, oy)
  ox, oy = ox or 0, oy or 0
  o = {}
  o.id = id
  o.b = love.physics.newBody(world, x, y, bType)
  o.s = love.physics.newRectangleShape(ox, oy, w, h, 0)
  o.f = love.physics.newFixture(o.b, o.s)
  table.insert(ophysics.objects, o)
  return o
end

function ophysics.create.polygon(x, y, tab, bType)
  if type(tab) ~= "table" or #tab < 4 then
    return
  end
  o = {}
  o.b = love.physics.newBody(world, x, y, bType)
  o.s = love.physics.newPolygonShape(unpack(tab))
  o.f = love.physics.newFixture(o.b, o.s)
  return o
end

function ophysics.create.circle(x, y, r, bType)
  o = {}
  o.b = love.physics.newBody(world, x, y, bType)
  o.s = love.physics.newCircleShape(r)
  o.f = love.physics.newFixture(o.b, o.s)
  return o
end

function ophysics.create.edge(x, y, x1, y1, bType)
  o = {}
  o.b = love.physics.newBody(world, x, y, bType)
  o.s = love.physics.newEdgeShape(x, y, x1, y1)
  o.f = love.physics.newFixture(o.b, o.s)
  return o
end

function ophysics.create.chain(loop, tab, bType)
  if type(tab) ~= "table" then
    return
  end
  o = {}
  o.b = love.physics.newBody(world, x, y, bType)
  o.s = love.physics.newChainShape(loop, unpack(tab))
  o.f = love.physics.newFixture(o.b, o.s)
  return o
end

function ophysics.draw(o, color)
  local c = color or {255, 255, 255}
  love.graphics.setColor(c)
  
  local bx,by =  o.b:getPosition()
  local bodyAngle = o.b:getAngle()
  local shapeType = o.s:getType()
  
  love.graphics.push()
  love.graphics.translate(bx,by)
  love.graphics.rotate(bodyAngle)  
    if shapeType == 'chain' then
      love.graphics.line(o.s:getPoints())
    elseif shapeType == 'circle' then
      love.graphics.circle("fill", o.s:getPoint(), o.s:getRadius(), 10)
    else
      love.graphics.polygon("fill", o.s:getPoints())
    end
  love.graphics.pop()
  
  love.graphics.setColor(255, 255, 255)
end



function ophysics.debugDraw()
  local bodies = world:getBodyList()
  
  for b=#bodies,1,-1 do
    local body = bodies[b]
    local bx,by = body:getPosition()
    local bodyAngle = body:getAngle()
    
    love.graphics.push()
    love.graphics.translate(bx,by)
    love.graphics.rotate(bodyAngle)    
    
    local fixtures = body:getFixtureList()
    for i=1,#fixtures do
      local fixture = fixtures[i]
      local shape = fixture:getShape()
      local shapeType = shape:getType()
      local isSensor = fixture:isSensor()
      
      if (isSensor) then
        love.graphics.setColor(0,0,255,96)
      else
        love.graphics.setColor(32,32,158,96)
      end
      
      love.graphics.setLineWidth(1)
      if (shapeType == "circle") then
        local x,y = shape:getPoint() --0.9.1
        local radius = shape:getRadius()
        love.graphics.circle("fill",x,y,radius,15)
        love.graphics.setColor(0,0,150,255)
        love.graphics.circle("line",x,y,radius,15)
        local eyeRadius = radius/4
        love.graphics.setColor(0,0,150,255)
        love.graphics.circle("fill",x+radius-eyeRadius,y,eyeRadius,10)
      elseif (shapeType == "polygon") then
        local points = {shape:getPoints()}
        love.graphics.polygon("fill",points)
        love.graphics.setColor(0,0,150,255)
        love.graphics.polygon("line",points)
      elseif (shapeType == "edge") then
        love.graphics.setColor(0,0,150,255)
        --local p = {shape:getPoints()}
        --for i=2,#p,2 do p[i-1] = p[i-1] - bx p[i] = p[i] - by end
        --love.graphics.line(unpack(p))
        love.graphics.origin()
        love.graphics.line(shape:getPoints())
      elseif (shapeType == "chain") then
        love.graphics.setColor(0,0,150,255)
        love.graphics.line(shape:getPoints())
      end
    end
    
    love.graphics.pop()
  end
  
  
  
  local joints = world:getJointList()
  for index,joint in pairs(joints) do
    love.graphics.setColor(0,255,0,255)
    local x1,y1,x2,y2 = joint:getAnchors()
    if (x1 and x2) then
      love.graphics.setLineWidth(3)
      love.graphics.line(x1,y1,x2,y2)
    else
      love.graphics.setPointSize(3)
      if (x1) then
        love.graphics.point(x1,y1)
      end
      if (x2) then
        love.graphics.point(x2,y2)
      end
    end
  end
  
  --local contacts = world:getContactList()
  --for i=1,#contacts do
  --  love.graphics.setColor(255,0,0,255)
  --  love.graphics.setPointSize(3)
  --  local x1,y1,x2,y2 = contacts[i]:getPositions()
  --  if (x1) then
  --    love.graphics.point(x1,y1)
  --  end
  --  if (x2) then
  --    love.graphics.point(x2,y2)
  --  end
  --end
  
  love.graphics.setColor(255, 255, 255)
end

return ophysics