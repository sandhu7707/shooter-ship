titleState = require "states/titleState"
playState = require "states/playState"
overState = require "states/overState"
pauseState = require "states/pauseState"

local stateMachine = {
    states = {title=titleState, play=playState, pause=pauseState, over=overState}
}

local currentState = titleState

function stateMachine:changeState(state)
    currentState = state
end

function stateMachine:update(dt)
    currentState:update(dt)
end

function stateMachine:draw()
    currentState:draw()
end

return stateMachine