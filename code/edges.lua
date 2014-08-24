local Edges = {}

local curMouse = { x = 0, y = 0 }
local edgesSize = 20
local edgesH = 15
local edgesNumber = 0
local edgesCur = 1
local edges = {}

Edges.all = edges

function Edges:init()
  for i=1, edgesSize do
    edges[i] = nil
  end
end

function Edges:update(dt)
  local mx, my = love.mouse.getPosition()
  if mx < 30 then
    mx = 30
  elseif mx > windowW - 30 then
    mx = windowW - 30
  end
  if my < 30 then
    my = 30
  elseif my > windowH - 30 then
    my = windowH - 30
  end  

  if curMouse.x ~= 0 and curMouse.y ~= 0 then
    if dist(mx, my, curMouse.x, curMouse.y) > edgesH then --каждые h координат создавать блок
      local e = Physics.create.chain(false, {curMouse.x, curMouse.y, mx, my}, "dynamic")
      e.b:setMass(100)
      e.f:setUserData({name = 'edge'})
      
      edgesNumber = edgesNumber + 1
      
      if edgesNumber < edgesSize then
        edges[edgesCur] = e
        edgesCur = edgesCur + 1
      else
        if edgesCur == edgesSize then
          edges[edgesCur] = e
          edgesCur = 1
        end
        local v = edges[edgesCur]
        v.b:destroy()
        v.b, v.s, v.f = e.b, e.s, e.f
        edgesCur = edgesCur + 1
      end
    end
    
    local n = edgesCur - 1
    if n < 1 then
      n = edgesSize
    end
    if edges[n] ~= nil then
      local x1, y1, x2, y2 = edges[n].s:getPoints()
      if dist(x1, y1, mx, my) < dist(x2, y2, mx, my) then
        curMouse.x, curMouse.y = x1, y1
      else
        curMouse.x, curMouse.y = x2, y2
      end
      curMouse.x, curMouse.y = curMouse.x + edges[n].b:getX(), curMouse.y + edges[n].b:getY()
    end
  end
  
  for _,v in ipairs(edges) do
    v.b:setLinearVelocity( -100, 0 )
  end
end

function Edges:draw()
  for _,v in ipairs(edges) do
    Physics.draw(v)
  end
end

function Edges:mousepressed(x, y, button)
  if button == 'l' and curMouse.x == 0 then
    curMouse.x, curMouse.y = love.mouse.getPosition()
  end
end

return Edges