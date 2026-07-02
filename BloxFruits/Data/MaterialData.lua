-- Zenith-Hub/bloxfruits/data/MaterialData.lua
-- Dados de Materiais baseados no Zyn Hub

local MaterialData = {}

MaterialData.List = {
    -- SEA 1
    ["Leather + Scrap Metal"] = {
        Sea = 1,
        Mobs = {"Brute", "Pirate"},
        FarmPos = CFrame.new(-1145, 15, 4350)
    },
    ["Angel Wings"] = {
        Sea = 1,
        Mobs = {"Shanda", "Royal Squad", "Royal Soldier", "Wysper", "Thunder God"},
        FarmPos = CFrame.new(-4698, 845, -1912),
        Entrance = Vector3.new(-4607, 872, -1667)
    },
    ["Magma Ore"] = {
        Sea = 1,
        Mobs = {"Military Soldier", "Military Spy", "Magma Admiral"},
        FarmPos = CFrame.new(-5815, 84, 8820)
    },
    ["Fish Tail"] = {
        Sea = 1,
        Mobs = {"Fishman Warrior", "Fishman Commando", "Fishman Lord"},
        FarmPos = CFrame.new(61123, 19, 1569),
        Entrance = Vector3.new(61163, 5, 1819)
    },

    -- SEA 2
    ["Radioactive Material"] = {
        Sea = 2,
        Mobs = {"Factory Staff"},
        FarmPos = CFrame.new(295, 73, -56)
    },
    ["Ectoplasm"] = {
        Sea = 2,
        Mobs = {"Ship Deckhand", "Ship Engineer", "Ship Steward", "Ship Officer"},
        FarmPos = CFrame.new(911, 125, 33159),
        Entrance = Vector3.new(923, 126, 32852)
    },
    ["Mystic Droplet"] = {
        Sea = 2,
        Mobs = {"Water Fighter"},
        FarmPos = CFrame.new(-3385, 239, -10542)
    },
    ["Vampire Fang"] = {
        Sea = 2,
        Mobs = {"Vampire"},
        FarmPos = CFrame.new(-6033, 7, -1317)
    },

    -- SEA 3
    ["Scrap Metal"] = {
        Sea = 3,
        Mobs = {"Jungle Pirate", "Forest Pirate"},
        FarmPos = CFrame.new(-11975, 331, -10620)
    },
    ["Conjured Cocoa"] = {
        Sea = 3,
        Mobs = {"Chocolate Bar Battler", "Cocoa Warrior"},
        FarmPos = CFrame.new(620, 78, -12581)
    },
    ["Dragon Scale"] = {
        Sea = 3,
        Mobs = {"Dragon Crew Archer", "Dragon Crew Warrior"},
        FarmPos = CFrame.new(6594, 383, 139)
    },
    ["Gunpowder"] = {
        Sea = 3,
        Mobs = {"Pistol Billionaire"},
        FarmPos = CFrame.new(-84, 85, 6132)
    },
    ["Mini Tusk"] = {
        Sea = 3,
        Mobs = {"Mythological Pirate"},
        FarmPos = CFrame.new(-13545, 470, -6917)
    },
    ["Demonic Wisp"] = {
        Sea = 3,
        Mobs = {"Demonic Soul"},
        FarmPos = CFrame.new(-9495, 453, 5977)
    },
}

function MaterialData:GetMaterial(name)
    return self.List[name]
end

function MaterialData:GetMaterialsBySea(sea)
    local result = {}
    for name, data in pairs(self.List) do
        if data.Sea == sea then
            table.insert(result, name)
        end
    end
    return result
end

return MaterialData
