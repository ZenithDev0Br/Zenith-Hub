-- Zenith-Hub/bloxfruits/modules/SkillController.lua
-- SkillController (ATUALIZADO)
-- Responsabilidade única: equipar armas, disparar habilidades e implementar
-- métodos avançados de Fast Attack (tool manipulation, remote firing, etc).

local Players           = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UserInputService  = game:GetService("UserInputService")

local SkillController = {}

-- Dependências
local Movement = nil
local Mob      = nil

-- Configurações
local Settings = {
    CurrentWeapon   = "Sword",
    FastAttack      = true,
    FastAttackMode  = "Hybrid", -- Tool | Remote | Hybrid
    AttackSpeed     = 0.1,      -- intervalo entre ataques (segundos)
    UseSkills       = true,     -- usa skills Z/X/C/V durante fast attack
}

-- Estado
local LocalPlayer = Players.LocalPlayer
local ToolCache   = {}
local FastAttackActive = false
local FastAttackThread = nil

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
-- Métodos de Fast Attack
------------------------------------------------------------

--- Método 1: Tool Manipulation
-- Chama diretamente o método Activate da tool
local function FastAttack_Tool()
    local character = GetCharacter()
    if not character then return end

    local tool = character:FindFirstChildOfClass("Tool")
    if not tool then return end

    -- Tenta encontrar o script local da tool
    local localScript = tool:FindFirstChildWhichIsA("LocalScript")
    if localScript and localScript.Activate then
        -- Chama a função diretamente (método mais rápido)
        pcall(function()
            localScript.Activate()
        end)
    end
end

--- Método 2: Remote Firing
-- Dispara RemoteEvents de ataque diretamente
local function FastAttack_Remote()
    local character = GetCharacter()
    if not character then return end

    local tool = character:FindFirstChildOfClass("Tool")
    if not tool then return end

    -- Procura remotes de ataque
    local commFolder = ReplicatedStorage:FindFirstChild("Comm_")
    if not commFolder then return end

    -- Dispara o remote de ataque (nome varia conforme a arma)
    local attackRemote = commFolder:FindFirstChild("WeaponActivate")
                      or commFolder:FindFirstChild("Attack")
                      or commFolder:FindFirstChild(tool.Name .. "Activate")

    if attackRemote then
        pcall(function()
            attackRemote:FireServer(tool.Name)
        end)
    end
end

--- Método 3: Hybrid (combina Tool + Remote)
-- Usa ambos os métodos para máxima velocidade
local function FastAttack_Hybrid()
    FastAttack_Tool()
    FastAttack_Remote()
end

--- Loop principal do Fast Attack
local function FastAttackLoop()
    local attackFunctions = {
        Tool   = FastAttack_Tool,
        Remote = FastAttack_Remote,
        Hybrid = FastAttack_Hybrid,
    }

    local attackFunc = attackFunctions[Settings.FastAttackMode] or FastAttack_Hybrid

    while FastAttackActive do
        -- Ataque básico
        attackFunc()

        -- Usa skills em ciclo (Z, X, C, V)
        if Settings.UseSkills then
            SkillController:UseSkill("Z")
            task.wait(0.05)
            SkillController:UseSkill("X")
            task.wait(0.05)
        end

        task.wait(Settings.AttackSpeed)
    end
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

    -- Se desativou o fast attack, para o loop
    if not Settings.FastAttack then
        self:StopFastAttack()
    end
end

--- Equipa a arma atualmente selecionada.
function SkillController:EquipWeapon()
    local tool = GetToolByName(Settings.CurrentWeapon)
    if not tool then
        warn("[SkillController] Arma não encontrada: " .. tostring(Settings.CurrentWeapon))
        return false
    end

    local character = GetCharacter()
    if not character then return false end

    if tool.Parent == character then return true end

    local humanoid = character:FindFirstChildOfClass("Humanoid")
    if humanoid then
        humanoid:EquipTool(tool)
        return true
    end
    return false
end

--- Ativa a ferramenta equipada (ataque básico).
function SkillController:ActivateTool()
    local character = GetCharacter()
    if not character then return end

    local tool = character:FindFirstChildOfClass("Tool")
    if tool and tool:IsA("Tool") then
        local remote = ReplicatedStorage:FindFirstChild("Comm_")
        if remote and remote:FindFirstChild("WeaponActivate") then
            remote.WeaponActivate:FireServer(tool.Name)
        end

        if tool.Activate and typeof(tool.Activate) == "function" then
            tool.Activate:InvokeServer()
        end
    end
end

--- Usa uma skill específica (Z, X, C, V, F, etc).
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

--- Inicia o Fast Attack.
function SkillController:StartFastAttack()
    if FastAttackActive then return end

    FastAttackActive = true
    FastAttackThread = task.spawn(function()
        FastAttackLoop()
    end)
end

--- Para o Fast Attack.
function SkillController:StopFastAttack()
    FastAttackActive = false

    if FastAttackThread then
        task.cancel(FastAttackThread)
        FastAttackThread = nil
    end
end

--- Retorna se o Fast Attack está ativo.
function SkillController:IsFastAttackEnabled()
    return FastAttackActive
end

--- Retorna a arma atualmente configurada.
function SkillController:GetCurrentWeapon()
    return Settings.CurrentWeapon
end

return SkillController
