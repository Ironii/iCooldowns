local _, iCD = ...
function iCD:EVOKER(specID)
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
	if specID == 1467 then -- Devastation
		iCD.outOfRangeSpells = {
			main = "",
			range = "",
		}
		t.power = {
			func = function()
				return math.floor((UnitPower('player', 0)/UnitPowerMax('player', 0))*100)
			end,
		}
		t.row1 = {}
		t.row2 = {}
		t.row3 = {}
		t.row4 = {}
		t.row5 = {}
		t.buffsI = {}
		t.buffsC = {}
	elseif specID == 1468 then -- Preservation
		iCD.outOfRangeSpells = {
			main = "",
			range = "",
		}
		t.power = {
			func = function()
				return math.floor((UnitPower('player', 0)/UnitPowerMax('player', 0))*100)
			end,
		}
		t.row1 = {}
		t.row2 = {}
		t.row3 = {}
		t.row4 = {}
		t.row5 = {}
		t.buffsI = {}
		t.buffsC = {}
	end
	return temp
end
