-- Zenith-Hub/bloxfruits/data/IslandData.lua
-- Dados extraídos do Zyn Hub: Posições de Quests e Mobs por Level

local IslandData = {}

IslandData.QuestsByLevel = {
    -- SEA 1
    [1]   = { Name = "BanditQuest1",   Mob = "Bandit",              Pos = CFrame.new(1045, 27, 1560) },
    [10]  = { Name = "JungleQuest",    Mob = "Monkey",              Pos = CFrame.new(-1598, 35, 153) },
    [15]  = { Name = "JungleQuest",    Mob = "Gorilla",             Pos = CFrame.new(-1598, 35, 153) },
    [30]  = { Name = "BuggyQuest1",    Mob = "Pirate",              Pos = CFrame.new(-1141, 4, 3831) },
    [40]  = { Name = "BuggyQuest1",    Mob = "Brute",               Pos = CFrame.new(-1141, 4, 3831) },
    [60]  = { Name = "DesertQuest",    Mob = "Desert Bandit",       Pos = CFrame.new(894, 5, 4392) },
    [75]  = { Name = "DesertQuest",    Mob = "Desert Officer",      Pos = CFrame.new(894, 5, 4392) },
    [90]  = { Name = "SnowQuest",      Mob = "Snow Bandit",         Pos = CFrame.new(1389, 88, -1298) },
    [100] = { Name = "SnowQuest",      Mob = "Snowman",             Pos = CFrame.new(1389, 88, -1298) },
    [120] = { Name = "MarineQuest2",   Mob = "Chief Petty Officer", Pos = CFrame.new(-5039, 27, 4324) },
    [150] = { Name = "SkyQuest",       Mob = "Sky Bandit",          Pos = CFrame.new(-4839, 716, -2619) },
    [175] = { Name = "SkyQuest",       Mob = "Dark Master",         Pos = CFrame.new(-4839, 716, -2619) },
    [190] = { Name = "PrisonerQuest",  Mob = "Prisoner",            Pos = CFrame.new(5308, 1, 475) },
    [210] = { Name = "PrisonerQuest",  Mob = "Dangerous Prisoner",  Pos = CFrame.new(5308, 1, 475) },
    [250] = { Name = "ColosseumQuest", Mob = "Toga Warrior",        Pos = CFrame.new(-1580, 6, -2986) },
    [275] = { Name = "ColosseumQuest", Mob = "Gladiator",           Pos = CFrame.new(-1580, 6, -2986) },
    [300] = { Name = "MagmaQuest",     Mob = "Military Soldier",    Pos = CFrame.new(-5313, 10, 8515) },
    [325] = { Name = "MagmaQuest",     Mob = "Military Spy",        Pos = CFrame.new(-5313, 10, 8515) },
    [375] = { Name = "FishmanQuest",   Mob = "Fishman Warrior",     Pos = CFrame.new(61122, 18, 1569) },
    [400] = { Name = "FishmanQuest",   Mob = "Fishman Commando",    Pos = CFrame.new(61122, 18, 1569) },
    [450] = { Name = "SkyExp1Quest",   Mob = "God's Guard",         Pos = CFrame.new(-4721, 843, -1949) },
    [475] = { Name = "SkyExp1Quest",   Mob = "Shanda",              Pos = CFrame.new(-7859, 5544, -381) },
    [525] = { Name = "SkyExp2Quest",   Mob = "Royal Squad",         Pos = CFrame.new(-7906, 5634, -1411) },
    [550] = { Name = "SkyExp2Quest",   Mob = "Royal Soldier",       Pos = CFrame.new(-7906, 5634, -1411) },
    [625] = { Name = "FountainQuest",  Mob = "Galley Pirate",       Pos = CFrame.new(5259, 37, 4050) },
    [650] = { Name = "FountainQuest",  Mob = "Galley Captain",      Pos = CFrame.new(5259, 37, 4050) },

    -- SEA 2
    [700]  = { Name = "Area1Quest",     Mob = "Raider",              Pos = CFrame.new(-429, 71, 1836) },
    [725]  = { Name = "Area1Quest",     Mob = "Mercenary",           Pos = CFrame.new(-429, 71, 1836) },
    [775]  = { Name = "Area2Quest",     Mob = "Swan Pirate",         Pos = CFrame.new(638, 71, 918) },
    [800]  = { Name = "Area2Quest",     Mob = "Factory Staff",       Pos = CFrame.new(632, 73, 918) },
    [875]  = { Name = "MarineQuest3",   Mob = "Marine Lieutenant",   Pos = CFrame.new(-2440, 71, -3216) },
    [900]  = { Name = "MarineQuest3",   Mob = "Marine Captain",      Pos = CFrame.new(-2440, 71, -3216) },
    [950]  = { Name = "ZombieQuest",    Mob = "Zombie",              Pos = CFrame.new(-5497, 47, -795) },
    [975]  = { Name = "ZombieQuest",    Mob = "Vampire",             Pos = CFrame.new(-5497, 47, -795) },
    [1000] = { Name = "SnowMountainQuest", Mob = "Snow Trooper",     Pos = CFrame.new(609, 400, -5372) },
    [1050] = { Name = "SnowMountainQuest", Mob = "Winter Warrior",   Pos = CFrame.new(609, 400, -5372) },
    [1100] = { Name = "IceSideQuest",   Mob = "Lab Subordinate",     Pos = CFrame.new(-6064, 15, -4902) },
    [1125] = { Name = "IceSideQuest",   Mob = "Horned Warrior",      Pos = CFrame.new(-6064, 15, -4902) },
    [1175] = { Name = "FireSideQuest",  Mob = "Magma Ninja",         Pos = CFrame.new(-5428, 15, -5299) },
    [1200] = { Name = "FireSideQuest",  Mob = "Lava Pirate",         Pos = CFrame.new(-5428, 15, -5299) },
    [1250] = { Name = "ShipQuest1",     Mob = "Ship Deckhand",       Pos = CFrame.new(1037, 125, 32911) },
    [1275] = { Name = "ShipQuest1",     Mob = "Ship Engineer",       Pos = CFrame.new(1037, 125, 32911) },
    [1300] = { Name = "ShipQuest2",     Mob = "Ship Steward",        Pos = CFrame.new(968, 125, 33244) },
    [1325] = { Name = "ShipQuest2",     Mob = "Ship Officer",        Pos = CFrame.new(968, 125, 33244) },
    [1350] = { Name = "FrostQuest",     Mob = "Arctic Warrior",      Pos = CFrame.new(5667, 26, -6486) },
    [1375] = { Name = "FrostQuest",     Mob = "Snow Lurker",         Pos = CFrame.new(5667, 26, -6486) },
    [1425] = { Name = "ForgottenQuest", Mob = "Sea Soldier",         Pos = CFrame.new(-3054, 235, -10142) },
    [1450] = { Name = "ForgottenQuest", Mob = "Water Fighter",       Pos = CFrame.new(-3054, 235, -10142) },

    -- SEA 3
    [1500] = { Name = "PiratePortQuest",  Mob = "Pirate Millionaire",  Pos = CFrame.new(-290, 42, 5581) },
    [1525] = { Name = "PiratePortQuest",  Mob = "Pistol Billionaire",  Pos = CFrame.new(-290, 42, 5581) },
    [1575] = { Name = "DragonCrewQuest",  Mob = "Dragon Crew Warrior", Pos = CFrame.new(6737, 127, -712) },
    [1600] = { Name = "DragonCrewQuest",  Mob = "Dragon Crew Archer",  Pos = CFrame.new(6737, 127, -712) },
    [1625] = { Name = "VenomCrewQuest",   Mob = "Hydra Enforcer",      Pos = CFrame.new(5206, 1004, 748) },
    [1650] = { Name = "VenomCrewQuest",   Mob = "Venomous Assailant",  Pos = CFrame.new(5206, 1004, 748) },
    [1700] = { Name = "MarineTreeIsland", Mob = "Marine Commodore",    Pos = CFrame.new(2180, 27, -6741) },
    [1725] = { Name = "MarineTreeIsland", Mob = "Marine Rear Admiral", Pos = CFrame.new(2179, 28, -6740) },
    [1775] = { Name = "DeepForestIsland3",Mob = "Fishman Raider",      Pos = CFrame.new(-10581, 330, -8761) },
    [1800] = { Name = "DeepForestIsland3",Mob = "Fishman Captain",     Pos = CFrame.new(-10581, 330, -8761) },
    [1825] = { Name = "DeepForestIsland", Mob = "Forest Pirate",       Pos = CFrame.new(-13234, 331, -7625) },
    [1850] = { Name = "DeepForestIsland", Mob = "Mythological Pirate", Pos = CFrame.new(-13234, 331, -7625) },
    [1900] = { Name = "DeepForestIsland2",Mob = "Jungle Pirate",       Pos = CFrame.new(-12680, 389, -9902) },
    [1925] = { Name = "DeepForestIsland2",Mob = "Musketeer Pirate",    Pos = CFrame.new(-12680, 389, -9902) },
    [1975] = { Name = "HauntedQuest1",    Mob = "Reborn Skeleton",     Pos = CFrame.new(-9479, 141, 5566) },
    [2000] = { Name = "HauntedQuest1",    Mob = "Living Zombie",       Pos = CFrame.new(-9479, 141, 5566) },
    [2025] = { Name = "HauntedQuest2",    Mob = "Demonic Soul",        Pos = CFrame.new(-9516, 172, 6078) },
    [2050] = { Name = "HauntedQuest2",    Mob = "Posessed Mummy",      Pos = CFrame.new(-9516, 172, 6078) },
    [2075] = { Name = "NutsIslandQuest",  Mob = "Peanut Scout",        Pos = CFrame.new(-2104, 38, -10194) },
    [2100] = { Name = "NutsIslandQuest",  Mob = "Peanut President",    Pos = CFrame.new(-2104, 38, -10194) },
    [2125] = { Name = "IceCreamIslandQuest", Mob = "Ice Cream Chef",   Pos = CFrame.new(-820, 65, -10965) },
    [2150] = { Name = "IceCreamIslandQuest", Mob = "Ice Cream Commander", Pos = CFrame.new(-820, 65, -10965) },
    [2200] = { Name = "CakeQuest1",       Mob = "Cookie Crafter",      Pos = CFrame.new(-2021, 37, -12028) },
    [2225] = { Name = "CakeQuest1",       Mob = "Cake Guard",          Pos = CFrame.new(-2021, 37, -12028) },
    [2250] = { Name = "CakeQuest2",       Mob = "Baking Staff",        Pos = CFrame.new(-1927, 37, -12842) },
    [2275] = { Name = "CakeQuest2",       Mob = "Head Baker",          Pos = CFrame.new(-1927, 37, -12842) },
    [2300] = { Name = "ChocQuest1",       Mob = "Cocoa Warrior",       Pos = CFrame.new(233, 29, -12201) },
    [2325] = { Name = "ChocQuest1",       Mob = "Chocolate Bar Battler", Pos = CFrame.new(233, 29, -12201) },
    [2350] = { Name = "ChocQuest2",       Mob = "Sweet Thief",         Pos = CFrame.new(150, 30, -12774) },
    [2375] = { Name = "ChocQuest2",       Mob = "Candy Rebel",         Pos = CFrame.new(150, 30, -12774) },
}

--- Retorna a quest recomendada para o nível atual
function IslandData:GetQuestForLevel(level)
    local bestQuest = nil
    local bestLevel = 0
    
    for reqLevel, data in pairs(self.QuestsByLevel) do
        if level >= reqLevel and reqLevel > bestLevel then
            bestLevel = reqLevel
            bestQuest = data
        end
    end
    
    return bestQuest
end

return IslandData
