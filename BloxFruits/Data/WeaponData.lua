-- Zenith-Hub/bloxfruits/data/WeaponData.lua
-- Dados das armas do Blox Fruits
-- Responsabilidade: armazenar informações sobre armas (melee, sword, gun, fruit).

local WeaponData = {}

WeaponData.List = {
    -- ========== MELEE ==========
    ["Melee"] = {
        {
            Name = "Combat",
            Type = "Melee",
            Damage = 10,
            Speed = 1.0,
            UnlockLevel = 1,
            Price = 0,
        },
        {
            Name = "Medusa",
            Type = "Melee",
            Damage = 15,
            Speed = 1.2,
            UnlockLevel = 50,
            Price = 5000,
        },
        {
            Name = "Superhuman",
            Type = "Melee",
            Damage = 25,
            Speed = 1.5,
            UnlockLevel = 300,
            Price = 50000,
        },
    },

    -- ========== SWORD ==========
    ["Sword"] = {
        {
            Name = "Cutlass",
            Type = "Sword",
            Damage = 20,
            Speed = 1.0,
            UnlockLevel = 10,
            Price = 1500,
        },
        {
            Name = "Dual Katana",
            Type = "Sword",
            Damage = 35,
            Speed = 1.3,
            UnlockLevel = 100,
            Price = 25000,
        },
        {
            Name = "Triple Katana",
            Type = "Sword",
            Damage = 50,
            Speed = 1.5,
            UnlockLevel = 500,
            Price = 150000,
        },
        {
            Name = "Buddy Sword",
            Type = "Sword",
            Damage = 60,
            Speed = 1.6,
            UnlockLevel = 800,
            Price = 500000,
        },
    },

    -- ========== GUN ==========
    ["Gun"] = {
        {
            Name = "Musket",
            Type = "Gun",
            Damage = 30,
            Speed = 0.8,
            UnlockLevel = 20,
            Price = 8000,
        },
        {
            Name = "Finest Season",
            Type = "Gun",
            Damage = 45,
            Speed = 1.0,
            UnlockLevel = 200,
            Price = 75000,
        },
        {
            Name = "Flintlock",
            Type = "Gun",
            Damage = 55,
            Speed = 1.2,
            UnlockLevel = 400,
            Price = 200000,
        },
    },

    -- ========== BLOX FRUIT ==========
    ["Blox Fruit"] = {
        {
            Name = "Rocket",
            Type = "Blox Fruit",
            Element = "Rocket",
            Damage = 40,
            UnlockLevel = 1,
            Rarity = "Common",
        },
        {
            Name = "Spin",
            Type = "Blox Fruit",
            Element = "Spin",
            Damage = 50,
            UnlockLevel = 50,
            Rarity = "Common",
        },
        {
            Name = "Flame",
            Type = "Blox Fruit",
            Element = "Fire",
            Damage = 80,
            UnlockLevel = 100,
            Rarity = "Uncommon",
        },
        {
            Name = "Ice",
            Type = "Blox Fruit",
            Element = "Ice",
            Damage = 85,
            UnlockLevel = 150,
            Rarity = "Uncommon",
        },
        {
            Name = "Sand",
            Type = "Blox Fruit",
            Element = "Sand",
            Damage = 90,
            UnlockLevel = 200,
            Rarity = "Rare",
        },
        {
            Name = "Dark",
            Type = "Blox Fruit",
            Element = "Dark",
            Damage = 120,
            UnlockLevel = 500,
            Rarity = "Rare",
        },
        {
            Name = "Light",
            Type = "Blox Fruit",
            Element = "Light",
            Damage = 150,
            UnlockLevel = 800,
            Rarity = "Legendary",
        },
        {
            Name = "Rubber",
            Type = "Blox Fruit",
            Element = "Rubber",
            Damage = 200,
            UnlockLevel = 1000,
            Rarity = "Mythical",
        },
        {
            Name = "Dragon",
            Type = "Blox Fruit",
            Element = "Dragon",
            Damage = 300,
            UnlockLevel = 1500,
            Rarity = "Mythical",
        },
    },
}

--- Retorna todas as armas de um tipo específico.
function WeaponData:GetWeaponsByType(weaponType)
    return self.List[weaponType] or {}
end

--- Retorna os dados de uma arma específica.
function WeaponData:GetWeapon(weaponName)
    for weaponType, weapons in pairs(self.List) do
        for _, weapon in ipairs(weapons) do
            if weapon.Name == weaponName then
                return weapon
            end
        end
    end
    return nil
end

--- Retorna a melhor arma desbloqueada para um nível específico.
function WeaponData:GetBestWeaponForLevel(level, weaponType)
    local weapons = self:GetWeaponsByType(weaponType)
    local best = nil

    for _, weapon in ipairs(weapons) do
        if level >= weapon.UnlockLevel then
            if not best or weapon.Damage > best.Damage then
                best = weapon
            end
        end
    end

    return best
end

return WeaponData
