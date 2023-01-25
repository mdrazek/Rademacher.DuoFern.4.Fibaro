-- Rademacher.DuoFern.4.Fibaro
-- Author: @mdrazek
-- Version: 1.0.0 (230125)
-- License: MIT License
-- https://github.com/mdrazek/Rademacher.DuoFern.4.Fibaro

-- Roller shutter type should handle actions: open, close, stop
-- To update roller shutter state, update property "value" with integer 0-100

function QuickApp:sendRequest(method, data)
    local address = "http://" .. self.ip .. "/devices/" .. self.deviceId
    local http = net.HTTPClient({timeout=3000})
    http:request(address, {
        options = {
            headers = {
                ["Content-Type"] = "application/json"
            },
            data = data,
            checkCertificate = false,
            method = method
        },
        success = function(response)
            if response and response.status and response.data then
                --self:debug("RolloTron response status:", response.status) 
                local data = json.decode(response.data)
                if data.payload and data.payload.device and data.payload.device.capabilities then
                    for i = 1, #data.payload.device.capabilities do
                        if data.payload.device.capabilities[i].name == "CURR_POS_CFG" then
                            local value = 100 - tonumber(data.payload.device.capabilities[i].value)
                            self:updateProperty("value", value)
                        end
                    end
                end
            end
        end,
        error = function(error)
            --self:debug('error: ', json.encode(error))
        end
    }) 
end


function QuickApp:open()
    local data = string.format('{ "name": "%s" }', "POS_UP_CMD")
    self:sendRequest('PUT', data)
    self:updateProperty("value", 100)
end

function QuickApp:close()
    local data = string.format('{ "name": "%s" }', "POS_DOWN_CMD")
    self:sendRequest('PUT', data)
    self:updateProperty("value",  0)    
end

function QuickApp:stop()
    local data = string.format('{ "name": "%s" }', "STOP_CMD")
    self:sendRequest('PUT', data)
end

function QuickApp:refresh()
    self:sendRequest('GET', '')
end

function QuickApp:setValue(value)
    local position = 100 - value
    local data = string.format('{ "name": "%s", "value": "%s" }', "GOTO_POS_CMD", position)
    self:sendRequest('PUT', data)
    self:updateProperty("value", value)
end

function QuickApp:onInit()
    self.ip = self:getVariable("ip")
    self.deviceId = self:getVariable("deviceId")
    self.pollingTime = tonumber(self:getVariable("pollingTime"))
    if self.pollingTime > 0 then
        setInterval(function()
            self:refresh()
        end, self.pollingTime * 1000)
    end
end
