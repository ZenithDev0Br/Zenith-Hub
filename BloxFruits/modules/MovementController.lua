-- Zenith-Hub/bloxfruits/modules/MovementController.lua
-- MovementController
-- Responsabilidade única: mover o personagem do jogador para um destino
-- usando TweenService, de forma suave e cancelável.

local TweenService = game:GetService("TweenService")
local Players      = game:GetService("Players")

local MovementController = {}

-- Estado interno
local LocalPlayer  = Players.LocalPlayer
local ActiveTween  = nil
local DefaultInfo  = TweenInfo.new(1, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut)

------------------------------------------------------------
-- Funções privadas
------------------------------------------------------------

local function GetRootPart()
    local character = LocalPlayer.Character
    return character and character:FindFirstChild("HumanoidRootPart")
end

local function CancelCurrentTween()
    if ActiveTween then
        ActiveTween:Cancel()
        ActiveTween = nil
    end
end

------------------------------------------------------------
-- Funções públicas
------------------------------------------------------------

--- Move o jogador até uma posição (Vector3).
-- @param targetPosition Vector3 destino
-- @param tweenInfo TweenInfo opcional (velocidade, easing, etc)
-- @return boolean true se o tween foi criado com sucesso
function MovementController:MoveTo(targetPosition, tweenInfo)
    CancelCurrentTween()

    local root = GetRootPart()
    if not root then
        warn("[MovementController] HumanoidRootPart não encontrado.")
        return false
    end

    if typeof(targetPosition) ~= "Vector3" then
        warn("[MovementController] Destino inválido.")
        return false
    end

    local info = tweenInfo or DefaultInfo
    local goal = { CFrame = CFrame.new(targetPosition) }

    ActiveTween = TweenService:Create(root, info, goal)
    ActiveTween:Play()

    return true
end

--- Move o jogador até um CFrame (útil para NPCs com orientação).
function MovementController:MoveToCFrame(targetCFrame, tweenInfo)
    CancelCurrentTween()

    local root = GetRootPart()
    if not root then return false end

    local info = tweenInfo or DefaultInfo
    local goal = { CFrame = targetCFrame }

    ActiveTween = TweenService:Create(root, info, goal)
    ActiveTween:Play()

    return true
end

--- Para qualquer movimento em andamento.
function MovementController:Stop()
    CancelCurrentTween()
end

--- Retorna true se o jogador está se movendo atualmente.
function MovementController:IsMoving()
    return ActiveTween ~= nil and ActiveTween.PlaybackState == Enum.PlaybackState.Playing
end

--- Aguarda até o movimento terminar (yield).
function MovementController:WaitUntilReached(timeout)
    if not ActiveTween then return end

    local start = tick()
    while ActiveTween and ActiveTween.PlaybackState == Enum.PlaybackState.Playing do
        if timeout and (tick() - start) > timeout then
            return false
        end
        task.wait(0.1)
    end
    return true
end

return MovementController
