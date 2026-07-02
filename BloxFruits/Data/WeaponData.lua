-- Zenith-Hub/bloxfruits/data/WeaponData.lua
-- Categorias de armas para o Select Weapon do Farm

local WeaponData = {}

WeaponData.Types = {
    "Melee",
    "Sword",
    "Gun",
    "Blox Fruit"
}

-- Verifica se uma tool é do tipo selecionado comparando ToolTip
function WeaponData:IsType(tool, weaponType)
    if not tool or not tool:IsA("Tool") then return false end
    return tool.ToolTip == weaponType
end

-- Busca a melhor arma disponível no inventário do tipo desejado
function WeaponData:FindBestWeapon(player, weaponType)
    local backpack = player:FindFirstChild("Backpack")
    local character = player.Character
    
    -- Prioriza arma equipada
    if character then
        local equipped = character:FindFirstChildOfClass("Tool")
        if equipped and self:IsType(equipped, weaponType) then
            return equipped.Name
        end
    end
    
    -- Busca no backpack
    if backpack then
        for _, tool in ipairs(backpack:GetChildren()) do
            if self:IsType(tool, weaponType) then
                return tool.Name
            end
        end
    end
    
    return nil
end

return WeaponData
