local StateMachine = {}
StateMachine.__index = StateMachine
function StateMachine.new(states)
    local self = setmetatable({}, StateMachine)
    self.states  = states
    self.current = nil
    self.currentName = nil
    return self
end
function StateMachine:change(stateName, params)
    if self.current then
        self.current:exit()
    end
    self.current = self.states[stateName]()
    self.current:enter(params or {})
    self.currentName = stateName
end
function StateMachine:update(dt)
    if self.current then
        self.current:update(dt)
    end
end
function StateMachine:render()
    if self.current then
        self.current:render()
    end
end
return StateMachine
