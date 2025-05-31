-----------------------------------------------------------------------------------------
--
-- main.lua
--
-----------------------------------------------------------------------------------------

-- Your code here
local screenW = display.contentWidth
local screenH = display.contentHeight
local screenCenterX = display.contentCenterX
local screenCenterY = display.contentCenterY

local player 
local enemySpawn = 0
local enemies = {}
local count = 0
local countText
local timeLeft = 60
local timerText
local playing = false

--
local function hasCollide(obj1, obj2)
    local left = obj1.x - (obj1.width/2)
    local right = obj1.x + (obj1.width/2)
    local top = obj1.y - (obj1.height/2)
    local bottom = obj1.y + (obj1.height/2)
    
    local objLeft = obj2.x - (obj2.width/2)
    local objRight = obj2.x + (obj2.width/2)
    local objTop = obj2.y - (obj2.height/2)
    local objBottom = obj2.y + (obj2.height/2)
    
    return (left < objRight and right > objLeft and
            top < objBottom and bottom > objTop)
end 

local function handleStop()
    playing = false
    transition.to(player, {time = 500, widthth = 0, height = 0 , alpha = 0} )
    timer.cancel(timerID)
    timerText.text = "Time's Up!"
    message.text = "Game Over! " 
    message2.text = "Score: " .. count

    for i = 1, #enemies do
        local enemy = enemies[i]
        if enemy ~= nil then
            transition.to( enemy, {time = 0, width = 0, height = 0} )
        end
    end
end

local function addEnemy()
    enemySpawn = 0
    local enemy = display.newImageRect( "asset/coin.png", 30, 30 )
    enemy.x = math.random( 20, screenW - 20 )
    enemy.y = 30
    -- enemy:setFillColor( math.random(0,1),math.random(0,1) , math.random(0,1) )
    enemies[#enemies + 1] = enemy
end

local function updateTimer()
    timeLeft = timeLeft - 1
    timerText.text = timeLeft .. "s"
    if timeLeft <= 0 then
        timer.cancel(timerID)
    end
end

local function enterFrame(event)
    if playing == true then
        if player.direction == "left" then
            player.x = player.x - 3
        elseif player.direction == "right" then
            player.x = player.x + 3
        end
        if player.x <= 30 then
            player.direction = "right"
        elseif player.x >= screenW - 30 then
            player.direction = "left"
        end

        ----

        enemySpawn = enemySpawn + 1
        if enemySpawn >= 60 then
            addEnemy()
        end 
        ------
        if timerText.text == "0s" then
            handleStop()
        end

        for i = 1, #enemies do
            local enemy = enemies[i]

            if enemy ~= nil then
                if hasCollide(player, enemy) then
                    count = count + 1
                    countText.text = "$" .. count
                    enemy:setFillColor( 1, 0, 0 )
                    transition.to( enemy, {time = 0, width = 0, height = 0} )
                end
                enemy.y = enemy.y + 2
                if enemy.y > screenH then
                    -- enemy:removeSelf()
                    -- enemies[i] = nil
                end
            end
        end
    end

end 

local function move(event)
    if event.phase == "began" and playing then
        if player.direction == "left" then
            player.direction = "right"
        elseif player.direction == "right" then
            player.direction = "left"
        end
    elseif event.phase == "began" and not playing then
        playing = true
        timerID = timer.performWithDelay(1000, updateTimer, 60)
        message.text = ""
    end

end 

--

local background = display.newRect( screenCenterX, screenCenterY, screenW, screenH )
local background2 = display.newRect( screenCenterX, 0, screenW, 50 )
background:setFillColor( 0, 0.1, 0.1 )
background2:setFillColor( 1, 1, 1 )

-- player = display.newRect( screenCenterX, screenH, 50, 50 )
player = display.newImageRect( "asset/bucket.webp", 75, 75 )
player.x = screenCenterX
player.y = screenH 

player.alphha = 0
message = display.newText( "Touch to Start", screenCenterX, screenCenterY, native.systemFont, 24 )
message2 = display.newText( "", screenCenterX, screenCenterY-30, native.systemFont, 24 )

Level = display.newText( "Level 1", screenCenterX , 0, native.systemFont, 20 )
countText = display.newText( "$" .. count, 30 , 0, native.systemFont, 20 )
timerText = display.newText( timeLeft .. "s", screenW - 50, 0, native.systemFont, 20 )
Level:setFillColor( 0, 0, 0 )
countText:setFillColor( 0, 0, 0 )
timerText:setFillColor( 0, 0, 0 )
player.direction = "right"
Runtime:addEventListener( "enterFrame", enterFrame )

Runtime:addEventListener( "touch", move )



