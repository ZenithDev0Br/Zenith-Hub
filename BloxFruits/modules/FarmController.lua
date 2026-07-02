-- Zenith-Hub/bloxfruits/modules/FarmController.lua
-- FarmController (ATUALIZADO)
-- Responsabilidade única: orquestrar o ciclo completo do Auto Farm.
-- Coordena Quest → Mob → Combat → Fast Attack, sem conter lógica de execução.

local Players = game:GetService("Players")

local FarmController = {}

-- Dependências (injetadas pelo loader)
local Combat   = nil
local Movement = nil
local Mob      = nil
local Skill    = nil
local Quest    = nil

-- Configurações
local Settings = {
    Enabled        = false,
    AutoQuest      = true,
    BringMobs      = true,
    FastAttack     = true,
    NoClip         = true,
    QuestNPC       = "BanditQuest", -- nome do NPC de quest
    MobFilter      = nil,           -- nil = qualquer mob, string = filtra por nome
}

-- Estado
local LocalPlayer = Players.LocalPlayer
local FarmThread  = nil
local CurrentPhase = "Idle" -- Idle | Questing | Seeking | Combatting

------------------------------------------------------------
-- Funções privadas
------------------------------------------------------------

local function GetRootPart()
    local char = LocalPlayer.Character
    return char and char:FindFirstChild("HumanoidRootPart")
end

--- Fase 1: Gerenciamento de Quest
local function HandleQuestPhase()
    if not Settings.AutoQuest then
        return true -- pula se auto quest desativado
    end

    CurrentPhase = "Questing"

    -- Se não tem quest ativa, aceita uma
    if not Quest:IsQuestInProgress() then
        local success = Quest:AcceptQuest(Settings.QuestNPC)
        if not success then
            warn("[FarmController] Falha ao aceitar quest. Aguardando...")
            task.wait(2)
            return false
        end
    end

    return true
end

--- Fase 2: Busca de Mobs
local function HandleSeekingPhase()
    CurrentPhase = "Seeking"

    -- Busca mob mais próximo (com filtro opcional)
    local target = Mob:GetClosestMob(Settings.MobFilter)

    if not target then
        -- Sem mobs próximos: tenta trazer mobs ou aguarda
        if Settings.BringMobs then
            local root = GetRootPart()
            if root then
                Mob:BringMobs(root.Position)
            end
        end
        task.wait(1)
        return nil
    end

    return target
end

--- Fase 3: Combate
local function HandleCombatPhase(target)
    CurrentPhase = "Combatting"

    -- Inicia combate
    Combat:StartCombat(target)

    -- Inicia Fast Attack se habilitado
    if Settings.FastAttack then
        Skill:StartFastAttack()
    end

    -- Aguarda o mob morrer ou o farm ser desativado
    while Settings.Enabled and Combat:IsActive() do
        -- Verifica se precisa trazer mais mobs
        if Settings.BringMobs then
            local root = GetRootPart()
            if root then
                Mob:BringMobs(root.Position)
            end
        end
        task.wait(0.5)
    end

    -- Para Fast Attack
    if Settings.FastAttack then
        Skill:StopFastAttack()
    end
end

--- Fase 4: Verificação de Quest
local function HandleQuestCompletion()
    if not Settings.AutoQuest then return end

    -- Verifica se a quest foi concluída
    if Quest:IsQuestComplete() then
        local success = Quest:TurnInQuest(Settings.QuestNPC)
        if success then
            print("[FarmController] Quest concluída com sucesso!")
        end
    end
end

--- Ciclo principal do Farm
local function FarmCycle()
    while Settings.Enabled do
        -- Fase 1: Quest
        local questReady = HandleQuestPhase()
        if not questReady then
            continue
        end

        -- Fase 2: Busca mob
        local target = HandleSeekingPhase()
        if not target then
            continue
        end

        -- Fase 3: Combate
        HandleCombatPhase(target)

        -- Fase 4: Verifica conclusão de quest
        HandleQuestCompletion()

        -- Pequena pausa entre ciclos
        task.wait(0.3)
    end

    CurrentPhase = "Idle"
end

------------------------------------------------------------
-- Funções públicas
------------------------------------------------------------

--- Injeta dependências (chamado pelo loader).
function FarmController:SetDependencies(deps)
    Combat   = deps.Combat
    Movement = deps.Movement
    Mob      = deps.Mob
    Skill    = deps.Skill
    Quest    = deps.Quest
end

--- Atualiza configurações.
function FarmController:SetSettings(newSettings)
    for k, v in pairs(newSettings) do
        if Settings[k] ~= nil then
            Settings[k] = v
        end
    end

    -- Propaga configurações para outros módulos
    if Mob then
        Mob:SetSettings({
            BringEnabled = Settings.BringMobs,
        })
    end

    if Skill then
        Skill:SetSettings({
            FastAttack = Settings.FastAttack,
        })
    end

    if Quest then
        Quest:SetSettings({
            AutoQuest = Settings.AutoQuest,
        })
    end

    -- Se desativou, para o ciclo
    if not Settings.Enabled then
        self:Stop()
    end
end

--- Inicia o Auto Farm.
function FarmController:Start()
    if Settings.Enabled then return end

    Settings.Enabled = true
    FarmThread = task.spawn(function()
        FarmCycle()
    end)

    print("[FarmController] Auto Farm iniciado.")
end

--- Para o Auto Farm.
function FarmController:Stop()
    Settings.Enabled = false

    -- Para todos os sistemas
    if Combat then Combat:StopCombat() end
    if Skill then Skill:StopFastAttack() end
    if Movement then Movement:Stop() end

    if FarmThread then
        task.cancel(FarmThread)
        FarmThread = nil
    end

    CurrentPhase = "Idle"
    print("[FarmController] Auto Farm parado.")
end

--- Alterna entre ligado/desligado.
function FarmController:Toggle()
    if Settings.Enabled then
        self:Stop()
    else
        self:Start()
    end
end

--- Retorna o estado atual.
function FarmController:IsEnabled()
    return Settings.Enabled
end

--- Retorna a fase atual do farm.
function FarmController:GetCurrentPhase()
    return CurrentPhase
end

--- Retorna todas as configurações atuais.
function FarmController:GetSettings()
    return Settings
end

return FarmController
