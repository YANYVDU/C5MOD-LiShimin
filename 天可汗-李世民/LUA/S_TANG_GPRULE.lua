include("UtilityFunctions");
include("FLuaVector.lua");
include("PlotIterators.lua");
include("Policy_FreeBuildingClass.lua");
local CV_S_TANG = GameInfoTypes["CIVILIZATION_S_TANG"]
local LINYAN_TYPE = GameInfoTypes["BUILDING_S_TANG_MONUMENT"]
local QVJIANG_TYPE = GameInfoTypes["BUILDING_S_TANG_NATIONAL_SCULPTURE"]
local HONGLU_TYPE = GameInfoTypes["BUILDING_S_TANG_HONGLUSI"]
S_TANG_LINYAN_Button  = {
	Name = "将伟人入驻本城市凌烟阁",
	Title = "TXT_KEY_S_TANG_GP_BUTTON_NAME1", -- or a TXT_KEY
	OrderPriority = 1500, -- default is 200
	IconAtlas = "S_TANG_ATLAS", -- 45 and 64 variations required
	PortraitIndex = 10,
    ToolTip = "TXT_KEY_S_TANG_GP_BUTTON_TIP1", -- or a TXT_KEY_ or a function
	Condition = function(action, unit)
        local pPlayer = Players[unit:GetOwner()];
	  return unit:CanMove() and unit:IsGreatPerson() and pPlayer:GetCivilizationType() == CV_S_TANG and (LINYANGP_2(unit) ~= 0)
	end, -- or nil or a boolean, default is true
	Disabled = function(action, unit) 
	  local plot = unit:GetPlot();
	  if not plot:IsCity() then 
        return true end;
	  local city = plot:GetPlotCity()
	  return not city 
      or city:GetOwner() ~= unit:GetOwner() 
	  or not (city:GetNumBuilding(LINYAN_TYPE) == 1)
      or not HasGPSlot(city,LINYANGP_2(unit))
      or (city:GetNumBuilding(QVJIANG_TYPE) == 1)
      or (city:GetNumBuilding(HONGLU_TYPE) == 1)
	  ;
	end, -- or nil or a boolean, default is false
	Action = function(action, unit, eClick)
	  local plot = unit:GetPlot();
	  local city = plot:GetPlotCity()
      local LINYAN_UNM = LINYANGP_2(unit)
	  if not city then return end
        LINYAN_CHECK(city,LINYAN_UNM)
	  	unit:Kill()
		print(city:GetName().. "已经入驻伟人"..LINYAN_UNM)
	end,
  };
S_TANG_QVJIANG  = {
	Name = "将伟人入驻本城市曲江池",
	Title = "TXT_KEY_S_TANG_GP_BUTTON_NAME2", -- or a TXT_KEY
	OrderPriority = 1500, -- default is 200
	IconAtlas = "S_TANG_ATLAS", -- 45 and 64 variations required
	PortraitIndex = 0,
    ToolTip = "TXT_KEY_S_TANG_GP_BUTTON_TIP2", -- or a TXT_KEY_ or a function
	Condition = function(action, unit)
        local pPlayer = Players[unit:GetOwner()];
        local plot = unit:GetPlot();
	    if not plot:IsCity() then 
            return false 
        else
            local city = plot:GetPlotCity()
            local QVJIANG_NUM = city:GetNumBuilding(QVJIANG_TYPE)
            if unit:CanMove() and unit:IsGreatPerson() and pPlayer:GetCivilizationType() == CV_S_TANG and QVJIANG_NUM == 1 and (LINYANGP_2(unit) ~= 0)then
                return true 
            else
                return false
            end
        end
	end, -- or nil or a boolean, default is true
	Disabled = function(action, unit) 
	  local plot = unit:GetPlot();
	  if not plot:IsCity() then 
        return true end;
	  local city = plot:GetPlotCity()
	  return not city or city:GetOwner() ~= unit:GetOwner() 
	  or not (city:GetNumBuilding(QVJIANG_TYPE) == 1)
      or not HasGPSlot(city,LINYANGP_2(unit))
      or (LINYANGP_2(unit) == 0)
	  ;
	end, -- or nil or a boolean, default is false
	Action = function(action, unit, eClick)
	  local plot = unit:GetPlot();
	  local city = plot:GetPlotCity()
      local LINYAN_UNM = LINYANGP_2(unit)
	  if not city then return end
        LINYAN_CHECK(city,LINYAN_UNM)
	  	unit:Kill()
		print(city:GetName().. "已经入驻第二位伟人")
	end,
  };
  S_TANG_HONGLU  = {
	Name = "将伟人入驻本城市鸿胪寺",
	Title = "TXT_KEY_S_TANG_GP_BUTTON_NAME3", -- or a TXT_KEY
	OrderPriority = 1500, -- default is 200
	IconAtlas = "S_TANG_ATLAS", -- 45 and 64 variations required
	PortraitIndex = 0,
    ToolTip = "TXT_KEY_S_TANG_GP_BUTTON_TIP3", -- or a TXT_KEY_ or a function
	Condition = function(action, unit)
        local pPlayer = Players[unit:GetOwner()];
        local plot = unit:GetPlot();
	    if not plot:IsCity() then 
            return false 
        else
            local city = plot:GetPlotCity()
            local HONGLU_NUM = city:GetNumBuilding(HONGLU_TYPE)
            if unit:CanMove() and unit:IsGreatPerson() and pPlayer:GetCivilizationType() == CV_S_TANG and HONGLU_NUM == 1 and (LINYANGP_2(unit) ~= 0)then
                return true 
            else
                return false
            end
        end
	end, -- or nil or a boolean, default is true
	Disabled = function(action, unit) 
	  local plot = unit:GetPlot();
	  if not plot:IsCity() then 
        return true end;
	  local city = plot:GetPlotCity()
	  return not city or city:GetOwner() ~= unit:GetOwner() 
	  or not (city:GetNumBuilding(HONGLU_TYPE) == 1)
      or not HasGPSlot(city,LINYANGP_2(unit))
      or (LINYANGP_2(unit) == 0)
	  ;
	end, -- or nil or a boolean, default is false
	Action = function(action, unit, eClick)
	  local plot = unit:GetPlot();
	  local city = plot:GetPlotCity()
      local LINYAN_UNM = LINYANGP_2(unit)
	  if not city then return end
        LINYAN_CHECK(city,LINYAN_UNM)
	  	unit:Kill()
	end,
  };
-- 伟人类型与建筑的映射表
local GP_B = {
    GameInfoTypes["BUILDING_LINYAN_GENERAL"],      --1.军
    GameInfoTypes["BUILDING_LINYAN_SCIENTIST"],    --2.科
    GameInfoTypes["BUILDING_LINYAN_ENGINEER"],     --3.工
    GameInfoTypes["BUILDING_LINYAN_ARTIST"],       --4.艺
    GameInfoTypes["BUILDING_LINYAN_WRITER"],       --5.文
    GameInfoTypes["BUILDING_LINYAN_PROPHET"],      --6.圣
    GameInfoTypes["BUILDING_LINYAN_MERCHANT"],     --7.商
    GameInfoTypes["BUILDING_LINYAN_MUSICIAN"],     --8.乐
    GameInfoTypes["BUILDING_LINYAN_ADMIRAL"],      --9.海
    GameInfoTypes["BUILDING_LINYAN_DOCTOR"],       --10.医
}
local TABLE_S_TANG_GPCLASS = {  
    [GameInfoTypes.UNITCLASS_GREAT_GENERAL] = 1,  
    [GameInfoTypes.UNITCLASS_SCIENTIST] = 2,  
    [GameInfoTypes.UNITCLASS_ENGINEER] = 3,  
    [GameInfoTypes.UNITCLASS_ARTIST] = 4,  
    [GameInfoTypes.UNITCLASS_WRITER] = 5,  
    [GameInfoTypes.UNITCLASS_PROPHET] = 6,  
    [GameInfoTypes.UNITCLASS_MERCHANT] = 7,  
    [GameInfoTypes.UNITCLASS_MUSICIAN] = 8,  
    [GameInfoTypes.UNITCLASS_GREAT_ADMIRAL] = 9,  
}
if GameInfoTypes.UNITCLASS_GREAT_DOCTOR then  
    TABLE_S_TANG_GPCLASS[GameInfoTypes.UNITCLASS_GREAT_DOCTOR] = 10  
end
local TABLE_S_TANG_GP_POLICY1 = {  
    [GameInfoTypes.POLICY_LINYAN_GENERAL] = 1,  
    [GameInfoTypes.POLICY_LINYAN_SCIENTIST] = 2,  
    [GameInfoTypes.POLICY_LINYAN_ENGINEER] = 3,  
    [GameInfoTypes.POLICY_LINYAN_ARTIST] = 4,  
    [GameInfoTypes.POLICY_LINYAN_WRITER] = 5,  
    [GameInfoTypes.POLICY_LINYAN_PROPHET] = 6,  
    [GameInfoTypes.POLICY_LINYAN_MERCHANT] = 7,  
    [GameInfoTypes.POLICY_LINYAN_MUSICIAN] = 8,  
    [GameInfoTypes.POLICY_LINYAN_ADMIRAL] = 9,  
    [GameInfoTypes.POLICY_LINYAN_DOCTOR] = 10,  
}  
local TABLE_S_TANG_GP_POLICY2 = {  
    [1] = GameInfoTypes.POLICY_LINYAN_GENERAL,  
    [2] = GameInfoTypes.POLICY_LINYAN_SCIENTIST,  
    [3] = GameInfoTypes.POLICY_LINYAN_ENGINEER,  
    [4] = GameInfoTypes.POLICY_LINYAN_ARTIST,  
    [5] = GameInfoTypes.POLICY_LINYAN_WRITER,  
    [6] = GameInfoTypes.POLICY_LINYAN_PROPHET,  
    [7] = GameInfoTypes.POLICY_LINYAN_MERCHANT,  
    [8] = GameInfoTypes.POLICY_LINYAN_MUSICIAN,  
    [9] = GameInfoTypes.POLICY_LINYAN_ADMIRAL,  
    [10] = GameInfoTypes.POLICY_LINYAN_DOCTOR,  
}  
local CITY_FONT = {  
    [1] = "军",  
    [2] = "科",  
    [3] = "工",  
    [4] = "艺",  
    [5] = "文",  
    [6] = "圣",  
    [7] = "商",  
    [8] = "乐",  
    [9] = "航",  
    [10] = "医"  
}
--检查某种伟人是否还未圆满
function NeedToAssign(pPlayer, target_unm)
    print("检查圆满:"..target_unm)
    local NeedNum = GP_P_CHECK(pPlayer, target_unm)
    print("检测返回值:"..NeedNum)
    if NeedNum == 0  then-- 未解锁政策时返回 true
        return true
    end
    return false
end

--检测城市是否能入驻伟人
function HasGPSlot(city, target_unm)
    print("凌烟阁政策检测值1:"..target_unm) 
    local pPlayer = Players[city:GetOwner()]
    --已经拥有该加成，不能入驻
    if not NeedToAssign(pPlayer, target_unm) then
        return false
    end
    print("没有加成:"..target_unm) 
    -- 规则1：目标类型已入驻过，直接拒绝
    if city:GetNumBuilding(GP_B[target_unm]) > 0 then
        return false
    end
    print("没有入驻:"..target_unm) 
    -- 规则2：凌烟阁未入驻任何类型时，允许入驻
    if city:GetNumBuilding(LINYAN_TYPE) == 1 then
        local is_empty = true
        for _, building in ipairs(GP_B) do
            if city:GetNumBuilding(building) > 0 then
                is_empty = false
                break
            end
        end
        if is_empty then
            return true  -- 凌烟阁空位可用
        end
    end
    print("凌烟阁已满:"..target_unm) 
    -- 规则3：曲江池允许其他未入驻类型
    if city:GetNumBuilding(QVJIANG_TYPE) > 0 then
        return true
    end
    -- 鸿胪寺额外槽位
    local extra_slots = GetHonglusiExtraSlots(city)
    if extra_slots > 0 then
        local current_count = 0
        for _, building in ipairs(GP_B) do
            if city:GetNumBuilding(building) > 0 then
                current_count = current_count + 1
            end
        end
        print("鸿胪寺已经入驻数量:"..current_count..";鸿胪寺额外入驻数量："..extra_slots) 
        if current_count < extra_slots then
            return true
        end
    end

    return false
end

--检测单位是否入驻圆满，已圆满返回0，其他返回伟人序号
function LINYANGP_2(unit)  
    local target_unm = TABLE_S_TANG_GPCLASS[unit:GetUnitClassType()]
    if target_unm == nil then 
        target_unm = 0
    end
    if target_unm > 0 then
        -- print("凌烟阁政策检测值:"..target_unm) 
        local pPlayer = Players[unit:GetOwner()];
        local GP_PLIVE=GP_P_CHECK(pPlayer,target_unm)
        if target_unm == GP_PLIVE then
            target_unm = 0
        end
    end
    return target_unm  
end
--检测圆满政策是否已获取，已获取返回序号，未获取返回0
function GP_P_CHECK(pPlayer,target_unm)
    local GP_HASPOLICY_CHECK_RESULT = 0
    local GP_HASPOLIVY_CHECK = target_unm
    local GP_CHECKING_POLICY = TABLE_S_TANG_GP_POLICY2[GP_HASPOLIVY_CHECK]  
    if pPlayer:HasPolicy(GP_CHECKING_POLICY) then  
        GP_HASPOLICY_CHECK_RESULT = GP_HASPOLIVY_CHECK  --拥有该加成返回target_unm
        print("凌烟阁政策检测已拥有:"..GP_HASPOLICY_CHECK_RESULT)   
    end
    print("凌烟阁政策检测值4:"..GP_HASPOLIVY_CHECK..",结果："..GP_HASPOLICY_CHECK_RESULT) 
    return GP_HASPOLICY_CHECK_RESULT  
end
--鸿胪寺-计算原始首都数量
function S_TANG_GET_OC_UNM(player)
    local count = 0
    for city in player:Cities() do
        if city:IsOriginalCapital() then
            count = count + 1
        end
    end
    return count
end
--鸿胪寺-计算城市的额外入驻槽位数量
function GetHonglusiExtraSlots(city)
    local player = Players[city:GetOwner()]
    if city:GetNumBuilding(HONGLU_TYPE) == 1 then
        return S_TANG_GET_OC_UNM(player)
    end
    return 0
end
--伟人入驻
function LINYAN_CHECK(city, LINYAN_UNM)  
    if LINYAN_UNM < 1 or LINYAN_UNM > #GP_B then  
        print("Invalid LINYAN_UNM value:"..LINYAN_UNM)  
    end  
    local GP_BONUS_BUILDING = GP_B[LINYAN_UNM]  
    print('LINYAN_UNM:'..LINYAN_UNM)
    city:SetNumRealBuilding(GP_BONUS_BUILDING, 1)
    local cityname = city:GetName()
    local pPlayer = Players[city:GetOwner()]
    if pPlayer:IsHuman() then
        local text0 = Locale.ConvertTextKey("TXT_KEY_S_TANG_GP_IN",cityname);
        Events.GameplayAlertMessage(text0);
    end
    print("一位伟人入驻了"..cityname)
    if pPlayer:HasPolicy(TABLE_S_TANG_GP_POLICY2[6] ) then  
        S_TANG_ENHANCE(city:GetOwner()) 
    end
    if city:GetOriginalOwner() ~= city:GetOwner() then
        local M = CITY_FONT[LINYAN_UNM]  
        city:SetName(M..'·'..cityname)
    end
    local GP_NOW_B_NUM =  pPlayer:CountNumBuildings(GP_BONUS_BUILDING)
    S_TANG_BONUS_SET(city, LINYAN_UNM,GP_NOW_B_NUM)
    if city:IsOriginalCapital() then
        city:SetNumRealBuilding(GP_BONUS_BUILDING, 2)
        GP_NOW_B_NUM = GP_NOW_B_NUM + 1
        S_TANG_BONUS_SET(city, LINYAN_UNM,GP_NOW_B_NUM)
    end
end
--大仙入驻
function S_TANG_ENHANCE(iPlayer)
    local pPlayer = Players[iPlayer]
	if Game.IsOption(GameOptionTypes.GAMEOPTION_NO_RELIGION)==1 or pPlayer == nil  then
        print("S_TANG_ENHANCE ERROR:NOPLAYER")   
		return;
    end
    if not pPlayer:HasCreatedReligion() then
        S_TANG_FAITHBONUS(pPlayer:GetID(),1)
        return;
    end
        if  pPlayer:IsAlive() and pPlayer:GetCivilizationType() == CV_S_TANG then
			local eReligion = pPlayer:GetReligionCreatedByPlayer();
			local availableBeliefs = {};
			for i,v in ipairs(Game.GetAvailablePantheonBeliefs()) do
				local belief = GameInfo.Beliefs[v];
				if belief ~= nil then
					table.insert(availableBeliefs, belief.ID);
				end
			end
			for i,v in ipairs(Game.GetAvailableFounderBeliefs()) do
				local belief = GameInfo.Beliefs[v];
				if belief ~= nil then
					table.insert(availableBeliefs, belief.ID);
				end
			end
			for i,v in ipairs(Game.GetAvailableFollowerBeliefs()) do
				local belief = GameInfo.Beliefs[v];
				if belief ~= nil then
					table.insert(availableBeliefs, belief.ID);
				end
			end
			for i,v in ipairs(Game.GetAvailableEnhancerBeliefs()) do
				local belief = GameInfo.Beliefs[v];
				if belief ~= nil then
					table.insert(availableBeliefs, belief.ID);
				end
			end
			for i,v in ipairs(Game.GetAvailableReformationBeliefs()) do
				local belief = GameInfo.Beliefs[v];
				if belief ~= nil then
					table.insert(availableBeliefs, belief.ID);
				end
			end
			print("Nums of available Beliefs: " .. #availableBeliefs);
			if #availableBeliefs > 0 then
				local randNum = Game.Rand(#availableBeliefs, "at S_TANG_ENHANCE") + 1
				local str = string.format("Calling random at S_TANG_ENHANCE , random number is %d:\n", randNum)
				print(str)
                S_TANG_FAITHBONUS(pPlayer:GetID(),5)
				Game.EnhanceReligion(iPlayer, eReligion, availableBeliefs[randNum], -1);
            else
                S_TANG_FAITHBONUS(pPlayer:GetID(),1)
            end
		end
end
--大仙入驻信仰
function S_TANG_FAITHBONUS(iPlayer,bonusnumber)
    local pPlayer = Players[iPlayer]
    local P_num = pPlayer:GetNumPolicies()
    local C_num = pPlayer:GetNumCities()
    local W_num = pPlayer:GetNumWorldWonders()
    local FINALBONUS = 100*P_num + 100*C_num +100*W_num
    FINALBONUS = FINALBONUS/bonusnumber
    print(FINALBONUS)
    pPlayer:ChangeFaith(FINALBONUS)
    if pPlayer:IsHuman() then
        local text4 = Locale.ConvertTextKey("TXT_KEY_S_TANG_FAITHFINALBONUS",FINALBONUS);
        Events.GameplayAlertMessage(text4);
    end
end
--动态调整伟人需求
function S_TANG_GPNEED()
    local iW, iH = Map.GetGridSize();
    local GP_NEED_NUM = 8;
    if iW < 50 then
        GP_NEED_NUM = 5
    elseif iW < 60 then
        GP_NEED_NUM = 6
    elseif iW < 90 then
        GP_NEED_NUM = 7
    elseif iW < 120 then
        GP_NEED_NUM = 8
    else
        GP_NEED_NUM = 9
    end
    return GP_NEED_NUM
end
--检测入驻伟人后是否圆满
function S_TANG_BONUS_SET(city, LINYAN_UNM,GP_NOW_B_NUM)
    local GP_NEED_NUM = S_TANG_GPNEED()
    local TESTCHANGE = 0--测试时用于降低入驻数量需求
    GP_NEED_NUM = GP_NEED_NUM - TESTCHANGE
    local playerID = city:GetOwner() 
    local pPlayer = Players[playerID]
    if GP_NOW_B_NUM >= GP_NEED_NUM then
        local GP_CHECKING_POLICY = TABLE_S_TANG_GP_POLICY2[LINYAN_UNM]
        local idescriotion = GameInfo.Policies[GP_CHECKING_POLICY].Description
        pPlayer:SetHasPolicy(GP_CHECKING_POLICY,true,true)
        if LINYAN_UNM == 3 then
            local capital = pPlayer:GetCapitalCity();
            if capital == nil then
                return;
            end
            capital:SetNumRealBuilding(GameInfoTypes["BUILDING_LINYAN_ENGINEER_2"], 1);
        end
        if pPlayer:IsHuman() then
            local text1 = Locale.ConvertTextKey("TXT_KEY_S_TANG_BUFF_ON",idescriotion);
            Events.GameplayAlertMessage(text1);
            print("李世民已集齐凌烟阁加成"..idescriotion)
        end
    else
        if pPlayer:IsHuman() then
            local text2 = Locale.ConvertTextKey("TXT_KEY_S_TANG_BUFF_ING",GP_NEED_NUM-GP_NOW_B_NUM);
            Events.GameplayAlertMessage(text2);
            print("李世民距离集齐凌烟阁加成还需要"..GP_NEED_NUM-GP_NOW_B_NUM)
        end
    end
    S_TANG_GP_NOTIFICATION(playerID,city,LINYAN_UNM,GP_NOW_B_NUM)
end

--右侧提示
function S_TANG_GP_NOTIFICATION(playerID,city,LINYAN_UNM,GP_NOW_B_NUM)
    local player = Players[playerID]
    local plot = city:Plot()
    local cityname = city:GetName()
    local GP_CHECKING_POLICY = TABLE_S_TANG_GP_POLICY2[LINYAN_UNM]
    local idescriotion = GameInfo.Policies[GP_CHECKING_POLICY].Description
    if player:IsHuman() then
        local heading = Locale.ConvertTextKey("TXT_KEY_S_TANG_GP_IN",cityname)
        local GP_NEED_NUM = S_TANG_GPNEED()
        local text = Locale.ConvertTextKey("TXT_KEY_S_TANG_GP_NOT_OVER", cityname,idescriotion,GP_NEED_NUM-GP_NOW_B_NUM)
        if GP_NOW_B_NUM >= GP_NEED_NUM then
            text = Locale.ConvertTextKey("TXT_KEY_S_TANG_GP_OVER", cityname,idescriotion)
        end
        player:AddNotification(NotificationTypes.NOTIFICATION_GENERIC, text, heading, plot:GetX(),plot:GetY());
    end 
end