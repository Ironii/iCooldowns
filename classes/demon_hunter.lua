local _, iCD = ...
function iCD:DEMONHUNTER(specID)
	local temp = {}
	temp.spec = {}
	temp.all = {}
	temp.all.row1 = {
		[306830] = { -- Elysian Decree
			order = 99999, -- Always last
			showTimeAfterGCD = true,
			covenant = iCD.covenants.KYRIAN
		},
	}
	temp.all.row2 = {}
	temp.all.row3 = {}
	temp.all.row4 = {}
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
	if specID == 577 then --Havoc
		--gcd = 162243, -- Demon's Bite
		iCD.outOfRangeSpells = {
			main = 'Chaos Strike',
			range = 'Throw Glaive',
		}
		t.power = {
			func = function()
				local p = UnitPower('player', 17)
				if p < 40 then
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
			[198013] = { -- Eye Beam
				order = 2,
				cost = true,
				range = true,
				showTimeAfterGCD = true,
			},
			[188499] = { -- Blade Dance
				order = 4,
				cost = true,
				showTimeAfterGCD = true,
			},
			[258920] = { -- Immolation Aura
				order = 6,
				stack = true,
				stackFunc = function()
					local count, duration, expirationTime, value1, value2, value3 = iCD.UnitBuff('player', 'Immolation Aura')
					if expirationTime then
						local dura = expirationTime - GetTime()
						return dura, '%.0f'
					else
						return ''
					end
				end,
				showTimeAfterGCD = true,

			},
			[342817] = { -- Glaive Tempest
				order = 5,
				showTimeAfterGCD = true,
				cost = true,
				showFunc = function()
					return select(4, GetTalentInfo(3, 3, 1))
				end,
			},
			[258925] = { -- Fel Barrage
				order = 8,
				showTimeAfterGCD = true,
				range = true,
				showFunc = function()
					return select(4, GetTalentInfo(7, 3, 1))
				end,
			},
			[232893] = { -- Felblade
				order = 7,
				range = true,
				glow = true,
				glowSound = true,
				showFunc = function()
					return select(4, GetTalentInfo(1, 3, 1))
				end,
				showTimeAfterGCD = true,
			},
			[185123] = { -- Throw Glaive
				order = 10,
				range = true,
				stack = true,
				showTimeAfterGCD = true,
			},
			[211881] = { -- Fel Eruption
				order = 10,
				range = true,
				cost = true,
				showFunc = function()
					return select(4, GetTalentInfo(6, 3, 1))
				end,
				showTimeAfterGCD = true,
			},
			[258860] = { -- Essence Break
				order = 10,
				showFunc = function()
					return select(4, GetTalentInfo(5, 3, 1))
				end,
				showTimeAfterGCD = true,
			},
		}
		t.row2 = {
			[191427] = { -- Metamorphosis
				order = 5,
			},
			[198793] = { -- Vengeful Retreat
				order = 7,
			},
			[195072] = { -- Fel Rush
				order = 8,
				stack = true,
			},
			[198589] = { -- Blur
				order = 10,
			},
			[196718] = { -- Darkness
				order = 12,
			},
		}
		t.row4 = {
			[179057] = {}, -- Chaos Nova
			[278326] = {}, -- Consume Magic
			[281854] = { -- Torment
				ignoreGCD = true,
			},
			[217832] = {}, -- Imprison
			[221527] = {}, -- Imprison (pvp)
			[188501] = {}, -- Spectral Sight
		}
		t.buffsI = {
			[162264] = {}, -- Metamorphosis
			[275936] = { -- Seething Power
				stack = true,
				azerite = 245,
			},
			[347462] = { -- Unbound Chaos
				showFunc = function()
					return select(4, GetTalentInfo(3, 2, 1))
				end,
			},
		}
		t.buffsC = {
			[212800] = { -- Blur
				stack = '-DT',
			},
			[273232] = { -- Furious Gaze
				stack = "+H",
				azerite = 159,
			},
		}
	elseif specID == 581 then --Vengeance
		iCD.outOfRangeSpells = {
			main = "Demon's Bite",
			range = "Consume Magic",
		}
		-- Row 1
		--gcd = 203782,
		t.power = {
			pos = {
				from = "bottomright",
      	to = "center",
      	x = -45,
				y = -72
			},
			fontSize = 16,
			func = function()
				local p = UnitPower('player', 17)
				if p < 30 then
					return p
				elseif p >= 120 then
					return '|cffff0000'..p
				else
					return '|cff00ff00'..p
				end
			end,
		}
		t.row1 = {
			[263642] = { -- Fracture
				order = 1,
				range = true,
				customRangeSpell = 'Shear',
				stack = true,
				showFunc = function()
					return select(4, GetTalentInfo(4, 3, 1))
				end,
				showTimeAfterGCD = true,
			},
			[232893] = { -- Felblade
				order = 3,
				range = true,
				glow = true,
				glowSound = true,
				showFunc = function()
					return select(4, GetTalentInfo(1, 3, 1))
				end,
				showTimeAfterGCD = true,
			},
			[258920] = { -- Immolation Aura
				order = 6,
				showTimeAfterGCD = true,
				stack = true,
				stackFunc = function()
					local count, duration, expirationTime, value1, value2, value3 = iCD.UnitBuff('player', 'Immolation Aura')
					if expirationTime then
						local dura = expirationTime - GetTime()
						return dura, '%.0f'
					else
						return ''
					end
				end,
			},
			[204596] = { -- Sigil of Flame
				order = 8,
				showTimeAfterGCD = true,
			},
			[204157] = { -- Throw Glaive
				order = 10,
				range = true,
				showTimeAfterGCD = true,
				customRangeSpell = "Consume Magic",
			},
			[212084] = { -- Fel Devastation
				order = 15,
				cost = true,
				showTimeAfterGCD = true,
			},
		}
		t.row2 = {
				[189110] = { -- Infernal Strike
					order = 1,
					stack = true,
					ignoreGCD = true,
				},
			[263648] = { -- Soul Barrier
				order = 2,
				showFunc = function()
					return select(4, GetTalentInfo(6, 3, 1))
				end,
				cost = true,
			},
			[204021] = { -- Fiery Brand
				order = 4,
				range = true,
				customRangeSpell = "Consume Magic",
			},
			[187827] = { -- Metamorphosis
				order = 5,
			},
			[202137] = { -- Sigil of Silence
				order = 6,
			},
			[202138] = { -- Sigil of Chains
				order = 8,
				showFunc = function()
					return select(4, GetTalentInfo(5, 3, 1))
				end,
			},

		}
		-- Row 3
		t.row3 = {
			[203720] = { -- Demon Spikes
				order = 2,
				stack = true,
				ignoreGCD = true,
				AM = function()
					local count, duration, expirationTime, value1, value2, value3 = iCD.UnitBuff('player', 'Demon Spikes')
					if expirationTime then
						local dura = expirationTime - GetTime()
						if dura + 6 > 18 then
							return true
						end
					end
					return
				end,
			},
		}
		t.row4 = {
			[217832] = {}, -- Imprison
			[202140] = {}, -- Sigil of Misery
			[188501] = {}, -- Specral Sight
			[185245] = { -- Torment
				ignoreGCD = true,
			},

			[278326] = {}, -- Consume Magic
		}
		t.row5 = {
			[207771] = { -- Fiery Brand
				debuff = true,
			},
			[187827] = {}, -- Metamorphosis
			[263648] = {  -- Soul Barrier
				stack = true,
				stackFunc = function()
					local v = select(5, iCD.UnitBuff('player', "Soul Barrier", nil, 'player'))
					if v then
						return v/1e3, '%.1f'
					else
						return ''
					end
				end
			},
		}
		t.buffsI = {
			[203819] = {}, -- Demon Spikes
			[204598] = { -- Sigil of Flame
				debuff = true,
			},
			[247456] = {
				debuff = true,
				showFunc = function()
					return select(4, GetTalentInfo(6, 2, 1))
				end,
			},
		}
		t.buffsC = {
			[275351] = { -- Rigid Carapace (trait)
				stack = true,
			},
			[278769] = { -- Cycle of Binding
				stack = "+Agi",
			},
			[288882] = { -- Hour of Reaping (trait)
				stack = true,
				stackFunc = function()
					local count = iCD.UnitBuff('player', 'Hour of Reaping')
					if count and count < 40 then
						return 40-count
					else
						return "SB"
					end
				end
			},
		}
	end
	return temp
end
