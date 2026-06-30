--// SXRE Init.
getgenv().is_sxre_compatible = function()
	return true
end
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
getgenv().lz4_compreess = lz4compress
getgenv().lz4_decompreess = lz4decompress
getgenv().lz4 = {}
lz4.compress = lz4compress
lz4.decompress = lz4decompress
getgenv().isreadonly = function(tab)
	local succ, err = pcall(function()
		tab["Hello"] = "Pedone"
	end)
	if succ then
		return false
	else
		return true
	end
end
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
					Table[c] = c
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
			Ret[v] = v
		end
	end
	return Ret
end

getgenv().PROTOSMASHER_LOADED = true

getgenv().printskibidi = function()
	print([[
		                                           -+++++++++++                                             
                                       ++++++++++++++++++++                                         
                                     +++++++++++++++++++++++++-....-                                
                                  -++++++++++++++++##########++-.......                             
                     ............-+++++++++++++#################+--------                           
                    -...........-+++++++++++++####################++++++                            
                     --------+++++++++++++++#######################+++--                            
                      ++++++++++++++++++++++#######################+++-                             
                      -+++++++++++++++++++++##++++++++###++------+##++-                             
                      .------+++++++++++++++#+++------------------##++-                             
                      -+++++++++++++++++++++#+++------.......-----+#+++                             
                        ++++++++++++++++++++++++------......------+#+++                             
                        -++++++++++++++++++++++#+#+---....-----++++++++                             
                         ++++++++++++++++++++########++--########+++++                              
                          +++++++++++++++++++##+--#####+####--+##+++++                              
                          ++++++++++++++++++++#+-++###+++##+---#++++++                              
                          -++++++++++++++++++++++++++++-++++------+++-                              
                           ++++++++++++++++++++---+++++--+++------+++                               
                            +++++++++++++++++++++++++++--++++##+++++                                
                             ++++++++++++++++++#####+++--++#####++++                                
                             ++++++++++++++++++############++##+++-                                 
                             -+++++++++++++++++#######++++####+++-                                  
                              -+++++++++++++++++#####+++++##++++++                                  
                              ++++++++++++++++++####++++++++++#+-....                               
                               -+++---++-+-----.+##+++#++++++##+-.........                          
                                 ++.............-#############++-............                       
                                 ............----+###########+++-----.........                      
                                ..........------++###########++++-----.........                     
                                .........------++++##########+++++----.......--.                    
                                -.........----+++++##########++------.......--.-                    
                                .--...........-----#########+++-........----.--                     
                                --.-----..........................------..---+                      
                                 ----..-----------------------------.-----+++                       
                                  +++++--------..--------.-.------+++++++++++                       
                                   +++++++++++++++++++++++++++++++++++++++++                        
                                    +++++++++++++++++++++++++++++++++++++++                         
                                      ++++++++++++++++++++++++++++++++++++                          
                                        ++++++++++++++++++++++++++++++++                            
                                          ++++++++++++++++++++++++++++                              
                                            ++++++++++++++++++++++++                                
                                             --+++++++++++++++++++-                                 
                                             ----+++++++++++++++----                                
                                              -----+++++++++++------                                
                                              ------+++++++++-------                                
                                            +--------+++++++---------                               
                                           .--.-------++-+++---------                               
                                           ....-------+---------------                              
                                           -...-----------------------                              
                                            -..------------------------                             
                                            +-.-------++---++----------                             
                                             ---------+--++++----------                             
                                              --------+-++++++--------+                             
                                               ------+++++++++++--++++                              
                                                -+++++++++++++++++++                                
                                                  +++++++++++++                                     
	]])
end
getgenv().print_skibidi = printskibidi
local RBX_Env = {}
for i,v in pairs(getgenv()) do
	RBX_Env[v] = v
end
getgenv().getrenv = function()
	return RBX_Env
end
if isfile then
	getgenv().loadfile = function(path)
		if isfile(path) == true then
			return loadstring(readfile(path))
		end
	end
	getgenv().dofile = loadfile
end
local CRefs = {}
getgenv().cloneref = function(hey)
	if not CRefs[hey] then CRefs[hey] = {} end
	local amir = newproxy(true)
	getmetatable(amir).__type = "Instance"
	getmetatable(amir).__index = function(self, k, v) local e = hey[k] if type(e) == "function" then return function(...) return e(hey, ...) end end return e end
    getmetatable(amir).__newindex = function(self, k, v) hey[k] = v end
    getmetatable(amir).__call = function(self, k, ...) return hey[k](x, ...) end
    getmetatable(amir).__tostring = function(self) return hey.Name end
    getmetatable(amir).__len = function(self) return error('attempt to get length of a userdata value') end
    getmetatable(amir).__metatable = "The metatable is locked"
	CRefs[hey] = amir
	return amir
end
getgenv().compareinstances = function(ayy,lmao)
	if not CRefs[ayy] then
		return ayy == lmao
	elseif CRefs[ayy] then
		return true
	else
		return false
	end
end
getgenv().Raindrop = {}
Raindrop.DownloadString = function(string)
	local body = request({Url = string, Method = "GET"}).Body
	return body
end
local gtab = {}
getgenv()._G = gtab
getgenv().shared = gtab
