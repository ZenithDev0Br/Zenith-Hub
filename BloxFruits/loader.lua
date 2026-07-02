-- Zenith-Hub/bloxfruits/loader.lua
-- Loader Profissional do Blox Fruits
-- Responsabilidade: Orquestrar a inicialização de Dados, Controllers e UI

local Loader = {}

-- Configuração Base
local BaseUrl = "https://raw.githubusercontent.com/Zenith-Hub/main/bloxfruits/"
-- Se estiver testando localmente ou em outro repo, altere esta URL

------------------------------------------------------------
-- Funções Auxiliares de Carregamento Seguro
------------------------------------------------------------

local function LoadRemoteModule(path)
    local success, result = pcall(function()
        return loadstring(game:HttpGet(BaseUrl .. path))()
    end)
    
    if not success then
        warn(string.format("[Zenith Loader] Falha ao carregar módulo: %s | Erro: %s", path, tostring(result)))
        return nil
    end
    return result
end

local function Notify(title, message, duration)
    -- Notificação simples antes da UI carregar
    game:GetService("StarterGui"):SetCore("SendNotification", {
        Title = title,
        Text = message,
        Duration = duration or 5
    })
end

------------------------------------------------------------
-- Inicialização Principal
------------------------------------------------------------

function Loader.Start()
    print("[Zenith Hub] Iniciando carregamento...")
    Notify("Zenith Hub", "Carregando módulos...", 3)

    -- 1. CARREGAR DADOS (Data Layer)
    -- Os dados devem ser carregados primeiro pois os controllers dependem deles
    local IslandData   = LoadRemoteModule("data/IslandData.lua")
    local WeaponData   = LoadRemoteModule("data/WeaponData.lua")
    local BossData     = LoadRemoteModule("data/BossData.lua")
    local MaterialData = LoadRemoteModule("data/MaterialData.lua")
    local QuestData    = LoadRemoteModule("data/QuestData.lua")

    if not (IslandData and WeaponData and BossData and MaterialData and QuestData) then
        Notify("Zenith Hub", "Erro crítico ao carregar dados!", 10)
        return
    end

    -- 2. CARREGAR CONTROLLERS (Logic Layer)
    local MovementController = LoadRemoteModule("modules/MovementController.lua")
    local MobController      = LoadRemoteModule("modules/MobController.lua")
    local SkillController    = LoadRemoteModule("modules/SkillController.lua")
    local CombatController   = LoadRemoteModule("modules/CombatController.lua")
    local QuestController    = LoadRemoteModule("modules/QuestController.lua")
    local FarmController     = LoadRemoteModule("modules/FarmController.lua")

    if not (MovementController and MobController and SkillController and CombatController and QuestController and FarmController) then
        Notify("Zenith Hub", "Erro crítico ao carregar controllers!", 10)
        return
    end

    -- 3. INJEÇÃO DE DEPENDÊNCIAS
    -- Conecta os módulos sem acoplamento direto
    
    -- QuestController precisa de Movement e Dados
    QuestController:SetDependencies({
        Movement   = MovementController,
        IslandData = IslandData,
        QuestData  = QuestData,
    })

    -- CombatController precisa de Movimento, Mobs e Skills
    CombatController:SetDependencies({
        Movement = MovementController,
        Mob      = MobController,
        Skill    = SkillController,
    })

    -- FarmController é o orquestrador principal
    FarmController:SetDependencies({
        Combat       = CombatController,
        Movement     = MovementController,
        Mob          = MobController,
        Skill        = SkillController,
        Quest        = QuestController,
        WeaponData   = WeaponData,
        BossData     = BossData,
        MaterialData = MaterialData,
    })

    -- 4. CARREGAR INTERFACE (UI Layer)
    -- A Wand UI (Redz V5 Remake) é carregada dentro do ui.lua
    local UI = LoadRemoteModule("ui.lua")
    
    if UI and typeof(UI.Initialize) == "function" then
        UI:Initialize({
            Farm = FarmController,
            Data = {
                Islands   = IslandData,
                Weapons   = WeaponData,
                Bosses    = BossData,
                Materials = MaterialData,
            }
        })
    else
        Notify("Zenith Hub", "Falha ao inicializar UI!", 10)
    end

    -- 5. OTIMIZAÇÕES GLOBAIS (Extraídas do Zyn Hub)
    -- Aplicar otimizações básicas que não quebram a arquitetura
    task.spawn(function()
        -- Auto Ken (Observation Haki)
        local ReplicatedStorage = game:GetService("ReplicatedStorage")
        local CollectionService = game:GetService("CollectionService")
        local Player = game:GetService("Players").LocalPlayer
        
        while task.wait(1) do
            pcall(function()
                local char = Player.Character
                if char and not CollectionService:HasTag(char, "Ken") then
                    ReplicatedStorage.Remotes.CommE:FireServer("Ken", true)
                end
            end)
        end
    end)

    print("[Zenith Hub] ✅ Carregamento concluído com sucesso!")
end

return Loader
