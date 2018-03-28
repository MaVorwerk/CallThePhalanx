function OnLoad()
    CTP_Frame:RegisterEvent("CHAT_MSG_ADDON");
    CTP_Frame:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED");
    CTP_Frame:RegisterEvent("PLAYER_ENTERING_WORLD");
    CTP_Frame:RegisterEvent("PLAYER_REGEN_ENABLED");
end
  
function OnEvent(self,event, ...)
    if event=="CHAT_MSG_ADDON" then
        local status, err = pcall(InformGuildMember,...)
    end

    if (event=="COMBAT_LOG_EVENT_UNFILTERED") then
        local status, err = pcall(AnalyzeSurroundings,...)
    end 

    if (event=="PLAYER_REGEN_ENABLED") then
        eventBool = false
    end

    if (event=="PLAYER_ENTERING_WORLD") then
        eventBool = false
        if RegisterAddonMessagePrefix("CaThPh") then
        else
            print("Registration with CallThePhalanx failed")
        end
    end
end

function InformGuildMember(...)
    local prefix = (select(1,...))
    local message = (select(2,...))
    local sender = (select(4,...))
    if prefix == "CaThPh" then 
        RaidNotice_AddMessage(RaidBossEmoteFrame, message, ChatTypeInfo["RAID_BOSS_EMOTE"])
        PlaySoundFile("Sound/Events/scourge_horn.ogg")
    end
end

function AnalyzeSurroundings(...)
    local timestamp, type, hideCaster,sourceGUID, sourceName, sourceFlags, sourceRaidFlags, destGUID, destName, destFlags, destRaidFlags = ...  
    if destGUID == UnitGUID("player") then
        if type == "SPELL_ABSORBED" then
            if(string.find(sourceGUID,"Player") == 1) then
                pcall(playerAttacked(destName, sourceName))
            end
        end
        if type == "SPELL_DAMAGE" then
            if(string.find(sourceGUID,"Player") == 1) then
                pcall(playerAttacked(destName, sourceName))
            end
        end
        if type == "SWING_DAMAGE" then
            if(string.find(sourceGUID,"Player") == 1) then
                pcall(playerAttacked(destName, sourceName))
            end
        end
    end
end

function playerAttacked(...)    
    local bValidAlert = isValidAlert(...)
    if bValidAlert then
        eventBool = true
        SetMapToCurrentZone() 
        zoneIndex = GetCurrentMapZone()
        zoneName = GetZoneText()
        CallThePhalanx(destName.." wird von "..sourceName.." in "..zoneName.." angegriffen!")
    end
end

function isValidAlert(...)
    local bIsValidCall = false
    if eventBool == false then
        local inInstance, instanceType IsInInstance()
        if inInstance == false then
            destName, sourceName = ...
            if destName ~= sourceName then
                bIsValidCall = true
            end
        end
        if inInstance == nil then
            destName, sourceName = ...
            if destName ~= sourceName then
                bIsValidCall = true
            end
        end
    end 
    return bIsValidCall
end 

function CallThePhalanx(...)
    local message = (select(1,...))
    SendAddonMessage("CaThPh",message,"GUILD")
end