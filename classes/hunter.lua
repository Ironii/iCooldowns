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
				stack = true,
				glow = true,
				glowSound = 'text1',
				stackFunc = function()
					local count, duration, expirationTime, value1, value2, value3 = iCD.UnitBuff('player', 'Marking Targets')
					if expirationTime then
						local dura = expirationTime - GetTime()
						return dura, '%.0f'
					else
						return ''
					end
				end
			},
			[19434] = { -- Aimed Shot
				order = 3,
				range = true,
				cost = true,
				glow = true,
				glowSound = true,
				stack = true,
				stackFunc = function()
					local count, duration, expirationTime, value1, value2, value3 = iCD.UnitBuff('player', 'Lock and Load')
					if count then
						return count
					else
						return ''
					end
				end,
			},
			[212431] = { -- Explosive Shot
				order = 5,
				range = true,
				showFunc = function()
					return select(4, GetTalentInfo(4, 1, 1))
				end,
				cost = true,
			},
			[194599] = { -- Black Arrow
				order = 10,
				range = true,
				showFunc = function()
					return select(4, GetTalentInfo(2, 2, 1))
				end,
				cost = true,
			},
		}
		t.row2 = {
			[131894] = { -- A Murder of Crows
				order = 2,
				range = true,
				showFunc = function()
					return select(4, GetTalentInfo(6, 1, 1))
				end,
				cost = true,
			},
			[193526] = { -- Trueshot
				order = 3,
				ignoreGCD = true,
			},
			[186265] = { -- Aspect of the Turtle
				order = 10,
				ignoreGCD = true,
			},
			[109304] = {
				order = 8,
				ignoreGCD = true,
			},
		}
		t.row4 = {
			[186257] = {}, -- Aspect of the Cheetah
			[109248] = { -- Binding Shot
				showFunc = function()
					return select(4, GetTalentInfo(5, 1, 1))
				end,
			},
			[186387] = {}, -- Bursting Shot
			[781] = {}, -- Disengage
			[5384] = {}, -- Feign Death
			[1543] = {}, -- Flare
			[34477] = {}, -- Misdirection
			[187650] = {}, -- Freezing Trap
			[187698] = {}, -- Tar Trap


		}
		t.buffsI = {
		}
		t.buffsC = {
		}
	elseif specID == 255 then
		iCD.outOfRangeSpells = {
			main = 'Flanking Strike',
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
			[203415] = { -- Fury of the Eeagle (artifact)
				order = 1,
				range = true,
			},
			[190928] = { -- Mongoose Bite
				order = 2,
				range = true,
				stack = true,
				glow = true,
				glowSound = true,
			},
			[212436] = { -- Butchery
				order = 4,
				range = true,
				stack = true,
				showFunc = function()
					return select(4, GetTalentInfo(6, 1, 1))
				end,
			},
			[202800] = { -- Flanking Strike
				order = 5,
				range = true,
				cost = true,
			},
		}
		t.row2 = {
			[194407] = { -- Spitting Cobra
				order = 1,
				showFunc = function()
					return select(4, GetTalentInfo(7, 1, 1))
				end,
			},
			[186289] = { -- Aspect of the Eagle
				order = 5,
				ignoreGCD = true,
			},
			[186265] = { -- Aspect of the Turtle
				order = 10,
				ignoreGCD = true,
			},
			[109304] = {
				order = 8,
				ignoreGCD = true,
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
		}
		t.buffsI = {
			[185855] = { -- Lacerate
				debuff = true,
			}
		}
		t.buffsC = {
		}
	end
	return temp
end
