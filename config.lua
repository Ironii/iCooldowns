local _, iCD = ...

iCD.font = 'Interface\\AddOns\\iCooldowns\\Media\\ap.ttf'
iCD.fontSize = 14
iCD.stackFontSize = 12

iCD.sounds = {
    default = 'Interface\\AddOns\\iCooldowns\\Media\\Kachink.ogg',
    text1 = 'Interface\\AddOns\\iCooldowns\\Media\\Text1.ogg',
    text2 = 'Interface\\AddOns\\iCooldowns\\Media\\Text2.ogg',
}

iCD.setups = {
  row1 = {
    size = 20,
    horizontal = true,
    position = { -- anchor: iCD.hpBar
      from = "top",
      to = "bottom",
      x = 0,
      y = -13,
    }
  },
  row2 = {
    size = 20,
    horizontal = true,
    position = { -- anchor: iCD.hpBar
      from = "top",
      to = "bottom",
      x = 0,
      y = -34,
    }
  },
  row3 = {
    size = 20,
    horizontal = true,
    position = { -- anchor: iCD.hpBar
      from = "bottomright",
      to = "top",
      x = -25,
      y = 17,
    }
  },
  row4 = {
    size = 24,
    horizontal = true,
    position = { -- anchor: iCD.hpBar
      from = "top",
      to = "bottom",
      x = 0,
      y = -78,
    }
  },
  row5 = {
    size = 32,
    horizontal = false,
    position = { -- anchor: iCD.hpBar
      from = "bottomright",
      to = "bottomleft",
      x = -7,
      y = -12,
    }
  },
  buffsI = {
    size = 20,
    horizontal = true,
    position = { -- anchor: iCD.hpBar
      from = "bottomleft",
      to = "top",
      x = 25,
      y = 17,
    }
  },
  buffsC = {
    size = 20,
    horizontal = true,
    position = { -- anchor: iCD.hpBar
      from = "top",
      to = "bottom",
      x = 0,
      y = -55,
    }
  },
  hpBar = {
    width = 220,
    height = 16,
    defaultColor = {.1,.1,.1,1},
    position = { -- anchor: UIParent
      from = "bottom",
      to = "bottom",
      x = 0,
      y = 470,
    },
    inverted = true,
  },
  ehText = {
    fontSize = 16,
    position = { -- anchor: iCD.hpBar
      from = "bottom",
      to = "top",
      x = 0,
      y = 17,
    }
  },
  gcd = {
    width = 109,
    height = 11,
    defaultColor = {1,.5,0,1},
    position = { -- anchor: iCD.hpBar
      from = "topleft",
      to = "bottomleft",
      x = 0,
      y = -1,
    }
  },
  power = {
    fontSize = 16,
    justifyH = "right",
    position = { -- anchor: UIParent
      from = "bottomright",
      to = "center",
      x = -30,
      y = -65,
    },
  },
  outOfRange = {
    fontSize = 32,
    justifyH = "center",
    text = "OUT OF RANGE",
    position = { -- anchor: UIParent
      from = "center",
      to = "center",
      x = 0,
      y = 70,
    }
  },
}