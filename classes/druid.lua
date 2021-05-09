local _, iCD = ...
function iCD:DRUID(specID)
	local temp = {}
	temp.spec = {}
	temp.all = {}
	temp.all.row1 = {
		[325727] = { -- Adaptive Swarm
			order = 999999, -- Always last
			showTimeAfterCast = true,
			range = true,
			covenant = iCD.covenants.NECROLORD
		},
		[323764] = { -- Concoke the Spirits
			order = 999999, -- Always last
			showTimeAfterCast = true,
			covenant = iCD.covenants.NIGHTFAE
		},
	}
	temp.all.row2 = {}
	temp.all.row3 = {}
	temp.all.row4 = {
		[1850] = {}, -- Dash
		[2908] = {}, -- Soothe
		[106898] = {}, -- Stampeding Roar
	}
	temp.all.row5 = {
		[22812] = {}, -- Barkskin
	}
	temp.all.buffsI = {}
	temp.all.buffsC = {}
	local t = temp.spec
	t.row1 = {}
	t.row2 = {}
	t.row3 = {}
	t.row4 = {}
	t.row5 = {}
	t.buffsC = {}
	t.buffsI = {}
	if specID == 102 then --Balance
		iCD.outOfRangeSpells = {
			main = 'Moonfire',
			range = 'Moonfire',
		}
		t.power = {
			func = function()
				local form = GetShapeshiftFormID()
				if not form or form == 31 then -- Caster/Moonkin
					return UnitPower('player', 8)
				elseif form == 1 then -- Cat form
					return UnitPower('player', 3)
				elseif form == 5 then -- Bear
					return UnitPower('player', 1)
				end
			end,
		}
		t.row1 = {
			-- Cat form
			[202770] = { -- Fury of Elune
				order = 5,
				range = true,
				showFunc = function()
					return select(4, GetTalentInfo(7, 2, 1))
				end,
				stack = true,
				stackFunc = function()
					if iCD.customSpellTimers[202770] then
						local dura =  iCD.customSpellTimers[202770] - GetTime()
						if dura <= 0 then
							return ''
						elseif dura > 5 then
							return dura,'%.0f'
						else
							return dura, '|cffff1a1a%.1f'
						end
					else
						return ''
					end
				end,
				showTimeAfterCast = true,
			},
		}
		t.row2 = {
			[194223] = { -- Celestial Alignment
				order = 5,
				level = 48,
				showTimeAfterCast = true,
			},
			[205636] = { -- Force of Nature
				order = 7,
				showFunc = function()
					return select(4, GetTalentInfo(1, 3, 1))
				end,
				showTimeAfterCast = true,
			},
			[22812] = { -- Barkskin
				order = 3,
				ignoreGCD = true,
			},
			[319454] = { -- Heart of the Wild
				order = 20,
				showFunc = function()
					return select(4, GetTalentInfo(4, 3, 1))
				end,
			},
		}
		t.row3 = {
			[190984] = { -- Solar Wrath
				order = 3,
				range = true,
				customText = function()
					local c = GetSpellCount(190984)
					return c == 0 and "" or c
				end,
				stack = true,
				stackFunc = function()
					local count, duration, expirationTime, value1, value2, value3 = iCD.UnitBuff('player', 'Eclipse (Solar)')
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
			[194153] = { -- Lunar Strike
				order = 4,
				cost = true,
				range = true,
				customText = function()
					local c = GetSpellCount(194153)
					return c == 0 and "" or c
				end,
				stack = true,
				stackFunc = function()
					local count, duration, expirationTime, value1, value2, value3 = iCD.UnitBuff('player', 'Eclipse (Lunar)')
					
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
			[18562] = { -- Swiftmend
				showFunc = function()
					return select(4, GetTalentInfo(3, 3, 1))
				end,
				showTimeAfterGCD = true,
			},
			[48438] = { -- Wild Growth
				showFunc = function()
					return select(4, GetTalentInfo(3, 3, 1))
				end,
				showTimeAfterGCD = true,
			},
			[1850] = {}, -- Dash
			[5215] = {}, -- Prowl
			[5211] = { -- Mighty Bash
				showFunc = function()
					return select(4, GetTalentInfo(4, 1, 1))
				end,
			},
			[132469] = { -- Typhoon
				showFunc = function()
					return select(4, GetTalentInfo(4, 3, 1))
				end,
			},
			[102359] = { -- Mass Entanglement
				showFunc = function()
					return select(4, GetTalentInfo(4, 2, 1))
				end,
			},
			[2782] = {}, --Remove Corruption
			[6795] = {}, -- Growl
			[102401] = { -- Wild Charge
				showFunc = function()
					return select(4, GetTalentInfo(2, 3, 1))
				end,
			},
		}
		t.buffsI = {
			[164812] = {  -- Moonfire
				debuff = true,
			},
			[164815] = { -- Sunfire
				debuff = true,
			},
			[191034] = {}, -- Starfall
		}
		t.buffsC = {
			[194223] = {}, -- Celestial Alignment
		}
	elseif specID == 103 then -- Feral
		iCD.outOfRangeSpells = {
			main = 'Shred',
			range = 'Moonfire',
		}
		t.power = {
			func = function()
				local form = GetShapeshiftFormID()
				if form then
					if form == 5 then -- Bear form
						local Ironfur = select(2, IsUsableSpell('Ironfur'))
						return (not Ironfur and '|cff00ff00' or '') .. UnitPower('player', 1)
					elseif form == 1 then
						return UnitPower('player', 3)
					end
				end
				return math.floor(UnitPower('player', 0)/UnitPowerMax('player', 0))*100
			end,
		}
		t.row1 = {
			-- Cat form
			[5217] = { -- Tiger's Fury
				order = 1,
				ignoreGCD = true,
			},
			[202028] = { -- Brutal Slash
				order = 6,
				range = true,
				stack = true,
				charges = true,

				showFunc = function()
					return select(4, GetTalentInfo(6, 2, 1))
				end,
				showTimeAfterGCD = true,
			},

			[5221] = { -- Shred
				order = 4,
				cost = true,
				range = true,
				glow = true,
				glowSound = true,
				showFunc = function()
					local form = GetShapeshiftFormID() or 0
					return form == CAT_FORM
				end,
			},
		}
		t.row2 = {
			[106951] = { -- Berserk
				order = 5,
				showFunc = function()
					return not select(4, GetTalentInfo(5, 3, 1))
				end,
			},
			[102543] = { -- Incarnation: King of the Jungle
				order = 5,
				showFunc = function()
					return select(4, GetTalentInfo(5, 3, 1))
				end,
			},
			[61336] = { -- Survival Instincts
				order = 10,
				ignoreGCD = true,
			},
		}
		t.row3 = {
			[1822] = { -- Rake
				order = 3,
				cost = true,
				range = true,
				customText = function()
					--local name, _, icon, count, debuffType, duration, expirationTime, _, _, _, spellID = UnitDebuff('target', 'Rake', nil, 'player')
					local count, duration, expirationTime, value1, value2, value3 = iCD.UnitDebuff('target', 'Rake', true)
					if duration then
						local dura = expirationTime - GetTime()
						if dura > 5 then
							return string.format('%.0f', dura)
						else
							return string.format('|cffff1a1a%.1f', dura)
						end
					else
						return ' '
					end
				end,
			},
			[1079] = { -- Rip
				order = 2,
				cost = true,
				customText = function()
					local count, duration, expirationTime, value1, value2, value3 = iCD.UnitDebuff('target', 'Rip', true)
					if duration then
						local dura = expirationTime - GetTime()
						if dura > 5 then
							return string.format('%.0f', dura)
						else
							return string.format('|cffff1a1a%.1f', dura)
						end
					else
						return ' '
					end
				end,
			},
			[106830] = { -- Thrash
				order = 1,
				cost = true,
				customText = function()
					local count, duration, expirationTime, value1, value2, value3 = iCD.UnitDebuff('target', 'Thrash', true)
					if duration then
						local dura = expirationTime - GetTime()
						if dura > 5 then
							return string.format('%.0f', dura)
						else
							return string.format('|cffff1a1a%.1f', dura)
						end
					else
						return ' '
					end
				end,
			},
		}
		t.row4 = {
			[1850] = {}, -- Dash
			[22570] = {}, -- Maim
			[5215] = {}, -- Prowl
			[5211] = { -- Mighty Bash
				showFunc = function()
					return select(4, GetTalentInfo(4, 1, 1))
				end,
			},
			[132469] = { -- Typhoon
				showFunc = function()
					return select(4, GetTalentInfo(4, 3, 1))
				end,
			},
			[2782] = {}, --Remove Corruption
			[77764] = {}, --Stampeding Roar
			[6795] = {}, -- Growl
			[102401] = { -- Wild Charge
				showFunc = function()
					return select(4, GetTalentInfo(2, 3, 1))
				end,
			},
		}
		t.buffsI = {
			[69369] = {}, -- Predatory Swiftness
			[145152] = { -- Bloodtalons
				stack = true,
				showFunc = function()
					return select(4, GetTalentInfo(7, 2, 1))
				end,
			},
			[5217] = {}, -- Tiger's Fury
		}
	elseif specID == 104 then -- Guardian
		iCD.outOfRangeSpells = {
			main = 'Maul',
			range = 'Moonfire',
		}
		--gcd = 8921, -- Moonfire
		t.power = {
			func = function()
				local form = GetShapeshiftFormID()
				if form then
					if form == 5 then -- Bear form
						local Ironfur = select(2, IsUsableSpell('Ironfur'))
						return (not Ironfur and '|cff00ff00' or '') .. UnitPower('player', 1)
					elseif form == 1 then
						return UnitPower('player', 3)
					end
				end
				return math.floor(UnitPower('player', 0)/UnitPowerMax('player', 0)*100)
			end,
		}
		t.row1 = {
			[77758] = { -- Trash
				order = 6,
				range = true,
				customRange = function()
					if UnitExists('target') then
						return IsSpellInRange('Maul', 'target') == 1
					else
						return true
					end
				end,
				stack = true,
				stackFunc = function()
					local count, duration, expirationTime, value1, value2, value3 = iCD.UnitDebuff('target', 'Thrash', true)
					if expirationTime then
						local dura = expirationTime - GetTime()
						if dura < 5 then
							return dura, '|cffff1a1a%.1f'
						else
							return count
						end
					else
						return ''
					end
				end,
				showFunc = function()
					local form = GetShapeshiftFormID() or 0
					return form == BEAR_FORM
				end,
				showTimeAfterGCD = true,
			},
			[33917] = { -- Mangle
				order = 4,
				range = true,
				glow = true,
				glowSound = true,
				showFunc = function()
					local form = GetShapeshiftFormID() or 0
					return form == BEAR_FORM
				end,
				showTimeAfterGCD = true,
			},
			[8921] = { -- Moonfire
				order = 10,
				range = true,
				glow = true,
				glowSound = 'text1',
				stack = true,
				stackFunc = function()
					local count, duration, expirationTime, value1, value2, value3 = iCD.UnitBuff('player', 'Galactic Guardian', nil, 'player')
					if expirationTime then
						local dura = expirationTime - GetTime()
						return string.format('%.0f', dura)
					else
						return ''
					end
				end,
				showFunc = function()
					local form = GetShapeshiftFormID() or 0
					return form == BEAR_FORM or form == 0 or form == 3
				end,
			},
			[80313] = { -- Pulverize
				order = 6,
				range = true,
				showFunc = function()
					local form = GetShapeshiftFormID() or 0
					return form == BEAR_FORM and select(4, GetTalentInfo(7, 3, 1))
				end,
			},
			-- Caster form
			[18562] = { -- Swiftmend
				order = 5,
				showFunc = function()
					local form = GetShapeshiftFormID() or 0
					return select(4, GetTalentInfo(3, 3, 1)) and (form == 0 or form == 3)
				end,
				showTimeAfterGCD = true,
			},
			[339] = { -- Entangling Roots
				order = 15,
				range = true,
				showFunc = function()
					local form = GetShapeshiftFormID() or 0
					return form == 0 or form == 3
				end,
				showTimeAfterGCD = true,
			},
		}
		t.row2 = {
			[22812] = { -- Barkskin
				order = 3,
				ignoreGCD = true,
			},
			[61336] = { -- Survival Instincts
				order = 4,
				charges = true,
				stack = true,
			},
			[50334] = { -- Berserk
				order = 5,
				ignoreGCD = true,
			},
			[102558] = { -- Incarnation: Guardian of Ursoc
				order = 7,
				showFunc = function()
					return select(4, GetTalentInfo(5, 3, 1))
				end,
			},
			[155835] = { -- Bristling Fur
				order = 8,
				showFunc = function()
					return select(4, GetTalentInfo(1, 3, 1))
				end,
			},
			[319454] = { -- Heart of the Wild
				order = 20,
				showFunc = function()
					return select(4, GetTalentInfo(4, 3, 1))
				end,
			},
		}
		t.row3 = {
			[22842] = { -- Frenzied Regeneration
				order = 3,
				stack = true,
				charges = true,
			},
		}
		t.row4 = {
			[1850] = { -- Dash
				showFunc = function()
					return not select(4, GetTalentInfo(2, 1, 1))
				end,
			},
			[99] = {}, -- Incapacitating Roar
			[252216] = { -- Tiger Dash
				showFunc = function()
					return select(4, GetTalentInfo(2, 1, 1))
				end,
			},
			[5211] = { -- Mighty Bash
				showFunc = function()
					return select(4, GetTalentInfo(4, 1, 1))
				end,
			},
			[132469] = { -- Typhoon
				showFunc = function()
					return select(4, GetTalentInfo(4, 3, 1))
				end,
			},
			[102359] = { -- Mass Entanglement
				showFunc = function()
					return select(4, GetTalentInfo(4, 2, 1))
				end,
			},
			[2782] = {}, --Remove Corruption
			[77761] = {}, --Stampeding Roar
			[6795] = {}, -- Growl
			[102401] = { -- Wild Charge
				showFunc = function()
					return select(4, GetTalentInfo(2, 3, 1))
				end,
			},
			[18562] = { -- Swiftmend
				showFunc = function()
					return select(4, GetTalentInfo(3, 3, 1))
				end,
				showTimeAfterGCD = true,
			},
			[48438] = { -- Wild Growth
				showFunc = function()
					return select(4, GetTalentInfo(3, 3, 1))
				end,
				showTimeAfterGCD = true,
			},
			[102793] = { -- Ursol's Vortex
				showFunc = function()
					return select(4, GetTalentInfo(2, 2, 1))
				end,
				showTimeAfterGCD = true,
			},
			[5215] = {} -- Prowl
		}
		t.row5 = {
			[61336] = {}, -- Survival Instincts
			[22812] = {}, -- Barkskin
			[80313] = { -- Pulverize
				debuff = true,
			},
		}
		t.buffsI = {
			[22842] = {}, -- Frenzied Regeneration
			[213680] = { -- Guardian of Elune
				showFunc = function()
					return select(4, GetTalentInfo(6, 3, 1))
				end,
			},
			[50334] = {}, -- Berserk
			[102558] = { -- Incarnation
				showFunc = function()
					local talent = select(4, GetTalentInfo(5, 3, 1))
					local essence = iCD:Essences(22, true)
					return (talent or essence) and true or false
				end,
			},
			[155835] = { -- Bristling Fur
				showFunc = function()
					return select(4, GetTalentInfo(1, 3, 1))
				end,
			},
			[279943] = { -- Pvp maul thrash
				stack = "+D",
			},
			[203975] = { -- Earthwarden
				stack = true,
				showFunc = function()
					return select(4, GetTalentInfo(6, 1, 1))
				end,
			},
			[158792] = { -- Pulverize
				showFunc = function()
					return select(4, GetTalentInfo(7, 3, 1))
				end,
			},
		}
		t.buffsC = {
			[279541] = { -- Guardian's Wrath
				stack = true,
				azerite = 361,
			},
		}
	elseif specID == 105 then -- Restoration
		--gcd = 8921, -- Moonfire
		iCD.outOfRangeSpells = {
			main = 'Moonfire',
			range = 'Moonfire',
		}
		t.power = {
			func = function()
				local form = GetShapeshiftFormID()
				if form then
					if form == 5 then -- Bear form
						return UnitPower('player', 1)
					elseif form == 1 then
						return UnitPower('player', 3)
					end
				end
				return math.floor(UnitPower('player', 0)/UnitPowerMax('player', 0)*100)
			end,
		}
		t.row1 = {
			[18562] = { -- Swiftmend
				order = 1,
				range = true,
				cost = true,
				showTimeAfterCast = true,
			},
			[48438] = { -- Wild Growth
				order = 3,
				range = true,
				cost = true,
				level = 40,
				showTimeAfterCast = true,
			},
			[203651] = { -- Overgrowth
				order = 10,
				cost = true,
				showTimeAfterCast = true,
				showFunc = function()
					return select(4, GetTalentInfo(5, 3, 1))
				end,
			},
			[102351] = { -- Cenarion Ward
				order = 10,
				cost = true,
				showTimeAfterCast = true,
				showFunc = function()
					return select(4, GetTalentInfo(1, 3, 1))
				end,
			},
			[197626] = { -- Starsurge
				order = 20,
				range = true,
				cost = true,
				showFunc = function()
					return select(4, GetTalentInfo(3, 1, 1))
				end,
			},
			[197628] = { -- Starfire
				order = 21,
				range = true,
				cost = true,
				showFunc = function()
					return select(4, GetTalentInfo(3, 1, 1))
				end,
				customText = function()
					local c = GetSpellCount(197628)
					return c > 0 and c or ''
				end,
				glow = true,
			},
			[5176] = { -- Wrath
				order = 22,
				range = true,
				cost = true,
				showFunc = function()
					return select(4, GetTalentInfo(3, 1, 1))
				end,
				customText = function()
					local c = GetSpellCount(5176)
					return c > 0 and c or ''
				end,
				glow = true,
			},
		}
		t.row2 = {
			[197721] = { -- Flourish
				order = 2,
				showFunc = function()
					return select(4, GetTalentInfo(7, 3, 1))
				end,
			},
			[108238] = { -- Renewal
				order = 3,
				showFunc = function()
					return select(4, GetTalentInfo(2, 2, 1))
				end,
			},
			[740] =  { -- Tranquility
				order = 4,
				--level = 80,
			},
			[22812] = { -- Barkskin
				order = 5,
				ignoreGCD = true,
			},
			[102342] = { -- Ironbark
				order = 6,
				ignoreGCD = true,
				--level = 54,
			},
			[132158] = { -- Nature's Swiftness
				order = 7,
				ignoreGCD = true,
			},
			[29166] = { -- Innervate
				order = 8,
				--level = 50,
			},
			[33891] = { -- Incarnation
				order = 10,
				showFunc = function()
					return select(4, GetTalentInfo(5, 3, 1))
				end,
			}
		}
		t.row4 = {
			[88423] = {}, -- Nature's Cure
			[102793] = {}, -- Ursol's Vortex
			[1850] = {}, -- Dash
			[5215] = {}, -- Prowl
			[5211] = { -- Mighty Bash
				showFunc = function()
					return select(4, GetTalentInfo(4, 1, 1))
				end,
			},
			[132469] = { -- Typhoon
				showFunc = function()
					return select(4, GetTalentInfo(3, 1, 1))
				end,
			},
			[6795] = {}, -- Growl
			[102401] = { -- Wild Charge
				showFunc = function()
					return select(4, GetTalentInfo(2, 3, 1))
				end,
			},
			[102359] = { -- Mass Entanglement
				showFunc = function()
					return select(4, GetTalentInfo(4, 2, 1))
				end,
			},
			[319454] = { -- Heart of the Wild
				showFunc = function()
					return select(4, GetTalentInfo(4, 3, 1))
				end,
			},
		}
		t.row5 = {
			[22812] = {}, -- Barkskin
		}
		t.buffsI = {
			[208253] = {}, -- Essence of G'hanir
			[29166] = {}, -- Innervate
			[16870] = { -- Clearcasting
				stack = true,
			},
			[117679] = { -- Incarnation: Tree of Life
				showFunc = function()
					return select(4, GetTalentInfo(5, 3, 1))
				end,
			},
			[164815] = { -- Sunfire
				debuff = true,
			},
			[164812] = { -- Moonfire
				debuff = true,
			},
			[155722] = { -- Rake
				debuff = true,
			},
			[1079] = { -- Rip
				debuff = true,
			},
			[48518] = {
				stack = 'SF',
			},
			[48517] = {
				stack = "W",
			},
		}
	end
	return temp
end
