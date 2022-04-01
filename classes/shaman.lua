local _, iCD = ...
function iCD:SHAMAN(specID)
	local temp = {}
	temp.spec = {}
	temp.all = {}
	temp.all.row1 = {
		[326059] = { -- Primordial Wave
			order = 9999,
			showTimeAfterCast = true,
			covenant = iCD.covenants.NECROLORD,
			range = true,
		},
		[320674] = { -- Chain Harvest
			order = 9999,
			showTimeAfterCast = true,
			covenant = iCD.covenants.VENTHYR,
			range = true,
		},
	}
	temp.all.row2 = {}
	temp.all.row3 = {}
	temp.all.row4 = {}
	temp.all.row5 = {
		[108271] = {}, -- Astral Shift
		[79206] = {}, -- Spiritwalker's Grace
	}
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
	if specID == 262 then -- Elemental
		iCD.outOfRangeSpells = {
			main = "Lightning Bolt",
			range = "Lightning Bolt"
		}
		t.power = {
			func = function()
				local ES = select(2, IsUsableSpell('Earth Shock'))
				return (not ES and '|cff00ff00' or '') .. UnitPower('player', 11)
			end
		}
		t.row1 = {
			[188389] = { -- Flame Shock
				order = 1,
				range = true,
				showTimeAfterCast = true,
			},
			[51505] = {
				-- Lava Burst
				order = 3,
				range = true,
				stack = true,
				glow = true,
				glowSound = true,
				showTimeAfterCast = true,
			},
			[117014] = {
				-- Elemental Blast
				order = 5,
				range = true,
				showFunc = function()
					return select(4, GetTalentInfo(2, 3, 1))
				end,
				showTimeAfterCast = true,
			},
			[210714] = { -- Icefury
				order = 8,
				range = true,
				showFunc = function()
					return select(4, GetTalentInfo(6, 3, 1))
				end,
				showTimeAfterCast = true,
			},
			[192222] = {
				-- Liquid Magma Totem
				order = 3,
				showFunc = function()
					return select(4, GetTalentInfo(4, 3, 1))
				end,
				showTimeAfterCast = true,
			},
			[320125] = { -- Echoing Shock
				order = 3,
				showFunc = function()
					return select(4, GetTalentInfo(2, 2, 1))
				end,
				showTimeAfterCast = true,
			},

		}
		t.row2 = {
			[191634] = { -- Stormkeeper
				order = 2,
				showFunc = function()
					return select(4, GetTalentInfo(7, 2, 1))
				end,
				showTimeAfterCast = true,
			},
			[114050] = { -- Ascendance
				order = 4,
				showFunc = function()
					return select(4, GetTalentInfo(7, 3, 1))
				end
			},
			[198067] = {
				-- Fire Elemental
				order = 5
			},
			[108281] = { -- Ancestral Guidance
				order = 7,
				showFunc = function()
					return select(4, GetTalentInfo(5, 2, 1))
				end
			},
			[108271] = {
				-- Astral Shift
				order = 10,
				ignoreGCD = true
			},
			[198103] = {
				-- Earth Elemental
				order = 6
			},
			[5394] = { -- Healing Stream Totem
				order = 20,
			},
			[79206] = { -- Spiritwalker's Grace
				order = 18,
				ignoreGCD = true,
			},
		}
		t.row4 = {
			[51886] = {}, -- Cleanse Spirit
			[2484] = {}, -- Earthbind Totem
			[51514] = {}, -- Hex
			[192058] = {}, -- Lightning Surge Totem
			[51490] = {}, -- Thunderstorm
			[8143] = {}, -- Tremor Totem

		}
		t.buffsC = {
			[114050] = { -- Ascendance
				showFunc = function()
					return select(4, GetTalentInfo(7, 3, 1))
				end
			},
			[16246] = {
				-- Elemental Focus
				stack = true
			},
			[273453] = { -- Lava Shock, Azerite trait
				stack = true,
				azerite = 178,
			},

		}
		t.buffsI = {
			[188389] = { -- Flame Shock
				debuff = true
			},
			[191634] = {
				-- Stormkeeper
				stack = true,
				showFunc = function()
					return select(4, GetTalentInfo(7, 2, 1))
				end
			},
			[210714] = { -- Icefury
				stack = true,
			},
		}
	elseif specID == 263 then -- Enhancement
		iCD.outOfRangeSpells = {
			main = "Lava Lash",
			range = "Lightning Bolt"
		}
		t.power = {
			func = function()
				return math.floor((UnitPower("player", 0) / UnitPowerMax("player", 0)) * 100)
			end
		}
		t.row1 = {
			[60103] = { -- Lava Lash
				order = 3,
				range = true,
				stack = true,
				cost = true,
				showTimeAfterGCD = true,
				range = true,
			},
			[17364] = { -- Stormstrike
				order = 5,
				range = true,
				stack = true,
				glow = true,
				glowSound = true,
				cost = true,
				showTimeAfterGCD = true,
				range = true,
			},
			[188089] = { -- Earthen Spike
				order = 7,
				range = true,
				cost = true,
				showTimeAfterGCD = true,
				showFunc = function()
					return select(4, GetTalentInfo(7, 2, 1))
				end
			},
			[187874] = { -- Crash Lightning
				order = 10,
				range = true,
				cost = true,
				range = true,
				stack = true,
				showTimeAfterGCD = true,
			},
			[188389] = { -- Flame Shock
				order = 25,
				range = true,
				showTimeAfterGCD = true,
			},
			[197214] = { -- Sundering
				order = 30,
				showTimeAfterGCD = true,
				showFunc = function()
					return select(4, GetTalentInfo(6, 3, 1))
				end
			},
		}
		t.row2 = {
			[51533] = { -- Feral Spirits
				order = 5,
				showTimeAfterGCD = true,
			},
			[108271] = { -- Astral Shift
				order = 7,
				ignoreGCD = true
			}
		}
		t.row3 = {
			[344179] = { -- Maelstorm Weapon
				order = 1,
				customText = function()                                                         
					local count, duration, expirationTime, value1, value2, value3 = iCD.UnitBuff("player","Maelstrom Weapon")
					return count or ""
				end
			},
		}
		t.row4 = {
			[196884] = {-- Feral Lunge
				showFunc = function()
					return select(4, GetTalentInfo(2, 2, 1))
				end
			},
			[136037] = {-- Rainfall
				showFunc = function()
					return select(4, GetTalentInfo(2, 1, 1))
				end
			},
			[2825] = {}, -- Bloodlust
			[51886] = {}, -- Cleanse Spirit
			[2484] = {}, -- Earthbind Totem
			[51514] = {}, -- Hex
			[58875] = {}, --Spirit Walk
			[192058] = {}, -- Capacitor Totem
		}
		t.buffsC = {
			[114051] = { -- Ascendance

				showFunc = function()
					return select(4, GetTalentInfo(7, 1, 1))
				end
			},
			[58875] = {} -- Spirit Walk
		}
		t.buffsI = {
			[187878] = {}, -- Crash Lightning (cleave)
			[188389] = { -- Flame Shock
				debuff = true,
			}
		}
	elseif specID == 264 then -- Restoration
		iCD.customSpellTimers[157153] = 0
		iCD.outOfRangeSpells = {
			main = "Flame Shock",
			range = "Flame Shock"
		}
		t.power = {
			func = function()
				return math.floor((UnitPower("player", 0) / UnitPowerMax("player", 0)) * 100)
			end
		}
		t.row1 = {
			[51505] = {
				-- Lava Burst
				order = 5,
				range = true,
				cost = true,
				stack = true,
				glow = true,
				glowSound = true,
				showTimeAfterCast = true,
			},
			[188389] = { -- Flame Shock
				order = 4,
				range = true,
				cost = true,
				showTimeAfterCast = true,
			},
			[61295] = {
				-- Riptide
				order = 2,
				range = true,
				cost = true,
				stack = true,
				showTimeAfterCast = true,
			},
			[73685] = { -- Unleash Life
				order = 3,
				cost = true,
				showTimeAfterCast = true,
				showFunc = function()
					return select(4, GetTalentInfo(1, 3, 1))
				end,
				stack = true,
				stackFunc = function()
					local count, duration, expirationTime, value1, value2, value3 = iCD.UnitBuff('player', 'Unleash Life')
					if expirationTime then
						local dura = expirationTime - GetTime()
						if dura > 5 then
							return dura, '%.0f'
						else
							return dura, '|cffff1a1a%.1f'
						end
					else
						return ''
					end
				end,
			},
			[73920] = { -- Healing Rain
				order = 4,
				cost = true,
				range = true,
				showTimeAfterCast = true,
			},
			[197995] = { -- Wellspring
				order = 4,
				cost = true,
				range = true,
				showTimeAfterCast = true,
				showFunc = function()
					return select(4, GetTalentInfo(7, 2, 1))
				end,
			},
			[5394] = {
				-- Healing Stream Totem
				order = 7,
				range = true,
				stack = true,
				showFunc = function()
					return not select(4, GetTalentInfo(6, 3, 1))
				end,
				showTimeAfterCast = true,
			},
			[157153] = { -- Cloudburst Totem
				order = 7,
				range = true,
				stack = true,
				showFunc = function()
					return select(4, GetTalentInfo(6, 3, 1))
				end,
				showTimeAfterCast = true,
			},
			[198838] = { -- Earthen Wall Totem
				order = 8,
				showFunc = function()
					return select(4, GetTalentInfo(4, 2, 1))
				end,
				showTimeAfterCast = true,
			},
		}
		t.row2 = {
			[79206] = { -- Spiritwalker's grace
				order = 2
			},

			[108280] = { -- Healing tide totem
				order = 4,
				showTimeAfterCast = true,
			},
			[98008] = { -- Spirit Link Totem
				order = 5,
				showTimeAfterCast = true,
			},
			[114052] = { -- Ascendance
				showTimeAfterCast = true,
				order = 7,
				showFunc = function()
					return select(4, GetTalentInfo(7, 3, 1))
				end
			},
			[108271] = {
				-- Astral Shift
				order = 7,
				ignoreGCD = true
			}
		}
		t.row4 = {
			[77130] = {}, -- Cleanse Spirit
			[2484] = {}, -- Earthbind Totem
			[51514] = {}, -- Hex
			[192058] = {}, -- Capacitor Totem
			[192077] = { -- Wind Rush Totem
				showFunc = function()
					return select(4, GetTalentInfo(5, 3, 1))
				end
			},
			[8143] = {}, -- Tremor Totem
			[16191] = {}, -- Mana Tide Totem
		}
		t.buffsC = {
			[114050] = {
				-- Ascendance
				showFunc = function()
					return select(4, GetTalentInfo(7, 3, 1))
				end
			},
			[79206] = {}, -- Spirit Walker's Grace

		}
		t.buffsI = {
			[288675] = { -- High Tide
				stack = true,
				showFunc = function()
					return select(4, GetTalentInfo(7, 1, 1))
				end
			},
			[157504] = {  -- Cloudburst Totem
				showFunc = function()
					return select(4, GetTalentInfo(6, 3, 1))
				end,
				customText = function()
					if iCD.customSpellTimers[157153] then
						local dura =  iCD.customSpellTimers[157153] - GetTime()
						if dura <= 0 then
							return ' '
						elseif dura > 5 then
							return dura,'%.0f'
						else
							return dura, '|cffff1a1a%.1f'
						end
					else
						return ''
					end
				end,
			},
			[188389] = {
				-- Flame Shock
				debuff = true
			},
			[53390] = {
				-- Tidal Waves
				stack = true
			},
			[338340] = { -- Swirling Currents
				showFunc = function() return iCD:Soulbinds(118) end,
				stack = true,
			}
		}
	end

	return temp
end
