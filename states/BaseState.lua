local BaseState = {}
  BaseState.__index = BaseState
   function BaseState.new()
      return setmetatable({}, BaseState)


   end
   function BaseState:enter(params)
   end


   function BaseState:update(dt) 
   end

function BaseState:render()
    
end
function BaseState:exit() 

end

return BaseState
