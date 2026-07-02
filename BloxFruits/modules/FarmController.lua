-- Zenith-Hub/bloxfruits/modules/FarmController.lua (ATUALIZADO)
-- Responsabilidade: Orquestrar o ciclo completo usando dados reais

local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")

local FarmController = {}

-- Dependências
local Combat   = nil
local Movement = nil
local Mob      = nil
local Skill    = nil
local Quest    = nil
local WeaponData = nil
local BossData = nil
local MaterialData = nil

-- Configurações
local Settings = {
    Enabled       = false,
    Mode          = "Level", -- Level | Bone | Material | Boss
    AutoQuest     = true,
    BringMobs     = true,
    FastAttack    = true,
    SelectedWeapon = "Melee", -- Melee | Sword | Gun | Blox Fruit
    SelectedMaterial = nil,
    SelectedBoss = nil,
}

-- Estado
local LocalPlayer = Players.LocalPlayer
local FarmThread  = nil
local CurrentPhase = "Idle"

------------------------------------------------------------
-- Funções Privadas
------------------------------------------------------------

local function GetRootPart()
    local char = LocalPlayer.Character
    return char and char:FindFirstChild("HumanoidRootPart")
end

--- Seleciona a melhor arma disponível do tipo escolhido
local function AutoEquipWeapon()
    if not WeaponData then return end
    local bestWeapon = WeaponData:FindBestWeapon(LocalPlayer, Settings.SelectedWeapon)
    if bestWeapon then
        Skill:EquipWeapon(bestWeapon)
    end
end

--- Ciclo de Farm por Nível
local function LevelFarmCycle()
    while Settings.Enabled and Settings.Mode == "Level" do
        CurrentPhase = "Questing"
        
        -- Garante que tem a quest correta
        if Settings.AutoQuest then
            Quest:EnsureQuest()
        end
        
        CurrentPhase = "Seeking"
        local targetMobName = Quest:GetTargetMobName()
        local spawnPos = Quest:GetMobSpawnPosition()
        
        -- Busca mob mais próximo do tipo da quest
        local target = Mob:GetClosestMob(targetMobName)
        
        if not target and spawnPos then
            -- Se não achou mob, vai pro spawn
            Movement:MoveTo(spawnPos.Position)
            Movement:WaitUntilReached(5)
            task.wait(1)
        else
            CurrentPhase = "Combatting"
            
            -- Agrupa mobs se habilitado
            if Settings.BringMobs then
                local root = GetRootPart()
                if root then Mob:BringMobs(root.Position) end
            end
            
            -- Equipa arma e inicia combate
            AutoEquipWeapon()
            Combat:StartCombat(target)
            
            if Settings.FastAttack then
                Skill:StartFastAttack()
            end
            
            -- Aguarda mob morrer
            while Settings.Enabled and Combat:IsActive() do
                if Settings.BringMobs then
                    local root = GetRootPart()
                    if root then Mob:BringMobs(root.Position) end
                end
                task.wait(0.5)
            end
            
            Skill:StopFastAttack()
        end
        
        task.wait(0.3)
    end
end

--- Ciclo de Farm por Material
local function MaterialFarmCycle()
    while Settings.Enabled and Settings.Mode == "Material" do
        if not Settings.SelectedMaterial then
            warn("[FarmController] Nenhum material selecionado.")
            task.wait(2)
            continue
        end
        
        local matData = MaterialData:GetMaterial(Settings.SelectedMaterial)
        if not matData then
            warn("[FarmController] Material não encontrado nos dados.")
            task.wait(2)
            continue
        end
        
        CurrentPhase = "Seeking"
        
        -- Tenta achar um dos mobs que dropam o material
        local target = nil
        for _, mobName in ipairs(matData.Mobs) do
            target = Mob:GetClosestMob(mobName)
            if target then break end
        end
        
        if not target then
            -- Vai pra posição de farm do material
            Movement:MoveTo(matData.FarmPos.Position)
            Movement:WaitUntilReached(5)
            task.wait(1)
        else
            CurrentPhase = "Combatting"
            if Settings.BringMobs then
                local root = GetRootPart()
                if root then Mob:BringMobs(root.Position) end
            end
            
            AutoEquipWeapon()
            Combat:StartCombat(target)
            if Settings.FastAttack then Skill:StartFastAttack() end
            
            while Settings.Enabled and Combat:IsActive() do
                task.wait(0.5)
            end
            Skill:StopFastAttack()
        end
        
        task.wait(0.3)
    end
end

--- Ciclo de Farm por Boss
local function BossFarmCycle()
    while Settings.Enabled and Settings.Mode == "Boss" do
        if not Settings.SelectedBoss then
            warn("[FarmController] Nenhum boss selecionado.")
            task.wait(2)
            continue
        end
        
        local bossData = BossData:GetBoss(Settings.SelectedBoss)
        if not bossData then
            warn("[FarmController] Boss não encontrado nos dados.")
            task.wait(2)
            continue
        end
        
        CurrentPhase = "Seeking"
        
        -- Verifica se o boss está spawnado
        local bossModel = Workspace.Enemies:FindFirstChild(Settings.SelectedBoss)
            or Workspace:FindFirstChild(Settings.SelectedBoss)
        
        if not bossModel then
            -- Boss não spawnou, vai pro spawn point
            Movement:MoveTo(bossData.Spawn.Position)
            Movement:WaitUntilReached(5)
            task.wait(3)
        else
            CurrentPhase = "Combatting"
            AutoEquipWeapon()
            Combat:StartCombat(bossModel)
            if Settings.FastAttack then Skill:StartFastAttack() end
            
            while Settings.Enabled and Combat:IsActive() do
                task.wait(0.5)
            end
            Skill:StopFastAttack()
        end
        
        task.wait(0.3)
    end
end

--- Dispatcher principal
local function FarmCycle()
    while Settings.Enabled do
        if Settings.Mode == "Level" then
            LevelFarmCycle()
        elseif Settings.Mode == "Material" then
            MaterialFarmCycle()
        elseif Settings.Mode == "Boss" then
            BossFarmCycle()
        elseif Settings.Mode == "Bone" then
            -- Bone farm usa mesma lógica de material mas com mobs específicos
            Settings.SelectedMaterial = "Demonic Wisp" -- Placeholder
            MaterialFarmCycle()
        else
            task.wait(1)
        end
    end
    
    CurrentPhase = "Idle"
end

------------------------------------------------------------
-- Funções Públicas
------------------------------------------------------------

function FarmController:SetDependencies(deps)
    Combat       = deps.Combat
    Movement     = deps.Movement
    Mob          = deps.Mob
    Skill        = deps.Skill
    Quest        = deps.Quest
    WeaponData   = deps.WeaponData
    BossData     = deps.BossData
    MaterialData = deps.MaterialData
end

function FarmController:SetSettings(newSettings)
    for k, v in pairs(newSettings) do
        if Settings[k] ~= nil then
            Settings[k] = v
        end
    end
    
    -- Propaga configurações
    if Mob then Mob:SetSettings({ BringEnabled = Settings.BringMobs }) end
    if Skill then Skill:SetSettings({ FastAttack = Settings.FastAttack }) end
    
    if not Settings.Enabled then self:Stop() end
end

function FarmController:Start()
    if Settings.Enabled then return end
    Settings.Enabled = true
    FarmThread = task.spawn(FarmCycle)
    print("[FarmController] Auto Farm iniciado no modo: " .. Settings.Mode)
end

function FarmController:Stop()
    Settings.Enabled = false
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

function FarmController:Toggle()
    if Settings.Enabled then self:Stop() else self:Start() end
end

function FarmController:IsEnabled() return Settings.Enabled end
function FarmController:GetCurrentPhase() return CurrentPhase end
function FarmController:GetSettings() return Settings end

return FarmController
