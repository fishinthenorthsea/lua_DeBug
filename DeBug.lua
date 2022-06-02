local _M = {}
_M.localvalue = {}  --调试模式--记录局部变量
_M.upvalue = {}     --调试模式--记录上值

local function fileWrite(res)
    assert(type(res)=="string")
    local file = assert(io.open("log.txt","a+"))
    file:write(res)
    io.flush()
    file:close()
end

local function getFirst()
    local info = debug.getinfo(2, "n")
    local func = info.name
    local info = debug.getinfo(3, "lS")
    local res = string.format("%s %s:%s 程序已占用 %s kb\n%s():",os.date("%Y-%m-%d %H:%M:%S"),info.short_src,info.currentline,collectgarbage("count"),func)
    return res
end

local function saveLocal()
    local n= 1
    while true do
        local i,v = debug.getlocal(3,n)
        if not i then
            break
        end
        _M.localvalue[i] = v
        n = n + 1
    end
end

local function saveUpValue()
    local n = 1
    local info = debug.getinfo(3, "f")
	local func = info.func
    while true do
        local i,v = debug.getupvalue(func,n)
        if  not i then
            break
        end
        _M.upvalue[i] = v
        n = n + 1
    end
end

function printLocalValue(res) 
    assert(type(res)=="string")
    print(_M.localvalue[res])
end

function printUpvalue(res) 
    assert(type(res)=="string")
    print(_M.upvalue[res])
end

function _M.debug()
    saveLocal()
    saveUpValue()
    debug.debug()
end

--func():
function _M.getAllLocal()
    local n= 1
    local str = getFirst()
    local tb = {}
    table.insert(tb,str)
    while true do
        local i,v = debug.getlocal(2,n)
        if not i then
            break
        end
        v= tostring(v)
        str = "[" .. i .." : "  .. v  .."]" 
        table.insert(tb,str)
        n = n + 1
    end
    table.insert(tb,"")
    str = table.concat(tb,"\n")
    fileWrite(str)
end

--func():
function _M.getAllUpValue()
    local n = 1
    local str = getFirst()
    local tb = {}
    table.insert(tb,str)
    local info = debug.getinfo(2, "f")
	local func = info.func
    while true do
        local i,v = debug.getupvalue(func,n)
        if  not i then
            break
        end
        v= tostring(v)
        str = "[" .. i .." : "  ..v  .."]"
        table.insert(tb,str)
        n = n + 1
    end
    table.insert(tb,"")
    str = table.concat(tb,"\n")
    fileWrite(str)
end

--func():
--返回当前的堆栈信息
function _M.getTrace()
    fileWrite(debug.traceback().."\n")
end

-- func(string):
function _M.getLocal(key)
    assert(type(key)=="string")
    local n= 1
    local str = getFirst()
    local tb = {}
    table.insert(tb,str)
    while true do
        local i,v = debug.getlocal(2,n)
        if not i then
            break
        end
        if i==key then
            v= tostring(v)
            str = "[" .. i .." : "  ..v  .."]"
            table.insert(tb,str)
            table.insert(tb,"")
            str = table.concat(tb,"\n")
            fileWrite(str)
            return 
        end
        n = n + 1
    end
    str = "[" .. key .." : "    .."nil]"
    table.insert(tb,str)
    table.insert(tb,"")
    str = table.concat(tb,"\n")
    fileWrite(str)
end


-- func(string):any
function _M.setLocal(key,value)
    assert(type(key)=="string")
    local n= 1
    local str = getFirst()
    local tb = {}
    table.insert(tb,str)
    while true do
        local i,v = debug.getlocal(2,n)
        if not i then
            break
        end
        if i==key then
            v= tostring(v)
            str = "[" .. i .." : "  ..v  .."]"
            debug.setlocal(2,n,value)
            v= tostring(v)
            str = str .. "-->[".. i .." : "  ..value  .."]"
            table.insert(tb,str)
            table.insert(tb,"")
            str = table.concat(tb,"\n")
            fileWrite(str)
            return 
        end
        n = n + 1
    end
    str = "[" .. key .." : "    .."nil]"
    table.insert(tb,str)
    table.insert(tb,"")
    str = table.concat(tb,"\n")
    fileWrite(str)
end

--func(string):
function _M.getUpValue(key)
    assert(type(key)=="string")
    local n = 1
    local info = debug.getinfo(2, "f")
	local func = info.func
    local str = getFirst()
    local tb = {}
    table.insert(tb,str)
    while true do
        local i,v = debug.getupvalue(func,n)
        if  not i then
            break
        end
        if i==key then
            v= tostring(v)
            str = "[" .. i .." : "  ..v  .."]"
            table.insert(tb,str)
            table.insert(tb,"")
            str = table.concat(tb,"\n")
            fileWrite(str)
            return 
        end
        n = n + 1
    end
    str = "[" .. key .." : "    .."nil]"
    table.insert(tb,str)
    table.insert(tb,"")
    str = table.concat(tb,"\n")
    fileWrite(str)
end

--func(string):
function _M.setUpValue(key,value)
    assert(type(key)=="string")
    local n = 1
    local info = debug.getinfo(2, "f")
	local func = info.func
    local str = getFirst()
    local tb = {}
    table.insert(tb,str)
    while true do
        local i,v = debug.getupvalue(func,n)
        if  not i then
            break
        end
        if i==key then
            v= tostring(v)
            str = "[" .. i .." : "  ..v  .."]"
            debug.setupvalue(func,n,value)
            str = str .. "-->[".. i .." : "  ..value  .."]"
            table.insert(tb,str)
            table.insert(tb,"")
            str = table.concat(tb,"\n")
            fileWrite(str)
            return 
        end
        n = n + 1
    end
    str = "[" .. key .." : "    .."nil]"
    table.insert(tb,str)
    table.insert(tb,"")
    str = table.concat(tb,"\n")
    fileWrite(str)
end

function _M.traceBack()
    local function hook()
        fileWrite(debug.traceback().."\n")
    end
    debug.sethook(hook,"cr")
end

function _M.getInfo(level)
    local tb = {}
    local str;
    level = level or 2
    local table_info = debug.getinfo(level)
    for k,v in pairs(table_info) do
        v= tostring(v)
        str =  "[" .. k .." : "  ..v  .."]"
        table.insert(tb,str)
        table.insert(tb,"")
        str = table.concat(tb,"\n")
    end
    fileWrite(str)
end

function _M.startCountFunc(func)
    assert(type(func)=="function")
    local str = getFirst()
    local tb = {}    
    table.insert(tb,str)
    local count = {}   
    local index = {}   
    local function hook()
        local info= debug.getinfo(2,"Sfn")
        local f =info.func
        local s = string.format("[%s]:%s--%s",info.short_src,info.linedefined,info.name)
        if not index[f] then
            index[f] = #count + 1
            table.insert(count , {count = 1,str = s})
        else
            count[index[f]].count = count[index[f]].count + 1
        end
    end
    debug.sethook(hook,"c")
    func()
    debug.sethook()
    table.sort(count,function(a,b) return a.count>b.count end)
    for i,v in pairs(count) do
        table.insert(tb,string.format("%-30s   %d",v.str,v.count))
    end
    table.insert(tb,"")
    str = table.concat(tb,"\n")
    fileWrite(str)
end


return _M