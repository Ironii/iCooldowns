local _, iCD = ...
function iCD:WARLOCK(specID)
	local temp = {}
	temp.spec = {}
	temp.all = {}
	temp.all.row1 = {}
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
	if specID == 265 then -- Affliction
		--gcd = 162243, -- Demon's Bite
		iCD.outOfRangeSpells = {
			main = 'Corruption',
			range = 'Corruption',
		}
		t.power = {
			func = function()
				return math.floor((UnitPower('player', 0)/UnitPowerMax('player', 0))*100)
			end,
		}
		t.row1 = {
			[48181] = { -- Haunt
				order = 5,
				range = true,
				cost = true,
				showFunc = function()
					return select(4, GetTalentInfo(6, 2, 1))
				end,
				showTimeAfterCast = true,
			},
			[205179] = { -- Phantom Singularity
				order = 9,
				range = true,
				showFunc = function()
					return select(4, GetTalentInfo(4, 2, 1))
				end,
			},
			[278350] = { -- Vile Taint
				order = 9,
				cost = true,
				showTimeAfterCast = true,
				showFunc = function()
					return select(4, GetTalentInfo(4, 3, 1))
				end,
			},
		}
		t.row2 = {
			[104773] = { -- Unending Resolve
				order = 5,
				ignoreGCD = true,
			},
			[205180] = { -- Summon Darkglare
				order = 3,
			},
			[113860] = { -- Dark Soul: Misery
				order = 4,
				showFunc = function()
					return select(4, GetTalentInfo(7, 3, 1))
				end,
				ignoreGCD = true,
			},
			[108416] = { -- Dark Pact
				order = 10,
				showFunc = function()
					return select(4, GetTalentInfo(3, 3, 1))
				end,
				ignoreGCD = true,
			},
		}
		t.row3 = {
			[172] = { -- Corruption
				order = 3,
				customText = function(data, gcdInfo)
					local count, duration, expirationTime, value1, value2, value3 = iCD.UnitDebuff('target', 'Corruption', true)
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
			[980] = { -- Agony
				order = 4,
				customText = function(data, gcdInfo)
					local count, duration, expirationTime, value1, value2, value3 = iCD.UnitDebuff('target', 'Agony', true)
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
			[30108] = { -- Unstable Affliction
				order = 2,
				customText = function(data, gcdInfo)
					local count, duration, expirationTime, value1, value2, value3 = iCD.UnitDebuff('target', 'Unstable Affliction', true)
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
			[63106] = { -- Siphon Life
				order = 1,
				showFunc = function()
					return select(4, GetTalentInfo(2,3,1))
				end,
				customText = function(data, gcdInfo)
					local count, duration, expirationTime, value1, value2, value3 = iCD.UnitDebuff('target', 'Siphon Life', true)
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

			[111771] = {}, -- Demonic Gateway
			[6789] = { -- Mortal Coil
				showFunc = function()
					return select(4, GetTalentInfo(5,2,1))
				end,
			},
			[30283] = {}, -- Shadowfury
			[119910] = {}, -- Spell Lock
			[19505] = {}, -- Devour Magic
		}
		t.buffsC = {  -- Burning Rush
			[111400] = {
				showFunc = function()
					return select(4, GetTalentInfo(3,2,1))
				end,
			},
			[334320] = { -- Inevitable Demise
				stack = true,
				showFunc = function()
					return select(4, GetTalentInfo(1,2,1))
				end,
			},
		}
		t.buffsI = {
			--[[
			[233490] = { -- Unstable Affliction #1
				debuff = true,
			},
			[233496] = { -- Unstable Affliction #2
				debuff = true,
			},
			[233497] = { -- Unstable Affliction #3
				debuff = true,
			},
			[233498] = { -- Unstable Affliction #4
				debuff = true,
			},
			[233499] = { -- Unstable Affliction #5
				debuff = true,
			},
			[172] = { -- Corruption
				debuff = true,
			},
			[146739] = { -- Corruption
				debuff = true,
			},
			[980] = { -- Agony
				stack = true,
				debuff = true,
			},
			[63106] = { -- Siphon Life
				debuff = true,
				showFunc = function()
					return select(4, GetTalentInfo(2,3,1))
				end,
			},
			]]
			[205179] = { -- Phantom Singularity
				debuff = true,
				showFunc = function()
					return select(4, GetTalentInfo(4,2,1))
				end,
			},
			[48181] = { -- Haunt
				debuff = true,
				showFunc = function()
					return select(4, GetTalentInfo(6,2,1))
				end,
			},
		}
	elseif specID == 266 then --Demonology
		iCD.outOfRangeSpells = {
			main = 'Shadow bolt',
			range = 'Shadow bolt',
		}
		t.power = {
			func = function()
				return math.floor((UnitPower('player', 0)/UnitPowerMax('player', 0))*100)
			end,
		}
		t.row1 = {
			[104316] = { -- Call Dreadstalkers
				order = 5,
				range = true,
				cost = true,
				showTimeAfterCast = true,
				stack = true,
				stackFunc = function()
					local count, duration, expirationTime, value1, value2, value3 = iCD.UnitBuff('player', 'Demonic Calling')
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
			[267211] = { -- Bilescourge Bombers
				order = 7,
				cost = true,
				showFunc = function()
					return select(4, GetTalentInfo(1, 2, 1))
				end,
				showTimeAfterCast = true,
			},
			[264057] = { -- Soul Strike
				order = 3,
				range = true,
				showFunc = function()
					return select(4, GetTalentInfo(4, 2, 1))
				end,
				showTimeAfterCast = true,
			},
			[264119] = { -- Summon Vilefiend
				order = 3,
				range = true,
				cost = true,
				showFunc = function()
					return select(4, GetTalentInfo(4, 3, 1))
				end,
				showTimeAfterCast = true,
			},
			[267171] = { -- Demonic Strength
				order = 7,
				showFunc = function()
					return select(4, GetTalentInfo(1, 3, 1))
				end,
				showTimeAfterCast = true,
			},
		}
		t.row2 = {
			[265187] = { -- Summon Demonic Tyrant
				order = 2,
				showTimeAfterCast = true,
			},
			[267171] = { -- Demonic Strength
				order = 3,
				showFunc = function()
					return select(4, GetTalentInfo(1, 2, 1))
				end,
				showTimeAfterCast = true,
			},
			[111898] = { -- Grimoire: Felguard
				order = 5,
				range = true,
				cost = true,
				showFunc = function()
					return select(4, GetTalentInfo(6, 3, 1))
				end,
				showTimeAfterCast = true,
			},
			[6789] = { -- Mortal Coil
				order = 7,
				cost = true,
				range = true,
				showFunc = function()
					return select(4, GetTalentInfo(5, 2, 1))
				end,
			},
			[104773] = { -- Unending Resolve
				order = 9,
				ignoreGCD = true,
			},
		}
		t.row3 = {
			[196277] = { -- Implosion
				order = 3,
				customText = function() return GetSpellCount(196277) end,
				stack = true,
				stackFunc = function()
					local count, duration, expirationTime, value1, value2, value3 = iCD.UnitBuff('player', 'Explosive Potential')
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
			[603] = { -- Doom
				order = 1,
				showFunc = function()
					return select(4, GetTalentInfo(2,3,1))
				end,
				customText = function(data, gcdInfo)
					local count, duration, expirationTime, value1, value2, value3 = iCD.UnitDebuff('target', 'Doom', true)
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
			[111771] = {}, -- Demonic Gateway
			[6789] = { -- Mortal Coil
				showFunc = function()
					return select(4, GetTalentInfo(5,2,1))
				end,
			},
			[30283] = {}, -- Shadowfury
			[119910] = {}, -- Spell Lock
			[19505] = {}, -- Devour Magic
			[48020] = {}, -- Demonic Circle: Teleport
		}
		t.buffsC = {
		}
		t.buffsI = {
			[264173] = { -- Demonic Calling
				stack = true,
			},
		}
	elseif specID == 267 then --Destruction
				--gcd = 162243, -- Demon's Bite
				iCD.outOfRangeSpells = {
					main = 'Immolate',
					range = 'Immolate',
				}
				t.power = {
					func = function()
						return math.floor((UnitPower('player', 0)/UnitPowerMax('player', 0))*100)
					end,
				}
				t.row1 = {
					[17962] = { -- Conflagrate
						order = 5,
						range = true,
						stack = true,
						showTimeAfterCast = true,
					},
					[80240] = { -- Havoc
						order = 7,
						range = true,
						cost = true,
						showTimeAfterCast = true,
					},
					[152108] = { -- Cataclysm
						order = 2,
						showFunc = function()
							return select(4, GetTalentInfo(4, 3, 1))
						end,
						showTimeAfterCast = true,
					},
					[17877] = { -- Shadowburn
						stack = true,
						order = 10,
						cost = true,
						showFunc = function()
							return select(4, GetTalentInfo(4, 3, 1))
						end,
						showTimeAfterCast = true,
					},
				}
				t.row2 = {
					[1122] = { -- Summon Infernal
						order = 1,
					},
					[113858] = { -- Dark Soul: Instability
						order = 3,
						showFunc = function()
							return select(4, GetTalentInfo(7,3,1))
						end,
					},
					[104773] = { -- Unending Resolve
						order = 5,
						ignoreGCD = true,
					},
					[6789] = { -- Mortal Coil
						order = 5,
						showFunc = function()
							return select(4, GetTalentInfo(5, 2, 1))
						end,
					},
				}
				t.row3 = {
					[157736] = { -- Immolate
						order = 3,
						customText = function(data, gcdInfo)
							local count, duration, expirationTime, value1, value2, value3 = iCD.UnitDebuff('target', 'Immolate', true)
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
					[111771] = {}, -- Demonic Gateway
					[30283] = {}, -- Shadowfury
				}
				t.buffsC = {
				}
				t.buffsI = {
					[117828] = { -- Backdraft
						stack = true,
					},
					[266091] = { -- Grimoire of Supremacy
						stack = true,
					},
					[279673] = { -- Chaotic Inferno (azerite)
						azerite = 432,
					},
				}
	end
	return temp
end
