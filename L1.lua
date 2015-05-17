local sides = {"top","bottom","left","right","back","front"}
local sidesTable = {top = 0,bottom = 1,left = 2,right = 3,back = 4,front = 5}
local modem = {}
local defaultSide = ""
local channel  = 20613

function wrap()
	for a = 1,6 do 
		if peripheral.isPresent(sides[a]) then 
			if peripheral.getType(sides[a]) == "wireless_modem" or peripheral.getType(sides[a]) == "modem" then
				if defaultSide == "" then defaultSide = sides[a] end
				modem[sides[a]] = peripheral.wrap(sides[a])
			end
		end
		a = a+1
	end
end

function intOpen(int)
	modem[sides[int]].open(channel)
end

function intClose(int)
	modem[sides[int]].close()
end

function send(int,data)
	local frame = standFrame or QFrame
	if (not data == nil) then 
		modem[int or defaultSide].transmit(channel,channel,data)
	else
		modem[int or defaultSide].transmit(channel,channel,frame)
		standFrame = standFrame_Temp
		QFrame = QFrame_Temp
	end
end

function receive()
	while true do
		local event = {os.pullEvent("modem_message")}
		if event[3] == channel then
			local destMac = string.sub(event[5],1,6)
			local sendMac = string.sub(event[5],7,12)
			if destMac == getMac(event[2]) then
				return event[5], event[4]
			end
		end
	end
end