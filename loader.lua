-- Zenith-Hub/loader.lua
-- Loader global do Zenith Hub
-- Responsabilidade: identificar o jogo atual e carregar o módulo correspondente.

local GameId = game.PlaceId

local GameModules = {
    [2753915549] = "bloxfruits", -- Blox Fruits (ID principal)
    [4483381587] = "bloxfruits", -- Blox Fruits (ID alternativo)
}

local GameKey = GameModules[GameId]

if not GameKey then
    warn("[Zenith Hub] Jogo não suportado: " .. tostring(GameId))
    return
end

-- Carrega o loader específico do jogo
local GameLoader = loadstring(game:HttpGet(
    "https://raw.githubusercontent.com/Zenith-Hub/main/" .. GameKey .. "/loader.lua"
))()

if GameLoader then
    GameLoader.Start()
end
