include("UtilityFunctions");
include("FLuaVector.lua");
include("PlotIterators.lua");
include("S_TANG_GPRULE.lua");

local PRO_S_TANG = GameInfo.UnitPromotions["PROMOTION_S_TANG_ELITE_RIDER"].ID
local PRO_S_TANG_2 = GameInfo.UnitPromotions["PROMOTION_S_TANG_ELITE_RIDER_2"].ID
local PRO_S_TANG_2D = GameInfo.UnitPromotions["PROMOTION_S_TANG_ELITE_RIDER_2_DEBUFF"].ID
local CV_S_TANG = GameInfoTypes["CIVILIZATION_S_TANG"]
local S_TANG_WONDER_DEBUFF = GameInfoTypes["BUILDING_S_TANG_WONDER_DEBUFF"]
local S_TANG_REGECTDEBUFF = GameInfoTypes["BUILDING_S_TANG_REJECTTIMES"]
local S_TANG_EXP = GameInfoTypes["BUILDING_S_TANG_ARMORY"]
local PRO_S_TANG_QINWANG = GameInfo.UnitPromotions["PROMOTION_QINWANG"].ID
local S_TANG_STOPNUM = 0
local AI_PRIORITY_ORDER = {3, 2, 1, 5, 7, 9, 8, 4} 
function S_TANG_DOTURN(playerID)  
    local pPlayer = Players[playerID]  
    if pPlayer == nil or pPlayer:IsBarbarian() or pPlayer:IsMinorCiv() then  
        return  
    end  
    if pPlayer:GetCivilizationType() == CV_S_TANG then  
        for unit in pPlayer:Units() do  
            if unit:IsCombatUnit() then  
                if unit:IsHasPromotion(PRO_S_TANG) then  
                    unit:ChangeExperience(5)  
                    break  
                end   
            end  
        end 
        S_TANG_STOPNUM = 0
        for unit in pPlayer:Units() do  
            if unit:IsCombatUnit() then  
                -- local pPlot = unit:GetPlot()   
                -- if pPlot:GetPlotCity()   
                -- and pPlot:GetPlotCity():IsHasBuilding(GameInfoTypes["BUILDING_S_TANG_ARMORY"])   
                -- then  
                --     -- unit:ChangeExperience(5)  
                --     local strenth = unit:GetBaseCombatStrength()  
                --     local city = pPlot:GetPlotCity()  
                --     strenth = strenth*0.2  
                --     city:ChangeFood(strenth)  
                --     strenth = 0  
                -- end  
                local EXPNUM = pPlayer:CountNumBuildings(S_TANG_EXP)  
                if EXPNUM > 0 then  
                    unit:ChangeExperience(EXPNUM)  
                end  
            end  
        end  
        for city in pPlayer:Cities() do  
            local WONDERDEBUFF = city:GetNumRealBuilding(S_TANG_WONDER_DEBUFF) 
            -- local REGECTDEBUFF = city:GetNumBuilding(S_TANG_REGECTDEBUFF)  
            if  WONDERDEBUFF> 0 then  
                city:SetNumRealBuilding(S_TANG_WONDER_DEBUFF,WONDERDEBUFF-1)  
            end 
            -- if  REGECTDEBUFF> 0 then  
            --     print(city:GetName()..':'..REGECTDEBUFF) 
            -- end  
        end  
    end  
end
GameEvents.PlayerDoTurn.Add(S_TANG_DOTURN)

function S_TANG_FREEGP(playerID, policyTypeID)
	local pPlayer = Players[playerID]
	if pPlayer == nil then
		print ("非正常文明")
		return 	
	end
	if pPlayer:IsBarbarian() or pPlayer:IsMinorCiv() then
		return
 	end
	if pPlayer:GetCivilizationType() == CV_S_TANG then
		print ("李世民开启了新的政策树")
		pPlayer:ChangeNumFreeGreatPeople(1)
	end
end
S_TANG_ELITE_RIDER_2 = {
	Name = "千里奔袭",
	Title = "恢复所有移动力，[COLOR_NEGATIVE_TEXT]本回合降低[ENDCOLOR]100%[ICON_STRENGTH]战斗力",
	OrderPriority = 1500,
	IconAtlas = "S_TANG_ATLAS",
	PortraitIndex = 16,
	ToolTip = "恢复所有移动力，[COLOR_NEGATIVE_TEXT]本回合降低[ENDCOLOR]100%[ICON_STRENGTH]战斗力",
	Condition = function(action, unit)
		local maxMove = unit:MaxMoves()
		return unit:CanMove() and unit:IsHasPromotion(PRO_S_TANG_2) and unit:GetMoves() ~= maxMove and not unit:IsHasPromotion(PRO_S_TANG_2D)
	end,
	Action = function(action, unit, eClick)
		local maxMove = unit:MaxMoves()
		local nowMove = unit:GetMoves()
		unit:SetMoves(maxMove + nowMove)
		unit:SetHasPromotion(PRO_S_TANG_2D, true)
	end
};
S_TANG_QINWANG = {
	Name = "安抚百姓",
	Title = "消耗所有移动力，本城市降低等同移动力的抵抗时长",
	OrderPriority = 1500,
	IconAtlas = "S_TANG_ATLAS",
	PortraitIndex = 26,
	ToolTip = "消耗所有移动力，本城市降低等同移动力的抵抗时长，这将花费降低的抵抗时长x10的[ICON_GOLD]金钱，每降低一回合抵抗还将延长1回合[ICON_GOLDEN_AGE]黄金时代",
	Condition = function(action, unit)
		local pPlayer = Players[unit:GetOwner()]
        local plot = unit:GetPlot()
	    if not plot:IsCity() then 
            return false 
        else
            local city = plot:GetPlotCity()
            if unit:CanMove() and unit:GetMoves() > 0 and city:IsResistance() and pPlayer:GetCivilizationType() == CV_S_TANG and unit:IsHasPromotion(PRO_S_TANG_QINWANG) then
                return true 
            else
                return false
            end
        end
	end,
    Disabled = function(action, unit)
        local pPlayer = Players[unit:GetOwner()];
        local plot = unit:GetPlot()
        local city = plot:GetPlotCity()
        local QINWANG_UNM = city:GetResistanceTurns()
        local gold = pPlayer:GetGold()
        if not (gold > 10*QINWANG_UNM) then 
            return true
        end
      end,
	Action = function(action, unit, eClick)
        local pPlayer = Players[unit:GetOwner()]
        local plot = unit:GetPlot()
        local city = plot:GetPlotCity()
        local QINWANG_UNM = city:GetResistanceTurns()
		local nowMove = unit:GetMoves()
        if nowMove >= QINWANG_UNM then
            unit:SetMoves(0)
            pPlayer:ChangeGold(-10*QINWANG_UNM)
            city:ChangeResistanceTurns(-QINWANG_UNM)
            pPlayer:ChangeGoldenAgeTurns(QINWANG_UNM)
        else
            unit:SetMoves(0)
            pPlayer:ChangeGold(-10*nowMove)
            city:ChangeResistanceTurns(-nowMove)
            pPlayer:ChangeGoldenAgeTurns(nowMove)
        end
	end
};
function S_TANG_INIT_FREE_UNIT(pCity, iUnitType, iNum)
	local tUnits = {}
	pPlayer = Players[pCity:GetOwner()]
	for i = 1, iNum do
		pUnit = pPlayer:InitUnit(iUnitType, pCity:GetX(), pCity:GetY())
		if not(pUnit:JumpToNearestValidPlot()) then return tUnits end
		table.insert(tUnits, pUnit)
		pUnit:SetExperience(pCity:GetProductionExperience(pUnit:GetUnitType()))
		for promotion in GameInfo.UnitPromotions() do
			iPromotion = promotion.ID
				if pCity:GetFreePromotionCount(iPromotion) > 0  or pPlayer:GetFreePromotionCount(iPromotion) > 0 then
				if pUnit:IsPromotionValid(iPromotion) then
				pUnit:SetHasPromotion(iPromotion, true)
			   end
		   end
		end
	end
	return tUnits
end

function S_TANG_ZHECHONG_FREE_UNIT(pCity,UnitType)
	local freeUnit = S_TANG_INIT_FREE_UNIT(pCity, UnitType, 1)[1]
end
local S_TANG_ZHECHONG_UNIT = {
    [0] = GameInfoTypes.UNIT_CATAPULT,
    [1] = GameInfoTypes.UNIT_CATAPULT,
    [2] = GameInfoTypes.UNIT_TREBUCHET,
    [3] = GameInfoTypes.UNIT_CULVERIN, 
    [4] = GameInfoTypes.UNIT_CANNON, 
    [5] = GameInfoTypes.UNIT_HOWITZER, 
    [6] = GameInfoTypes.UNIT_ARTILLERY, 
    [7] = GameInfoTypes.UNIT_ARTILLERY, 
    [8] = GameInfoTypes.UNIT_SELF_PROPELLED_ARTILLERY,
    [9] = GameInfoTypes.UNIT_SELF_PROPELLED_ARTILLERY};

function S_TANG_ZHECHONG(iPlayer, iCity, iBuilding, bGold, bFaithOrCulture)
    local pPlayer = Players[iPlayer];
	local pCity = pPlayer:GetCityByID(iCity)
	if pPlayer == nil  then
	   return
	end  
	if iBuilding == S_TANG_EXP then
	    local era = pPlayer:GetCurrentEra()
        local unitType = S_TANG_ZHECHONG_UNIT[era]
		S_TANG_ZHECHONG_FREE_UNIT(pCity,unitType)
	 end
end

local COLLECTION_S_TANG = GameInfoTypes["PROMOTION_COLLECTION_S_TANG"];
local COLLECTION_S_TANG_DEBUFF = GameInfoTypes["PROMOTION_COLLECTION_S_TANG_DEBUFF"];
local S_TANG_DEBUFF1 = GameInfoTypes["PROMOTION_S_TANG_DEBUFF_1"];
local S_TANG_DEBUFF2 = GameInfoTypes["PROMOTION_S_TANG_DEBUFF_2"];
local S_TANG_DEBUFF3 = GameInfoTypes["PROMOTION_S_TANG_DEBUFF_3"];
GameEvents.OnTriggerAddEnemyPromotion.Add(function(eThisPromotionType, eThisPromotionCollection, eThisBattleType, iThisPlayer,
                                                   iThisUnit, iThisUnitType, eThatPromotionType,
                                                   eThatPromotionCollection, iThatPlayer, iThatUnit, iThatUnitType)
    if eThisPromotionCollection ~= COLLECTION_S_TANG or eThatPromotionCollection ~= COLLECTION_S_TANG_DEBUFF then
        return
    end
    local pThisPlayer = Players[iThisPlayer]
    local pThatPlayer = Players[iThatPlayer]
    if pThisPlayer == nil or pThatPlayer == nil then
        return
    end
    local pThisUnit = pThisPlayer:GetUnitByID(iThisUnit)
    local pThatUnit = pThatPlayer:GetUnitByID(iThatUnit)
    if pThisUnit == nil or pThatUnit == nil then
        return
    end
    local message = 0
    if pThatUnit:IsHasPromotion(S_TANG_DEBUFF3) then
         message = 3
    elseif pThatUnit:IsHasPromotion(S_TANG_DEBUFF2) then
			message = 2
    elseif pThatUnit:IsHasPromotion(S_TANG_DEBUFF1) then
			message = 1
	end
    local thisUnitName = pThisUnit:GetName()
    local thatUnitName = pThatUnit:GetName()
    if pThisPlayer:IsHuman() then
        if message == 1 then
            local text = Locale.ConvertTextKey("TXT_KEY_S_TANG_DEBUFF_1", thisUnitName, thatUnitName)
            Events.GameplayAlertMessage(text)
        elseif message == 2 then
            local text = Locale.ConvertTextKey("TXT_KEY_S_TANG_DEBUFF_2", thisUnitName, thatUnitName)
            Events.GameplayAlertMessage(text)
		elseif message == 3 then
            local text = Locale.ConvertTextKey("TXT_KEY_S_TANG_DEBUFF_3", thisUnitName, thatUnitName)
            Events.GameplayAlertMessage(text)
        end
    end
    if pThatPlayer:IsHuman() then
        if message == 1 then
            local text = Locale.ConvertTextKey("TXT_KEY_S_TANG_DEBUFFED_1", thisUnitName, thatUnitName)
            Events.GameplayAlertMessage(text)
        elseif message == 2 then
            local text = Locale.ConvertTextKey("TXT_KEY_S_TANG_DEBUFFED_2", thisUnitName, thatUnitName)
            Events.GameplayAlertMessage(text)
		elseif message == 3 then
            local text = Locale.ConvertTextKey("TXT_KEY_S_TANG_DEBUFFED_3", thisUnitName, thatUnitName)
            Events.GameplayAlertMessage(text)
        end
    end
end)
function S_TANG_IsCivilisationActive(CivilizationID)
	for iSlot = 0, GameDefines.MAX_MAJOR_CIVS-1, 1 do
		local slotStatus = PreGame.GetSlotStatus(iSlot)
		if (slotStatus == SlotStatus.SS_TAKEN or slotStatus == SlotStatus.SS_COMPUTER) then
			if PreGame.GetCivilization(iSlot) == CivilizationID then
				return true
			end
		end
	end
	return false
end
function S_TANG_AI_AUTOGP(playerID, unitID, UnitType,iX,iY)
    print("AI入驻开始监测1")  
    local pPlayer = Players[playerID]  
    local unit = pPlayer:GetUnitByID(unitID)  
    if pPlayer == nil then  
        return     
    end  
    if pPlayer:IsBarbarian() or pPlayer:IsMinorCiv() or pPlayer:IsHuman() then  
        return  
    end  
    if pPlayer:GetCivilizationType() ~= CV_S_TANG then  
        return  
    end  

    local valid_cities = {}
    local qvjiang_cities = {}   

    if unit:IsGreatPerson() then  
        if unit:GetUnitClassType() == GameInfoTypes.UNITCLASS_PROPHET and not pPlayer:HasCreatedReligion() then  
            return  
        end
        print("AI入驻开始监测2") 
        for _, target_unm in ipairs(AI_PRIORITY_ORDER) do 
            for city in pPlayer:Cities() do  
                if HasGPSlot(city, target_unm) then  
                    table.insert(valid_cities, city)  
                end 
                if (city:GetNumRealBuilding(GameInfoTypes["BUILDING_S_TANG_NATIONAL_SCULPTURE"]) > 0) or (city:GetNumRealBuilding(GameInfoTypes["BUILDING_S_TANG_HONGLUSI"]) > 0) then  
                    table.insert(qvjiang_cities, city)  
                end 
            end
            if #valid_cities == 0 and #qvjiang_cities == 0 then  
                print("无有效城市，跳过后续判定")  
                return  
            end
            if GP_P_CHECK(pPlayer, target_unm) == 0 then  -- 政策未解锁 
                print("没有加成")  
                if #valid_cities ~= 0 then
                    for _, city in ipairs(valid_cities) do  
                        if HasGPSlot(city, target_unm) then  
                            LINYAN_CHECK(city, target_unm)  
                            unit:Kill(true)  
                            print("AI 入驻类型:", target_unm, "到城市:", city:GetName())  
                            return  -- 处理完成后直接退出  
                        end  
                    end
                end
                if #qvjiang_cities ~= 0 then
                    for _, city in ipairs(qvjiang_cities) do  
                        if HasGPSlot(city, target_unm) then  
                            LINYAN_CHECK(city, target_unm)  
                            unit:Kill(true)  
                            print("AI 入驻类型:", target_unm, "到城市:", city:GetName())  
                            return  -- 处理完成后直接退出  
                        end  
                    end
                end
            end
            print("AI入驻开始监测3"..target_unm) 
        end  
    end   
end
local bIsCivS_TANGActive = S_TANG_IsCivilisationActive(CV_S_TANG)
if bIsCivS_TANGActive then
    LuaEvents.UnitPanelActionAddin(S_TANG_LINYAN_Button)
    LuaEvents.UnitPanelActionAddin(S_TANG_QVJIANG)
    LuaEvents.UnitPanelActionAddin(S_TANG_HONGLU)
    LuaEvents.UnitPanelActionAddin(S_TANG_ELITE_RIDER_2)
    LuaEvents.UnitPanelActionAddin(S_TANG_QINWANG)
    GameEvents.PlayerAdoptPolicyBranch.Add(S_TANG_FREEGP)
    GameEvents.UnitCreated.Add(S_TANG_AI_AUTOGP)
    GameEvents.CityConstructed.Add(S_TANG_ZHECHONG)
end


