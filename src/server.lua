---@diagnostic disable-next-line: deprecated
Tunnel = module("vrp","lib/Tunnel")
---@diagnostic disable-next-line: deprecated
Proxy = module("vrp", "lib/Proxy")
---@diagnostic disable-next-line: undefined-field
vRP = Proxy.getInterface("vRP")
---@diagnostic disable-next-line: undefined-field
vRPclient = Tunnel.getInterface("vRP")

src = {}
---@diagnostic disable-next-line: undefined-field
Tunnel.bindInterface(GetCurrentResourceName(), src)
---@diagnostic disable-next-line: undefined-field
vCLIENT = Tunnel.getInterface(GetCurrentResourceName())

function src:giveItem()
	local source = source
	local user_id = vRP.getUserId(source)
	if user_id then
		local value = math.random(5,10)
        local randomItem = math.random(#Config.itensReward)
        local item = Config.itensReward[randomItem]
		vRP.generateItem(user_id,item,value,true)
	else
        print('Deu erro')
    end
end