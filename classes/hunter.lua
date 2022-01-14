local _, iCD = ...
function iCD:HUNTER(specID)
	local temp = {}
	temp.spec = {}
	temp.all = {}
	temp.all.row1 = {
		[328231] = { -- Wild Spirits
			order = 9999,
			showTimeAfterGCD = true,
			covenant = iCD.covenants.NIGHTFAE,
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
	if specID == 253 then --Beastmastery
		iCD.outOfRangeSpells = {
			main = 'Tranquilizing Shot',
			range = 'Tranquilizing Shot',
		}
		t.power = {
			func = function()
				local p = UnitPower('player', 2)
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
			[217200] = { -- Barbed Shot
				order = 2,
				range = true,
				cost = true,
				stack = true,
				glow = true,
				glowSound = true,
				showTimeAfterGCD = true,
			},
			[34026] = { -- Kill Command
				order = 5,
				range = true,
				cost = true,
				showTimeAfterGCD = true,
			},
			[53351] = { -- Kill Shot
				order = 7,
				range = true,
				cost = true,
				customCost = function()
					local isUsable = IsUsableSpell("Kill Shot")
					return not isUsable
				end,
				showTimeAfterGCD = true,
				glow = true,
			},
			[53209] = { -- Chimaera Shot
				order = 10,
				range = true,
				showTimeAfterGCD = true,
				showFunc = function()
					return select(4, GetTalentInfo(2, 3, 1))
				end,
			},
			[120679] = { -- Dire Beast
				order = 14,
				range = true,
				stack = true,
				showFunc = function()
					return select(4, GetTalentInfo(1, 3, 1))
				end,
			},
			[131894] = { -- A Murder of Crows
				order = 18,
				range = true,
				showFunc = function()
					return select(4, GetTalentInfo(4, 3, 1))
				end,
				cost = true,
			},
		}
		t.row2 = {
			[193530] = { -- Aspect of the Wild
				order = 4,
			},
			[19574] = { -- Bestial Wrath
				order = 3,
			},
			[201430] = { -- Stampede
				order = 6,
				range = true,
				showFunc = function()
					return select(4, GetTalentInfo(6, 3, 1))
				end,
			},
			[186265] = { -- Aspect of the Turtle
				order = 10,
				ignoreGCD = true,
			},
			[109304] = { -- Exhilaration
				order = 8,
			},
		}
		t.row4 = {
			[186257] = {}, -- Aspect of the Cheetah
			[109248] = { -- Binding Shot
				showFunc = function()
					return select(4, GetTalentInfo(5, 3, 1))
				end,
			},
			[272679] = {}, -- Survival of the fittest (pet)
			[781] = {}, -- Disengage
			[5384] = {}, -- Feign Death
			[1543] = {}, -- Flare
			[34477] = {}, -- Misdirection
			[187650] = {}, -- Freezing Trap
			[187698] = {}, -- Tar Trap
			--[264265] = {}, -- Spirit Shock (pet)
			[90361] = {}, -- Spirit Mend (pet)
			[19577] = {}, -- Intimidation
			[136] = {}, -- Mend Pet
			[209997] = {}, -- Play Dead
			[19801] = {}, -- Tranquilizing Shot
		}
		t.buffsI = {
			[272790] = { -- Barbed Shot
				stack = true,
				pet = true,
			},
			[268877] = {}, -- Beast Cleave
			[274443] = {  -- Dance of Death (azerite)
				stack = "+A",
				azerite = 211,
			},
		}
		t.buffsC = {
			[186265] = {}, -- Turtle
			[19574] = {}, -- Bestial Wrath
			[193530] = {}, -- Aspect of the wild
		}
	elseif specID == 254 then --Markmanship
		iCD.outOfRangeSpells = {
			main = 'Arcane Shot',
			range = 'Arcane Shot',
		}
		t.power = {
			func = function()
				local p = UnitPower('player', 2)
				if p < 50 then
					return p
				elseif p >= 115 then
					return '|cffff0000'..p
				else
					return '|cff00ff00'..p
				end
			end,
		}
		-- Row 1
		t.row1 = {
			[185358] = { -- Arcane Shot
				order = 2,
				range = true,
				cost = true,
				stack = true,
				glow = true,
				glowSound = 'text1',
				stackFunc = function()
					local count, duration, expirationTime, value1, value2, value3 = iCD.UnitBuff('player', 'Precise Shots')
					return count or ""
				end
			},
			[19434] = { -- Aimed Shot
				order = 3,
				range = true,
				cost = true,
				glow = true,
				glowSound = true,
				stack = true,
				showTimeAfterGCD = true,
			},
			[120360] = { -- Barrage
				order = 10,
				cost = true,
				showTimeAfterGCD = true,
				range = true,
				showFunc = function()
					return select(4, GetTalentInfo(2, 2, 1))
				end,
				cost = true,
			},
			[53351] = { -- Kill Shot
				order = 5,
				range = true,
				cost = true,
				stack = true,
				customCost = function()
					local isUsable = IsUsableSpell("Kill Shot")
					return not isUsable
				end,
				glow = true,
				glowSound = "text2",
				showTimeAfterGCD = true,
			},
			[257044] = { -- Rapid Fire
				order = 7,
				range = true,
				showTimeAfterGCD = true,
			},
			[120360] = { -- Barrage
				order = 10,
				cost = true,
				showTimeAfterGCD = true,
				range = true,
				showFunc = function()
					return select(4, GetTalentInfo(2, 2, 1))
				end,
				cost = true,
			},
		}
		t.row2 = {
			[260402] = { -- Double Tap
				order = 1,
				cost = true,
				showTimeAfterGCD = true,
				range = true,
				showFunc = function()
					return select(4, GetTalentInfo(6, 3, 1))
				end,
				cost = true,
			},
			[131894] = { -- A Murder of Crows
				order = 2,
				range = true,
				showFunc = function()
					return select(4, GetTalentInfo(1, 3, 1))
				end,
				cost = true,
			},
			[288613] = { -- Trueshot
				order = 3,
				ignoreGCD = true,
			},
			[186265] = { -- Aspect of the Turtle
				order = 10,
				ignoreGCD = true,
			},
			[109304] = { -- Exhilaration
				order = 8,
			},
		}
		t.row4 = {
			[186257] = {}, -- Aspect of the Cheetah
			[109248] = {}, -- Binding Shot
			[186387] = {}, -- Bursting Shot
			[781] = {}, -- Disengage
			[5384] = {}, -- Feign Death
			[1543] = {}, -- Flare
			[34477] = {}, -- Misdirection
			[187650] = {}, -- Freezing Trap
			[187698] = {}, -- Tar Trap
			[5116] = {}, -- Concussive Shot
		}
		t.buffsI = {
		}
		t.buffsC = {
		}
	elseif specID == 255 then --Survival
		iCD.outOfRangeSpells = {
			main = 'Raptor Strike',
			range = 'Harpoon',
		}
		t.power = {
			func = function()
				local p = UnitPower('player', 2)
				if p < 50 then
					return p
				elseif p >= 115 then
					return '|cffff0000'..p
				else
					return '|cff00ff00'..p
				end
			end,
		}
		-- Row 1
		t.row1 = {
			[259495] = { -- Wildfire Bomb
				stack = true,
				order = 10,
				range = true,
				showTimeAfterGCD = true,
			},
			[259489] = { -- Kill Command
				order = 15,
				range = true,
				stack = true,
				glow = true,
				glowSound = true,
				showTimeAfterGCD = true,
			},
			[187708] = { -- Carve
				order = 20,
				showTimeAfterGCD = true,
				cost = true,
				range = true,
			},
			[320976] = { -- Kill Shot
				order = 30,
				range = true,
				cost = true,
				customCost = function()
					local isUsable = IsUsableSpell("Kill Shot")
					return not isUsable
				end,
				showTimeAfterGCD = true,
				glow = true,
			},
		}
		t.row2 = {
			[266779] = { -- Coordinated Assault
				order = 3,
				ignoreGCD = true,
			},
			[186289] = { -- Aspect of the Eagle
				order = 5,
				ignoreGCD = true,
			},
			[186265] = { -- Aspect of the Turtle
				order = 10,
				ignoreGCD = true,
			},
			[109304] = { -- Exhilaration
				order = 8,
			},
		}
		t.row3 = {
			[259491] = { -- Serpent Sting
				order = 1,
				cost = true,
				range = true,
				customText = function(data, gcdInfo)
					local count, duration, expirationTime, value1, value2, value3 = iCD.UnitDebuff('target', 'Serpent Sting', true)
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
			[186257] = {}, -- Aspect of the Cheetah
			[781] = {}, -- Disengage
			[5384] = {}, -- Feign Death
			[1543] = {}, -- Flare
			[34477] = {}, -- Misdirection
			[187650] = {}, -- Freezing Trap
			[191433] = {}, -- Explosive Trap
			[187698] = {}, -- Caltrops
			[190925] = {}, -- Harpoon
			[19577] = {}, -- Intimidation
			[136] = {}, -- Mend Pet
		}
		t.buffsI = {
			[186289] = {}, -- Aspect of the Eagle
		}
		t.buffsC = {
		}
	end
	return temp
end
