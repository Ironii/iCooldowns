local _, iCD = ...
--options---------
local sounds = iCD.sounds
--end-of-options--
iCD.colors = {
	['green'] = '|cff00ff00',
	['yellow'] = '',
	['red'] = '|cffff1a1a',
}
iCD.backdrop = {
	bgFile = 'Interface\\Buttons\\WHITE8x8',
	edgeFile = 'Interface\\Buttons\\WHITE8x8',
	edgeSize = 1,
	insets = {
		left = 0,
		right = 0,
		top = 0,
		bottom = 0,
	}
}
iCD.barBD = {
	bgFile = 'Interface\\Buttons\\WHITE8x8',
	edgeFile = 'Interface\\Buttons\\WHITE8x8',
	edgeSize = 1,
	insets = {
		left = 0,
		right = 0,
		top = 0,
		bottom = 0,
	}
}
iCD.onCD = {}
iCD.buffs = {}
iCD.PetBuffs = {}
iCD.BuffsI = {}
iCD.PetBuffsI = {}
iCD.BuffsC = {}
iCD.PetBuffsC = {}
iCD.debuffs = {}
iCD.DebuffsI = {}
iCD.DebuffsC = {}
iCD.spells = {}
iCD.extras = {}
iCD.soulbinds = {}
iCD.currentEssences = {major = {0,0}, minor = {}}
local currentAzeritePowers = {}
local buffFrames = {
	['row5'] = true,
	['buffsI'] = true,
	['buffsC'] = true,
}
-- Covenant stuff
local currentCovenant = 0

--APIs to locals
local IsItemInRange,IsSpellInRange, UnitCastingInfo, GetItemCooldown, GetSpellCooldown, GetTime, GetSpellCharges, FindSpellOverrideByID =
	IsItemInRange,IsSpellInRange, UnitCastingInfo, GetItemCooldown, GetSpellCooldown, GetTime, GetSpellCharges, FindSpellOverrideByID
--

local function spairs(t, order)
    -- collect the keys
    local keys = {}
    for k in pairs(t) do keys[#keys+1] = k end

    -- if order function given, sort by it by passing the table and keys a, b,
    -- otherwise just sort the keys
    if order then
        table.sort(keys, function(a,b) return order(t, a, b) end)
    else
        table.sort(keys)
    end

    -- return the iterator function
    local i = 0
    return function()
        i = i + 1
        if keys[i] then
            return keys[i], t[keys[i]]
        end
    end
end
local function UpdateAzeritePowers()
	currentAzeritePowers = nil
	currentAzeritePowers = {}
	for _, itemLocation in AzeriteUtil.EnumerateEquipedAzeriteEmpoweredItems() do
		for _,tier in pairs(C_AzeriteEmpoweredItem.GetAllTierInfo(itemLocation)) do
			for _,azeriteID in pairs(tier.azeritePowerIDs) do
				if C_AzeriteEmpoweredItem.IsPowerSelected(itemLocation, azeriteID) then
					currentAzeritePowers[azeriteID] = true
					break
				end
			end
		end
	end
end

function iCD:Soulbinds(id)
	return iCD.soulbinds[id]
end
function iCD:Essences(essenceID, major, minRank)
	return false
	--[[
	if major then
			if minRank then
				return iCD.currentEssences.major[1] == essenceID and iCD.currentEssences.major[2] >= minRank
			end
			return iCD.currentEssences.major[1] == essenceID
	else
		return minRank and (iCD.currentEssences.minor[essenceID] and iCD.currentEssences.minor[essenceID] >= minRank) or iCD.currentEssences.minor[essenceID]
	end
	--]]
end
local _auras = {
	playerBuffs = {},
	targetDebuffs = {},
	petBuffs = {},
}
--isSelected = C_AzeriteEmpoweredItem.IsPowerSelected(itemLocation, powerid)
function iCD.UnitBuff(target,buffName,castByPlayer)
	if target:lower() == "player" then
		for k,v in pairs(_auras.playerBuffs) do
			if v[1] == buffName then
				if not castByPlayer or (castByPlayer and v[7] == 'player') then
					return v[3], v[5], v[6], v[16], v[17], v[18]
				end
			end
		end
	elseif target:lower() == "pet" then
		for k,v in pairs(_auras.petBuffs) do
			if v[1] == buffName then
				if not castByPlayer or (castByPlayer and v[7] == 'player') then
					return v[3], v[5], v[6], v[16], v[17], v[18]
				end
			end
		end
	else
		for i = 1, 129 do -- Buffs
			local name, icon, count, debuffType, duration, expirationTime, sourceUnit, _, _, spellID,canApplyAura,isBossDebuff, castByPlayer, nameplateShowAll,timeMod,value1,value2,value3 = UnitBuff(target, i, castByPlayer and "player")
		if not name then return end
			if buffName == name then
				return count, duration, expirationTime, value1, value2, value3
			end
		end
	end
	return
end

function iCD.UnitDebuff(target, buffName, castByPlayer)
	if not target or target:lower() == "target" then
		if not iCD.hasTargetDebuffs then
			iCD.hasTargetDebuffs = true
			for i = 1, 129 do -- Debuffs
				local name, icon, count, debuffType, duration, expirationTime, sourceUnit, _, _, spellID,canApplyAura,isBossDebuff, castByPlayer, nameplateShowAll,timeMod,value1,value2,value3 = UnitDebuff((target and target or 'target'), i, castByPlayer and 'player')
				if not name then return end
				if buffName == name then
					return count, duration, expirationTime, value1, value2, value3
				end
			end
		end
		for k,v in pairs(_auras.targetDebuffs) do
			if v[1] == buffName then
				if not castByPlayer or (castByPlayer and v[7] == 'player') then
					return v[3], v[5], v[6], v[16], v[17], v[18]
				end
			end
		end
	else
		for i = 1, 129 do -- Debuffs
			local name, icon, count, debuffType, duration, expirationTime, sourceUnit, _, _, spellID,canApplyAura,isBossDebuff, castByPlayer, nameplateShowAll,timeMod,value1,value2,value3 = UnitDebuff((target and target or 'target'), i, castByPlayer and 'player')
			if not name then return end
			if buffName == name then
				return count, duration, expirationTime, value1, value2, value3
			end
		end
	end
	return
end
do
	local gcdInfo = {
		left = 0,
		duration = 0,
		start = 0,
		lastFrame = 0,
	}
	function iCD:getTimeAfterGCD(t)
		local _time = GetTime()
		if gcdInfo.lastFrame ~= _time then
			local gS, gcdD = GetSpellCooldown(iCD.gcd)
			local gCD = gS+gcdD-_time
			gcdInfo = {
				left = gCD,
				duration = gcdD,
				start = gS,
				lastFrame = _time
			}
		end
		if gcdInfo.start == 0 then
			return "%.1f", t
		end
		if t <= gcdInfo.duration then
			return '|cffFF9999(%.0f)', t-gcdInfo.duration
		else
			t = t - gcdInfo.duration
			if t > 5 then
				return '|cffFF9999%.0f', t
			elseif t <= 0.05 then
				return "|cffCCFFFF%.1f", t -- change color?
			elseif t < 2 then
				return '|cffCCFFFF%.1f', t
			else
				return '|cfffc2ffc%.1f', t
			end
		end
end
do
	local castInfo = {
		left = 0,
		lastFrame = 0,
	}
	function iCD:getTimeAfterCast(t)
		local _time = GetTime()
		if castInfo.lastFrame ~= _time then
				local name, _, _, startTimeMS, endTimeMS = UnitCastingInfo("player")
				if endTimeMS then
					castInfo.left = endTimeMS/1000 - _time
				else
					local _format, text = iCD:getTimeAfterGCD(t)
					return _format, text
				end
		end
		if castInfo.left > t then -- ready during cast, use gcd
			local _format, text = iCD:getTimeAfterGCD(t)
			return _format, text
		end
			t = t - castInfo.left
			if t > 5 then
				return '|cffFF9999%.0f', t
			elseif t <= 0.05 then
				return "%.1f", t
			elseif t < 2 then
				return '|cffCCFFFF%.1f', t
			else
				return '|cfffc2ffc%.1f', t
			end
		end
	end
end
local addon = CreateFrame('Frame')
addon:SetScript("OnEvent", function(self, event, ...)
	self[event](self, ...)
end)
iCD.customSpellTimers = {}
--Health bar
local invertedHPBar = iCD.setups.hpBar.inverted
do
	local c = iCD.setups.hpBar
	iCD.hpBar = CreateFrame('Statusbar', 'iCD_Health', UIParent)
	iCD.hpBar:SetStatusBarTexture('Interface\\Buttons\\WHITE8x8')
	iCD.hpBar:SetWidth(c.width)
	iCD.hpBar:SetHeight(c.height)
	iCD.hpBar:SetStatusBarColor(c.defaultColor[1], c.defaultColor[2],	c.defaultColor[3], c.defaultColor[4])
	iCD.hpBar:SetMinMaxValues(0,1)
	if invertedHPBar then
		iCD.hpBar:SetReverseFill(true)
	end
	iCD.hpBar:SetValue(0)
	iCD.hpBar:SetPoint(c.position.from, UIParent, c.position.to, c.position.x,c.position.y)

	iCD.hpBar.bg = CreateFrame('frame', nil, iCD.hpBar, "BackdropTemplate")
	iCD.hpBar.bg:SetWidth(c.width)
	iCD.hpBar.bg:SetHeight(c.height)
	iCD.hpBar.bg:SetPoint('CENTER', iCD.hpBar, 'CENTER',0,0)
	iCD.hpBar.bg:SetBackdrop(iCD.barBD)
	iCD.hpBar.bg:SetBackdropBorderColor(0,0,0,1)
	iCD.hpBar.bg:SetBackdropColor(0,0,0,0)

	iCD.hpBar.flash = iCD.hpBar:CreateAnimationGroup()
	iCD.hpBar.flash:SetLooping('REPEAT')
	iCD.hpBar.flash:HookScript('OnPlay', function()
		iCD.hpBar.anim = true
	end)
	iCD.hpBar.flash:HookScript('OnStop', function()
		iCD.hpBar.anim = false
	end)
	iCD.hpBar.fadeOut = iCD.hpBar.flash:CreateAnimation('Alpha')
	iCD.hpBar.fadeOut:SetDuration(0.15)
	iCD.hpBar.fadeOut:SetFromAlpha(1)
	iCD.hpBar.fadeOut:SetToAlpha(0)
	iCD.hpBar.fadeOut:SetOrder(1)

	iCD.hpBar.fadeIn = iCD.hpBar.flash:CreateAnimation('Alpha')
	iCD.hpBar.fadeIn:SetDuration(0.15)
	iCD.hpBar.fadeIn:SetFromAlpha(0)
	iCD.hpBar.fadeIn:SetToAlpha(1)
	iCD.hpBar.fadeIn:SetOrder(2)
end
--EH text
do
	local c = iCD.setups.ehText
	iCD.EHtext = iCD.hpBar:CreateFontString()
	iCD.EHtext:SetFont(iCD.font, c.fontSize, 'OUTLINE')
	iCD.EHtext:SetPoint(c.position.from, iCD.hpBar, c.position.to, c.position.x,c.position.y)
	iCD.EHtext:SetText('')
end
local function setupFrame(f,n)
	local c = iCD.setups[n]
	if not c then print("iCD: ERROR - no setup found for :", n) return end
	f:ClearAllPoints()
	f:SetPoint(c.position.from, iCD.hpBar, c.position.to, c.position.x, c.position.y)
end
iCD.positions = {
	row1 = {default = function(f) setupFrame(f, "row1") end, changed = false},
	row2 = {default = function(f) setupFrame(f, "row2") end, changed = false},
	row3 = {default = function(f) setupFrame(f, "row3") end, changed = false},
	row4 = {default = function(f) setupFrame(f, "row4") end, changed = false},
	row5 = {default = function(f) setupFrame(f, "row5") end, changed = false},
	buffsI = {default = function(f) setupFrame(f, "buffsI") end, changed = false},
	buffsC = {default = function(f) setupFrame(f, "buffsC") end, changed = false},
}
--row1
iCD.row1 = CreateFrame('frame', nil, UIParent)
iCD.row1:SetSize(20,20)
iCD.positions.row1.default(iCD.row1)
--row2
iCD.row2 = CreateFrame('frame', nil, UIParent)
iCD.row2:SetSize(20,20)
iCD.positions.row2.default(iCD.row2)
-- Row 3
iCD.row3 = CreateFrame('frame', nil, UIParent)
iCD.row3:SetSize(20,20)
iCD.positions.row3.default(iCD.row3)
-- Row 4 (only on cd)
iCD.row4 = CreateFrame('frame', nil, UIParent)
iCD.row4:SetSize(20,20)
iCD.positions.row4.default(iCD.row4)
-- Row 5 Big Buffs
iCD.row5 = CreateFrame('frame', nil, UIParent)
iCD.row5:SetSize(20,20)
iCD.positions.row5.default(iCD.row5)

-- Buffs (Important)
iCD.buffsI = CreateFrame('frame', nil, UIParent)
iCD.buffsI:SetSize(20,20)
iCD.positions.buffsI.default(iCD.buffsI)

-- Buffs (center)
iCD.buffsC = CreateFrame('frame', nil, UIParent)
iCD.buffsC:SetSize(20,20)
iCD.positions.buffsC.default(iCD.buffsC)

-- GCD
do
	local c = iCD.setups.gcd
	iCD.GCD = CreateFrame('Statusbar', nil, UIParent)
	iCD.GCD:SetStatusBarTexture('Interface\\Buttons\\WHITE8x8')
	iCD.GCD:SetWidth(c.width)
	iCD.GCD:SetHeight(c.height)
	iCD.GCD:SetStatusBarColor(c.defaultColor[1], c.defaultColor[2], c.defaultColor[3], c.defaultColor[4])
	iCD.GCD:SetMinMaxValues(0,1)
	iCD.GCD:SetValue(0)
	iCD.GCD:SetPoint(c.position.from, iCD.hpBar, c.position.to, c.position.x, c.position.y)

	iCD.GCD.bg = CreateFrame('frame', nil, iCD.GCD, "BackdropTemplate")
	iCD.GCD.bg:SetWidth(c.width)
	iCD.GCD.bg:SetHeight(c.height)
	iCD.GCD.bg:SetPoint('CENTER', iCD.GCD, 'CENTER',0,0)
	iCD.GCD.bg:SetBackdrop(iCD.barBD)
	iCD.GCD.bg:SetBackdropBorderColor(0,0,0,1)
	iCD.GCD.bg:SetBackdropColor(0,0,0,0)
end
-- Anchor for texts above health bar
iCD.textAnchor = CreateFrame('frame', nil, UIParent)
iCD.textAnchor:SetSize(40,20)
iCD.textAnchor:SetPoint('BOTTOM', iCD.hpBar, 'TOP',0,2)

-- Power Text
do
	local c = iCD.setups.power
	iCD.powerText = iCD.GCD:CreateFontString('iCD_powerText')
	iCD.powerText:SetFont(iCD.font, c.fontSize, 'OUTLINE')
	iCD.powerText:SetJustifyH(c.justifyH)
	iCD.powerText:SetPoint(c.position.from, UIParent, c.position.to, c.position.x, c.position.y)
	iCD.powerText:SetText('')
end

-- Out of range warning
do
	local c = iCD.setups.outOfRange
	iCD.outOfRangeFrame = CreateFrame('frame', nil, UIParent)
	iCD.outOfRange = iCD.outOfRangeFrame:CreateFontString('iCD_outOfRange')
	iCD.outOfRange:SetFont(iCD.font, c.fontSize, 'OUTLINE')
	iCD.outOfRange:SetJustifyH(c.justifyH)
	iCD.outOfRange:SetPoint(c.position.from, UIParent, c.position.to, c.position.x, c.position.y)
	iCD.outOfRange:SetText(c.text)
	iCD.outOfRange:SetTextColor(1,0,0)
	iCD.outOfRange:Hide()
	iCD.outOfRange.color = 1 -- red

	iCD.outOfRange.flash = iCD.outOfRange:CreateAnimationGroup()
	iCD.outOfRange.flash:SetLooping('REPEAT')
	iCD.outOfRange.flash:HookScript('OnPlay', function()
		iCD.outOfRange.anim = true
		--iCD.outOfRange:Show()
	end)
	iCD.outOfRange.flash:HookScript('OnStop', function()
		iCD.outOfRange.anim = false
	--	iCD.outOfRange:Hide()
	end)
	iCD.outOfRange.fadeOut = iCD.outOfRange.flash:CreateAnimation('Alpha')
	iCD.outOfRange.fadeOut:SetDuration(.25)
	iCD.outOfRange.fadeOut:SetFromAlpha(1)
	iCD.outOfRange.fadeOut:SetToAlpha(0)
	iCD.outOfRange.fadeOut:SetOrder(1)

	iCD.outOfRange.fadeIn = iCD.outOfRange.flash:CreateAnimation('Alpha')
	iCD.outOfRange.fadeIn:SetDuration(.25)
	iCD.outOfRange.fadeIn:SetFromAlpha(0)
	iCD.outOfRange.fadeIn:SetToAlpha(1)
	iCD.outOfRange.fadeIn:SetOrder(2)
end
iCD.frames = {
	row1 = {},
	row2 = {},
	row3 = {},
	row4 = {},
	row5 = {},
	buffsI = {},
	buffsC = {},
}
iCD.textFrames = {}
local icdRangeCheckTimer = 0
function iCD:checkRange(force)
	local t = GetTime()
	if force or (t > icdRangeCheckTimer + 0.1) then
		icdRangeCheckTimer = t
		if UnitExists('target') then
			local rangeID, rangeColor, range, lastRange = iCD:GetRange('target')
			if rangeID == 3 then
				if iCD.outOfRange.anim then
					iCD.outOfRange.flash:Stop()
					iCD.outOfRange:Hide()
				end
			elseif not iCD.outOfRange.anim then
					iCD.outOfRange.flash:Play()
					iCD.outOfRange:Show()
			end
			if iCD.outOfRange.currentColor ~= rangeID then
				iCD.outOfRange:SetTextColor(rangeColor.r, rangeColor.g, rangeColor.b)
				iCD.outOfRange.currentColor = rangeID
			end
			if iCD.outOfRange.currentRange ~= range then
				iCD.outOfRange.currentRange = range
				iCD.outOfRange:SetText(string.format("%d-%d\n%s", range, lastRange, iCD.setups.outOfRange.text))
			end
		elseif iCD.outOfRange.anim then
			iCD.outOfRange.flash:Stop()
			iCD.outOfRange:Hide()
		end
	end
end
function iCD:resetGlows()
	if iCD.glowEffects then
		for spellID, v in pairs(iCD.glowEffects) do -- Stop animations
			for i = 1, #v do
				if iCD.frames[iCD.glowEffects[spellID][i].row][iCD.glowEffects[spellID][i].id].anim then
					iCD.frames[iCD.glowEffects[spellID][i].row][iCD.glowEffects[spellID][i].id].flash:Stop()
					iCD.frames[iCD.glowEffects[spellID][i].row][iCD.glowEffects[spellID][i].id]:SetAlpha(1)
				end
			end
		end
	end
	iCD.glowEffects = {}
	iCD.glowSoundEffects = {}
end
function iCD:createTextString(id)
	if not iCD.textFrames[id] then
		iCD.textFrames[id] = iCD.textAnchor:CreateFontString()
		iCD.textFrames[id]:SetFont(iCD.font, 12, 'OUTLINE')
		iCD.textFrames[id]:SetWidth(25)
		if id == 1 then
			iCD.textFrames[id]:SetPoint('LEFT', iCD.textAnchor, 'LEFT', 0,0)
		else
			iCD.textFrames[id]:SetPoint('LEFT', iCD.textFrames[id-1], 'RIGHT', 0,0)
		end
	end
end
local function getGeneralCooldown(id)
	if not id then -- gcd
		local start, cooldown = GetSpellCooldown(61304)
		return start, cooldown
	end
	if id < 0 then 
		local start, cooldown = GetItemCooldown(-id)
		return start, cooldown, nil, nil, true
	else
		local charges,maxCharges,chargeStart,chargeDuration = GetSpellCharges(id)
		if charges then
			return chargeStart, chargeDuration, charges, maxCharges
		end
		local start, cooldown = GetSpellCooldown(id)
		return start, cooldown
	end
end
do
function iCD:updateFrame(id, row, frame, gcdInfo)
	--local data = iCD.frames[row][id].data
	if buffFrames[row] then
		if frame.data.customText then
			local text, f = frame.data.customText(frame.data, gcdInfo)
			if f then
				frame.cooldownText:SetFormattedText(f, text)
			else
				frame.cooldownText:SetText(text)
			end
		else
			local text = frame.data.endTime-GetTime()
			if text > 60 then
				local s = (math.floor(text * 10 + 0.5) / 10)%60
				local m = math.floor(text/60)
				frame.cooldownText:SetFormattedText('%d:%.2d', m,s)
			elseif text > 5 then
				frame.cooldownText:SetFormattedText('%.0f', text)
			elseif text > 0 then
				frame.cooldownText:SetFormattedText('|cffff1a1a%.1f', text)
			else
				frame.cooldownText:SetText('')
			end

			if text <= 3 and text >= 0 then
				if not frame.anim then
					frame:SetAlpha(1)
					frame.flash:Play()
				end
			elseif frame.anim then
				frame:SetAlpha(1)
				frame.flash:Stop()
			end
		end
	else
		local cost = false
		local range = false
		if frame.data.customCost then
			if frame.data.customCost(frame.data, gcdInfo) then
				cost = true
			end
		elseif frame.data.cost then
			if select(2, IsUsableSpell(frame.data.spellName)) then
				cost = true
			end
		end
		if frame.data.customRange then
			if not frame.data.customRange(frame.data, gcdInfo) then
				range = true
			end
		elseif frame.data.range then
			local rangeSpell = frame.data.customRangeSpell or frame.data.spellName
			if frame.data.customRangeSpell and tonumber(frame.data.customRangeSpell) then
				if not IsItemInRange(frame.data.customRangeSpell*-1, 'target') then
				range = true
				end
			else
				if IsSpellInRange(rangeSpell, 'target') == 0 then
					range = true
				end
			end
		end
		if frame.data.AM and frame.data.AM(frame.data, gcdInfo) then
			if frame.data.unMod ~= 'am' then
				frame.tex:SetVertexColor(1,0,1,1)
				frame.data.unMod = 'am'
			end
		elseif range then
			if frame.data.unMod ~= 'range' then
				frame.tex:SetVertexColor(1,0,0,1)
				frame.data.unMod = 'range'
			end
		elseif cost then
			if frame.data.unMod ~= 'cost' then
				frame.tex:SetVertexColor(0.5,0.5,1,1)
				frame.data.unMod = 'cost'
			end
		else
			if frame.data.unMod ~= 'none' then
				frame.tex:SetVertexColor(1,1,1,1)
				frame.data.unMod = 'none'
			end
		end
		local text = 0
		if frame.data.customText then
			text, f = frame.data.customText(frame.data, gcdInfo)
			if f then
				frame.cooldownText:SetFormattedText(f, text)
			else
				frame.cooldownText:SetText(text)
			end
		else
			local gS, gcdD = getGeneralCooldown()
			local gCD = gS+gcdD-GetTime()
			local s, cd = 0,0
			local readyDuringCast = false
			if frame.data.customDuration then
				text = frame.data.customDuration - GetTime()
			elseif frame.data.showTimeAfterGCD then
				local s,cd,c,m = getGeneralCooldown(frame.data.allowOverride and FindSpellOverrideByID(frame.data.usedBy) or frame.data.usedBy)
				if c and c == m then
					s = 0
				end
				local cdD = s+cd-GetTime()
				if s > 0 then
					if gcdD ~= cd then
						if gCD > 0 then
							text = cdD - gCD
						else
							text = cdD
						end
					end
				end
			elseif frame.data.showTimeAfterCast then
				local s,cd,c,m = getGeneralCooldown(frame.data.allowOverride and FindSpellOverrideByID(frame.data.usedBy) or frame.data.usedBy)
				if c and c == m then
					s = 0
				end
				local cdD = s+cd-GetTime()
				if s > 0 then
					if gcdD ~= cd then
						local name, _, _, startTimeMS, endTimeMS = UnitCastingInfo("player")
						if endTimeMS then
							local castLeft = endTimeMS/1000 - GetTime()
							if castLeft < cdD then
								if gCD > 0 and gCD > castLeft then
									text = cdD - gCD
								else
									text = cdD-castLeft
								end
							else
								if gCD > 0 then
									text = cdD - gCD
								else
									text = cdD
								end
								readyDuringCast = true
							end
						elseif gCD > 0 then
							text = cdD - gCD
						else
							text = cdD
						end
					end
				end
			else
				local s,cd,c,m = getGeneralCooldown(frame.data.allowOverride and FindSpellOverrideByID(frame.data.usedBy) or frame.data.usedBy)
				if c and c == m then
					s = 0
				end
				local cdD = s+cd-GetTime()
				if s > 0 then
					if frame.data.ignoreGCD or frame.data.item then
						text = cdD
					else
						if gcdD ~= cd then
							text = cdD
						end
					end
				end
			end
			if row == 'row2' then
				if text > 0 then
					local fade = true
					if frame.data.stack then
						local c,m,sd,d = GetSpellCharges(frame.data.usedBy)
						if c > 0 then
							fade = false
						end
					end
					if fade then
						frame:SetAlpha(.35)
					else
						frame:SetAlpha(1)
					end
				elseif text == 0 then
					frame:SetAlpha(1)
					frame.onCD = false
				end
			end
			if (frame.data.showTimeAfterGCD and gcdD > 0) or (frame.data.showTimeAfterCast and text > 0) then
				if text > 60 then
					local s = (math.floor(text * 10 + 0.5) / 10)%60
					local m = math.floor(text/60)
					frame.cooldownText:SetFormattedText('%d:%.2d', m,s)
				elseif text > 5 then
					if readyDuringCast then
						frame.cooldownText:SetFormattedText('|cffFF9999(%.0f)', text)
					else
						frame.cooldownText:SetFormattedText('|cffFF9999%.0f', text)
					end
					
				elseif text > 0 then
					if text <= 0.05 then
						frame.cooldownText:SetText('')
					elseif text < 2 then
						if readyDuringCast then
							frame.cooldownText:SetFormattedText('|cffCCFFFF(%.1f)', text)
						else
							frame.cooldownText:SetFormattedText('|cffCCFFFF%.1f', text)
						end
					else
						if readyDuringCast then
							frame.cooldownText:SetFormattedText('|cfffc2ffc(%.1f)', text)
						else
							frame.cooldownText:SetFormattedText('|cfffc2ffc%.1f', text)
						end
					end
				else
					if row == 'row4' then
						iCD:updateCDs()
					else
						frame.cooldownText:SetText('')
					end
				end
			else
				if text > 60 then
					local s = (math.floor(text * 10 + 0.5) / 10)%60
					local m = math.floor(text/60)
					frame.cooldownText:SetFormattedText('%d:%.2d', m,s)
				elseif text > 5 then
					frame.cooldownText:SetFormattedText('%.0f', text)
				elseif text > 0 then
					if row == 'row1' and ((gCD + 0.1 > text) or (gcdD == 0 and text < 0.3))then
						frame.cooldownText:SetFormattedText('|cff00ff00%.1f', text)
					else
						frame.cooldownText:SetFormattedText('|cffff1a1a%.1f', text)
					end
				else
					if row == 'row4' then
						iCD:updateCDs()
					else
						frame.cooldownText:SetText('')
					end
				end
			end
		end
	end
	if frame.data.stackFunc then
		local txt, txtFormat = frame.data.stackFunc(frame.data, gcdInfo)
		if txtFormat then
			frame.stackText:SetFormattedText(txtFormat, txt)
		else
			frame.stackText:SetText(txt)
		end
	elseif frame.data.stack then
		if type(frame.data.stack) == "boolean" then
			local s,cd,c,m = getGeneralCooldown(frame.data.allowOverride and FindSpellOverrideByID(frame.data.usedBy) or frame.data.usedBy)
			if m and m > 1 then
				frame.stackText:SetText(c)
			else
				frame.stackText:SetText("")
			end
		else
			frame.stackText:SetText(frame.data.stack)
		end
	end
end
end
function iCD:CreateNewFrame(id, row)
	if iCD.frames[row][id] then
		iCD.frames[row][id].cooldownText:SetText('')
		iCD.frames[row][id].stackText:SetText('')
		iCD.frames[row][id]:SetAlpha(1)
		return
	end
	local c = iCD.setups[row]
	iCD.frames[row][id] = CreateFrame('frame',nil,iCD[row], "BackdropTemplate")
	iCD.frames[row][id]:SetSize(c.size,c.size)
	--Backdrop
	iCD.frames[row][id]:SetBackdrop(iCD.backdrop)
	iCD.frames[row][id]:SetBackdropColor(0.2,0.2,0.2,0.5)
	iCD.frames[row][id]:SetBackdropBorderColor(0,0,0,1)
	iCD.frames[row][id]:SetFrameStrata('MEDIUM')
	if c.horizontal then
		if id == 1 then
			iCD.frames[row][id]:SetPoint('LEFT', iCD[row] , 'LEFT', 0, 0)
		else
			iCD.frames[row][id]:SetPoint('LEFT', iCD.frames[row][id-1], 'RIGHT', 1, 0)
		end
	else
		if id == 1 then
			iCD.frames[row][id]:SetPoint('BOTTOM', iCD[row] , 'BOTTOM', 0, 0)
		else
			iCD.frames[row][id]:SetPoint('BOTTOM', iCD.frames[row][id-1], 'TOP', 0, 1)
		end
	end
	--Icon
	iCD.frames[row][id].tex = iCD.frames[row][id]:CreateTexture()
	iCD.frames[row][id].tex:SetAllPoints(iCD.frames[row][id])
	--Cooldown
	iCD.frames[row][id].cooldownText = iCD.frames[row][id]:CreateFontString()
	iCD.frames[row][id].cooldownText:SetIgnoreParentAlpha(true)

	if row == 'row5' then
		iCD.frames[row][id].cooldownText:SetFont(iCD.font, iCD.fontSize+4, 'OUTLINE')
		iCD.frames[row][id].cooldownText:SetPoint('CENTER', iCD.frames[row][id], 'CENTER', 0,0)
	else
		iCD.frames[row][id].cooldownText:SetFont(iCD.font, iCD.fontSize, 'OUTLINE')
		iCD.frames[row][id].cooldownText:SetPoint('BOTTOM', iCD.frames[row][id], 'BOTTOM', 0,0)
	end
	iCD.frames[row][id].cooldownText:SetTextColor(1,1,0.1,1)
	--Stack
	iCD.frames[row][id].stackText = iCD.frames[row][id]:CreateFontString()
	iCD.frames[row][id].stackText:SetFont(iCD.font, iCD.stackFontSize, 'OUTLINE')
	if row == 'row4' then
		iCD.frames[row][id].stackText:SetPoint('TOPRIGHT', iCD.frames[row][id], 'TOPRIGHT', 0,0)
	elseif row == 'buffsI' or row == 'buffsC' then
		iCD.frames[row][id].stackText:SetPoint('RIGHT', iCD.frames[row][id], 'TOPRIGHT', 0,0)
	else
		iCD.frames[row][id].stackText:SetPoint('CENTER', iCD.frames[row][id], 'TOPRIGHT', 0,0)
	end
	iCD.frames[row][id].stackText:SetTextColor(1,1,1,1)
	--Flash (glow)
	iCD.frames[row][id].flash = iCD.frames[row][id]:CreateAnimationGroup()
	iCD.frames[row][id].flash:SetLooping('REPEAT')
	iCD.frames[row][id].flash:HookScript('OnPlay', function()
		iCD.frames[row][id].anim = true
	end)
	iCD.frames[row][id].flash:HookScript('OnStop', function()
		iCD.frames[row][id].anim = false
	end)
	iCD.frames[row][id].fadeOut = iCD.frames[row][id].flash:CreateAnimation('Alpha')
	iCD.frames[row][id].fadeOut:SetDuration(0.25)
	iCD.frames[row][id].fadeOut:SetFromAlpha(1)
	iCD.frames[row][id].fadeOut:SetToAlpha(0)
	iCD.frames[row][id].fadeOut:SetOrder(1)

	iCD.frames[row][id].fadeIn = iCD.frames[row][id].flash:CreateAnimation('Alpha')
	iCD.frames[row][id].fadeIn:SetDuration(0.25)
	iCD.frames[row][id].fadeIn:SetFromAlpha(0)
	iCD.frames[row][id].fadeIn:SetToAlpha(1)
	iCD.frames[row][id].fadeIn:SetOrder(2)
end
function iCD:updateCDs()
	local temp = {}
	local tempExtras
	for k,v in pairs(iCD.extras) do
		local dura = v.customDuration - GetTime()
		if dura > 0 then
			temp[k] = v
			temp[k].duration = dura
		end
	end
	for k,v in pairs(iCD.onCD) do
		--local spellIDToUse = k
		if v.allowOverride then
			k = FindSpellOverrideByID(k)
		end
		local s, cd
		local s,cd,c,m,isItem = getGeneralCooldown(k)
		if c and c == m then
			s = 0
		end
		--[[
		if v.charges then
			local c,m,sd,d = GetSpellCharges(k)
			if c == m then
				s = 0
				cd = d
			else
				s = sd
				cd = d
			end
		elseif k < 0 then
			s, cd = GetItemCooldown(-k)
			isItem = true
		else
			s,cd = GetSpellCooldown(k)
		end
		--]]
		local cdD = s+cd-GetTime()
		local dura = 0
		if s > 0 then
			if isItem or v.ignoreGCD then
				if isItem and v.ignoreGCD then
					local _,gcdD = getGeneralCooldown()
					if s > 0 and cd == gcdD then
						dura = 0
					else
						dura = cdD
					end
				else
					dura = cdD
				end
			else
				local gS, gcdD = getGeneralCooldown()
				local gCD = gS+gcdD-GetTime()
				if (gCD + 0.05) < cdD then
					dura = cdD
				end
			end
		end
		if dura > 0 then
			v.duration = dura
			temp[k] = v
		end
	end
	local id = 1
	for k,v in spairs(temp, function(t,a,b) return t[b].duration > t[a].duration end) do
		iCD:CreateNewFrame(id, 'row4')
		iCD.frames.row4[id].data = {}
		iCD.frames.row4[id].data.usedBy = k
		--allowOverride
		--iCD.frames.row4[id].data.spellName = GetSpellInfo(k)
		if v.customDuration then
			iCD.frames.row4[id].data.customDuration = v.customDuration
		end
		if k < 0 then
			--iCD.frames.row4[id].data.item = true
			local itemName,_,_,_,_,_,_,_,_,icon = GetItemInfo(-k)
			iCD.frames.row4[id].data.spellName = itemName
			iCD.frames.row4[id].tex:SetTexture(v.icon or icon)
		else
			iCD.frames.row4[id].data.spellName = GetSpellInfo(k)
			iCD.frames.row4[id].tex:SetTexture(v.icon or GetSpellTexture(k))
		end
		if v.stackFunc then
			iCD.frames.row4[id].data.stackFunc = v.stackFunc
		elseif v.stack then
			iCD.frames.row4[id].data.stack = v.stack
		end
		if v.customText then
			iCD.frames.row4[id].data.customText = v.customText
		end
		if v.ignoreGCD then
			iCD.frames.row4[id].data.ignoreGCD = true
		end
		if v.charges then
			iCD.frames.row4[id].data.charges = true
		end
		if v.showTimeAfterGCD then
			iCD.frames.row4[id].data.showTimeAfterGCD = true
		end
		if v.showTimeAfterCast then
			iCD.frames.row4[id].data.showTimeAfterCast = true
		end
		iCD.frames.row4[id].tex:SetVertexColor(1,1,1,1)
		iCD.frames.row4[id].data.unMod = 'none'
		iCD.frames.row4[id]:Show()
		id = id + 1
	end
	iCD.row4:SetWidth((id-1)*(iCD.setups.row4.size+1)-1)
	for i = id, #iCD.frames.row4 do
		iCD.frames.row4[i].data = {}
		iCD.frames.row4[i]:Hide()
	end
	temp = nil
end
function iCD:updateOnCD()
	if not iCD.class or not iCD.specID then
		return
	end
	local temp = {}
	for k,v in pairs(iCD.general.row4) do
		if not v.showFunc or (v.showFunc and v.showFunc()) and (not v.level or v.level <= iCD.level) then
			if v.itemReq or k < 0 then
				if type(v.itemReq) == 'table' then
					for k,_ in pairs(v.itemReq) do
						if IsEquippedItem(k) then
							temp[k] = v
						end
					end
				elseif k < 0 then
					if v.utility or IsEquippedItem(-k) then
						temp[k] = v
					end
				else
					if IsEquippedItem(v.itemReq) then
						temp[k] = v
					end
				end
			else
				temp[k] = v
			end
		end
	end
	for k,v in pairs(iCD.spellData.spec.row4) do
		if not v.showFunc or (v.showFunc and v.showFunc()) then
			if v.itemReq or k < 0 then
				if type(v.itemReq) == 'table' then
					for k,_ in pairs(v.itemReq) do
						if IsEquippedItem(k) then
							temp[k] = v
						end
					end
				elseif k < 0 then
					if v.utility or IsEquippedItem(-k) then
						temp[k] = v
					end
				else
					if IsEquippedItem(v.itemReq) then
						temp[k] = v
					end
				end
			else
				temp[k] = v
			end
		end
	end
	for k,v in pairs(iCD.spellData.all.row4) do
		if not v.showFunc or (v.showFunc and v.showFunc()) then
			if v.itemReq or k < 0 then
				if type(v.itemReq) == 'table' then
					for k,_ in pairs(v.itemReq) do
						if IsEquippedItem(k) then
							temp[k] = v
						end
					end
				elseif k < 0 then
					if v.utility or IsEquippedItem(-k) then
						temp[k] = v
					end
				else
					if IsEquippedItem(v.itemReq) then
						temp[k] = v
					end
				end
			else
				temp[k] = v
			end
		end
	end
	iCD.onCD = temp
	iCD:updateCDs()
end
function iCD:updateBuffs()
	local temp = {}
	local tempI = {}
	local tempC = {}
	_auras = {
		playerBuffs = {},
		targetDebuffs = {},
		petBuffs = {},
	}
	if iCD.hasPlayerBuffs then
		for i = 1, 129 do -- Buffs
			local t = {UnitBuff('player', i)}
			--local name, icon, count, debuffType, duration, expirationTime, sourceUnit, _, _, spellID = UnitBuff('player', i)
			if not t[1] then
				break
			else
				local name, icon, count, duration, expirationTime, sourceUnit, spellID, castByPlayer = t[1], t[2], t[3], t[5], t[6], t[7], t[10], t[13]
				_auras.playerBuffs[i] = t
				if iCD.buffs[spellID] then
					local data = {
						endTime = expirationTime,
						texture = iCD.buffs[spellID].icon or icon,
					}
					if iCD.buffs[spellID].stack then
						if iCD.buffs[spellID].stackFunc then
							data.stackFunc = iCD.buffs[spellID].stackFunc
						elseif type(iCD.buffs[spellID].stack) == 'string' then
							if iCD.buffs[spellID].stack == 'caster' then
								data.stack = UnitName(sourceUnit)
							else
								data.stack = iCD.buffs[spellID].stack
							end
						else
							data.stack = count
						end
					end
					if iCD.buffs[spellID].customText then
						data.customText = iCD.buffs[spellID].customText
					end
					temp[spellID] = data
				end
				if iCD.BuffsI[spellID] then
					local data = {
						endTime = expirationTime,
						texture = iCD.BuffsI[spellID].icon or icon,
					}
					if iCD.BuffsI[spellID].stack then
						if iCD.BuffsI[spellID].stackFunc then
							data.stackFunc = iCD.BuffsI[spellID].stackFunc
						elseif type(iCD.BuffsI[spellID].stack) == 'string' then
							data.stack = iCD.BuffsI[spellID].stack
						else
							data.stack = count
						end
					end
					if iCD.BuffsI[spellID].customText then
						data.customText = iCD.BuffsI[spellID].customText
					end
					tempI[spellID] = data
				end
				if iCD.BuffsC[spellID] then
					local data = {
						endTime = expirationTime,
						texture = iCD.BuffsC[spellID].icon or icon,
					}
					if iCD.BuffsC[spellID].stack then
						if iCD.BuffsC[spellID].stackFunc then
							data.stackFunc = iCD.BuffsC[spellID].stackFunc
						elseif type(iCD.BuffsC[spellID].stack) == 'string' then
							data.stack = iCD.BuffsC[spellID].stack
						else
							data.stack = count
						end
					end
					if iCD.BuffsC[spellID].customText then
						data.customText = iCD.BuffsC[spellID].customText
					end
					tempC[spellID] = data
				end
			end
		end
	end
	if iCD.hasPetAuras then
		for i = 1, 129 do -- Pet Buffs
			local t = {UnitBuff('pet', i)}
			if not t[1] then
				break
			else
				local name, icon, count, duration, expirationTime, sourceUnit, spellID, castByPlayer = t[1], t[2], t[3], t[5], t[6], t[7], t[10], t[13]
				_auras.petBuffs[i] = t
				if iCD.PetBuffs[spellID] then
					local data = {
						endTime = expirationTime,
						texture = icon,
					}
					if iCD.PetBuffs[spellID].stack then
						if iCD.PetBuffs[spellID].stackFunc then
							data.stackFunc = iCD.PetBuffs[spellID].stackFunc
						elseif type(iCD.PetBuffs[spellID].stack) == 'string' then
							if iCD.buffs[spellID].stack == 'caster' then
								data.stack = UnitName(sourceUnit)
							else
								data.stack = iCD.PetBuffs[spellID].stack
							end
						else
							data.stack = count
						end
					end
					if iCD.PetBuffs[spellID].customText then
						data.customText = iCD.PetBuffs[spellID].customText
					end
					temp[spellID] = data
				end
				if iCD.PetBuffsI[spellID] then
					local data = {
						endTime = expirationTime,
						texture = icon,
					}
					if iCD.PetBuffsI[spellID].stack then
						if iCD.PetBuffsI[spellID].stackFunc then
							data.stackFunc = iCD.PetBuffsI[spellID].stackFunc
						elseif type(iCD.PetBuffsI[spellID].stack) == 'string' then
							data.stack = iCD.PetBuffsI[spellID].stack
						else
							data.stack = count
						end
					end
					if iCD.PetBuffsI[spellID].customText then
						data.customText = iCD.PetBuffsI[spellID].customText
					end
					tempI[spellID] = data
				end
				if iCD.PetBuffsC[spellID] then
					local data = {
						endTime = expirationTime,
						texture = icon,
					}
					if iCD.PetBuffsC[spellID].stack then
						if iCD.PetBuffsC[spellID].stackFunc then
							data.stackFunc = iCD.PetBuffsC[spellID].stackFunc
						elseif type(iCD.PetBuffsC[spellID].stack) == 'string' then
							data.stack = iCD.PetBuffsC[spellID].stack
						else
							data.stack = count
						end
					end
					if iCD.PetBuffsC[spellID].customText then
						data.customText = iCD.PetBuffsC[spellID].customText
					end
					tempC[spellID] = data
				end
			end
		end
	end
	if iCD.hasTargetDebuffs then
		for i = 1, 129 do -- Debuffs
			--local name, icon, count, debuffType, duration, expirationTime, sourceUnit, _, _, spellID = UnitDebuff('target', i)
			local t = {UnitDebuff('target', i)}
			if not t[1] then
				break
			else
				local name, icon, count, duration, expirationTime, source, spellID = t[1], t[2], t[3], t[5], t[6], t[7], t[10]
				_auras.targetDebuffs[i] = t
				if source and source == 'player' then
					if iCD.debuffs[spellID] then
						local data = {
							endTime = expirationTime,
							texture = icon,
						}
						if iCD.debuffs[spellID].stack then
							if type(iCD.debuffs[spellID].stack) == 'string' then
								data.stack = iCD.debuffs[spellID].stack
							else
								data.stack = count
							end
						end
						if iCD.debuffs[spellID].customText then
							data.customText = iCD.debuffs[spellID].customText
						end
						temp[spellID] = data

					end
					if iCD.DebuffsI[spellID] then
						local data = {
							endTime = expirationTime,
							texture = icon,
						}
						if iCD.DebuffsI[spellID].stack then
							if type(iCD.DebuffsI[spellID].stack) == 'string' then
								data.stack = iCD.DebuffsI[spellID].stack
							else
								data.stack = count
							end
						end
						if iCD.DebuffsI[spellID].customText then
							data.customText = iCD.DebuffsI[spellID].customText
						end
						tempI[spellID] = data
					end
					if iCD.DebuffsC[spellID] then
						local data = {
							endTime = expirationTime,
							texture = icon,
						}
						if iCD.DebuffsC[spellID].stack then
							if type(iCD.DebuffsC[spellID].stack) == 'string' then
								data.stack = iCD.DebuffsC[spellID].stack
							else
								data.stack = count
							end
						end
						if iCD.DebuffsC[spellID].customText then
							data.customText = iCD.DebuffsC[spellID].customText
						end
						tempC[spellID] = data
					end
				end
			end
		end
	end
	local id = 1
	for k,v in spairs(temp, function(t,a,b) return t[b].endTime > t[a].endTime end) do
		iCD:CreateNewFrame(id, 'row5')
		iCD.frames.row5[id].data = {}
		iCD.frames.row5[id].data.usedBy = k
		iCD.frames.row5[id].data.endTime = v.endTime
		iCD.frames.row5[id].data.spellName = GetSpellInfo(k)
		if v.stackFunc then
			iCD.frames.row5[id].data.stackFunc = v.stackFunc
		elseif v.stack then
			iCD.frames.row5[id].stackText:SetText(v.stack)
		else
			iCD.frames.row5[id].stackText:SetText('')
		end
		if v.customText then
			iCD.frames.row5[id].data.customText = v.customText
		end
		iCD.frames.row5[id].tex:SetTexture(v.icon or GetSpellTexture(k))
		iCD.frames.row5[id].tex:SetVertexColor(1,1,1,1)
		iCD.frames.row5[id].data.unMod = 'none'
		iCD.frames.row5[id]:Show()
		id = id + 1
	end
	iCD.row5:SetHeight((id-1)*(iCD.setups.row5.size+1)-1)
	for i = id, #iCD.frames.row5 do
		iCD.frames.row5[i].data = {}
		iCD.frames.row5[i]:Hide()
	end
	id = 1
	for k,v in spairs(tempI, function(t,a,b) return t[b].endTime > t[a].endTime end) do
		iCD:CreateNewFrame(id, 'buffsI')
		iCD.frames.buffsI[id].data = {}
		iCD.frames.buffsI[id].data.usedBy = k
		iCD.frames.buffsI[id].data.endTime = v.endTime
		iCD.frames.buffsI[id].data.spellName = GetSpellInfo(k)
		if v.stackFunc then
			iCD.frames.buffsI[id].data.stackFunc = v.stackFunc
		elseif v.stack then
			iCD.frames.buffsI[id].stackText:SetText(v.stack)
		else
			iCD.frames.buffsI[id].stackText:SetText('')
		end
		if v.customText then
			iCD.frames.buffsI[id].data.customText = v.customText
		end
		iCD.frames.buffsI[id].tex:SetTexture(v.texture or GetSpellTexture(k))
		iCD.frames.buffsI[id].tex:SetVertexColor(1,1,1,1)
		iCD.frames.buffsI[id].data.unMod = 'none'
		iCD.frames.buffsI[id]:Show()
		id = id + 1
	end
	iCD.buffsI:SetWidth((id-1)*(iCD.setups.buffsI.size+1)-1)
	for i = id, #iCD.frames.buffsI do
		iCD.frames.buffsI[i].data = {}
		iCD.frames.buffsI[i]:Hide()
	end

	id = 1
	for k,v in spairs(tempC, function(t,a,b) return t[b].endTime > t[a].endTime end) do
		iCD:CreateNewFrame(id, 'buffsC')
		iCD.frames.buffsC[id].data = {}
		iCD.frames.buffsC[id].data.usedBy = k
		iCD.frames.buffsC[id].data.endTime = v.endTime
		iCD.frames.buffsC[id].data.spellName = GetSpellInfo(k)
		if v.stackFunc then
			iCD.frames.buffsC[id].data.stackFunc = v.stackFunc
		elseif v.stack then
			iCD.frames.buffsC[id].stackText:SetText(v.stack)
		else
			iCD.frames.buffsC[id].stackText:SetText('')
		end
		if v.customText then
			iCD.frames.buffsC[id].data.customText = v.customText
		end
		iCD.frames.buffsC[id].tex:SetTexture(v.texture or GetSpellTexture(k))
		iCD.frames.buffsC[id].tex:SetVertexColor(1,1,1,1)
		iCD.frames.buffsC[id].data.unMod = 'none'
		iCD.frames.buffsC[id]:Show()
		id = id + 1
	end
	iCD.buffsC:SetWidth((id-1)*(iCD.setups.buffsC.size+1)-1)
	for i = id, #iCD.frames.buffsC do
		iCD.frames.buffsC[i].data = {}
		iCD.frames.buffsC[i]:Hide()
	end
	temp, tempI, tempC = nil,nil,nil
end
function iCD:updateBuffList()
	if not iCD.class or not iCD.specID then
		return
	end
	iCD.hasPetAuras = false
	iCD.hasTargetDebuffs = false
	iCD.hasPlayerBuffs = false
	local function addIfEligible(spellID,v,b,d,p)
		if v.showFunc then
			if not v.showFunc() then return end
		end
		if v.itemReq then
			if type(v.itemReq) == 'table' then
				for k,_ in pairs(v.itemReq) do
					if not IsEquippedItem(k) then return end
				end
			else
				if not IsEquippedItem(v.itemReq) then return end
			end
		end
		if v.azerite then
			if not currentAzeritePowers[v.azerite] then return end
		end
		if v.covenant and v.covenant ~= currentCovenant then return end
		if v.debuff then
			d[spellID] = v
			iCD.hasTargetDebuffs = true
		elseif v.pet then
			p[spellID] = v
			iCD.hasPetAuras = true
		else
			iCD.hasPlayerBuffs = true
			b[spellID] = v
		end
	end
	local tempBuffs = {}
	local tempDebuffs = {}
	local tempPetBuffs = {}

	for k,v in pairs(iCD.spellData.spec.row5) do
		addIfEligible(k,v, tempBuffs, tempDebuffs, tempPetBuffs)
	end
	for k,v in pairs(iCD.spellData.all.row5) do
		addIfEligible(k,v, tempBuffs, tempDebuffs, tempPetBuffs)
	end
	for k,v in pairs(iCD.general.row5) do
		addIfEligible(k,v, tempBuffs, tempDebuffs, tempPetBuffs)
	end
	iCD.buffs = tempBuffs
	iCD.debuffs = tempDebuffs
	iCD.PetBuffs = tempPetBuffs
	-- buffsI
	local tempDebuffsI = {}
	local tempBuffsI = {}
	local tempPetBuffsI = {}
	for k,v in pairs(iCD.spellData.spec.buffsI) do
		addIfEligible(k,v, tempBuffsI, tempDebuffsI, tempPetBuffsI)
	end
	for k,v in pairs(iCD.spellData.all.buffsI) do
		addIfEligible(k,v, tempBuffsI, tempDebuffsI, tempPetBuffsI)
	end
	for k,v in pairs(iCD.general.buffsI) do
		addIfEligible(k,v, tempBuffsI, tempDebuffsI, tempPetBuffsI)
	end
	iCD.BuffsI = tempBuffsI
	iCD.DebuffsI = tempDebuffsI
	iCD.PetBuffsI = tempPetBuffsI

	local tempDebuffsC = {}
	local tempBuffsC = {}
	local tempPetBuffsC = {}

	for k,v in pairs(iCD.spellData.spec.buffsC) do
		addIfEligible(k,v, tempBuffsC, tempDebuffsC, tempPetBuffsC)
	end
	for k,v in pairs(iCD.spellData.all.buffsC) do
		addIfEligible(k,v, tempBuffsC, tempDebuffsC, tempPetBuffsC)
	end
	for k,v in pairs(iCD.general.buffsC) do
		addIfEligible(k,v, tempBuffsC, tempDebuffsC, tempPetBuffsC)
	end
	iCD.BuffsC = tempBuffsC
	iCD.DebuffsC = tempDebuffsC
	iCD.PetBuffsC = tempPetBuffsC

	iCD:updateBuffs()
end
function iCD:UpdateSkills()
	iCD:resetGlows()
	iCD.soulbinds = {}
	local soulbindID = C_Soulbinds.GetActiveSoulbindID()
	do
		if soulbindID and soulbindID ~= 0 then
			local s = C_Soulbinds.GetSoulbindData(soulbindID)
			for _,d in pairs(s.tree.nodes) do
				if d.state == 3 then -- selected
					if d.conduitID ~= 0 then
						iCD.soulbinds[d.conduitID] = true
					else
						iCD.soulbinds[d.ID] = true
					end
				end
			end
		end
	end
	iCD.general = iCD:GetGenerals(iCD.specID)
	local temp = {row1 = {}, row2 = {}, row3 = {}}
	local function add(k,v, row)
		if v.level and v.level > iCD.level then return end
		if v.covenant and v.covenant ~= currentCovenant then return end
		if not v.showFunc or (v.showFunc and v.showFunc()) then
			temp[row][k] = v
		end
	end
	if not iCD.class or not iCD.specID then
		return
	end
	iCD.currentEssences = {major = {0,0}, minor = {}}
	-- essences
	if (C_AzeriteEssence.CanOpenUI()) then
		for k,v in pairs (C_AzeriteEssence.GetMilestones() or {}) do
			if v.slot == 0 then -- Mains Slot
				local id = C_AzeriteEssence.GetMilestoneEssence(v.ID)
				if id then
					local e = C_AzeriteEssence.GetEssenceInfo(id)
					iCD.currentEssences.major = {id, e.rank}
					iCD.currentEssences.minor[id] = e.rank
				end
			elseif v.slot then -- minor
				local id = C_AzeriteEssence.GetMilestoneEssence(v.ID)
				if id then
					local e = C_AzeriteEssence.GetEssenceInfo(id)
					iCD.currentEssences.minor[id] = e.rank
				end
			end
		end
	end

	--iCD.gcd = iCD[iCD.class][iCD.specID].gcd
	iCD.gcd = 61304
	for row,t in pairs(iCD.spellData.spec) do
		if row == 'row1' or row == 'row2' or row == 'row3' then
			for k,v in pairs(t) do
				add(k,v,row)
			end
		end
	end
	for row,t in pairs(iCD.spellData.all) do
		if row == 'row1' or row == 'row2' or row == 'row3' then
			for k,v in pairs(t) do
				add(k,v,row)
			end
		end
	end
	--TESTING
	for row,t in pairs(iCD.general) do
		if row == 'row1' or row == 'row2' or row == 'row3' then
			for k,v in pairs(t) do
				add(k,v,row)
			end
		end
	end
	iCD.spells = temp
	for row, v in pairs(temp) do
		local id = 1
		for k,v in spairs(v, function(t,a,b) return t[b].order > t[a].order end) do
			iCD:CreateNewFrame(id, row)
			iCD.frames[row][id].data = {}
			iCD.frames[row][id].data.usedBy = k
			iCD.frames[row][id].data.spellName = GetSpellInfo(k > 0 and k or -k)
			if v.stackFunc then
				iCD.frames[row][id].data.stackFunc = v.stackFunc
			elseif v.stack then
				iCD.frames[row][id].data.stack = true
			end
			if v.customText then
				iCD.frames[row][id].data.customText = v.customText
			end
			if v.AM then
				iCD.frames[row][id].data.AM = v.AM
			end
			if v.range then
				if v.customRange then
					iCD.frames[row][id].data.customRange = v.customRange
				else
					iCD.frames[row][id].data.range = true
				end
				if v.customRangeSpell then
					iCD.frames[row][id].data.customRangeSpell = v.customRangeSpell
				end
			end
			if v.cost then
				if v.customCost then
					iCD.frames[row][id].data.customCost = v.customCost
				else
					iCD.frames[row][id].data.cost = true
				end
			end
			if v.icon then
				iCD.frames[row][id].data.icon = v.icon -- testing
			end
			if v.ignoreGCD then
				iCD.frames[row][id].data.ignoreGCD = true
			end
			if v.charges then
				iCD.frames[row][id].data.charges = true
			end
			if v.showTimeAfterGCD then
				iCD.frames[row][id].data.showTimeAfterGCD = true
			end
			if v.showTimeAfterCast then
				iCD.frames[row][id].data.showTimeAfterCast = true
			end
			if v.allowOverride then
				iCD.frames[row][id].data.allowOverride = true
			end
			if v.glow then
				local glow = v.glow
				if type(v.glow) == 'boolean' then
					glow = k
				end
				if not iCD.glowEffects[glow] then
					iCD.glowEffects[glow] = {{['row'] = row, ['id'] = id}}
				else
					table.insert(iCD.glowEffects[glow], {['row'] = row, ['id'] = id})
				end
			end
			if v.glowSound then
				local glowSoundSpellID = k
				if type(v.glow) == 'number' then
					glowSoundSpellID = v.glow
				end
				if type(v.glowSound) == 'boolean' then
					iCD.glowSoundEffects[glowSoundSpellID] = sounds.default
				else
					if sounds[v.glowSound] then
						iCD.glowSoundEffects[glowSoundSpellID] = sounds[v.glowSound]
					else
						iCD.glowSoundEffects[glowSoundSpellID] = v.glowSound
					end
				end
			end
			--if v.customColor then
			--	iCD.frames[row][id].data.customColor = v.customColor
			--end
			iCD.frames[row][id].tex:SetTexture(v.icon or GetSpellTexture(k))
			iCD.frames[row][id].tex:SetVertexColor(1,1,1,1)
			iCD.frames[row][id].data.unMod = 'none'
			--Re center
			iCD[row]:SetWidth(id*21-1)
			iCD.frames[row][id]:Show()
			id = id + 1
		end
		for i = id, #iCD.frames[row] do
			iCD.frames[row][i].data = {}
			iCD.frames[row][i]:Hide()
		end
	end
end
function iCD:updateEH()
	local hp = UnitHealth('player')
	local mhp = UnitHealthMax('player')
	local a = UnitGetTotalAbsorbs('player')
	local ha = UnitGetTotalHealAbsorbs('player')
	local r = 1-hp/mhp
	local g = hp/mhp
	if ha > 0 then
		iCD.EHtext:SetFormattedText('-%.0f\n\124cff%02x%02x%02x%.0f\124r\n%.0f', ha/1000,math.ceil(r * 255), math.ceil(g* 255), 0, (hp/mhp)*100, (hp+a)/1000)
	else
		iCD.EHtext:SetFormattedText('\124cff%02x%02x%02x%.0f\124r\n%.0f', math.ceil(r * 255), math.ceil(g* 255), 0, (hp/mhp)*100, (hp+a)/1000)
	end
end
function iCD:updateCombatLogStuff()
end
function iCD:addToRow4(spellID, isItem, dura, stackFunc)
	if stackFunc then
		iCD.extras[spellID] = {
			item = isItem or nil,
			customDuration = dura + GetTime(),
			stack = stackFunc and true or false,
			stackFunc = stackFunc and stackFunc or nil,
		}
	else
		iCD.extras[spellID] = {
			item = isItem or nil,
			customDuration = dura + GetTime(),
			stack = true,
			stackFunc = stackFunc,
		}
	end
end

local function iCD_onUpdate()
	--Out of range checking
	iCD:checkRange()
	-- durations
	local gS, gcdD = getGeneralCooldown()
	local gCD = gS+gcdD-GetTime()
	local gcdInfo = {
		left = gCD > 0 and gCD or 0,
		duration = gcdD,
		start = gS,
	}
	for k,v in pairs(iCD.frames.row1) do
		if v.data.usedBy then
			iCD:updateFrame(k, 'row1', v, gcdInfo)
		end
	end
	for k,v in pairs(iCD.frames.row2) do
		if v.data.usedBy then
			iCD:updateFrame(k, 'row2', v, gcdInfo)
		end
	end
	for k,v in pairs(iCD.frames.row3) do
		if v.data.usedBy then
			iCD:updateFrame(k, 'row3', v, gcdInfo)
		end
	end
	for k,v in pairs(iCD.frames.row4) do
		if v.data.usedBy then
			iCD:updateFrame(k, 'row4', v, gcdInfo)
		end
	end
	for k,v in pairs(iCD.frames.row5) do
		if v.data.usedBy then
			iCD:updateFrame(k, 'row5', v, gcdInfo)
		end
	end
	for k,v in pairs(iCD.frames.buffsI) do
		if v.data.usedBy then
			iCD:updateFrame(k, 'buffsI', v, gcdInfo)
		end
	end
	for k,v in pairs(iCD.frames.buffsC) do
		if v.data.usedBy then
			iCD:updateFrame(k, 'buffsC', v, gcdInfo)
		end
	end
	if iCD.gcd then -- 8.2.5 loading screen fix
		iCD.GCD:SetValue(gCD/gcdD)
	end
	gcdInfo = nil
end
addon:RegisterEvent('PLAYER_LOGIN')
addon:RegisterUnitEvent('PLAYER_SPECIALIZATION_CHANGED', 'player')
addon:RegisterEvent('SPELL_ACTIVATION_OVERLAY_GLOW_SHOW')
addon:RegisterEvent('SPELL_ACTIVATION_OVERLAY_GLOW_HIDE')
addon:RegisterEvent('SPELL_UPDATE_COOLDOWN')
addon:RegisterEvent('COMBAT_LOG_EVENT_UNFILTERED')
addon:RegisterEvent('PLAYER_EQUIPMENT_CHANGED')
addon:RegisterEvent('PLAYER_LEVEL_CHANGED')
addon:RegisterEvent('PLAYER_LEVEL_UP')
addon:RegisterEvent('UNIT_AURA')
addon:RegisterEvent('PLAYER_TARGET_CHANGED')
--addon:RegisterEvent('AZERITE_EMPOWERED_ITEM_SELECTION_UPDATED')
--addon:RegisterEvent('AZERITE_ESSENCE_CHANGED')
--addon:RegisterEvent('AZERITE_ESSENCE_UPDATE')
addon:RegisterEvent('SOULBIND_ACTIVATED')
addon:RegisterEvent('SOULBIND_PATH_CHANGED')
addon:RegisterEvent('COVENANT_CHOSEN')
addon:RegisterUnitEvent('UNIT_HEALTH', 'player')
addon:RegisterUnitEvent('UNIT_ABSORB_AMOUNT_CHANGED', 'player')
addon:RegisterUnitEvent('UNIT_HEAL_ABSORB_AMOUNT_CHANGED', 'player')
addon:RegisterUnitEvent('UNIT_SPELLCAST_SUCCEEDED', 'player')
addon:RegisterUnitEvent('UNIT_TARGET', 'player')

local function updateHealth()
	local hp = UnitHealth('player')
	local maxHP = UnitHealthMax('player')
	local value = 0
	if hp and maxHP then
		value = hp/maxHP
	end
	if value <= 0.5 then
		if not iCD.hpBar.anim then
			iCD.hpBar.flash:Play()
		end
	elseif iCD.hpBar.anim then
		iCD.hpBar.flash :Stop()
	end
	iCD.hpBar:SetValue(invertedHPBar and 1-value or value)
	local r = math.max(1-value+0.1, 0.1)
	iCD.hpBar:SetStatusBarColor(r,0.1,0.1,1)
	iCD.hpBar.bg:SetBackdropBorderColor(1-value,0,0,1)
	iCD:updateEH()
end
function addon:PLAYER_TARGET_CHANGED()
	iCD:checkRange(true)
end
function addon:UNIT_HEALTH()
	updateHealth()
end
function addon:UNIT_ABSORB_AMOUNT_CHANGED()
	iCD:updateEH()
	addon:UNIT_AURA('player')
end
function addon:UNIT_TARGET()
	addon:UNIT_AURA('target')
end
function addon:UNIT_HEAL_ABSORB_AMOUNT_CHANGED()
	iCD:updateEH()
end
function addon:UNIT_POWER()
	iCD.powerText:SetText(iCD.powerFunc())
end
function addon:UNIT_POWER_FREQUENT()
	iCD.powerText:SetText(iCD.powerFunc())
end
function addon:PLAYER_LEVEL_UP()
	iCD.level = UnitLevel('player')
	iCD:UpdateSkills()
end
function addon:PLAYER_LOGIN()
	iCD.class = select(2,UnitClass('player'))
	iCD.player = UnitGUID('player')
	iCD.specID = GetSpecializationInfo(GetSpecialization())
	iCD.spellData = iCD[iCD.class](nil, iCD.specID)
	iCD.level = UnitLevel('player')
	currentCovenant = C_Covenants.GetActiveCovenantID()
	UpdateAzeritePowers()
	--ICDTEST = iCD.spellData
	iCD:UpdateSkills()
	iCD:updateBuffList()
	iCD:updateOnCD()
	iCD:updateCombatLogStuff()
	updateHealth()
	if iCD.specID == 581 then
		iCD.textTimers = {}
	end
	if iCD.class == 'DRUID' then
		addon:RegisterEvent('UPDATE_SHAPESHIFT_FORM')
	end
	if iCD.spellData.spec.power then
		if iCD.spellData.spec.power.pos then
			iCD.powerText:SetPoint('BOTTOMRIGHT', UIParent, 'CENTER', iCD.spellData.spec.power.pos.x, iCD.spellData.spec.power.pos.y)
		else
			iCD.powerText:SetPoint(iCD.setups.power.position.from, UIParent, iCD.setups.power.position.to, iCD.setups.power.position.x, iCD.setups.power.position.y)
		end
		if iCD.spellData.spec.power.fontSize then
			iCD.powerText:SetFont(iCD.font, iCD.spellData.spec.power.fontSize, 'OUTLINE')
		end
		iCD.powerFunc = iCD.spellData.spec.power.func
		--addon:RegisterUnitEvent('UNIT_POWER', 'player')
		addon:RegisterUnitEvent('UNIT_POWER_FREQUENT', 'player')
		iCD.powerText:SetText(iCD.powerFunc())
	else
		--addon:UnregisterEvent('UNIT_POWER')
		addon:UnregisterEvent('UNIT_POWER_FREQUENT')
		iCD.powerText:SetText('')
		iCD.powerFunc = nil
	end
	local changed = {}
	if iCD.spellData.spec.customPos then
		for k,v in pairs(iCD.spellData.spec.customPos) do
				iCD[k]:ClearAllPoints()
				iCD[k]:SetPoint(v.from, iCD.hpBar, v.to,v.x,v.y)
				iCD.positions[k].changed = true
				changed[k] = true
		end
	end
	for k,v in pairs(iCD.positions) do
		if v.changed and not changed[k] then
			v.default(iCD[k])
			v.changed = false
		end
	end
end
function addon:PLAYER_SPECIALIZATION_CHANGED(unitID)
	if unitID ~= "player" then return end
	iCD.class = select(2,UnitClass('player'))
	iCD.specID = GetSpecializationInfo(GetSpecialization())
	iCD.spellData = iCD[iCD.class](nil, iCD.specID)
	iCD:UpdateSkills()
	iCD:updateBuffList()
	iCD:updateCombatLogStuff()
	iCD:updateOnCD()
	if iCD.spellData.spec.power then
		if iCD.spellData.spec.power.pos then
			iCD.powerText:SetPoint('BOTTOMRIGHT', UIParent, 'CENTER', iCD.spellData.spec.power.pos.x, iCD.spellData.spec.power.pos.y)
		else
			iCD.powerText:SetPoint(iCD.setups.power.position.from, UIParent, iCD.setups.power.position.to, iCD.setups.power.position.x, iCD.setups.power.position.y)
		end
		if iCD.spellData.spec.power.fontSize then
			iCD.powerText:SetFont(iCD.font, iCD.spellData.spec.power.fontSize, 'OUTLINE')
		else
			iCD.powerText:SetFont(iCD.font, iCD.setups.power.fontSize, 'OUTLINE')
		end
		iCD.powerFunc = iCD.spellData.spec.power.func
		--addon:RegisterUnitEvent('UNIT_POWER', 'player')
		addon:RegisterUnitEvent('UNIT_POWER_FREQUENT', 'player')
		iCD.powerText:SetText(iCD.powerFunc())
	else
		--addon:UnregisterEvent('UNIT_POWER')
		addon:UnregisterEvent('UNIT_POWER_FREQUENT')
		iCD.powerText:SetText('')
		iCD.powerFunc = nil
	end
	--[[
	t.customPos = {
		buffsI = {
			from = "CENTER",
			to = "CENTER",
			x = 0,
			y = 0,
			horizontal = true,
		},
	}
	]]
	local changed = {}
	if iCD.spellData.spec.customPos then
		for k,v in pairs(iCD.spellData.spec.customPos) do
				iCD[k]:ClearAllPoints()
				iCD[k]:SetPoint(v.from, iCD.hpBar, v.to,v.x,v.y)
				iCD.positions[k].changed = true
				changed[k] = true
		end
	end
	for k,v in pairs(iCD.positions) do
		if v.changed and not changed[k] then
			v.default(iCD[k])
			v.changed = false
		end
	end
	if iCD.specID == 581 then
		iCD.textTimers = {}
	else
		iCD.textTimers = nil
	end
end
function addon:SPELL_ACTIVATION_OVERLAY_GLOW_SHOW(spellID)
	if iCD.glowEffects[spellID] then
		for i = 1, #iCD.glowEffects[spellID] do
			if not iCD.frames[iCD.glowEffects[spellID][i].row][iCD.glowEffects[spellID][i].id].anim then
				iCD.frames[iCD.glowEffects[spellID][i].row][iCD.glowEffects[spellID][i].id]:SetAlpha(1)
				iCD.frames[iCD.glowEffects[spellID][i].row][iCD.glowEffects[spellID][i].id].flash:Play()
			end
		end
	end
	if iCD.glowSoundEffects[spellID] then
		PlaySoundFile(iCD.glowSoundEffects[spellID], 'master')
	end
end
function addon:SPELL_ACTIVATION_OVERLAY_GLOW_HIDE(spellID)
	if iCD.glowEffects[spellID] then
		for i = 1, #iCD.glowEffects[spellID] do
			if iCD.frames[iCD.glowEffects[spellID][i].row][iCD.glowEffects[spellID][i].id].anim then
				iCD.frames[iCD.glowEffects[spellID][i].row][iCD.glowEffects[spellID][i].id].flash:Stop()
				iCD.frames[iCD.glowEffects[spellID][i].row][iCD.glowEffects[spellID][i].id]:SetAlpha(1)
			end
		end
	end
end
function addon:UNIT_SPELLCAST_SUCCEEDED(unitID, spellName,_,arg4,spellID)
	if spellID == 126389 then -- Goblin Glider
		iCD:addToRow4(spellID, false, 180)
	elseif spellID == 55004 then -- Nitro Boost
		iCD:addToRow4(spellID, false, 120)
	elseif spellID == 67890 then -- Frag belt
		iCD:addToRow4(spellID, false, 60)
	end
end
function addon:COMBAT_LOG_EVENT_UNFILTERED()
	local timestamp,event,hideCaster,sourceGUID,sourceName,sourceFlags,sourceRaidFlags,destGUID,destName,destFlags,destRaidFlags,spellID, spellName,spellSchool, auraType, stacks = CombatLogGetCurrentEventInfo()
	if sourceGUID and sourceGUID == iCD.player then
		--if event == 'SPELL_CAST_SUCCESS' then
		--	if spellID and spellID == 204255 then
		--		table.insert(iCD.textTimers, GetTime()+1.05)
		--	end
		--end
		if event == 'SPELL_AURA_APPLIED' then
			if spellID == 208052 then -- Sephuz, Prydaz
				iCD:addToRow4(spellID, false, 30)
			elseif spellID == 303041 then -- Edicts of the Faithless (Physical)
				iCD:addToRow4(spellID, false, 40, function() local v = select(5, iCD.UnitBuff('player', "Edict of the Myrmidon", nil, 'player')) if v then return v/1e3, 'P%.0f' else return '' end end)
			elseif spellID == 303044 then -- Edicts of the Faithless (Magic)
				iCD:addToRow4(spellID, false, 40, function() local v = select(5, iCD.UnitBuff('player', "Edict of the Sea Witch", nil, 'player')) if v then return v/1e3, 'M%.0f' else return '' end end)
			elseif spellID == 207472 then
				iCD:addToRow4(spellID, false, 30, function() local v = select(5, iCD.UnitBuff('player', "Xavaric's Magnum Opus", nil, 'player')) if v then return v/1e3, '%.1f' else return '' end end)
			end
		elseif event == 'SPELL_AURA_REFRESH' then
			if spellID == 207472 then -- Prydaz
				iCD:addToRow4(spellID, false, 30, function() local v = select(5, iCD.UnitBuff('player', "Xavaric's Magnum Opus", nil, 'player')) if v then return v/1e3, '%.1f' else return '' end end)
			elseif spellID == 303041 then -- Edicts of the Faithless (Physical)
				iCD:addToRow4(spellID, false, 40, function() local v = select(5, iCD.UnitBuff('player', "Edict of the Myrmidon", nil, 'player')) if v then return v/1e3, 'P%.0f' else return '' end end)
			elseif spellID == 303044 then -- Edicts of the Faithless (Magic)
				iCD:addToRow4(spellID, false, 40, function() local v = select(5, iCD.UnitBuff('player', "Edict of the Sea Witch", nil, 'player')) if v then return v/1e3, 'M%.0f' else return '' end end)
			end
		elseif event == 'SPELL_CAST_SUCCESS' then
			if spellID == 214584 then
				iCD:addToRow4(spellID, false, 60)
			elseif spellID == 206931 then -- DK, Blooddrinker
				iCD.customSpellTimers[spellID] = GetTime() + 30
			elseif spellID == 43265 or spellID == 324128 then -- DK, DnD
				iCD.customSpellTimers[43265] = GetTime() + (iCD.specID == 250 and 15 or 30)
			elseif spellID == 55233 then -- Vampiric Blood
				iCD.customSpellTimers[spellID] = 0
			elseif spellID == 26573 then -- Paladin, Conce
				iCD.customSpellTimers[spellID] = GetTime() + 12
			elseif spellID == 202770 then -- Druid, Fury of Elune
				iCD.customSpellTimers[spellID] = GetTime() + 8
			elseif spellID == 316958 then -- Paladin, Ashen Hallow
				iCD.customSpellTimers[spellID] = GetTime() + 30
			elseif spellID == 311648 then -- DK, Swarming Mist
				iCD.customSpellTimers[spellID] = GetTime() + 60
			elseif spellID == 157153 then -- Shaman, Cloudburst Totem
				iCD.customSpellTimers[spellID] = GetTime() + 15
			end
		elseif event == 'SPELL_PERIODIC_DAMAGE' then
			if spellID == 55078 then
				iCD.customSpellTimers[55233] = iCD.customSpellTimers[55233] + auraType
			end
		end
	end
	-- BW NL test
end
function addon:SPELL_UPDATE_COOLDOWN()
	iCD:updateOnCD()
end
function addon:UNIT_AURA(unitID)
	if unitID == 'player' or unitID == 'target' or unitID == 'pet' then
		if iCD.powerFunc and unitID == 'player' then
			addon:UNIT_POWER()
		end
		iCD:updateBuffs()
		iCD:updateEH()
	end
end
function addon:PLAYER_EQUIPMENT_CHANGED()
	UpdateAzeritePowers()
	addon:PLAYER_SPECIALIZATION_CHANGED("player")
end
function addon:UPDATE_SHAPESHIFT_FORM()
	iCD:UpdateSkills()
end
function addon:AZERITE_EMPOWERED_ITEM_SELECTION_UPDATED(arg)
	UpdateAzeritePowers()
end
function addon:AZERITE_ESSENCE_CHANGED()
	addon:PLAYER_SPECIALIZATION_CHANGED("player")
end
function addon:AZERITE_ESSENCE_UPDATE()
	addon:PLAYER_SPECIALIZATION_CHANGED("player")
end
function addon:PLAYER_LEVEL_CHANGED()
	iCD.level = UnitLevel('player')
	addon:PLAYER_SPECIALIZATION_CHANGED("player")
end
function addon:PLAYER_LEVEL_UP()
	--iCD.level = UnitLevel('player')
	--addon:PLAYER_SPECIALIZATION_CHANGED("player")
end
function addon:SOULBIND_ACTIVATED()
	iCD:UpdateSkills()
end
function addon:SOULBIND_PATH_CHANGED()
	iCD:UpdateSkills()
end
function addon:COVENANT_CHOSEN(covenantID)
	currentCovenant = C_Covenants.GetActiveCovenantID()
	addon:PLAYER_SPECIALIZATION_CHANGED("player")
end
--------------------
---NAMEPLATE-RANGE--
--------------------
--[[
                IRONI_NAMEPLATE_TOT[unitID] = CreateFrame('frame',nil, UIParent)
                IRONI_NAMEPLATE_TOT[unitID]:SetSize(1,1)
                IRONI_NAMEPLATE_TOT[unitID]:SetFrameStrata('HIGH')
                IRONI_NAMEPLATE_TOT[unitID].text = IRONI_NAMEPLATE_TOT[unitID]:CreateFontString()
                IRONI_NAMEPLATE_TOT[unitID].text:SetFont(LibStub("LibSharedMedia-3.0"):Fetch("font", o.font), o.fontSize, o.outline)
                IRONI_NAMEPLATE_TOT[unitID].text:SetPoint(o.justify, IRONI_NAMEPLATE_TOT[unitID], o.justify, 0,0)
                IRONI_NAMEPLATE_TOT[unitID].text:SetJustifyH(o.justify)

	if IsSpellInRange(iCD.outOfRangeSpells.range, 'target') == 0 then
				if iCD.outOfRange.color == 2 then
					iCD.outOfRange:SetTextColor(1,0,0)
					iCD.outOfRange.color = 1
				end
			else
				if iCD.outOfRange.color == 1 then
					iCD.outOfRange:SetTextColor(1,.5,0)
					iCD.outOfRange.color = 2
				end
			end
			if IsSpellInRange(iCD.outOfRangeSpells.main, 'target') == 0 then
IRONI_NAMEPLATE_TOT[unitID].text:SetJustifyH(o.justify)
end
local nameplate = C_NamePlate.GetNamePlateForUnit(unitID)
if not nameplate then return end
IRONI_NAMEPLATE_TOT[unitID]:ClearAllPoints()
IRONI_NAMEPLATE_TOT[unitID]:SetPoint(o.anchorPoint, nameplate, o.selfPoint, (o.xOffset or 0),(o.yOffset or 0))
IRONI_NAMEPLATE_TOT[unitID]:Show()
IRONI_NAMEPLATE_TOT[unitID].shown = true
--]]
do
	addon:RegisterEvent("NAME_PLATE_UNIT_ADDED")
	addon:RegisterEvent("NAME_PLATE_UNIT_REMOVED")
	local f = CreateFrame("frame")
	local rangeItems = {
		hostile = {
			{r = 2, id = 37727}, -- Ruby Acorn
			{r = 3, id = 42732}, -- Everfrost Razor
			{r = 4, id = 129055}, -- Shoe Shine Kit
			{r = 5, id = 8149}, -- Voodoo Charm
			{r = 7, id = 61323}, -- Ruby Seeds
			{r = 8, id = 34368}, -- Attuned Crystal Cores
			{r = 10, id = 32321}, -- Sparrowhawk Net
			{r = 15, id = 33069}, -- Sturdy Rope
			{r = 20, id = 10645}, -- Gnomish Death Ray
			{r = 25, id = 24268}, -- Netherweave Net
			{r = 30, id = 835}, -- Large Rope Net
			{r = 35, id = 24269}, -- Heavy Netherweave Net
			{r = 38, id = 140786}, -- Ley Spider Eggs
			{r = 40, id = 28767}, -- The Decapitator
			{r = 45, id = 23836}, -- Goblin Rocket Launcher
			{r = 50, id = 116139}, -- Haunting Memento
			{r = 55, id = 74637}, -- Kiryn's Poison Vial
			{r = 60, id = 32825}, -- Soul Cannon
			{r = 70, id = 41265}, -- Eyesore Blaster
			{r = 80, id = 35278}, -- Reinforced Net
			{r = 90, id = 133925}, -- Fel Lash
			{r = 100, id = 33119}, -- Malister's Frost Wand
			{r = 150, id = 46954}, -- Flaming Spears
			{r = 200, id = 75208}, -- Rancher's Lariat
		},
		friendly = {
			{r = 2, id = 37727}, -- Ruby Acorn
			{r = 3, id = 42732}, -- Everfrost Razor
			{r = 4, id = 129055}, -- Shoe Shine Kit
			{r = 5, id = 8149}, -- Voodoo Charm
			{r = 7, id = 61323}, -- Ruby Seeds
			{r = 8, id = 34368}, -- Attuned Crystal Cores
			{r = 10, id = 32321}, -- Sparrowhawk Net
			{r = 15, id = 1251}, -- Linen Bandage
			{r = 20, id = 21519}, -- Mistletoe
			{r = 25, id = 31463}, -- Zezzak's Shard
			{r = 30, id = 34191}, -- Handful of Snowflakes
			{r = 35, id = 18904}, -- Zorbin's Ultra-Shrinker
			{r = 38, id = 140786}, -- Ley Spider Eggs
			{r = 40, id = 34471}, -- Vial of the Sunwell
			{r = 45, id = 32698}, -- Wrangling Rope
			{r = 50, id = 116139}, -- Haunting Memento
			{r = 55, id = 74637}, -- Kiryn's Poison Vial
			{r = 60, id = 32825}, -- Soul Cannon
			{r = 70, id = 34191}, -- Eyesore Blaster
			{r = 80, id = 35278}, -- Reinforced Net
			{r = 90, id = 133925}, -- Fel Lash
			{r = 100, id = 41058}, -- Hyldnir Harpoon
			{r = 150, id = 46954}, -- Flaming Spears
			{r = 200, id = 75208}, -- Rancher's Lariat
		},
	}
	local nps = {}
	local frames = {}
	local function getString(unitID)
		if frames[unitID] then return frames[unitID] end
		frames[unitID] = CreateFrame('frame',nil, UIParent)
		frames[unitID]:SetSize(1,1)
		frames[unitID]:SetFrameStrata('HIGH')
		frames[unitID].text = frames[unitID]:CreateFontString()
		frames[unitID].text:SetFont(iCD.font, 16, 'OUTLINE')
		frames[unitID].text:SetPoint("left", frames[unitID], "right", 0,0)
		frames[unitID].text:SetJustifyH("left")
		frames[unitID].text:SetText("")
		return frames[unitID]
	end
	local rangeColors = {
		{r = 1, g = 0, b = 0}, -- oor
		{r = 1, g = .5, b = 0}, -- utility
		{r = 1, g = 1, b = 1}, -- in main dps range
	}
	function iCD:GetRange(unitID)
		local rangeID = 1
		if IsSpellInRange(iCD.outOfRangeSpells.main, unitID) == 1 then  -- is in range for main dps skill
			rangeID = 3
		elseif IsSpellInRange(iCD.outOfRangeSpells.range, unitID) == 1 then -- in Utility range
			rangeID = 2
		end
		local range = 0
		local lastRange = 0
		if UnitIsFriend("player", unitID) then
			for _,v in ipairs(rangeItems.friendly) do
				if not IsItemInRange(v.id, unitID) then
					range = v.r
				else
					lastRange = v.r
					break
				end
			end
		else
			for _,v in ipairs(rangeItems.hostile) do
				if not IsItemInRange(v.id, unitID) then
					range = v.r
				else
					lastRange = v.r
					break
				end
			end
		end
		return rangeID, rangeColors[rangeID], range, lastRange
	end
	local function updateNameplate(unitID)
		if not nps[unitID] then print("error: no nameplate for", unitID) return end
		if not nps[unitID].icdString then
			nps[unitID].icdString = getString(unitID)
			nps[unitID].icdString:ClearAllPoints()
			nps[unitID].icdString:SetPoint("LEFT", nps[unitID], "RIGHT", -5,0)
		end
		nps[unitID].icdString:Show()
		local rangeID, rangeColor, range = iCD:GetRange(unitID)
		if nps[unitID].icdString.currentColor ~= rangeID then
			nps[unitID].icdString.text:SetTextColor(rangeColor.r, rangeColor.g, rangeColor.b)
			nps[unitID].icdString.currentColor = rangeID
		end
		if nps[unitID].icdString.currentRange ~= range then
			nps[unitID].icdString.currentRange = range
			if range == 0 then
				nps[unitID].icdString.text:SetText("")
			else
				nps[unitID].icdString.text:SetText(string.format("%d+", range))
			end
		end
	end
	local lastUpdate = 0
	local function npOnUpdate(f)
		local t = GetTime()
		if t < lastUpdate + .1 then return end
		lastUpdate = t
		for k,v in pairs(nps) do
			if v then updateNameplate(k) end
		end
	end

	function addon:NAME_PLATE_UNIT_ADDED(unitID)
		local np = C_NamePlate.GetNamePlateForUnit(unitID)
		if np then
			nps[unitID] = np
		end
	end
	function addon:NAME_PLATE_UNIT_REMOVED(unitID)
		if nps[unitID].icdString then
			nps[unitID].icdString:Hide()
		end
		nps[unitID] = false
	end
	f:SetScript("OnUpdate", npOnUpdate)
end

---------------------------
---END-OF-NAMEPLATE-RANGE--
---------------------------


function ICDTEST()
	return iCD.onCD
end
iCD.row1:SetScript('OnUpdate', iCD_onUpdate)

SLASH_ICD1 = "/icd"
SLASH_ICD2 = '/icooldowns'
SlashCmdList["ICD"] = function(msg)
	if msg then
		msg = string.lower(msg)
	end
	if msg == "force" or msg == "f" then
		UpdateAzeritePowers()
		addon:PLAYER_SPECIALIZATION_CHANGED("player")
		if IroniStreamIconsUpdate then IroniStreamIconsUpdate() else print("Error: Addon isn't enabled") end
		return
	elseif msg == "removed" then
		local general = iCD:GetGenerals(iCD.specID)
		for row,v in pairs(general) do
			for id, _ in pairs(v) do
				if id > 0 then
					if not C_Spell.DoesSpellExist(id) then
						print(string.format("Missing (General) - row: %s, %s", row, id))
					end
				elseif not C_Item.DoesItemExistByID(id*-1) then
					print(string.format("Missing (General) - row: %s, %s", row, id))
				end
			end
		end
		local class = iCD[iCD.class](nil, iCD.specID)
		for _type, _v in pairs(class) do
			for row, v in pairs(_v) do
				if row ~= "power" then
					for id, _ in pairs(v) do
						if not tonumber(id) then print(id) end
						if id > 0 then
							if not C_Spell.DoesSpellExist(id) then
								print(string.format("Missing (Class) - %s - row: %s, %s", _type, row, id))
							end
						elseif not C_Item.DoesItemExistByID(id*-1) then
							print(string.format("Missing (Class) - %s - row: %s, %s", _type, row, id))
						end
					end
				end
			end
		end
		return
	end
	for k in pairs(currentAzeritePowers) do
		local azeriteInfo = C_AzeriteEmpoweredItem.GetPowerInfo(k)
		local spellName = Spell:CreateFromSpellID(azeriteInfo.spellID):GetSpellName()
		print(spellName, k)
	end
	print("Essences:")
	for k,v in pairs (C_AzeriteEssence.GetMilestones()) do
		if v.slot then
			local id = C_AzeriteEssence.GetMilestoneEssence(v.ID)
			if id then
				local essence = C_AzeriteEssence.GetEssenceInfo(id)
				print(essence.name, id, "("..essence.rank..")")
			end
		end
	end
	local soulbindID = C_Soulbinds.GetActiveSoulbindID()
	print("Soulbinds/Conduits:")
	do
		if soulbindID and soulbindID ~= 0 then
			local s = C_Soulbinds.GetSoulbindData(soulbindID)
			for _,d in pairs(s.tree.nodes) do
				if d.state == 3 then -- selected
					if d.conduitID ~= 0 then
						local c = C_Soulbinds.GetConduitCollectionData(d.conduitID)
						local n = GetItemInfo(c.conduitItemID)
						print(n, d.conduitID)
					else
						local n = GetSpellInfo(d.spellID)
						print(n, d.ID)
					end
				end
			end
		end
	end
end
--[=[
function IANTORUS()
	local s = ''
	local types = {
		['Cloth'] = true,
		['Leather'] = true,
		['Mail'] = true,
		['Plate'] = true,
		['Neck'] = true,
		['Finger'] = true,
		['Back'] = true,
	}
	for i = 1, EJ_GetNumLoot() do
		local itemID, encounterID, name, icon,slot, itemType, itemLink = EJ_GetLootInfoByIndex(i)
		if slot:find('Relic') then
			slot = slot:match('%a+')
		end
		local eN = EJ_GetEncounterInfo(encounterID)
		s = s..itemType..'\t'..slot..'\t'..name..'\t'..itemID..'\t'..eN..'\t'
		if types[itemType] or types[slot] then
			local stats = GetItemStats(itemLink)
			local tempT = {}
			total = 0
			if stats['ITEM_MOD_MASTERY_RATING_SHORT'] then
				tempT['M'] = stats['ITEM_MOD_MASTERY_RATING_SHORT']
				total = total + stats['ITEM_MOD_MASTERY_RATING_SHORT']
			end
			if stats['ITEM_MOD_HASTE_RATING_SHORT'] then
				tempT['H'] = stats['ITEM_MOD_HASTE_RATING_SHORT']
				total = total + tempT['H']
			end
			if stats['ITEM_MOD_CRIT_RATING_SHORT'] then
				tempT['C'] = stats['ITEM_MOD_CRIT_RATING_SHORT']
				total = total + tempT['C']
			end
			if stats['ITEM_MOD_VERSATILITY'] then
				tempT['V'] = stats['ITEM_MOD_VERSATILITY']
				total = total + tempT['V']
			end
			local stat
			for k,v in spairs(tempT,function(t,a,b) return t[b] < t[a] end) do
				local p = v/total*100
				if not stat then
					stat = string.format('%s%.0f',k,p)
				else
					stat = stat ..'/'..string.format('%s%.0f',k,p)
				end
			end
			s = s..stat..'\r'z
		else
			s = s..'\r'
		end
	end
	iEETCopyFrame:SetText(s)
	iEETCopyFrame:Show()

end
--]=]
--/script local t = GetItemStats(select(7,EJ_GetLootInfoByIndex(60))); for k,v in pairs(t) do print(k,v) end
--/script local s = 'Fire Artifact Relic';if s:find('Relic') then local t=s:match('%a+') print(t) else print('f') end
--=JOIN(",",FILTER('['&D3:L25&']='&L3:L25, NOT(ISBLANK(L3:L25))))


