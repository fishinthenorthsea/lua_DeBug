local db = require("DeBug") 


local n =5            --number
local x               --nil
local str = "123"     --sring
local bool = true     --boolean
local t = {}          --table
local function func() --function
end
local function www()
end
--测试getAllLocal()和getLocal(key)
local function test()
    local a = 5
    local b = 6
    local s = "dasd"
    www()

end



db.startCountFunc(test)