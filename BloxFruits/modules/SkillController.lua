-- Zenith-Hub/bloxfruits/modules/SkillController.lua
-- SkillController
-- Responsabilidade única: equipar armas e disparar habilidades (skills).
-- Isola toda a lógica de tool/skill para que CombatController não precise
-- conhecer os internals do Blox Fruits.

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local SkillController = {}

-- Dependências
local Movement = nil
local Mob      = nil

-- Configurações
local Settings = {
    CurrentWeapon = "Sword", -- Melee | Sword | Gun | Blox Fruit
    FastAttack    = true,
}

-- Estado
local LocalPlayer = Players.LocalPlayer
local ToolCache   = {}

------------------------------------------------------------
-- Funções privadas
------------------------------------------------------------

local function GetCharacter()
    return LocalPlayer.Character
end

local function GetToolByName(toolName)
    if ToolCache[toolName] then
        return ToolCache[toolName]
    end

    local character = GetCharacter()
    if not character then return nil end

    local backpack = LocalPlayer:FindFirstChild("Backpack")
    local tool = (backpack and backpack:FindFirstChild(toolName))
              or character:FindFirstChild(toolName)

    if tool then
        ToolCache[toolName] = tool
    end
    return tool
end

local function FindSkillRemote(skillName)
    -- Blox Fruits usa remotes em Comm_/CommF_ para skills
    local remotes = {
        ReplicatedStorage:FindFirstChild("Comm_"),
        ReplicatedStorage:FindFirstChild("CommF_"),
    }
    for _, folder in ipairs(remotes) do
        if folder then
            local remote = folder:FindFirstChild(skillName)
            if remote then return remote end
        end
    end
    return nil
end

------------------------------------------------------------
-- Funções públicas
------------------------------------------------------------

function SkillController:SetDependencies(deps)
    Movement = deps.Movement
    Mob      = deps.Mob
end

function SkillController:SetSettings(newSettings)
    for k, v in pairs(newSettings) do
        if Settings[k] ~= nil then
            Settings[k] = v
        end
    end
end

--- Equipa a arma atualmente selecionada.
-- @return boolean true se equipou com sucesso
function SkillController:EquipWeapon()
    local tool = GetToolByName(Settings.CurrentWeapon)
    if not tool then
        warn("[SkillController] Arma não encontrada: " .. tostring(Settings.CurrentWeapon))
        return false
    end

    local character = GetCharacter()
    if not character then return false end

    -- Se já está equipada, não faz nada
    if tool.Parent == character then return true end

    local humanoid = character:FindFirstChildOfClass("Humanoid")
    if humanoid then
        humanoid:EquipTool(tool)
        return true
    end
    return false
end

--- Ativa a ferramenta equipada (ataque básico / melee).
function SkillController:ActivateTool()
    local character = GetCharacter()
    if not character then return end

    local tool = character:FindFirstChildOfClass("Tool")
    if tool and tool:IsA("Tool") then
        -- Invoca o método interno da tool (padrão do Blox Fruits)
        local activate = tool:FindFirstChild("Activate")
            or (tool:FindFirstChildWhichIsA("LocalScript") and
                tool:FindFirstChildWhichIsA("LocalScript").Activate)

        -- Dispara via RemoteEvent (método mais confiável)
        local remote = ReplicatedStorage:FindFirstChild("Comm_")
        if remote and remote:FindFirstChild("WeaponActivate") then
            remote.WeaponActivate:FireServer(tool.Name)
        end

        -- Fallback: invoca diretamente
        if tool.Activate and typeof(tool.Activate) == "function" then
            tool.Activate:InvokeServer()
        end
    end
end

--- Usa uma skill específica (Z, X, C, V, F, etc).
-- @param skillKey string identificador da skill
function SkillController:UseSkill(skillKey)
    local remote = FindSkillRemote(skillKey)
    if remote and remote:IsA("RemoteEvent") then
        remote:FireServer()
        return true
    elseif remote and remote:IsA("RemoteFunction") then
        remote:InvokeServer()
        return true
    end
    return false
end

--- Retorna a arma atualmente configurada.
function SkillController:GetCurrentWeapon()
    return Settings.CurrentWeapon
end

--- Retorna se o Fast Attack está ativo.
function SkillController:IsFastAttackEnabled()
    return Settings.FastAttack
end

return SkillController
