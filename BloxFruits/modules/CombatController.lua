-- Zenith-Hub/bloxfruits/modules/CombatController.lua
-- CombatController
-- Responsabilidade única: gerenciar o ciclo de combate contra um alvo.
-- Orquestra SkillController (equipar/atacar), MovementController (se aproximar)
-- e MobController (manter mobs próximos).

local Players = game:GetService("Players")

local CombatController = {}

-- Dependências
local Movement = nil
local Mob      = nil
local Skill    = nil

-- Configurações
local Settings = {
    AttackDistance = 20,
    FastAttack     = true,
}

-- Estado
local LocalPlayer   = Players.LocalPlayer
local CurrentTarget = nil
local CombatActive  = false
local AttackThread  = nil

------------------------------------------------------------
-- Funções privadas
------------------------------------------------------------

local function GetRootPart()
    local char = LocalPlayer.Character
    return char and char:FindFirstChild("HumanoidRootPart")
end

local function GetMobRoot(mob)
    return mob and (mob:FindFirstChild("HumanoidRootPart") or mob.PrimaryPart)
end

local function IsTargetAlive()
    if not CurrentTarget then return false end
    local humanoid = CurrentTarget:FindFirstChildOfClass("Humanoid")
    return humanoid and humanoid.Health > 0
end

local function GetDistanceToTarget()
    local root = GetRootPart()
    local mobRoot = GetMobRoot(CurrentTarget)
    if not root or not mobRoot then return math.huge end
    return (root.Position - mobRoot.Position).Magnitude
end

local function AttackLoop()
    while CombatActive and IsTargetAlive() do
        -- 1. Se está longe, aproxima
        if GetDistanceToTarget() > Settings.AttackDistance then
            local mobRoot = GetMobRoot(CurrentTarget)
            if mobRoot then
                Movement:MoveTo(mobRoot.Position)
            end
        else
            Movement:Stop()
        end

        -- 2. Equipa a arma
        Skill:EquipWeapon()

        -- 3. Ataca
        Skill:ActivateTool()

        -- 4. Fast Attack: usa skills em ciclo se habilitado
        if Settings.FastAttack then
            Skill:UseSkill("Z")
            Skill:UseSkill("X")
        end

        -- 5. Tenta agrupar mobs próximos (opcional)
        local root = GetRootPart()
        if root then
            Mob:BringMobs(root.Position)
        end

        task.wait(0.2) -- cadência do ataque
    end
end

------------------------------------------------------------
-- Funções públicas
------------------------------------------------------------

function CombatController:SetDependencies(deps)
    Movement = deps.Movement
    Mob      = deps.Mob
    Skill    = deps.Skill
end

function CombatController:SetSettings(newSettings)
    for k, v in pairs(newSettings) do
        if Settings[k] ~= nil then
            Settings[k] = v
        end
    end
end

--- Inicia o combate contra um alvo.
-- @param target Model do mob
function CombatController:StartCombat(target)
    if not target then
        warn("[CombatController] Alvo inválido.")
        return
    end

    -- Cancela combate anterior, se houver
    self:StopCombat()

    CurrentTarget = target
    CombatActive  = true

    -- Inicia loop em thread separada
    AttackThread = task.spawn(function()
        AttackLoop()
    end)
end

--- Para o combate atual.
function CombatController:StopCombat()
    CombatActive = false
    CurrentTarget = nil

    if AttackThread then
        task.cancel(AttackThread)
        AttackThread = nil
    end

    Movement:Stop()
end

--- Retorna true se o combate está ativo.
function CombatController:IsActive()
    return CombatActive
end

--- Retorna o alvo atual.
function CombatController:GetCurrentTarget()
    return CurrentTarget
end

return CombatController
