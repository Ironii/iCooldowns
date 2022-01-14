 --[[
order = 5,
row = 2,
ignoreGCD = true,
cost = true,
stack = true,
glow = true,
glowSound = true,
stackFunc = function() return GetSpellCount(228477) end,
showFunc = function()
	return select(4, GetTalentInfo(5, 1, 1))
end,
range = true,
customRange = function()
	if UnitExists('target') then
		return IsSpellInRange('Maul', 'target') == 1
	else
		return true
	end
end,
--]]
local _, iCD = ...
function iCD:WARRIOR(specID)
	local temp = {}
	temp.spec = {}
	temp.all = {}
	temp.all.row1 = {
		[307865] = { -- Spear of Bastion
			order = 999999, -- Always last
			showTimeAfterGCD = true,
			range = true,
			covenant = iCD.covenants.KYRIAN
		},
		[324143] = { -- Conqueror's Banner
			order = 9999, -- Always last
			covenant = iCD.covenants.NECROLORD,
			showTimeAfterGCD = true,
		},
		[325886] = { -- Ancient Aftershock
			order = 9999, -- Always last
			covenant = iCD.covenants.NIGHTFAE,
			showTimeAfterGCD = true,
		},
	}
	temp.all.row2 = {}
	temp.all.row3 = {}
	temp.all.row4 = {
		[1161] = { -- Challenging Shout
			ignoreGCD = true,
		},
		[64382] = {}, -- Shattering Throw
		[12323] = {}, -- Piercing Howl
		[5246] = {}, -- Intimidating Shout
		[6673] = {}, -- Battle Shout
		[100] = { -- Charge
			stack = true,
		},
		[6544] = { -- Heroic Leap
			stack = true,
		},
	}
	temp.all.row5 = {
		[23920] = {}, -- Spell Reflection
	}
	temp.all.buffsC = {

	}
	temp.all.buffsI = {
		[46924] = {}, -- Bladestorm
		[227847] = {}, -- Bladestorm (arms only?)
		[324143] = {}, -- Conqueror's Banner
		[107574] = {}, -- Avatar
		[1719] = {}, -- Recklessness (lege?)
		[324143] = {}, -- Conqueror's Banner
		[335234] = { -- Ashen Juggernaut (conduit)
			stack = true,
		},
	}
	local t = temp.spec
	t.row1 = {}
	t.row2 = {}
	t.row3 = {}
	t.row4 = {}
	t.row5 = {}
	t.buffsC = {}
	t.buffsI = {}
	if specID == 71 then--Arms
		iCD.outOfRangeSpells = {
			main = 'Mortal Strike',
			range = 'Heroic Throw',
		}
		t.power = {
			func = function()
				local power = UnitPower('player', 1)
				if power >= 85 then
					return iCD.colors.green .. power
				else
					return power
				end
			end,
		}
		t.row1 = {
			[281000] = { -- Execute
				order = 1,
				glow = true,
				range = true,
				glowSound = "text1",
				cost = true,
				customCost = function()
					local isUsable = IsUsableSpell("Execute")
					if not isUsable then
						return true
					end
				end,
				stack = true,
				stackFunc = function()
					local count, duration, expirationTime, value1, value2, value3 = iCD.UnitBuff('player', 'Sudden Death')
					if expirationTime then
						local dura = expirationTime - GetTime()
						if dura > 5 then
							return dura,'%.0f'
						else
							return dura, '|cffff1a1a%.1f'
						end
					else
						return ''
					end
				end,
				showTimeAfterGCD = true,
			},
			[167105] = { -- Colossus Smash
				order = 3,
				range = true,
				glow = true,
				glowSound = true,
				showTimeAfterGCD = true,
				stack = true,
				stackFunc = function()
					local count, duration, expirationTime, value1, value2, value3 = iCD.UnitDebuff('Colossus Smash')
					if expirationTime then
						local dura = expirationTime - GetTime()
						if dura > 5 then
							--return string.format('%.0f', dura)
							return dura, '%.0f'
						else
							return dura, '|cffff1a1a%.1f'
						end
					else
						return ''
					end
				end,
				showFunc = function()
					return not select(4, GetTalentInfo(5, 2, 1))
				end,
			},
			[262161] = { -- Warbreaker
				order = 3,
				range = true,
				glow = true,
				glowSound = true,
				showTimeAfterGCD = true,
				stack = true,
				stackFunc = function()
					local count, duration, expirationTime, value1, value2, value3 = iCD.UnitDebuff('Colossus Smash')
					if expirationTime then
						local dura = expirationTime - GetTime()
						if dura > 5 then
							--return string.format('%.0f', dura)
							return dura, '%.0f'
						else
							return dura, '|cffff1a1a%.1f'
						end
					else
						return ''
					end
				end,
				showFunc = function()
					return select(4, GetTalentInfo(5, 2, 1))
				end,
			},
			[12294] = { -- Mortal Strike
				order = 5,
				range = true,
				showTimeAfterGCD = true,
				cost = true,
				glow = true,
				glowSound = 'text2',
			},
			[7384] = { -- Overpower
				order = 6,
				range = true,
				showTimeAfterGCD = true,
				glow = true,
				glowSound = true,
				stack = true,
			},
			[260643] = { -- Skullsplitter
				order = 7,
				showTimeAfterGCD = true,
				range = true,
				showFunc = function()
					return select(4, GetTalentInfo(1, 3, 1))
				end,
			},
			[152277] = { -- Ravager
				order = 9,
				showTimeAfterGCD = true,
				showFunc = function()
					return select(4, GetTalentInfo(7, 3, 1))
				end,
			},
			[845] = { -- Cleave
				order = 8,
				range = true,
				showTimeAfterGCD = true,
				cost = true,
				showFunc = function()
					return select(4, GetTalentInfo(5, 3, 1))
				end,
			},
			[107570] = { -- Stormbolt
				order = 9,
				row = 1,
				range = true,
				showFunc = function()
					return select(4, GetTalentInfo(2, 3, 1))
				end,
				showTimeAfterGCD = true,
			},
			[202168] = { -- Impending Victory
				order = 50,
				showTimeAfterGCD = true,
				showFunc = function()
					return select(4, GetTalentInfo(2, 2, 1))
				end,
			},
		}
		t.row2 = {
			[227847] = { -- Bladestorm
				order = 3,
				showTimeAfterGCD = true,
			},
			[97462] = { -- Commanding Shout
				order = 12,
			},
			[3411] = { -- Intervene
				level = 43,
				order = 15,
				ignoreGCD = true,
			},
			[118038] = { -- Die by the Sword
				order = 11,
				ignoreGCD = true,
			},
			[23920] = { -- Spell Reflection
				order = 14,
				ignoreGCD = true,
			},
			[107574] = { -- Avatar
				order = 4,
				showFunc = function()
					return select(4, GetTalentInfo(6, 2, 1))
				end,
			},
			[260708] = { -- Sweeping Strikes
				order = 5,
			},
		}
		t.row3 = {
			[772] = { -- Rend
				order = 1,
				showFunc = function()
					return select(4, GetTalentInfo(3,3,1))
				end,
				cost = true,
				range = true,
				customText = function(data, gcdInfo)
					local count, duration, expirationTime, value1, value2, value3 = iCD.UnitDebuff('target', 'Rend', true)
					if expirationTime then
						local dura = expirationTime - GetTime()
						if dura > 5 then
							return dura-gcdInfo.left, '%.0f'
						else
							return dura-gcdInfo.left, '|cffff1a1a%.1f'
						end
					else
						return ''
					end
				end,
			},
			[262111] = { -- Deep Wounds
				order = 1,
				customText = function(data, gcdInfo)
					local count, duration, expirationTime, value1, value2, value3 = iCD.UnitDebuff('target', 'Deep Wounds', true)
					if expirationTime then
						local dura = expirationTime - GetTime()
						if dura > 5 then
							return dura-gcdInfo.left, '%.0f'
						else
							return dura-gcdInfo.left, '|cffff1a1a%.1f'
						end
					else
						return ''
					end
				end,
			},
		}
		t.row4 = {
			[18499] = {}, -- Berserker Rage
			[355] = {}, -- Taunt
			[190456] = {}, -- Ignore Pain
		}
		t.row5 = {
			[118038] = {}, -- Die by the Sword
		}
		t.buffsI = {
			[206333] = { -- Taste for Blood
				stack = true,
			},
			[208086] = { -- Colossus Smash
				debuff = true,
			},
			[184362] = {}, -- Enrage
			--[[
			[262115] = { -- Deep Wounds
				debuff = true,
			},
			[772] = { -- Rend
				debuff = true,
				showFunc = function()
					return select(4, GetTalentInfo(3, 3, 1))
				end,
			},
			--]]
			[260708] = {}, -- Sweeping Strikes
			[7384] = { -- Overpower
				stack = true,
			},
			[32216] = {}, -- Victory Rush
			[278826] = {}, -- Crushing Assault
			[346574] = {}, -- Merciless Bonegrinder
		}
		t.buffsC = {
			[18499] = {}, -- Berserker Rage
			[197690] = {}, -- Defensive Stance
		}
	elseif specID == 72 then --Fury
		iCD.outOfRangeSpells = {
			main = 'Bloodthirst',
			range = 'Heroic Throw',
		}
		t.power = {
			func = function()
				local power = UnitPower('player', 1)
				local isRampageUsable = select(2, IsUsableSpell('Rampage'))
				if not isRampageUsable then
					return iCD.colors.green .. power
				else
					return power
				end
			end,
		}
		t.row1 = {
			[280735] = { -- Execute
				order = 1,
				glow = true,
				range = true,
				glowSound = true,
				cost = true,
				customCost = function()
					local isUsable = IsUsableSpell("Execute")
					if not isUsable then
						return true
					end
				end,
				stack = true,
				stackFunc = function()
					local count, duration, expirationTime, value1, value2, value3 = iCD.UnitBuff('player', 'Sudden Death')
					if expirationTime then
						local dura = expirationTime - GetTime()
						if dura > 5 then
							return dura,'%.0f'
						else
							return dura, '|cffff1a1a%.1f'
						end
					else
						return ''
					end
				end,
				showTimeAfterGCD = true,
			},
			[184367] = { -- Rampage
				order = 2,
				glow = true,
				range = true,
				glowSound = 'text1',
				cost = true,
			},
			[23881] = { -- Bloodthirst
				order = 3,
				range = true,
				showTimeAfterGCD = true,
			},
			[85288] = { -- Raging Blow
				order = 4,
				range = true,
				stack = true,
				showTimeAfterGCD = true,
			},
			[280772] = { -- Siegebreaker
				order = 5,
				range = true,
				showFunc = function()
					return select(4, GetTalentInfo(7, 3, 1))
				end,
				showTimeAfterGCD = true,
			},
			[118000] = { -- Dragon Roar
				order = 6,
				range = true,
				showFunc = function()
					return select(4, GetTalentInfo(6, 2, 1))
				end,
				showTimeAfterGCD = true,
			},
			[46924] = { -- Bladestorm
				order = 6,
				showFunc = function()
					return select(4, GetTalentInfo(6, 3, 1))
				end,
				showTimeAfterGCD = true,
			},
			[107570] = { -- Stormbolt
				order = 8,
				range = true,
				showFunc = function()
					return select(4, GetTalentInfo(2, 3, 1))
				end,
				showTimeAfterGCD = true,
			},
		}
		t.row2 = {
			[1719] = { -- Recklessness
				order = 3,
			},
			[202168] = { -- Impending Victory
				order = 8,
				range = true,
				cost = true,
				showFunc = function()
					return select(4, GetTalentInfo(2, 2, 1))
				end,
				showTimeAfterGCD = true,
			},
			[97462] = { -- Commanding Shout
				order = 12,
			},
			[184364] = { -- Enraged Regeneration
				order = 11,
				ignoreGCD = true,
			},
			[23920] = { -- Spell Reflection
				order = 6,
				ignoreGCD = true,
			},
		}
		t.row3 = {
		}
		t.row4 = {
			[18499] = {}, -- Berserker Rage
			[355] = { -- Taunt
				ignoreGCD = true,
			},
			[57755] = {}, -- Heroic Throw
			[5246] = {}, -- Intimidating Shout
			[190456] = {}, -- Ignore Pain
			[3411] = {}, -- Intervene
		}
		t.row5 = {
			[184364] = {}, -- Enraged Regeneration
		}
		t.buffsI = {
			[85739] = { -- Whirlind
				stack = true,
			},
			[184362] = {}, -- Enrage
			[32216] = {}, -- Victory Rush
		}
		t.buffsC = {
			[18499] = {}, -- Berserker Rage
			[213858] = {}, -- Battle Trance (pvp)
		}
	elseif specID == 73 then --Protection
		local bolsterActive = select(4, GetTalentInfo(7, 3, 1))
		--gcd = 20243, -- Devastate
		iCD.outOfRangeSpells = {
			main = 'Shield Slam',
			range = 'Heroic Throw',
		}
		t.power = {
			func = function()
				local power = UnitPower('player', 1)
				if power >= 40 then
					return iCD.colors.green .. power
				else
					return power
				end
			end,
		}
		t.row1 = {
			[23922] = { -- Shield Slam
				order = 3,
				row = 1,
				range = true,
				glow = true,
				glowSound = true,
				level = 3,
				showTimeAfterGCD = true,
			},
			--[[
			[6572] = { -- Revenge
				order = 7,
				row = 1,
				range = true,
				cost = true,
				glow = true,
				glowSound = 'text1',
				level = 22,
				stack = true,
				stackFunc = function()
					local count, duration, expirationTime, value1, value2, value3 = iCD.UnitBuff('player', 'Revenge!')
					if expirationTime then
						local dura = expirationTime - GetTime()
						if dura > 5 then
							return dura,'%.0f'
						else
							return dura, '|cffff1a1a%.1f'
						end
					else
						return ''
					end
				end,
				customRangeSpell = 'Shield Slam',
				showTimeAfterGCD = true,
			},
			--]]
			[6343] = { -- Thunder Clap
				order = 5,
				row = 1,
				stack = true,
				stackFunc = function()
					local count, duration, expirationTime, value1, value2, value3 = iCD.UnitBuff('player', 'Avatar')
					local start, cd = GetSpellCooldown(6343)
					if expirationTime and (start+cd) < expirationTime+.1 then
						return iCD.colors.green .. '+'
					else
						return ''
					end
				end,
				showTimeAfterGCD = true,
			},
			[46968] = { -- Shockwave
				order = 8,
				row = 1,
				showTimeAfterGCD = true,
				level = 50,
			},
			[107570] = { -- Stormbolt
				order = 9,
				row = 1,
				range = true,
				showFunc = function()
					return select(4, GetTalentInfo(2, 3, 1))
				end,
				showTimeAfterGCD = true,
			},
			[202168] = { -- Impending Victory
				order = 9,
				range = true,
				cost = true,
				showFunc = function()
					return select(4, GetTalentInfo(5, 3, 1))
				end,
				showTimeAfterGCD = true,
			},
			[228920] = { -- Ravager
				order = 10,
				showFunc = function()
					return select(4, GetTalentInfo(6, 3, 1))
				end,
				showTimeAfterGCD = true,
			},
		}
		t.row2 = {
			[1160] = { -- Demoralizing Shout
				order = 4,
				level = 27,
			},
			[12975] = { -- Last Stand
				order = 5,
				ignoreGCD = true,
				level = 38,
			},
			[871] = { -- Shield Wall
				order = 7,
				ignoreGCD = true,
				level = 23,
			},
			[23920] = { -- Spell Reflection
				order = 9,
				ignoreGCD = true,
				level = 47,
			},
			[107574] = { -- Avatar
				order = 10,
				level = 32,
			},
			[5246] = {  -- Intimidating Shout
				order = 13,
			},
			[97462] = { -- Rallying Cry
				order = 15,
			},
		}
		t.row3 = {
			[2565] = { -- Shield Block
				order = 2,
				stack = true,
				ignoreGCD = true,
				cost = true,
				AM = function()
					if bolsterActive then
						local _, _, ls = iCD.UnitBuff('player', "Last Stand", nil, 'player')
						if ls then return true end
					end
					local count, duration, expirationTime, value1, value2, value3 = iCD.UnitBuff('player', 'Shield Block')
					if expirationTime then
						local dura = expirationTime - GetTime()
						if dura + 6 > 18 then
							return true
						end
					end
					return
				end,
				level = 6,
			},
			[190456] = { -- Ignore Pain
				order = 1,
				cost = true,
				stack = true,
				level = 17,
				stackFunc = function()
					local v = select(4, iCD.UnitBuff('player', 'Ignore Pain'))
					if v then
						return v/1e3, '%.1f'
					else
						 return ''
					end
				end,
				customText = function()
					local count, duration, expirationTime, value1, value2, value3 = iCD.UnitBuff('player', "Ignore Pain", nil, 'player')
					if expirationTime then
						local dura = expirationTime - GetTime()
						if dura > 5 then
							return dura,'%.0f'
						else
							return dura, '|cffff1a1a%.1f'
						end
					else
						return ''
					end
				end,
			},
		}
		t.row4 = {
			[18499] = { -- Berserker Rage
				level = 29,
			},
			--[198304] = {}, -- Intercept
			[355] = {  -- Taunt
				ignoreGCD = true,
			},
			[3411] = { -- Intervene
				level = 43,
			},
			[64382] = {}, -- Shattering Throw
		}
		t.row5 = {
			[1160] = { -- Demoralizing Shout
				debuff = true,
			},
			[12975] = {}, -- Last Stand
			[227744] = { -- Ravager
				showFunc = function()
					return select(4, GetTalentInfo(6, 3, 1))
				end,
			},
			[871] = {}, -- Shield Wall
			[23920] = {}, -- Spell Reflection
		}
		t.buffsI = {
			[32216] = { -- Victory Rush enabled
				showFunc = function()
					return not select(4, GetTalentInfo(5, 3, 1))
				end,
			},
			[132404] = {}, -- Shield Block
			[204488] = { -- Focused Rage
				stack = true,
			},
			[5302] = {}, -- Revenge!
			--[[
			[202573] = { -- Vengeance: Revenge
				showFunc = function()
					return select(4, GetTalentInfo(6, 1, 1))
				end,
				stack = iCD.colors.red .. 'R',
			},
			[202574] = { -- Vengeance: Ignore Pain
				showFunc = function()
					return select(4, GetTalentInfo(6, 1, 1))
				end,
				stack = iCD.colors.green .. 'IP',
			},
			--]]
		}
		t.buffsC = {
			[107574] = {}, -- Avatar
			[18499] = {}, -- Berserker Rage
			[202289] = {  -- Renewed Fury
				showFunc = function()
					return select(4, GetTalentInfo(3, 1, 1))
				end,
			},
			[189064] = { -- Scales of Earth (Artifact)
				stack = '+A',
			},
		}


	else -- no spec
		iCD.outOfRangeSpells = {
			main = 'Slam',
			range = 'Slam',
		}
		t.power = {
			pos = {
				x = -30,
				y = -8,
			},
			func = function()
				local power = UnitPower('player', 1)
				if power >= 85 then
					return iCD.colors.green .. power
				else
					return power
				end
			end,
		}
		t.row1 = {
			[23922] = { -- Shield Slam
				order = 1,
				glow = true,
				range = true,
				cost = true,
				showTimeAfterGCD = true,
				level = 3,
			},
		}
		t.row2 = {}
		t.row3 = {
			[2565] = { -- Shield Block
				stack = true,
				cost = true,
				level = 6,
			},
		}
		t.row4 = {
			[100] = { -- Charge
				level = 2,
			},
		}
		t.row5 = {
		}
		t.buffsI = {
			[32216] = {}, -- Victory Rush
		}

	end
	return temp
end
