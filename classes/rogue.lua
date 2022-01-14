local _, iCD = ...
function iCD:ROGUE(specID)
	local temp = {}
	temp.spec = {}
	temp.all = {}
	temp.all.row1 = {}
	temp.all.row2 = {}
	temp.all.row3 = {}
	temp.all.row4 = {
		[5938] = {}, -- Shiv
	}
	temp.all.row5 = {}
	temp.all.buffsC = {}
	temp.all.buffsI = {}
	local t = temp.spec
	t.row1 = {}
	t.row2 = {}
	t.row3 = {}
	t.row4 = {}
	t.row5 = {}
	t.buffsC = {}
	t.buffsI = {}
	if specID == 259 then -- Assasination
		iCD.outOfRangeSpells = {
			main = 'Garrote',
			range = 'Poisoned Knife',
		}
		t.power = {
			func = function()
				local p = UnitPower('player', 3)
				if p < 40 then
					return p
				elseif p >= 90 then
					return '|cffff0000'..p
				else
					return '|cff00ff00'..p
				end
			end,
		}
		-- Row 1
		t.row1 = {
			[703] = { -- Garrote
				order = 5,
				cost = true,
				range = true,
				showTimeAfterGCD = true,
			},
			[137619] = { -- Marked for Death
				order = 10,
				showFunc = function()
					return select(4, GetTalentInfo(7, 2, 1))
				end,
				range = true,
			},
			[137619] = { -- Marked for Death
				order = 10,
				showFunc = function()
					return select(4, GetTalentInfo(3, 3, 1))
				end,
				range = true,
			},
		}
		t.row2 = {
			[79140] = { -- Vendetta
				order = 1,
			},
			[1856] = { -- Vanish
				order = 3,
			},
			[31224] = { -- Cloak of Shadows
				order = 6,
			},
			[185311] = { -- Crimson Vial
				order = 10,
				cost = true,
			},
		}
		t.row3 = {
			[121411] = { -- Crimson Tempest
				order = 2,
				range = true,
				cost = true,
				customText = function(data, gcdInfo)
					local count, duration, expirationTime, value1, value2, value3 = iCD.UnitDebuff('target', 'Crimson Tempest', true)
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
				showFunc = function()
					return select(4, GetTalentInfo(7, 3, 1))
				end,
			},
			[703] = { -- Garrote
				order = 3,
				range = true,
				cost = true,
				customText = function(data, gcdInfo)
					local count, duration, expirationTime, value1, value2, value3 = iCD.UnitDebuff('target', 'Garrote', true)
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
		[1943] = { -- Rupture
			order = 4,
			range = true,
			cost = true,
			customText = function(data, gcdInfo)
				local count, duration, expirationTime, value1, value2, value3 = iCD.UnitDebuff('target', 'Rupture', true)
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
			[2094] = {}, -- Blind
			[2983] = { -- Sprint
				ignoreGCD = true,
			},
			[408] = {}, -- Kidney Shot
			[36554] = { -- Shadow Step
				ignoreGCD = true,
			},
			[5277] = {}, -- Evasion
			[1725] = {}, -- Distract
			[1966] = {}, -- Feint
		}
		t.buffsI = {
			[79140] = { -- Vendetta
				debuff = true,
			},
			[115192] = {}, -- Subterfuge
			[32645] = {}, -- Envenom
		}
		t.buffsC = {
			[5277] = {}, -- Evasion
			[1966] = {}, -- Feint
			[2983] = {}, -- Sprint
		}
	elseif specID == 260 then --Outlaw
		iCD.outOfRangeSpells = {
			main = 'Sinister Strike',
			range = 'Pistol Shot',
		}
		t.power = {
			func = function()
				local p = UnitPower('player', 3)
				if p < 50 then
					return p
				elseif p >= 120 then
					return '|cffff0000'..p
				else
					return '|cff00ff00'..p
				end
			end,
		}
		-- Row 1
		t.row1 = {
			[271877] = { -- Blade Rush
				order = 1,
				showFunc = function()
					return select(4, GetTalentInfo(7, 2, 1))
				end,
				range = true,
			},
			[185763] = { -- Pistol Shot
				order = 2,
				cost = true,
				range = true,
				glow = true,
				glowSound = true,
				stack = true,
				stackFunc = function()
					local count, duration, expirationTime, value1, value2, value3 = iCD.UnitBuff('player', 'Opportunity')
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
			[315341] = { -- Between the Eyes
				order = 3,
				cost = true,
				range = true,
			},
			[13877] = { -- Blade Flurry
				order = 5,
				stack = true,
			},
			[137619] = { -- Marked for Death
				order = 10,
				showFunc = function()
					return select(4, GetTalentInfo(3, 3, 1))
				end,
				range = true,
			},
		}
		t.row2 = {
			[315508] = { -- Roll the Bones
				cost = true,
				order = 1,
			},
			[13750] = { --Adrenaline Rush
				order = 3,
			},
			[1966] = { -- Feint
				order = 5,
				cost = true,
			},
			[31224] = { -- Cloak of Shadows
				order = 10,
				ignoreGCD = true,
			},
			[185311] = { -- Crimson Vial
				order = 7,
			},
			[5277] = { -- Evasion
				order = 12,
				ignoreGCD = true,
			},
		}
		t.row4 = {
			[2094] = {}, -- Blind
			[1776] = {}, -- Gouge
			[2983] = {}, -- Sprint
			[1856] = {}, -- Vanish
			[199804] = {}, -- Between the Eyes
			[195457] = {}, -- Grappling Hook
			[57934] = {}, -- Tricks of the trade
		}
		t.buffsI = {
			[13877] = {}, -- Blade Flurry
			[315496] = {}, -- Slice and dice
			[193359] = {  -- True Bearing
				stack = "-CD",
			},
			[193357] = {  -- Ruthless Precision
				stack = "+CC",
			},
			[199603] = {  -- Skull and Crossbones
				stack = "+SS",
			},
			[193358] = {  -- Grand Melee
				stack = "+H",
			},
			[193356] = {  -- Broadside
				stack = "+CB",
			},
			[199600] = {  -- Buried Treasure
				stack = "+ER",
			},
		}
		t.buffsC = {
			[13750] = {}, -- Adrenaline Rush
			[199754] = {}, -- Riposte
			[2983] = {}, -- Sprint
				[275863] = { -- Snake Eyes
				stack = true,
				azerite = 239,
			},
			[31224] = {} -- Cloak of Shadows
		}
	elseif specID == 261 then --Sublety
		iCD.outOfRangeSpells = {
			main = 'Eviscerate',
			range = 'Shuriken Toss',
		}
		t.power = {
			func = function()
				local p = UnitPower('player', 3)
				if p < 40 then
					return p
				elseif p >= 90 then
					return '|cffff0000'..p
				else
					return '|cff00ff00'..p
				end
			end,
		}
		-- Row 1
		t.row1 = {
			[137619] = { -- Marked for Death
				order = 2,
				showFunc = function()
					return select(4, GetTalentInfo(3, 3, 1))
				end,
				range = true,
				showTimeAfterGCD = true,
			},
			[277925] = { -- Shuriken Tornado
				order = 2,
				showFunc = function()
					return select(4, GetTalentInfo(7, 3, 1))
				end,
				cost = true,
				showTimeAfterGCD = true,
			},
		}
		t.row2 = {
			[121471] = { -- Shadow Blades
				order = 5,
				showTimeAfterGCD = true,
			},
			[185313] = { -- Shadow Dance
				stack = true,
				order = 3,
				ignoreGCD = true,
			},
			[212283] = { -- Symbols of Death
				order = 6,
				ignoreGCD = true,
			},
			[36554] = { -- Shadow Step
				order = 8,
				ignoreGCD = true,
				stack = true,
				range = true,
			},
			[185311] = { -- Crimson Vial
				order = 10,
				cost = true,
			},


		}
		t.row3 = {
			[315496] = { -- Slice and Dice
				order = 2,
				cost = true,
				customText = function(data, gcdInfo)
					local count, duration, expirationTime, value1, value2, value3 = iCD.UnitBuff('player', 'Slice and Dice')
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
			[1943] = { -- Rupture
				order = 1,
				customText = function(data, gcdInfo)
					local count, duration, expirationTime, value1, value2, value3 = iCD.UnitDebuff('target', 'Rupture', true)
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
			[2094] = {}, -- Blind
			[2983] = {}, -- Sprint
			[1856] = {}, -- Vanish
			[408] = {}, -- Kidney Shot
			[31224] = {}, -- Cloak of Shadows
			[5277] = {}, -- Evasion
			[5938] = {}, -- Shiv
		}
		t.buffsI = {
			[185422] = {}, -- Shadow Dance
			[245640] = {  -- Shuriken Storm
				stack = true,
			},
		}
		t.buffsC = {
			[5277] = {}, -- Evasion
			[1966] = {}, -- Feint
			[2983] = {}, -- Sprint
		}
	end
	return temp
end
