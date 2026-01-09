--// fully lua cache lib and cloneref, wow
local clonedrefs = {}
    getgenv().cloneref = function(x)
        if not clonedrefs[x] then clonedrefs[x] = {} end
        local o = newproxy(true)
        getmetatable(o).__type = "Instance"
        getmetatable(o).__index = function(self, k, v) local e = x[k] if type(e) == "function" then return function(...) return e(x, ...) end end return e end
        getmetatable(o).__newindex = function(self, k, v) x[k] = v end
        getmetatable(o).__call = function(self, k, ...) return x[k](x, ...) end
        getmetatable(o).__tostring = function(self) return x.Name end
        getmetatable(o).__len = function(self) return error('attempt to get length of a userdata value') end
        getmetatable(o).__metatable = "The metatable is locked"
        table.insert(clonedrefs[x], o)
        return o
    end
    getgenv().compareinstances = function(a, b)
        if not clonedrefs[a] then
            return a == b
        else
            if table.find(clonedrefs[a], b) then return true end
        end
        return false
    end
    getgenv().cache = {}
    cache.iscached = function(thing)
        if cache[thing] == 'REMOVE' then return false end
        return typeof(thing) == "Instance"
    end
    cache.invalidate = function(thing)
        cache[thing] = 'REMOVE'
        thing.Parent = nil
    end
    cache.replace = function(a, b)
        if cache[a] then
            cache[a] = b
        end
        local n, p = a.Name, a.Parent -- name, parent
        b.Parent = p
        b.Name = n
        a.Parent = nil
    end
--// free task lib!
--// yes this code is retarded but it works, not very accurate but works i guess
getgenv().task = {}
function task.defer(func, ...)
    local args = {...}
    coroutine.wrap(function()
        coroutine.yield()
        func(table.unpack(args))
    end)()
end
task.wait = wait
function task.spawn(func, ...)
    local co = coroutine.create(func)
    local args = {...}
    coroutine.resume(co, table.unpack(args))
end
getgenv().isscriptable = function(object, property)
    return select(1, pcall(function()
        return object[property]
    end))
end
--// for SOME reason 0.477 has requestinternal so using this method.
getgenv().request = function(options)
        local Event = Instance.new("BindableEvent");
        local RequestInternal = game:GetService("HttpService").RequestInternal;
        local Request = RequestInternal(game:GetService("HttpService"), options);
        local Start = Request.Start;
        local Response;
        Start(Request, function(state, response) 
            Response = response;
            Event:Fire();
        end);
        Event.Event:Wait();
        return Response;
    end
getgenv().http = {}
http.request = request
getgenv().http_request = request
--// adding the rest of base64 aliases in lua since i cant be half assed to do such in lua c
getgenv().crypt = {}
crypt.base64encode = base64encode
crypt.base64decode = base64decode
crypt.base64_decode = base64decode
crypt.base64_encode = base64encode
crypt.base64 = {}
crypt.base64.encode = base64encode
crypt.base64.decode = base64decode
getgenv().base64 = {}
base64.encode = base64encode
base64.decode = base64decode
--// wow lz4 compression in lua, cant be half assed to do it with c++ so here you fucking go.
getgenv().lz4compress = function(input)
	local output = ""
	local pos = 1
	local len = #input
	while pos <= len do
		local max_match_len = 0
		local max_match_pos = pos
		local len = #input
		for i = pos - 1, 1, -1 do
			local match_len = 0
			while i + match_len <= len and input:sub(pos + match_len, pos + match_len) == input:sub(i + match_len, i + match_len) do
				match_len = match_len + 1
			end
			if match_len > max_match_len then
				max_match_len = match_len
				max_match_pos = i
			end
		end
		local match_pos, match_len = max_match_pos, max_match_len
		if match_len > 4 then
			output = output .. "*" .. string.char(math.floor(match_pos / 256)) .. string.char(match_pos % 256) .. string.char((match_len - 4) % 256)
			pos = pos + match_len
		else
			output = output .. input:sub(pos, pos)
			pos = pos + 1
		end
	end
	return output
end

getgenv().lz4decompress = function(input)
	local output = ""
	local pos = 1
	local len = #input
	while pos <= len do
		local byte = input:sub(pos, pos)
		if byte == "*" then
			local match_pos = input:byte(pos + 1) * 256 + input:byte(pos + 2)
			local match_len = input:byte(pos + 3) + 4
			output = output .. output:sub(#output - match_pos + 1, #output - match_pos + match_len)
			pos = pos + 4
		else
			output = output .. byte
			pos = pos + 1
		end
	end
	return output
end
getgenv().lz4 = {}
lz4.compress = lz4compress
lz4.decompress = lz4decompress
getgenv().hookmetamethod = function(self, method, func)
    local mt = getrawmetatable(self)
    local old = mt[method]
    setreadonly(mt, false)
    mt[method] = func
    setreadonly(mt, true)
    return old
end
getgenv().getinstances = function()
	local Table = {}
	for i, v in next, getreg() do
		if type(v) == "table" then
			for n, c in next, v do
				if typeof(c) == "Instance" then
					table.insert(Table, c)
				end
			end
		end
	end
	return Table
end

getgenv().getnilinstances = function()
	local Ret = {}
	for i, v  in next, getinstances() do
		if v.Parent == nil then
			Ret[#Ret + 1] = v
		end
	end
	return Ret
end
