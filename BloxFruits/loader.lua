-- Zenith-Hub/bloxfruits/loader.lua
-- Loader específico do Blox Fruits
-- Responsabilidade: inicializar controllers e UI.

local Loader = {}

-- Caminhos base (podem ser ajustados conforme seu repositório)
local BaseUrl = "https://raw.githubusercontent.com/ZenithHub/main/bloxfruits/"

local function LoadModule(name)
    local source = game:HttpGet(BaseUrl .. "modules/" .. name .. ".lua")
    return loadstring(source)()
end

function Loader.Start()
    -- 1. Carrega os controllers
    local MovementController = LoadModule("MovementController")
    local MobController      = LoadModule("MobController")
    local SkillController    = LoadModule("SkillController")
    local CombatController   = LoadModule("CombatController")
    local FarmController     = LoadModule("FarmController")

    -- 2. Injeta dependências (os controllers precisam se conhecer)
    CombatController:SetDependencies({
        Movement = MovementController,
        Mob      = MobController,
        Skill    = SkillController,
    })

    FarmController:SetDependencies({
        Combat   = CombatController,
        Movement = MovementController,
        Mob      = MobController,
    })

    -- 3. Carrega a UI e passa o FarmController para ela
    local UI = loadstring(game:HttpGet(BaseUrl .. "ui.lua"))()
    UI:Initialize({
        Farm = FarmController,
    })

    print("[Zenith Hub] Blox Fruits inicializado com sucesso.")
end

return Loader
