local _, iCD = ...
function iCD:DEATHKNIGHT(specID)
	iCD.customSpellTimers[55233] = 0
	local temp = {}
	temp.spec = {}
	local t = temp.spec
	temp.all = {}
	temp.all.row1 = {
		[43265] = { -- Death and Decay
				order = 4,
				glow = true,
				row = 1,
				glow = 43265,
				glowSound = true,
				stack = true,
				stackFunc = function()
					local count, duration, expirationTime, value1, value2, value3 = iCD.UnitBuff('player', 'Death and Decay')
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
				customText = function()
					if iCD.customSpellTimers[43265] then
						local s,d = GetSpellCooldown(43265)
						if s == 0 then
							return ''
						end
						local dura =  iCD.customSpellTimers[43265] - GetTime()
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
				level = 3,
				--showTimeAfterGCD = true,
			},
			[311648] = {
				order = 1e4,
				cost = true,
				covenant = iCD.covenants.VENTHYR,
				customText = function()
					if iCD.customSpellTimers[311648] then
						local s,d = GetSpellCooldown(311648)
						if s == 0 then
							return ''
						end
						local dura =  iCD.customSpellTimers[311648] - GetTime()
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
				stack = true,
				stackFunc = function()
					local count, duration, expirationTime, value1, value2, value3 = iCD.UnitBuff('player', 'Swarming Mist')
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
				end
			},
	}
	temp.all.row2 = {
		[48707] = { -- Anti-Magic Shell
			order = 8,
			level = 9,
		},
		[48792] = { -- Icebound Fortitude
			order = 12,
			level = 38,
		},
		[51052] = { -- Anti-Magic Zone
			order = 20,
			level = 47,
		},
		[49039] = { -- Lichborne
			order = 22,
			ignoreGCD = true,
			level = 33,
		},
		[327574] = { -- Sacrifical Pact
			order = 11,
			level = 54,
			cost = true,
		},
	}
	temp.all.row3 = {}
	temp.all.row4 = {
		[56222] = { -- Dark Command
			ignoreGCD = true,
		}, 
		[49576] = { -- Death Grip
			stack = true,
		},
		[48265] = {}, -- Death's Advance
	}
	temp.all.row5 = {
		[48707] = { -- Anti-Magic Shell
			stack = true,
			stackFunc = function()
				local amount = select(5, iCD.UnitBuff('player', 'Anti-Magic Shell'))
				if amount then
					return math.floor(amount/1e3)
				else
					return ""
				end
			end,
		},
		[48792] = {}, -- Icebound Fortitude
		[49039] = {}, -- Lichborne
	}
	temp.all.buffsC = {}
	temp.all.buffsI = {
		[326918] = { -- Rune of Hysteria
			stack = "+RP",
		},
		[48265] = {}, -- Death's Advance
	}
	t.row1 = {}
	t.row2 = {}
	t.row3 = {}
	t.row4 = {}
	t.row5 = {}
	t.buffsC = {}
	t.buffsI = {}
	if specID == 250 then -- Blood
		iCD.outOfRangeSpells = {
			main = 'Death Strike',
			range = 'Death Grip',
		}
		t.power = {
			func = function()
				local DS = select(2, IsUsableSpell('Death Strike'))
				return (not DS and '|cff00ff00' or '') .. UnitPower('player', 6)
			end,
		}
		t.row1 = {
			[206931] = { -- Blooddrinker
				order = 1,
				showTimeAfterGCD = true,
				range = true,
				customText = function()
					if iCD.customSpellTimers[206931] then
						local dura =  iCD.customSpellTimers[206931] - GetTime()
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
				showFunc = function()
					return select(4, GetTalentInfo(1, 2, 1))
				end,
			},
			[50842] = { -- Blood Boil
				order = 2,
				row = 1,
				stack = true,
				showTimeAfterGCD = true,
				level = 17,
			},	
			[274156] = { -- Consumption
				order = 5,
				showTimeAfterGCD = true,
				showFunc = function()
					return select(4, GetTalentInfo(2, 3, 1))
				end,
			},
			[194844] = { -- Bonestorm
				order = 25,
				showFunc = function()
					return select(4, GetTalentInfo(7, 3, 1))
				end,
				showTimeAfterGCD = true,
			},
			[46585] = {  -- Raise Dead
				order = 1e5,
			},
		}
		t.row2 = {
			[194679] = { -- Rune Tap
				order = 3,
				stack = true,
				ignoreGCD = true,
				level = 44,
			},
			[219809] = { -- Tombstone
				order = 4,
				showFunc = function()
					return select(4, GetTalentInfo(1, 3, 1))
				end,
				cost = true,
			},
			[55233] = { -- Vampiric Blood
				order = 6,
				level = 29,
			},
			[49028] = { -- Dancing Rune Weapon
				order = 10,
				range = true,
				level = 34,
			},

		}
		t.row4 = {
			[221562] = {}, -- Asphyxiate
			[108199] = {}, -- Gorefiend's Grasp
			[212552] = { -- Wraith Walk
				showFunc = function()
					return select(4, GetTalentInfo(5, 3, 1))
				end,
			}, 
			[206940] = { -- Mark of Blood
			showFunc = function()
				return select(4, GetTalentInfo(4, 3, 1))
			end,
			},
			[48743] = { -- Death Pact
				showFunc = function()
					return select(4, GetTalentInfo(6, 2, 1))
				end,
			},
		}
		t.row5 = {
			[55233] = {}, -- Vampiric Blood			
			[81256] = {}, -- Dancing Rune Weapon
			[194679] = {}, -- Rune Tap
		}
		t.buffsI = {
			[195181] = { -- Bone shield
				stack = true,
			},
			[206940] = { -- Mark of Blood
				showFunc = function()
					return select(4, GetTalentInfo(4, 3, 1))
				end,
				debuff = true,
			},
			[212552] = { -- Wraith Walk
				showFunc = function()
					return select(4, GetTalentInfo(5, 3, 1))
				end,
			},
			[77535] = { -- Blood Shield
				stack = true,
				stackFunc = function()
					local amount = select(4, iCD.UnitBuff('player', 'Blood Shield'))
					if amount then
						return math.floor((amount/UnitHealthMax('player'))*100)
					else
						return 0
					end
				end,
			},
			[235559] = { -- Heamostasis
				customText = function()
					local count = iCD.UnitBuff('player', 'Haemostasis', nil, 'player')
					if count then
						return count > 0 and count or ''
					else
						return ''
					end
				end,
				showFunc = function()
					return (IsEquippedItem(144281) or select(4, GetTalentInfo(2, 2, 1)))
				end,
			},
			[273947] = { -- Hemostasis
				customText = function()
					local count = iCD.UnitBuff('player', 'Hemostasis', nil, 'player')
					if count then
						return count > 0 and count or ''
					else
						return ''
					end
				end,
				showFunc = function()
					return (IsEquippedItem(144281) or select(4, GetTalentInfo(2, 2, 1)))
				end,
			},
			[219809] = { -- Tombstone
				showFunc = function()
					return select(4, GetTalentInfo(1, 3, 1))
				end,
				stack = true,
				stackFunc = function()
					local count, duration, expirationTime, value1, value2, value3 = iCD.UnitBuff('player', 'Tombstone', nil, 'player')
					if value2 then
						return value2/1e3, '%.0f'
					else
						return ''
					end
				end,
			},
		}
		t.buffsC = {
			[194844] = { -- Bonestorm
				showFunc = function()
					return select(4, GetTalentInfo(7, 3, 1))
				end,
			},
			[242010] = {}, -- Gravewarden
			[238698] = {
				stack = '+L',
			}
		}
	elseif specID == 251 then -- Frost
		iCD.outOfRangeSpells = {
			main = 'Death Strike',
			range = 'Death Grip',
		}
		t.power = {
			func = function()
				local DS = select(2, IsUsableSpell('Frost Strike'))
				return (not DS and '|cff00ff00' or '') .. UnitPower('player', 6)
			end,
		}
		t.row1 = {
			[49184] = { -- Howling Blast
				order = 10,
				range = true,
				cost = true,
				showTimeAfterGCD = true,
				stack = true,
				stackFunc = function()
					local count, duration, expirationTime, value1, value2, value3 = iCD.UnitBuff('player', 'Rime')
					--local name, _, icon, count, debuffType, duration, expirationTime, _, _, _, spellID = UnitBuff('player', 'Rime')
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
				glow = true,
				glowSound = 'text1',
			},
			[49020] = { -- Obliterate
				order = 5,
				level = 14,
				range = true,
				cost = true,
				showTimeAfterGCD = true,
				stack = true,
				stackFunc = function()
					local count, duration, expirationTime, value1, value2, value3 = iCD.UnitBuff('player', 'Killing Machine')
					--local name, _, icon, count, debuffType, duration, expirationTime, _, _, _, spellID = UnitBuff('player', 'Killing Machine')
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
				glow = true,
				glowSound = true,
			},
			[196770] = { -- Remorseless Winter
				order = 3,
				cost = true,
				level = 19,
				stack = true,
				stackFunc = function()
					local count, duration, expirationTime, value1, value2, value3 = iCD.UnitBuff('player', 'Remorseless Winter')
					--local name, _, icon, count, debuffType, duration, expirationTime, _, _, _, spellID = UnitBuff('player', 'Killing Machine')
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
		t.row2 = {
			[51271] = { -- Pillar of Frost
				order = 3,
				level = 29,
			},
			[47568] = { -- Empowered Rune Weapon
				order = 6,
				level = 48,
			},
			[207256] = { -- Obliteration
				order = 4,
				showFunc = function()
					return select(4, GetTalentInfo(7, 2, 1))
				end,
			},
			[152279] = { -- Breath of Sindragosa
				order = 4,
				showFunc = function()
					return select(4, GetTalentInfo(7, 3, 1))
				end,
			},
		}
		t.row4 = {
			[221562] = {}, -- Asphyxiate
			[212552] = {}, -- Wraith Walk

		}
		t.row5 = {
			[81256] = {}, -- Dancing Rune Weapon
		}
		t.buffsI = {
			[51271] = {}, -- Pillar of Frost
			[207256] = {}, -- Obliteration
			[281209] = { -- Cold Heart
				stack = true,
			},
			[152279] = {}, -- Breath of Sindragosa
		}
		t.buffsC = {

		}
	elseif specID == 252 then --Unholy
			iCD.outOfRangeSpells = {
				main = 'Death Strike',
				range = 'Death Coil',
			}
			t.power = {
				func = function()
					local DS = select(2, IsUsableSpell('Death Coil'))
					return (not DS and '|cff00ff00' or '') .. UnitPower('player', 6)
				end,
			}

			t.row1 = {
				[47541] = { -- Death Coil
					range = true,
					cost = true,
					order = 1,
					glow = true,
					glowSound = true,
					stack = true,
					stackFunc = function()
						local count, duration, expirationTime, value1, value2, value3 = iCD.UnitBuff("player", "Sudden Doom")
						return count or " "
					end,
				},
				[343294] = { -- Soul Reaper
					range = true,
					order = 2,
					showFunc = function()
						return select(4, GetTalentInfo(4, 3, 1))
					end,
				},
				[63560] = { -- Dark Transformation
					range = true,
					order = 4,
				},
				[275699] = { --Apocalypse
					range = true,
					order = 5,
				},
				[115989] = { -- Unholy Blight
					range = true,
					order = 10,
					showFunc = function()
						return select(4, GetTalentInfo(2, 3, 1))
					end,
					cost = true,
				},
			}
			t.row2 = {
				[207289] = { -- Unholy Frenzy
					order = 3,
					showFunc = function()
						return select(4, GetTalentInfo(7, 3, 1))
					end,
				},
				[42650] = { -- Army of the Dead
					order = 4,
					cost = true,
				},
			}
			t.row4 = {
				[212552] = {  -- Wraith Walk
					showFunc = function()
						return select(4, GetTalentInfo(5, 2, 1))
					end,
				},
				[108194] = {  -- Asphyxiate
					showFunc = function()
						return select(4, GetTalentInfo(3, 3, 1))
					end,
				},
				[47481] = {}, -- Gnaw (pet)
				[47482] = {}, -- Leap (pet)
				[46585] = {},  -- Raise Dead
			}
			t.buffsC = {
				[274373] = { -- Festermight (trait)
					stack = true,
				},
			}
			t.buffsI = {
				[194310] = { -- Festering Wound
					debuff = true,
					stack = true,
				},
				[191587] = { -- Virulent Plague
					debuff = true,
				},
				[196782] = { -- Outbreak
					debuff = true,
				},
				[207289] = { -- Unholy Frenzy
					showFunc = function()
						return select(4, GetTalentInfo(7, 3, 1))
					end,
				},
				[343294] = { -- Soul Reaper
					showFunc = function()
						return select(4, GetTalentInfo(4, 3, 1))
					end,
				},
				[63560] = { -- Dark Transformation
					pet = true,
				},
			}

	end
	return temp
end
