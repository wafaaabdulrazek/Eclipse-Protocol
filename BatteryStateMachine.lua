local StateMachine = {}
StateMachine.__index = StateMachine
function StateMachine.new(states)
    local self = setmetatable({}, StateMachine)
    self.states = states
    self.current = nil
    return self
end
function StateMachine:change(stateName, params)
    if self.current and self.current.exit then
        self.current:exit()
    end
    self.current = self.states[stateName]()
    if self.current and self.current.enter then
        self.current:enter(params or {})
    end
end
function StateMachine:update(dt)
    if self.current and self.current.update then
        self.current:update(dt)
    end
end
function StateMachine:render()
    if self.current and self.current.render then
        self.current:render()
    end
end
return StateMachine
