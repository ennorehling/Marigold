require('daisy')
math.randomseed( os.time() )

local gameData = { destructionCounter = 0, }
local gameField = {}
local player = { x = 0, y = 0, width = 100, height = 20, momentum = {}, momentumUpdate = 0 }
local maxMomentum, momentumTime = 8, .05
local balls = {}

local tileColors = {
	{ a = 255, r = 160, g = 120, b = 120 },
	{ a = 255, r = 180, g = 160, b = 130 },
	{ a = 255, r = 240, g = 230, b = 160 },
	{ a = 255, r = 240, g = 235, b = 220 },
}

local function addBall()

	local ball = { x = 0, y = 0, width = 10, height = 10, dx = 0, dy = 0, momentum = {}, momentumUpdate = 0, state = "locked" }
	table.insert(balls, ball)
	
	return ball

end

local function addTile(x, y, width, height, hits)

	local tile = {x = x, y = y, width = width, height = height, hits = hits}
	table.insert(gameField, tile)
	
	return tile
end

local function createLevel()

	gameField = {} -- clear old set
	
	local w,h = video.getScreenSize()
	local currentY = math.random(0, 5)
	
	while currentY < h / 2 do
	
		local tileHeight = math.random(30, 50)
		local currentX = math.random(0, 10)
		
		while currentX < w do
		
			local tileWidth = math.random(40, 80)
			if tileWidth + currentX > w then
				tileWidth = w - currentX
			end
			if tileWidth > 10 then
				addTile(currentX, currentY, tileWidth, tileHeight, math.random(1, 4))
			end
			
			currentX = currentX + tileWidth + math.random(3, 4)
		end
		
		currentY = currentY + tileHeight + math.random(3, 4)
	end
	
end

--[[
	INIT METHOD
]]
local function mainInit()

	createLevel()
	addBall()

end
hook.add("gameInit", mainInit)

local function updateMomentum(object, time)
	object.momentumUpdate = object.momentumUpdate + time
	if object.momentumUpdate > momentumTime then
		object.momentumUpdate = object.momentumUpdate - momentumTime
		
		table.insert(object.momentum, {x = object.x, y = object.y} )
		while #object.momentum > maxMomentum do
			table.remove(object.momentum, 1)
		end
	end
end

--[[
	UPDATE METHOD
]]
local function mainUpdate(time)
	if time > .06 then
		time = .06
	end
	
	local w, h = video.getScreenSize()
	
	-- update momentum
	updateMomentum(player, time)
	for index, ball in ipairs(balls) do
		updateMomentum(ball, time)
	end
	
	-- update player position
	local mx, my = daisy.getMousePosition()
	player.x = mx - player.width / 2
	if player.x < 0 then
		player.x = 0
	elseif player.x + player.width > w then
		player.x = w - player.width
	end
	player.y = h - player.height - 10
	
	-- update balls
	for ballIndex, ball in ipairs(balls) do
		if ball.state == "locked" then
			ball.x = player.x + (player.width - ball.width) / 2
			ball.y = player.y - ball.height
			
			if daisy.isMouseButtonPressed(0) then
				ball.state = "action"
				
				ball.dx, ball.dy = 0, -250
			end
			
		elseif ball.state == "action" then
			ball.x, ball.y = ball.x + ball.dx * time, ball.y + ball.dy * time
			
			if ball.x + ball.width > w then
				ball.dx = -ball.dx
				ball.x = w - ball.width
			elseif ball.x < 0 then
				ball.dx = -ball.dx
				ball.x = 0
			end
			if ball.y < 0 then
				ball.dy = -ball.dy
				ball.y = 0
			end
			
			for index, tile in ipairs(gameField) do
				if ball.x + ball.width >= tile.x and ball.x <= tile.x + tile.width and
					ball.y + ball.height >= tile.y and ball.y <= tile.y + tile.height then
					
					if tile.hits > 1 then
						tile.hits = tile.hits - 1
						
						if ball.y < tile.y or ball.y + ball.height > tile.y + tile.height then
							ball.dy = -ball.dy
						end
						if ball.x < tile.x or ball.x + ball.width > tile.x + tile.width then
							ball.dx = -ball.dx
						end
						audio.playSound("hit.wav")
					
					else
						table.remove(gameField, index)
						audio.playSound("break.wav")
						
						gameData.destructionCounter = gameData.destructionCounter + 1
						if gameData.destructionCounter % 10 == 0 then
							addBall()
						end
					end
					break -- only allow one tile collision per update
					
				end
			end
			
			if ball.x + ball.width >= player.x and ball.x <= player.x + player.width and
				ball.y + ball.height >= player.y and ball.y <= player.y + player.height then
				
				if ball.dy > 0 then
					ball.dy = -(ball.dy + 1)
					audio.playSound("bounce.wav")
				end
				ball.dx = ((ball.x + ball.width / 2) - (player.x + player.width / 2)) * 3
				
			end
			
			if ball.y > h then
				-- note, removing stuff inside a loop will mess up the loop index, so this is not best practise
				table.remove(balls, ballIndex)
			end
		end
	end
	
end
hook.add("frameUpdate", mainUpdate)

--[[
	RENDER METHOD
]]
local function mainRender()

	local w,h = video.getScreenSize()
	
	video.renderRectangle(0, 0, w, h, 255, 40, 60, 80)

	for index, tile in ipairs(gameField) do
		local color = tileColors[tile.hits]
		video.renderRectangle(tile.x, tile.y, tile.width, tile.height, color.a, color.r, color.g, color.b)
	end
	
	-- render player
	local intensity = 1
	for i=#player.momentum, 1, -1 do
		intensity = intensity * .8
		local a, r, g, b = math.floor(intensity * 255), 255, 255, 255
		video.renderRectangle(player.momentum[i].x, player.y, player.width, player.height, a, r, g, b)
	end
	video.renderRectangle(player.x, player.y, player.width, player.height, 255, 255, 255, 255)
	
	-- render balls
	for index, ball in ipairs(balls) do
		local intensity = 1
		for i=#ball.momentum, 1, -1 do
			intensity = intensity * .8
			local a, r, g, b = math.floor(intensity * 255), 230, 80, 20
			video.renderRectangle(ball.momentum[i].x, ball.momentum[i].y, ball.width, ball.height, a, r, g, b)
		end
		video.renderRectangle(ball.x, ball.y, ball.width, ball.height, 255, 230, 80, 20)
	end
	
	if #gameField == 0 then
		video.renderText("VICTORY! - Press Ctrl+R to play again", w / 2, h - 100, 1)
	elseif #balls == 0 then
		video.renderText("GAME OVER - Press Ctrl+R to try again", w / 2, h - 100, 1)
	end
	
	
end
hook.add("frameRender", mainRender)
daisy.main()
