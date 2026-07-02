-- Zenith-Hub/bloxfruits/data/IslandData.lua
-- Dados das ilhas do Blox Fruits
-- Responsabilidade: armazenar informações sobre ilhas, NPCs de quest, mobs e bosses.

local IslandData = {}

IslandData.List = {
    -- ========== FIRST SEA ==========
    ["Starter Island"] = {
        Sea = "First Sea",
        Level = { Min = 1, Max = 10 },
        QuestNPCs = {
            {
                Name = "BanditQuest",
                Position = Vector3.new(1180, 14, -29),
                TargetMob = "Bandit",
                TargetCount = 5,
            },
            {
                Name = "MonkeyQuest",
                Position = Vector3.new(1540, 37, -45),
                TargetMob = "Monkey",
                TargetCount = 7,
            },
        },
        Mobs = {
            { Name = "Bandit", Level = 1, SpawnPositions = {
                Vector3.new(1200, 14, -30),
                Vector3.new(1210, 14, -35),
            }},
            { Name = "Monkey", Level = 5, SpawnPositions = {
                Vector3.new(1550, 37, -50),
                Vector3.new(1560, 37, -55),
            }},
        },
        Bosses = {},
    },

    ["Marine Fortress"] = {
        Sea = "First Sea",
        Level = { Min = 10, Max = 30 },
        QuestNPCs = {
            {
                Name = "MarineQuest",
                Position = Vector3.new(-2340, 15, -1020),
                TargetMob = "Marine",
                TargetCount = 10,
            },
        },
        Mobs = {
            { Name = "Marine", Level = 15, SpawnPositions = {
                Vector3.new(-2350, 15, -1030),
                Vector3.new(-2360, 15, -1040),
            }},
            { Name = "Brute", Level = 25, SpawnPositions = {
                Vector3.new(-2370, 15, -1050),
            }},
        },
        Bosses = {
            {
                Name = "The Saw",
                Level = 30,
                SpawnPosition = Vector3.new(-2400, 20, -1100),
                RespawnTime = 600, -- segundos
            },
        },
    },

    ["Jungle"] = {
        Sea = "First Sea",
        Level = { Min = 30, Max = 50 },
        QuestNPCs = {
            {
                Name = "PirateQuest",
                Position = Vector3.new(-1650, 12, 150),
                TargetMob = "Pirate",
                TargetCount = 12,
            },
        },
        Mobs = {
            { Name = "Pirate", Level = 35, SpawnPositions = {
                Vector3.new(-1660, 12, 160),
                Vector3.new(-1670, 12, 170),
            }},
            { Name = "Gorilla", Level = 45, SpawnPositions = {
                Vector3.new(-1680, 12, 180),
            }},
        },
        Bosses = {
            {
                Name = "Gorilla King",
                Level = 50,
                SpawnPosition = Vector3.new(-1700, 15, 200),
                RespawnTime = 900,
            },
        },
    },

    -- ========== SECOND SEA ==========
    ["Graveyard"] = {
        Sea = "Second Sea",
        Level = { Min = 700, Max = 800 },
        QuestNPCs = {
            {
                Name = "GhostQuest",
                Position = Vector3.new(-5400, 20, -3200),
                TargetMob = "Ghost",
                TargetCount = 15,
            },
        },
        Mobs = {
            { Name = "Ghost", Level = 720, SpawnPositions = {
                Vector3.new(-5410, 20, -3210),
                Vector3.new(-5420, 20, -3220),
            }},
            { Name = "Zombie", Level = 750, SpawnPositions = {
                Vector3.new(-5430, 20, -3230),
            }},
        },
        Bosses = {
            {
                Name = "Cursed Captain",
                Level = 800,
                SpawnPosition = Vector3.new(-5500, 25, -3300),
                RespawnTime = 1200,
            },
        },
    },

    -- ========== THIRD SEA ==========
    ["Haunted Castle"] = {
        Sea = "Third Sea",
        Level = { Min = 1200, Max = 1350 },
        QuestNPCs = {
            {
                Name = "VampireQuest",
                Position = Vector3.new(-8200, 50, -5400),
                TargetMob = "Vampire",
                TargetCount = 20,
            },
        },
        Mobs = {
            { Name = "Vampire", Level = 1250, SpawnPositions = {
                Vector3.new(-8210, 50, -5410),
                Vector3.new(-8220, 50, -5420),
            }},
            { Name = "Dark Knight", Level = 1300, SpawnPositions = {
                Vector3.new(-8230, 50, -5430),
            }},
        },
        Bosses = {
            {
                Name = "Darkbeard",
                Level = 1350,
                SpawnPosition = Vector3.new(-8300, 60, -5500),
                RespawnTime = 1800,
            },
        },
    },
}

--- Retorna os dados de uma ilha específica.
function IslandData:GetIsland(islandName)
    return self.List[islandName]
end

--- Retorna todas as ilhas de um mar específico.
function IslandData:GetIslandsBySea(sea)
    local result = {}
    for name, data in pairs(self.List) do
        if data.Sea == sea then
            result[name] = data
        end
    end
    return result
end

--- Retorna a ilha recomendada para um nível específico.
function IslandData:GetRecommendedIsland(level)
    for name, data in pairs(self.List) do
        if level >= data.Level.Min and level <= data.Level.Max then
            return name, data
        end
    end
    return nil
end

--- Retorna todos os NPCs de quest de uma ilha.
function IslandData:GetQuestNPCs(islandName)
    local island = self:GetIsland(islandName)
    return island and island.QuestNPCs or {}
end

--- Retorna todos os mobs de uma ilha.
function IslandData:GetMobs(islandName)
    local island = self:GetIsland(islandName)
    return island and island.Mobs or {}
end

--- Retorna todos os bosses de uma ilha.
function IslandData:GetBosses(islandName)
    local island = self:GetIsland(islandName)
    return island and island.Bosses or {}
end

return IslandData
