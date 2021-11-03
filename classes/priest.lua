local _, iCD = ...
function iCD:PRIEST(specID)
	local temp = {}
	temp.spec = {}
	temp.all = {}
	temp.all.row1 = {
		[327661] = { -- Fae Guardians
			order = 999999, -- Always last
			showTimeAfterCast = true,
			covenant = iCD.covenants.NIGHTFAE
		},
		[325013] = { -- Boon of the Ascended
			order = 999999, -- Always last
			showTimeAfterCast = true,
			covenant = iCD.covenants.KYRIAN
		},
	}
	temp.all.row2 = {
		[19236] = { -- Desperate Prayer
			order = 10,
		},
		[10060] = { -- Power Infusion
			order = 6,
			showTimeAfterCast = true,
		},
	}
	temp.all.row3 = {}
	temp.all.row4 = {
		
	}
	temp.all.row5 = {}
	temp.all.buffsC = {}
	temp.all.buffsI = {
		[325013] = { -- Ascended Boon
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
	if specID == 256 then -- Discipline
		iCD.outOfRangeSpells = {
			main = 'Shadow Word: Pain',
			range = 'Shadow Word: Pain',
		}
		t.power = {
			func = function()
				return math.floor((UnitPower('player', 0)/UnitPowerMax('player', 0))*100)
			end,
		}
		t.row1 = {
			[47540] = { -- Penance
				order = 3,
				cost = true,
				range = true,
				showTimeAfterCast = true,
			},
			[129250] = { -- Power Word: Solace
				order = 1,
				range = true,
				showTimeAfterCast = true,
				showFunc = function()
					return select(4, GetTalentInfo(3, 3, 1))
				end,
			},
			[8092] = { -- Mind Blast
				order = 5,
				cost = true,
				range = true,
				showTimeAfterCast = true,
			},
			[214621] = { -- Schism
				order = 6,
				range = true,
				cost = true,
				showTimeAfterCast = true,
				showFunc = function()
					return select(4, GetTalentInfo(1, 3, 1))
				end,
			},
			[194509] = { -- Power Word: Radiance
				order = 7,
				cost = true,
				stack = true,
			},
			[120517] = { -- Halo
				order = 10,
				range  = true,
				cost = true,
				showFunc = function()
					return select(4, GetTalentInfo(6, 3, 1))
				end,
			},
			[32379] = { -- Shadow Word: Death
				order = 20,
				range = true,
				cost = true,
				stack = true,
			},
		}
		t.row2 = {
			[62618] = { -- Power Word: Barrier
				order = 5,
				cost = true,
			},
			[47536] = { -- Rapture
				order = 8,
				cost = true,
				showFunc = function()
					return not select(4, GetTalentInfo(7, 2, 1))
				end,
			},
			[34433] = { -- Shadowfiend
				order = 4,
				showFunc = function()
					return not select(4, GetTalentInfo(3, 2, 1))
				end,
			},
			[123040] = { -- Mindbender
				order = 4,
				range = true,
				showFunc = function()
					return select(4, GetTalentInfo(3, 2, 1))
				end,
			},
			[19236] = { -- Desperate Prayer
				order = 2,
				ignoreGCD = true,
			},
			[586] = { -- Fade
				order = 20,
				ignoreGCD = true,
			},
			[33206] = { -- Pain Suppression
				order = 7,
				ignoreGCD = true,
			},
			[246287] = { -- Evangelism
				order = 9,
				range = true,
				showFunc = function()
					return select(4, GetTalentInfo(7, 3, 1))
				end,
			},
			[109964] = { -- Spirit Shell
				order = 9,
				range = true,
				showFunc = function()
					return select(4, GetTalentInfo(7, 2, 1))
				end,
			},
		}
		t.row3 = {
		}
		t.row4 = {
			[8122] = {}, -- Psychis Scream
			[528] = {}, -- Dispel Magic
			[213634] = {}, -- Purify Disease
			[32375] = {}, -- Mass Dispel
			[121536] = { -- Angelic Feather
				showFunc = function()
					return select(4, GetTalentInfo(2, 3, 1))
				end,
				stack = true,
			},
		}
		t.buffsC = {
		}
		t.buffsI = {
			[589] = { -- Shadow Word: Pain
				debuff = true,
			},
			[204213] = { -- Purge the Wicked
				debuff = true,
				showFunc = function()
					return select(4, GetTalentInfo(6, 1, 1))
				end,
			},
			[214621] = { -- Schism
				debuff = true,
				showFunc = function()
					return select(4, GetTalentInfo(1, 3, 1))
				end,
			},
			[47536] = {}, -- Rapture
		}
	elseif specID == 257 then --Holy
		iCD.outOfRangeSpells = {
			main = 'Shadow Word: Pain',
			range = 'Shadow Word: Pain',
		}
		t.power = {
			func = function()
				return math.floor((UnitPower('player', 0)/UnitPowerMax('player', 0))*100)
			end,
		}
		t.row1 = {
			[110744] = { -- Divine Star
				order = 17,
				cost = true,
				showTimeAfterCast = true,
				showFunc = function()
					return select(4, GetTalentInfo(6, 2, 1))
				end,
			},
			[120517] = { -- Halo
				order = 17,
				cost = true,
				showTimeAfterCast = true,
				showFunc = function()
					return select(4, GetTalentInfo(6, 3, 1))
				end,
			},
			[2061] = { -- Flash Heal
				range = true,
				order = 5,
				glow = true,
				stack = true,
				glowSound = "text1",
				customText = function()
						local count, duration, expirationTime, value1, value2, value3 = iCD.UnitBuff('player', 'Surge of Light')
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
				stackFunc = function()
					local count, duration, expirationTime, value1, value2, value3 = iCD.UnitBuff('player', 'Surge of Light')
						return count and count > 0 and count or ""
				end,
				showFunc = function()
					return select(4, GetTalentInfo(5, 1, 1))
				end,
			},
			[32379] = { -- Shadow Word: Death
				range = true,
				order = 18,
				glow = true,
				stack = true,
				glowSound = "text2",
				range = true,
			},
			[14914] = { -- Holy Fire
				order = 20,
				cost = true,
				range = true,
				glow = true,
				glowSound = true,
				showTimeAfterCast = true,
			},
			[88625] = { -- Holy Word: Chastise
				order = 22,
				cost = true,
				range = true,
				showTimeAfterCast = true,
			},
		}
		t.row2 = {
			[200183] = { -- Apotheosis
				order = 12,
				showFunc = function()
					return select(4, GetTalentInfo(7, 2, 1))
				end,
			},
			[265202] = { -- Holy World: Salvation
				order = 13,
				ignoreGCD = true,
				showFunc = function()
					return select(4, GetTalentInfo(7, 3, 1))
				end,
				showTimeAfterCast = true,
			},
			[64843] = { -- Divine Hymn
				order = 8,
				cost = true,
				showTimeAfterCast = true,
			},
			[586] = { -- Fade
				order = 20,
				ignoreGCD = true,
			},
			[47788] = { -- Guardian Spirit
				order = 10,
				ignoreGCD = true,
			},
		}
		t.row3 = {
			[204883] = { -- Circle of Healing
				order = 20,
				cost = true,
				showTimeAfterCast = true,
			},
			[33076] = { -- Prayer of Mending
				order = 15,
				cost = true,
				showTimeAfterCast = true,
			},
			[2050] = { -- Holy Word: Serenity
				order = 5,
				cost = true,
				showTimeAfterCast = true,
			},
			[34861] = { -- Holy Word: Sanctify
				order = 10,
				cost = true,
				showTimeAfterCast = true,
			},
		}
		t.row4 = {
			[73325] = {}, -- Leap of Faith
			[528] = {}, -- Dispel Magic
			[213634] = {}, -- Purify Disease
			[32375] = {}, -- Mass Dispel
			[64901] = {}, -- Symbol of Hope
			[204263] = { -- Shining Force
				showFunc = function()
					return select(4, GetTalentInfo(4, 3, 1))
				end,
			},
			[8122] = {}, -- Psychis Scream
			[121536] = { -- Angelic Feather
				showFunc = function()
					return select(4, GetTalentInfo(2, 3, 1))
				end,
				stack = true,
			},
		}
		t.row5 = {
			[27827] = {}, -- Spirit of Redemption
		}
		t.buffsC = {
		}
		t.buffsI = {
			[589] = { -- Shadow Word: Pain
				debuff = true,
			},
			[200183] = { -- Apotheosis
				showFunc = function()
					return select(4, GetTalentInfo(7, 2, 1))
				end,
			},
			[321379] = { -- Prayer Circle
				showFunc = function()
					return select(4, GetTalentInfo(5, 3, 1))
				end,
			},
			[336267] = { -- Flash Concentration (legendary)
				stack = true,
			},
			[337948] = {}, -- Holy Oration (conduit)
		}
	elseif specID == 258 then --Shadow
		iCD.outOfRangeSpells = {
			main = 'Shadow Word: Pain',
			range = 'Shadow Word: Pain',
		}
		t.power = {
			func = function()
				return math.floor((UnitPower('player', 13)/UnitPowerMax('player', 13))*100)
			end,
		}
		t.row1 = {
			[205448] = { -- Void Bolt
				order = 2,
				range = true,
				stack = true,
				stackFunc = function()
						local count, duration, expirationTime, value1, value2, value3 = iCD.UnitBuff('player', 'Voidform', true)
						if expirationTime then
							return "+"
						else
							return ''
						end
				end,
				glow = 343355,
				glowSound = true,
				showTimeAfterCast = true,
			},
			[8092] = { -- Mind Blast
				order = 3,
				range = true,
				glow = true,
				glowSound = true,
				range = true,
				showTimeAfterGCD = true,
				stack = true,
			},
			[32379] = { -- Shadow Word: Death
				range = true,
				order = 6,
				glow = true,
				showTimeAfterCast = true,
				stack = true,
				glowSound = "text2",
			},
			[205385] = { -- Shadow Crash
				order = 7,
				range = true,
				showFunc = function()
					return select(4, GetTalentInfo(5, 3, 1))
				end,
				showTimeAfterGCD = true,
			},
			[341374] = { -- Damnation
				order = 7,
				range = true,
				showFunc = function()
					return select(4, GetTalentInfo(6, 1, 1))
				end,
				showTimeAfterGCD = true,
			},

		}
		t.row2 = {
			[228260] = { -- Void Eruption
				order = 3,
				showTimeAfterCast = true,
			},
			[34433] = { -- Shadowfiend
				order = 5,
				showTimeAfterCast = true,
			},
			[586] = { -- Fade
				order = 9,
				ignoreGCD = true,
			},
			[47585] = { -- Dispersion
				order = 10,
			},
			[15286] = { -- Vampiric Embrace
				order = 23,
			},
		}
		t.row3 = {
			[34914] = { -- Vampiric Touch
				order = 4,
				customText = function(data, gcdInfo)
					local count, duration, expirationTime, value1, value2, value3 = iCD.UnitDebuff('target', 'Vampiric Touch', true)
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
			[589] = { -- Shadow Word:Pain
				order = 3,
				customText = function(data, gcdInfo)
					local count, duration, expirationTime, value1, value2, value3 = iCD.UnitDebuff('target', 'Shadow Word: Pain', true)
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
			[335467] = { -- Devouring Plague
				order = 5,
				customText = function(data, gcdInfo)
					local count, duration, expirationTime, value1, value2, value3 = iCD.UnitDebuff('target', 'Devouring Plague', true)
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
			[528] = {}, -- Dispel Magic
			[213634] = {}, -- Purify Disease
			[32375] = {}, -- Mass Dispel
			[205369] = { -- Mind Bomb
				showFunc = function()
					return select(4, GetTalentInfo(4, 2, 1))
				end,
			},
			[8122] = { -- Psychic Scream
				showFunc = function()
					return not select(4, GetTalentInfo(4, 2, 1))
				end,
			},
			[64044] = { -- Psychic Horror
				showFunc = function()
					return select(4, GetTalentInfo(4, 3, 1))
				end,
			},
		}
		t.row5 = {
			[47585] = {}, -- Dispersion
		}
		t.buffsC = {
		}
		t.buffsI = {
			[194249] = {}, -- Voidform
			[15286] = {}, -- Vampiric Embrace
		}
	end
	return temp
end
