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
function iCD:MONK(specID)
	iCD.outOfRangeSpells = {
		main = 'Tiger Palm',
		range = 'Keg Smash',
	}

	local temp = {}
	temp.spec = {}
	temp.all = {}
	temp.all.row1 = {
		[310454] = { -- Weapons of Order
			order = 999999, -- Always last
			showTimeAfterCast = true,
			range = true,
			covenant = iCD.covenants.KYRIAN,
			stack = true,
			stackFunc = function()
				local count, duration, expirationTime, value1, value2, value3 = iCD.UnitBuff('player', 'Weapons of Order')
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
		},
	}
	temp.all.row2 = {}
	temp.all.row3 = {}
	temp.all.row4 = {}
	temp.all.row5 = {}
	temp.all.buffsC = {}
	temp.all.buffsI = {
		[312106] = { -- Weapons of Order
			covenant = iCD.covenants.KYRIAN,
			stack = true,
			debuff = true,
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
	if specID == 268 then --Brewmaster
		t.power = {
			func = function()
				local power = UnitPower('player', 3)
				local regen = GetPowerRegen()
				--color

				local castingTimeLeft
				local _,_,_,_,_,currentcastingTimeLeft = UnitCastingInfo('player')
				if currentcastingTimeLeft then
					castingTimeLeft = currentcastingTimeLeft/1000-GetTime()
				else
					castingTimeLeft = 0
				end
				local gcdstart, gcdcooldown = GetSpellCooldown('Tiger Palm')
				local gcdLeft = gcdstart + gcdcooldown-GetTime()
				if castingTimeLeft <= gcdLeft then
					castingTimeLeft = gcdLeft
				end
				local powerAfterGCD = power + (castingTimeLeft+1)*regen
				local color = ''
				if powerAfterGCD >= 90 then
					return '|cffff0000' .. power
				else
					local KSstart, KScooldown = GetSpellCooldown('Keg Smash')
					local KSLeft = KSstart + KScooldown-GetTime()
					local powerAtKS = power + (KSLeft)*regen
					if powerAtKS-25 >= 37 then
						return '|cff00ff00' .. power
					end
				end
				return power
			end,
		}
		t.row1 = {
			[121253] = { -- Keg Smash
				order = 2,
				range = true,
				cost = true,
				showTimeAfterGCD = true,
				stack = true,
			},
			[205523] = { -- Blackout Kick
				order = 4,
				range = true,
				customRangeSpell = 'Tiger Palm',
				stack = true,
				stackFunc = select(4, GetTalentInfo(7, 3, 1)) and function()
					local count, duration, expirationTime, value1, value2, value3 = iCD.UnitBuff('player', 'Blackout Combo')
					if expirationTime then
						return '+', '|cff00ff00%s'
					else
						return ' '
					end
				end or false,
				showTimeAfterGCD = true,
			},
			[115181] = { -- Breath of Fire
				order = 6,
				stack = true,
				glow = true,
				glowSound = true,
				stackFunc = function()
					local count, duration, expirationTime, value1, value2, value3 = iCD.UnitDebuff(nil,'Breath of Fire')
					if expirationTime then
						local dura = expirationTime - GetTime()
						return dura, '%.0f'
					else
						return ''
					end
				end,
				showTimeAfterGCD = true,
				--level = 29,
			},
			[116847] = { -- Rushing Jade Wind
				order = 8,
				showFunc = function()
					return select(4, GetTalentInfo(6, 2, 1))
				end,
				stack = true,
				stackFunc = function()
					local count, duration, expirationTime, value1, value2, value3 = iCD.UnitBuff('player', 'Rushing Jade Wind')
					if expirationTime then
						local dura = expirationTime - GetTime()
						return dura, '%.0f'
					else
						return ''
					end
				end,
				showTimeAfterGCD = true,
			},
			[123986] = { -- Chi Burst
				order = 10,
				range = true,
				showFunc = function()
					return select(4, GetTalentInfo(1, 3, 1))
				end,
				showTimeAfterGCD = true,
			},
			[115098] = { -- Chi Wave
				order = 10,
				range = true,
				showFunc = function()
					return select(4, GetTalentInfo(1, 2, 1))
				end,
				showTimeAfterGCD = true,
			},
		}
		t.row2 = {
			[325153] = { -- Exploding Keg
				order = 2,
				showFunc = function()
					return select(4, GetTalentInfo(6, 3, 1))
				end,
			},
			[122281] = { -- Healing Elixir
				order = 3,
				stack = true,
				ignoreGCD = true,
				showFunc = function()
					return select(4, GetTalentInfo(5, 2, 1))
				end,
			},
			[122278] = { -- Dampening Harm
				order = 4,
				ignoreGCD = true,
				showFunc = function()
					return select(4, GetTalentInfo(5, 3, 1))
				end,
			},
			[132578] = { -- Invoke Niuzao, the Black Ox
				order = 6,
				range = true,
			},
			[115176] = { -- Zen Meditation
				order = 10,
				ignoreGCD = true,
				--level = 65,
			},
			[115203] = { -- Fortifying Brew
			order = 8,
				ignoreGCD = true,
		},

		}
		t.row3 = {
			[322101] = { -- Expel Harm
				order = 10,
				stack = true,
				stackFunc = function()
					return GetSpellCount(322101)
				end,
				cost = true,
				showTimeAfterGCD = true,
				--level = 50,
			},
			[119582] = { -- Purifying Brew
				order = 5,
				stack = true,
				ignoreGCD = true,
			},
			[115399] = { --Black Ox Brew
				order = 3,
				ignoreGCD = true,
				showFunc = function()
					return select(4, GetTalentInfo(3, 3, 1))
				end,
			},
			[322507] = { -- Celestial Brew
				order = 2,
				showTimeAfterGCD = true,
			},
			[325092] = { -- Purified Chi
				order = 1,
				stack = true,
				stackFunc = function()
					local count, duration, expirationTime, value1, value2, value3 = iCD.UnitBuff('player', 'Purified Chi')
					return count or ""
				end,
				customText = function()
					local count, duration, expirationTime, value1, value2, value3 = iCD.UnitBuff('player', 'Purified Chi')
					if expirationTime then
						local dura = expirationTime - GetTime()
						return dura, '%.0f'
					else
						return ''
					end
				end,
				icon = 645193,
			},
		}
		t.row4 = {
			[218164] = {}, -- Detox
			[119381] = {}, -- Leg Sweep
			[116844] = { -- Ring of Peace
				showFunc = function()
					return select(4, GetTalentInfo(4, 3, 1))
				end,
			},
			[115315] = { -- Summon Black Ox Statue
				showFunc = function()
					return select(4, GetTalentInfo(4, 2, 1))
				end,
			},
			[115078] = {}, -- Paralysis
			[115546] = {}, -- Provoke
			[101643] = {}, -- Transcendence
			[119996] = {}, -- Transcendence: Transfer
			[115008] = { -- Chi Torpedo
				stack = true,
				ignoreGCD = true,
				showFunc = function()
					return select(4, GetTalentInfo(2, 2, 1))
				end,
			},
			[109132] = { -- Roll
				stack = true,
				ignoreGCD = true,
				showFunc = function()
					return not select(4, GetTalentInfo(2, 2, 1))
				end,
			},
			[116841] = { -- Tiger's Lust
				showFunc = function()
					return  select(4, GetTalentInfo(2, 3, 1))
				end,
			},
			[322109] = {}, -- Touch of Death
			[324312] = {}, -- Clash
		}
		t.row5 = {
			[120954] = {}, -- Fortifying Brew
			[122278] = {}, -- Dampening Harm
			[322507] = { -- Celestial Brew
				stack = true,
				stackFunc = function()
					local amount = select(4, iCD.UnitBuff('player', 'Celestial Brew'))
					if amount then
						return math.floor(amount/1e3)
					else
						return ""
					end
				end,
			},

		}
		t.buffsC = {
			[119085] = { -- Chi Torpedo, speed buff
				stack = true,
				showFunc = function()
					return select(4, GetTalentInfo(2, 2, 1))
				end,
			},
		}
		t.buffsI = {
			[215479] = {}, -- Ironskin Brew
		}
	elseif specID == 269 then --Windwalker
		t.power = {
			func = function()
					return UnitPower('player', 3)
			end,
		}
		t.row1 = {
			[107428] = { -- Rising Sun Kick
				order = 2,
				range = true,
				cost = true,
				showTimeAfterGCD = true,
			},
			[113656] = { -- First of Fury
				order = 3,
				range = true,
				cost = true,
				showTimeAfterGCD = true,
			},
			[152175] = { -- Whirling Dragon Punch
				order = 7,
				showTimeAfterGCD = true,
				cost = true,
				range = true,
				customCost = function()
					local isUsable = IsUsableSpell("Whirling Dragon Punch")
					if not isUsable then
						return true
					end
				end,
				showFunc = function()
					return select(4, GetTalentInfo(7, 2, 1))
				end,
			},
			[261947] = { -- Fist of the White Tiger
				order = 8,
				showTimeAfterGCD = true,
				cost = true,
				range = true,
				showFunc = function()
					return select(4, GetTalentInfo(3, 2, 1))
				end,
			},
			[116847] = { -- Rushing Jade Wind
				order = 9,
				cost = true,
				showTimeAfterGCD = true,
				showFunc = function()
					return select(4, GetTalentInfo(6, 2, 1))
				end,
			},
			[322101] = { -- Expel Harm
				order = 10,
				range = true,
				cost = true,
				showTimeAfterGCD = true,
			},
			[115098] = { -- Chi Wave
				order = 11,
				cost = true,
				showTimeAfterGCD = true,
				showFunc = function()
					return select(4, GetTalentInfo(1, 2, 1))
				end,
			},
			[123986] = { -- Chi Burst
				order = 11,
				cost = true,
				showTimeAfterGCD = true,
				showFunc = function()
					return select(4, GetTalentInfo(1, 3, 1))
				end,
			},
		}
		t.row2 = {
			[122278] = { -- Dampening Harm
				order = 5,
				ignoreGCD = true,
				showFunc = function()
					return select(4, GetTalentInfo(5, 3, 1))
				end,
			},
			[122783] = { -- Diffuse Magic
				order = 5,
				ignoreGCD = true,
				showFunc = function()
					return select(4, GetTalentInfo(5, 2, 1))
				end,
			},
			[123904] = { -- Invoke Xuen, the White Tiger
				order = 1,
				showFunc = function()
					return select(4, GetTalentInfo(6, 3, 1))
				end,
			},
			[137639] = { -- Storm, Earth, and Fire
				order = 2,
				stack = true,
			},
			[115080] = { -- Touch of Death
				order = 3,
			},
			[122470] = { -- Touch of Karma
				order = 4,
				ignoreGCD = true,
				range = true,
			},
		}
		t.row3 = {

		}
		t.row4 = {
			[101545] = {}, -- Flying Serpent Kick
			[115078] = {}, -- Paralysis
			[115546] = {  -- Provoke
				ignoreGCD = true,
			},
			[101643] = {}, -- Transcendence
			[119996] = {}, -- Transcendence: Transfer
			[115008] = { -- Chi Torpedo
				stack = true,
				ignoreGCD = true,
				showFunc = function()
					return select(4, GetTalentInfo(2, 2, 1))
				end,
			},
			[109132] = { -- Roll
				stack = true,
				ignoreGCD = true,
				showFunc = function()
					return not select(4, GetTalentInfo(2, 2, 1))
				end,
			},
			[218164] = {}, -- Detox
			[119381] = { -- Leg Sweep
			},
			[116844] = { -- Ring of Peace
				showFunc = function()
					return select(4, GetTalentInfo(4, 3, 1))
				end,
			},
			[116841] = { -- Tiger's Lust
				showFunc = function()
					return  select(4, GetTalentInfo(2, 3, 1))
				end,
			},
		}
		t.row5 = {
			[125174] = {}, -- Touch of Karma
		}
		t.buffsC = {

			[287062] = { -- Fury of Xuen
				stack = true,
				azerite = 117,
			}
		}
		t.buffsI = {
			[325202] = { -- Dance of Chi-Ji
				showFunc = function()
					return select(4, GetTalentInfo(6, 3, 1))
				end,
				stack = "+SCK",
			},
			[115080] = { -- Touch of Death
				debuff = true,
			},
			[137639] = {}, -- Storm, Earth, and Fire
			[116768] = { -- Free blackout kick
				stack = "+BOK",
			},
		}
	elseif specID == 270 then --Mistweaver
			t.power = {
				func = function()
					return math.floor(UnitPower('player', 0)/UnitPowerMax('player', 0)*100)
				end,
		}

		t.row1 = {
			[107428] = { -- Rising Sun Kick
				order = 6,
				glow = true,
				glowSound = true,
				range = true,
				showTimeAfterCast = true,
			},
			[100784] = { -- Blackout Strike
				order = 8,
				range = true,
				customRangeSpell = 'Tiger Palm',
				showTimeAfterCast = true,
				stack = true,
				stackFunc = function()
					local count, duration, expirationTime, value1, value2, value3 = iCD.UnitBuff('player', 'Teachings of the Monastery')
					--local name, _, icon, count, debuffType, duration, expirationTime, _, _, _, spellID = UnitBuff('player', 'Teachings of the Monastery', nil, 'player')
					if count and count > 0 then
						return count
					else
						return ''
					end
				end,
			},
			[196725] =  { -- Refreshing Jade Wind
				order = 10,
				showFunc = function()
					return select(4, GetTalentInfo(6, 2, 1))
				end,
				showTimeAfterCast = true,
			},
			[123986] =  { -- Chi Burst
				order = 12,
				showTimeAfterCast = true,
				showFunc = function()
					return select(4, GetTalentInfo(1, 3, 1))
				end,
			},
			[191837] = { -- Essence of Font
				order = 14,
				showTimeAfterCast = true,
			},
			[322101] = { -- Expel Harm
				order = 20,
				showTimeAfterCast = true,
			},

		}
		t.row2 = {
			[116680] = { -- Thunder Focus Tea
				order = 2,
				ignoreGCD = true,
				glow = true,
				glowSound = 'text2',
			},
			[197908] = { -- Mana Tea
				order = 3,
				showFunc = function()
					return select(4, GetTalentInfo(3, 3, 1))
				end,
			},
			[122281] = { -- Healing Elixir
				order = 4,
				stack = true,
				ignoreGCD = true,
				showFunc = function()
					return select(4, GetTalentInfo(5, 1, 1))
				end,

			},
			[122278] = { -- Dampening Harm
				order = 4,
				ignoreGCD = true,
				showFunc = function()
					return select(4, GetTalentInfo(5, 3, 1))
				end,
			},
			[122783] = { -- Diffuse Magic
				order = 4,
				ignoreGCD = true,
				showFunc = function()
					return select(4, GetTalentInfo(5, 2, 1))
				end,
			},
			[116849] = { -- Life Cocoon
				order = 5,
				ignoreGCD = true,
			},
			[325197] = { -- Invoke Chi-Ji the Red Crane
				order = 7,
				showFunc = function()
					return select(4, GetTalentInfo(6, 3, 1))
				end,
			},
			[322118] = { -- Invoke Yu'lon, the Jade Serpent
				order = 7,
				showFunc = function()
					return not select(4, GetTalentInfo(6, 3, 1))
				end,
			},
			[115310] = { -- Revival
				order = 8,
			},
			[243435] = { -- Fortifying Brew
				order = 10,
			},
		}
		t.row3 = {
			[115151] = { -- Renewing Mist
				order = 4,
				showTimeAfterCast = true,
				stack = true,
			},
		}
		t.row4 = {
			[115450] = {}, -- Detox
			[198898] = { -- Song of Chi-Ji
				showFunc = function()
					return select(4, GetTalentInfo(4, 2, 1))
				end,
			},
			[116844] = { -- Ring of Peace
				showFunc = function()
					return select(4, GetTalentInfo(4, 3, 1))
				end,
			},
			[115313] = { -- Summon Jade Serpent Statue
				showFunc = function()
					return select(4, GetTalentInfo(6, 1, 1))
				end,
			},
			[115078] = {}, -- Paralysis
			[115546] = {}, -- Provoke
			[101643] = {}, -- Transcendence
			[119996] = {}, -- Transcendence: Transfer
			[119381] = {}, -- Leg Sweep
			[115008] = { -- Chi Torpedo
				stack = true,
				ignoreGCD = true,
				showFunc = function()
					return select(4, GetTalentInfo(2, 2, 1))
				end,
			},
			[109132] = { -- Roll
				stack = true,
				ignoreGCD = true,
				showFunc = function()
					return not select(4, GetTalentInfo(2, 2, 1))
				end,
			},
			[116841] = { -- Tiger's Lust
				showFunc = function()
					return  select(4, GetTalentInfo(2, 3, 1))
				end,
			},
		}
		t.row5 = {
			[122278] = {}, -- Dampening Harm
		}
		t.buffsC = {
			[119085] = { -- Chi Torpedo, speed buff
				stack = true,
				showFunc = function()
					return select(4, GetTalentInfo(2, 2, 1))
				end,
			},
		}
		t.buffsI = {
			[216113] = {
				showFunc = function() return iCD:Essences(32, true) end,
			},
			[116680] = { -- Thunder Focus Tea
				stack = true,
			},
			[197206]  = {} -- Uplifting Trance
		}
	end
	return temp
end
