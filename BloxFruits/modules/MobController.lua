-- Zenith-Hub/bloxfruits/modules/MobController.lua
-- MobController
-- Responsabilidade única: localizar NPCs inimigos no workspace,
-- filtrá-los por critérios (vivo, distância, nome) e agrupá-los
-- em uma posição (Bring Mobs).

local Players = game:GetService("Players")

local MobController = {}

-- Dependências (injetadas pelo loader)
local Movement = nil

-- Configurações padrão
local Settings = {
    MobDistance    = 100,  -- alcance máximo para considerar um NPC
    BringRange     = 15,   -- raio em que os mobs ficarão agrupados
    BringEnabled   = true,
}

-- Estado
local LocalPlayer = Players.LocalPlayer
local CachedMobs  = {}

------------------------------------------------------------
-- Funções privadas
------------------------------------------------------------

local function GetRootPart()
    local char = LocalPlayer.Character
    return char and char:FindFirstChild("HumanoidRootPart")
end

local function IsAlive(model)
    local humanoid = model:FindFirstChildOfClass("Humanoid")
    return humanoid and humanoid.Health > 0
end

local function GetMobRoot(model)
    return model:FindFirstChild("HumanoidRootPart") or model.PrimaryPart
end

------------------------------------------------------------
-- Funções públicas
------------------------------------------------------------

--- Atualiza as configurações do módulo.
function MobController:SetSettings(newSettings)
    for k, v in pairs(newSettings) do
        if Settings[k] ~= nil then
            Settings[k] = v
        end
    end
end

--- Injeta dependências (chamado pelo loader).
function MobController:SetDependencies(deps)
    Movement = deps.Movement
end

--- Retorna todos os inimigos vivos dentro do alcance configurado.
-- @param filterName string opcional (filtra por nome do mob)
-- @return table lista de modelos
function MobController:GetNearbyMobs(filterName)
    local enemiesFolder = workspace:FindFirstChild("Enemies")
    if not enemiesFolder then return {} end

    local root = GetRootPart()
    if not root then return {} end

    local result = {}
    local playerPos = root.Position

    for _, mob in ipairs(enemiesFolder:GetChildren()) do
        if mob:IsA("Model") and IsAlive(mob) then
            local mobRoot = GetMobRoot(mob)
            if mobRoot then
                local dist = (mobRoot.Position - playerPos).Magnitude
                if dist <= Settings.MobDistance then
                    if not filterName or mob.Name == filterName then
                        table.insert(result, mob)
                    end
                end
            end
        end
    end

    CachedMobs = result
    return result
end

--- Retorna o mob mais próximo do jogador.
-- @param filterName string opcional
-- @return Model ou nil
function MobController:GetClosestMob(filterName)
    local mobs = self:GetNearbyMobs(filterName)
    local root = GetRootPart()
    if not root or #mobs == 0 then return nil end

    local closest, closestDist = nil, math.huge
    for _, mob in ipairs(mobs) do
        local mobRoot = GetMobRoot(mob)
        if mobRoot then
            local d = (mobRoot.Position - root.Position).Magnitude
            if d < closestDist then
                closest = mob
                closestDist = d
            end
        end
    end
    return closest
end

--- Agrupa todos os mobs próximos em uma posição (Bring Mobs).
-- @param targetPos Vector3 posição de agrupamento (geralmente perto do jogador)
function MobController:BringMobs(targetPos)
    if not Settings.BringEnabled then return end

    local mobs = self:GetNearbyMobs()
    for _, mob in ipairs(mobs) do
        local mobRoot = GetMobRoot(mob)
        if mobRoot then
            -- Calcula uma posição levemente deslocada para não sobrepor
            local offset = Vector3.new(
                math.random(-Settings.BringRange, Settings.BringRange),
                0,
                math.random(-Settings.BringRange, Settings.BringRange)
            )
            local destination = targetPos + offset

            -- Move o mob via CFrame (rápido e sem física)
            mobRoot.CFrame = CFrame.new(destination)
        end
    end
end

--- Retorna a lista cacheada de mobs (última busca).
function MobController:GetCachedMobs()
    return CachedMobs
end

return MobController
