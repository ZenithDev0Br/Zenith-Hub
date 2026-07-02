-- Zenith-Hub/bloxfruits/data/BossData.lua
-- Dados de Bosses extraídos do Zyn Hub

local BossData = {}

BossData.List = {
    -- SEA 1
    ["The Gorilla King"] = { 
        Sea = 1, Quest = "JungleQuest", QLevel = 3, 
        Spawn = CFrame.new(-1088, 8, -488) 
    },
    ["Bobby"] = { 
        Sea = 1, Quest = "BuggyQuest1", QLevel = 3, 
        Spawn = CFrame.new(-1087, 46, 4040) 
    },
    ["The Saw"] = { 
        Sea = 1, Quest = nil, QLevel = nil, 
        Spawn = CFrame.new(-784, 72, 1603) 
    },
    ["Yeti"] = { 
        Sea = 1, Quest = "SnowQuest", QLevel = 3, 
        Spawn = CFrame.new(1218, 138, -1488) 
    },
    ["Mob Leader"] = { 
        Sea = 1, Quest = nil, QLevel = nil, 
        Spawn = CFrame.new(-2844, 7, 5356) 
    },
    ["Vice Admiral"] = { 
        Sea = 1, Quest = "MarineQuest2", QLevel = 2, 
        Spawn = CFrame.new(-5006, 88, 4353) 
    },
    ["Saber Expert"] = { 
        Sea = 1, Quest = nil, QLevel = nil, 
        Spawn = CFrame.new(-1458, 29, -50) 
    },
    ["Warden"] = { 
        Sea = 1, Quest = "ImpelQuest", QLevel = 1, 
        Spawn = CFrame.new(5278, 2, 944) 
    },
    ["Chief Warden"] = { 
        Sea = 1, Quest = "ImpelQuest", QLevel = 2, 
        Spawn = CFrame.new(5206, 0, 814) 
    },
    ["Swan"] = { 
        Sea = 1, Quest = "ImpelQuest", QLevel = 3, 
        Spawn = CFrame.new(5325, 7, 719) 
    },
    ["Magma Admiral"] = { 
        Sea = 1, Quest = "MagmaQuest", QLevel = 3, 
        Spawn = CFrame.new(-5765, 82, 8718) 
    },
    ["Fishman Lord"] = { 
        Sea = 1, Quest = "FishmanQuest", QLevel = 3, 
        Spawn = CFrame.new(61260, 30, 1193) 
    },
    ["Wysper"] = { 
        Sea = 1, Quest = "SkyExp1Quest", QLevel = 3, 
        Spawn = CFrame.new(-7866, 5576, -546) 
    },
    ["Thunder God"] = { 
        Sea = 1, Quest = "SkyExp2Quest", QLevel = 3, 
        Spawn = CFrame.new(-7994, 5761, -2088) 
    },
    ["Cyborg"] = { 
        Sea = 1, Quest = "FountainQuest", QLevel = 3, 
        Spawn = CFrame.new(6094, 73, 3825) 
    },
    ["Ice Admiral"] = { 
        Sea = 1, Quest = nil, QLevel = nil, 
        Spawn = CFrame.new(1266, 26, -1399) 
    },
    ["Greybeard"] = { 
        Sea = 1, Quest = nil, QLevel = nil, 
        Spawn = CFrame.new(-5081, 85, 4257) 
    },

    -- SEA 2
    ["Diamond"] = { 
        Sea = 2, Quest = "Area1Quest", QLevel = 3, 
        Spawn = CFrame.new(-1576, 198, 13) 
    },
    ["Jeremy"] = { 
        Sea = 2, Quest = "Area2Quest", QLevel = 3, 
        Spawn = CFrame.new(2006, 448, 853) 
    },
    ["Fajita"] = { 
        Sea = 2, Quest = "MarineQuest3", QLevel = 3, 
        Spawn = CFrame.new(-2172, 103, -4015) 
    },
    ["Don Swan"] = { 
        Sea = 2, Quest = nil, QLevel = nil, 
        Spawn = CFrame.new(2286, 15, 863) 
    },
    ["Smoke Admiral"] = { 
        Sea = 2, Quest = "IceSideQuest", QLevel = 3, 
        Spawn = CFrame.new(-5275, 20, -5260) 
    },
    ["Awakened Ice Admiral"] = { 
        Sea = 2, Quest = "FrostQuest", QLevel = 3, 
        Spawn = CFrame.new(6403, 340, -6894) 
    },
    ["Tide Keeper"] = { 
        Sea = 2, Quest = "ForgottenQuest", QLevel = 3, 
        Spawn = CFrame.new(-3795, 105, -11421) 
    },
    ["Darkbeard"] = { 
        Sea = 2, Quest = nil, QLevel = nil, 
        Spawn = CFrame.new(3677, 62, -3144) 
    },
    ["Cursed Captain"] = { 
        Sea = 2, Quest = nil, QLevel = nil, 
        Spawn = CFrame.new(916, 181, 33422) 
    },
    ["Order"] = { 
        Sea = 2, Quest = nil, QLevel = nil, 
        Spawn = CFrame.new(-6217, 28, -5053) 
    },

    -- SEA 3
    ["Stone"] = { 
        Sea = 3, Quest = "PiratePortQuest", QLevel = 3, 
        Spawn = CFrame.new(-1027, 92, 6578) 
    },
    ["Hydra Leader"] = { 
        Sea = 3, Quest = "AmazonQuest2", QLevel = 3, 
        Spawn = CFrame.new(5821, 1019, -73) 
    },
    ["Kilo Admiral"] = { 
        Sea = 3, Quest = "MarineTreeIsland", QLevel = 3, 
        Spawn = CFrame.new(2764, 432, -7144) 
    },
    ["Captain Elephant"] = { 
        Sea = 3, Quest = "DeepForestIsland", QLevel = 3, 
        Spawn = CFrame.new(-13376, 433, -8071) 
    },
    ["Beautiful Pirate"] = { 
        Sea = 3, Quest = "DeepForestIsland2", QLevel = 3, 
        Spawn = CFrame.new(5283, 22, -110) 
    },
    ["Cake Queen"] = { 
        Sea = 3, Quest = "IceCreamIslandQuest", QLevel = 3, 
        Spawn = CFrame.new(-678, 381, -11114) 
    },
    ["Longma"] = { 
        Sea = 3, Quest = nil, QLevel = nil, 
        Spawn = CFrame.new(-10238, 389, -9549) 
    },
    ["Soul Reaper"] = { 
        Sea = 3, Quest = nil, QLevel = nil, 
        Spawn = CFrame.new(-9524, 315, 6655) 
    },
}

function BossData:GetBoss(name)
    return self.List[name]
end

function BossData:GetBossesBySea(seaNumber)
    local result = {}
    for name, data in pairs(self.List) do
        if data.Sea == seaNumber then
            table.insert(result, name)
        end
    end
    table.sort(result)
    return result
end

return BossData
