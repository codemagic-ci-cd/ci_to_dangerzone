-- this function needs to be named exactly "doObstacles" to be called by host Dart env
function doObstacles()
  -- mkObstacle is defined by the host Dart env
  mkObstacle(350, 365, visible());
  mkObstacle(600, 465, visible());
  mkObstacle(200, 150, visible());
  mkObstacle(600, 70, visible());
  mkObstacle(700, 190, visible());
end

-- returns bool, true for visible
function visible()
  return randomBool(0.6)
end

-- limit is number 0 to 1 excluding 1 above which 
-- the random number needs to be generated to return true
function randomBool(minimum)
  local r = random()
  --print(r)
  if r > minimum
    then return true
  end
  return false
end