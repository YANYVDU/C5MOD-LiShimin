
include("IconSupport")
include("InstanceManager")
WARN_NOT_SHARED = false; include( "SaveUtils" ); MY_MOD_NAME = "DYY_S_TANG";
include("UtilityFunctions.lua"); 
ButtonPopupTypes.BUTTONPOPUP_S_TANG = "BUTTONPOPUP_S_TANG"
g_PopupInfo = {["Type"] = ButtonPopupTypes.BUTTONPOPUP_S_TANG}
local bonus_num = 0
		

--=======================================================================================================================
-- Open/Close Functions
--=======================================================================================================================
function S_TANG_ShowHideHandler(bIsHide, bInitState)
    if(not bInitState) then
       if(not bIsHide) then
        	UI.incTurnTimerSemaphore()
        	Events.SerialEventGameMessagePopupShown(g_PopupInfo)
        else
            UI.decTurnTimerSemaphore()
            if(g_PopupInfo ~= nil) then
				Events.SerialEventGameMessagePopupProcessed.CallImmediate(g_PopupInfo.Type, 0)
			end
        end
    end
end
ContextPtr:SetShowHideHandler(S_TANG_ShowHideHandler)
--=======================================================================================================================
-- Initial Functions
--=======================================================================================================================
local iCiv = GameInfoTypes.CIVILIZATION_S_TANG   	
--=======================================================================================================================
-- Main Code
--=======================================================================================================================
function S_TANG_WONDERCompletedDo(iPlayer, icity, iBuilding, bGold, bFaithOrCulture)
	local pPlayer = Players[iPlayer]
    local city	 =	pPlayer:GetCityByID(icity)
    local cityname	 =	city:GetName()
	if (pPlayer:IsMinorCiv()) or (pPlayer:IsBarbarian()) then
		return
	end
	local IS_S_TANG = (pPlayer:GetCivilizationType() == iCiv )
    local iBuildingClass = GameInfo.Buildings[iBuilding].BuildingClass
	local iBuildingCost = GameInfo.Buildings[iBuilding].Cost
	local isWonder = GameInfo.BuildingClasses[iBuildingClass].MaxGlobalInstances
	local iQVJIANG	=	GameInfoTypes["BUILDING_S_TANG_NATIONAL_SCULPTURE"]
	if IS_S_TANG and isWonder==1 then
        print ("奇观完成者：李世民;".."奇观完成城市:"..cityname)
		local HONGWEN_NUM = pPlayer:CountNumBuildings(GameInfoTypes.BUILDING_S_TANG_LIBRARY)
		local REJECT_NUM = pPlayer:CountNumBuildings(GameInfoTypes.BUILDING_S_TANG_REJECTTIMES)
		local QVJIANG_NUM = pPlayer:CountNumBuildings(iQVJIANG)
		local WONDER_NUM = pPlayer:GetNumWorldWonders()
		print ("弘文馆数量："..HONGWEN_NUM..';拒绝次数：'..REJECT_NUM..";奇观数量："..WONDER_NUM)
		local CHECK_NUM = 2 * HONGWEN_NUM - 3 * REJECT_NUM + 10*QVJIANG_NUM + WONDER_NUM
		CHECK_NUM = CHECK_NUM + 10--基准的10%进谏概率
        if HONGWEN_NUM == 0 then
            CHECK_NUM = 0
			return
        end
		if CHECK_NUM <= 0 then
            return
        end
		local extrachance = load( pPlayer, "S_TANG_WDEXTRA", extrachance) or 0
		CHECK_NUM = CHECK_NUM + extrachance
		print ("进谏概率："..CHECK_NUM)
        local numEvent = math.random(1, 100)
        print ("进谏随机数："..numEvent)
		if CHECK_NUM > 100 then
			bonus_num = CHECK_NUM - 100
		end
		if numEvent <= CHECK_NUM then
			extrachance = 0
			save( pPlayer, "S_TANG_WDEXTRA", extrachance)
		    S_TANG_JINJIAN(pPlayer,city:GetID(),bonus_num)
			print ("溢出概率3："..bonus_num)
        else
			extrachance = extrachance + 5
			print ("额外概率2："..extrachance)
			save( pPlayer, "S_TANG_WDEXTRA", extrachance)
			if pPlayer:IsHuman() then
				S_TANG_JINJIAN_NOTIFICATION(iPlayer,city,CHECK_NUM)
			end
		end
	end
	if iBuilding == iQVJIANG then
		bonus_num = 0
		S_TANG_JINJIAN(pPlayer,city:GetID(),bonus_num)
	-- 	print ("曲江池")
	-- else
	-- 	print ("不是曲江池")
	end
end
function S_TANG_JINJIAN (pPlayer,icity,bonus_num)
    local city	 =	pPlayer:GetCityByID(icity)
    local cityname	 =	city:GetName()
	print ("溢出概率2："..bonus_num)
	-- Human Player
    print (cityname.."开始进谏流程")
	if pPlayer:IsHuman() then
        print ("玩家开始进谏流程")
		S_TANG_POPUP(pPlayer:GetID(), city:GetID(),bonus_num)
			
	else
		JINJIAN_ACCEPT(pPlayer:GetID(),city:GetID(),bonus_num)
	end
end
------------------------------------------------------------接受进谏
function JINJIAN_ACCEPT(iPlayer,icity,bonus_num)
	print ("溢出概率1："..bonus_num)
    local pPlayer = Players[iPlayer]
    local city	 =	pPlayer:GetCityByID(icity)
    local cityname	 =	city:GetName()
    print (cityname.."开始接受进谏流程")
	local gold = pPlayer:GetGold()
	local goldchange = (9*gold)/10
	local iTeamID = pPlayer:GetTeam()
    local iTeam = Teams[iTeamID]
	local iTeamTechs = iTeam:GetTeamTechs()
	pPlayer:ChangeGold(-goldchange)
	pPlayer:ChangeFaith(goldchange/10)
	pPlayer:ChangeJONSCulture(goldchange/2)
	ChangeResearchProcess_S_TANG(pPlayer, iTeamID, iTeam, iTeamTechs, ipPlayer,goldchange/4)
	pPlayer:ChangeGoldenAgeTurns(10)
	local capital = pPlayer:GetCapitalCity()
	capital:SetNumRealBuilding(GameInfoTypes.BUILDING_S_TANG_ACCEPT, 1) 
	capital:SetNumRealBuilding(GameInfoTypes.BUILDING_S_TANG_ACCEPT, 0) 
    local debuffs = city:GetNumRealBuilding(GameInfoTypes.BUILDING_S_TANG_WONDER_DEBUFF) 
    city:SetNumRealBuilding(GameInfoTypes.BUILDING_S_TANG_WONDER_DEBUFF, debuffs+3) 
	if pPlayer:GetGoldenAgeTurns() > 60 then
		if bonus_num <= 50 then
			pPlayer:ChangeGoldenAgeTurns(-(50-bonus_num))
			print ("溢出概率6："..bonus_num)
			pPlayer:ChangeNumFreeGreatPeople(1)
			numFreeTechs = pPlayer:GetNumFreeTechs()
			pPlayer:SetNumFreeTechs(numFreeTechs+1)
		else
			pPlayer:ChangeNumFreeGreatPeople(1)
			numFreeTechs = pPlayer:GetNumFreeTechs()
			pPlayer:SetNumFreeTechs(numFreeTechs+1)
		end
	end
	if pPlayer:IsAtWarAnyMajor() then
		for unit in pPlayer:Units() do
			if unit:IsCombatUnit() then
				-- unit:ChangeExperience((unit:GetExperience())+100)
				unit:ChangeExperience(100)
			end
		end
	end
end
-----------------------------------------------------------拒绝进谏
function JINJIAN_REJECT(iPlayer)
    local pPlayer = Players[iPlayer]
	local capital = pPlayer:GetCapitalCity()
	local REJECT_NUM = capital:GetNumRealBuilding(GameInfoTypes.BUILDING_S_TANG_REJECTTIMES) 
	capital:SetNumRealBuilding(GameInfoTypes.BUILDING_S_TANG_REJECTTIMES, REJECT_NUM+1)
	local FANGSHI_UnitType = GetCivSpecificUnit(pPlayer, "UNITCLASS_FANGSHI")
	local NewUnit = pPlayer:InitUnit(GameInfoTypes[FANGSHI_UnitType], capital:GetX(), capital:GetY(), UNITAI_WORKER)
	local NewUnit = pPlayer:InitUnit(GameInfoTypes[FANGSHI_UnitType], capital:GetX(), capital:GetY(), UNITAI_WORKER)
	if pPlayer:IsGoldenAge() then
		local GAS = pPlayer:GetGoldenAgeTurns()
		pPlayer:ChangeGoldenAgeTurns(-GAS)
		pPlayer:ChangeGold(200*GAS)
	else
		local culturechange = pPlayer:GetJONSCulture()
		pPlayer:ChangeJONSCulture(-culturechange)
		pPlayer:ChangeGold(5*culturechange)
	end
end
GameEvents.CityConstructed.Add(S_TANG_WONDERCompletedDo);
--=======================================================================================================================
-- Responses
--=======================================================================================================================
g_tCurrentWonder = nil
g_pCurrentPlayer = nil
g_pCurrentCity = nil
function S_TANG_POPUP(iPlayer, icity,bonus_num)
	print ("溢出概率4："..bonus_num)
    local pPlayer = Players[iPlayer]
    local city	 =	pPlayer:GetCityByID(icity)
	local cityname = city:GetName()
    local GAS = pPlayer:GetGoldenAgeTurns()
	local culturechange = pPlayer:GetJONSCulture()
	g_pCurrentPlayer = pPlayer
    g_pCurrentCity = city
	if bonus_num > 50 then
		bonus_num = 50
	end
	--Localise and hookup icons
	Controls.Message:LocalizeAndSetText("TXT_KEY_GONGWEN_JINJIAN",cityname)
	Controls.ACCEPT:SetToolTipString(Locale.ConvertTextKey("TXT_KEY_GONGWEN_JINJIAN_ACCEPT", cityname,50-bonus_num))
	Controls.REJECT:SetToolTipString(Locale.ConvertTextKey("TXT_KEY_GONGWEN_JINJIAN_REJECT",cityname))
	IconHookup(2, 128,S_TANG_ATLAS, Controls.WonderIcon)
	CivIconHookup(iPlayer, 64, Controls.Icon, Controls.CivIconBG, Controls.CivIconShadow, false, true )
	UIManager:QueuePopup(ContextPtr, PopupPriority.WonderPopup)
end
Controls.ACCEPT:RegisterCallback(Mouse.eLClick, 
	function()
        local pPlayer = g_pCurrentPlayer
        local pcity = g_pCurrentCity
		JINJIAN_ACCEPT(pPlayer:GetID(),pcity:GetID(),bonus_num)
        UIManager:DequeuePopup(ContextPtr)
		g_pCurrentPlayer = nil
        g_pCurrentCity = nil
		S_TANG_ShowHideHandler(true,false)
	end
)

Controls.REJECT:RegisterCallback(Mouse.eLClick, 
	function()
        local pPlayer = g_pCurrentPlayer
		UIManager:DequeuePopup(ContextPtr)
		JINJIAN_REJECT(pPlayer:GetID())
		g_pCurrentPlayer = nil
		S_TANG_ShowHideHandler(true,false)
	end
)
--=======================================================================================================================
-- Initialise
--=======================================================================================================================
UIManager:QueuePopup(ContextPtr, PopupPriority.WonderPopup)
UIManager:DequeuePopup(ContextPtr)

--=======================================================================================================================
--=======================================================================================================================
function ChangeResearchProcess_S_TANG(pPlayer, iTeamID, iTeam, iTeamTechs, iPlayerID, NumSciencePerTotal)
    if CanAdvanceResearch_S_TANG(pPlayer, iTeamID, iTeam, iTeamTechs, iPlayerID) then
    local iCanBeAdded = pPlayer:GetResearchCost(pPlayer:GetCurrentResearch()) - pPlayer:GetResearchProgress(pPlayer:GetCurrentResearch())
    if iCanBeAdded > NumSciencePerTotal then
    iTeamTechs:ChangeResearchProgress(pPlayer:GetCurrentResearch(),NumSciencePerTotal, iPlayerID)
    else
    iTeamTechs:ChangeResearchProgress(pPlayer:GetCurrentResearch(),iCanBeAdded, iPlayerID)
    pPlayer:ChangeOverflowResearch(NumSciencePerTotal-iCanBeAdded)
       end
    end
    if not CanAdvanceResearch_S_TANG(pPlayer, iTeamID, iTeam, iTeamTechs, iPlayerID) then
    pPlayer:ChangeOverflowResearch(NumSciencePerTotal)
    end
end
function CanAdvanceResearch_S_TANG(pPlayer, iTeamID, iTeam, iTeamTechs, iPlayerID)
    if pPlayer and iTeamID and iTeam and iTeamTechs and iPlayerID then
            if pPlayer:IsMinorCiv() 
            or (pPlayer:GetHandicapType() == nil ) 
            or pPlayer:GetHandicapType() == -1 
            or not pPlayer
            or iTeam == nil 
            or iTeam == -1 
            or iTeamID == nil 
            or iTeamID == -1 
            or iTeamTechs == nil 
            or iTeamTechs == -1 
            or iPlayerID == nil 
            or iPlayerID == -1 
            or iPlayerID == 63
            or pPlayer:GetCurrentResearch() == nil 
            or pPlayer:GetCurrentResearch() == -1 
            or pPlayer:GetResearchProgress() == nil 
            or pPlayer:GetResearchProgress() == -1 then 
            return false 
            else 
            return true 
            end
    end
end
function S_TANG_JINJIAN_NOTIFICATION(playerID,city,CHECK_NUM)
	local player = Players[playerID]
	local plot = city:Plot()
	local cityname = city:GetName()
	if player:IsHuman() then
		local heading = Locale.ConvertTextKey("TXT_KEY_S_TANG_GP_JINJIAN_HEAD")
		local text = Locale.ConvertTextKey("TXT_KEY_S_TANG_JINJIAN_PROB", cityname,CHECK_NUM)
		player:AddNotification(NotificationTypes.NOTIFICATION_GENERIC, text, heading, plot:GetX(),plot:GetY());
	end 
end