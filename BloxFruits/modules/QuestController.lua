-- Zenith-Hub/bloxfruits/modules/QuestController.lua
-- QuestController
-- Responsabilidade única: gerenciar o ciclo de quests.
-- Aceita quests, verifica progresso e entrega quando concluídas.
-- Não move o jogador nem ataca - apenas interage com NPCs de quest via remotes.

local Players           = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local QuestController = {}

-- Dependências (injetadas pelo loader)
local Movement = nil
local Mob      = nil

-- Configurações
local Settings = {
    AutoQuest       = true,
    CurrentIsland   = "First Sea", -- First Sea | Second Sea | Third Sea
    TargetLevel     = nil,         -- nil = aceita qualquer quest
}

-- Estado
local LocalPlayer     = Players.LocalPlayer
local CurrentQuest    = nil
local QuestInProgress = false

------------------------------------------------------------
-- Funções privadas
------------------------------------------------------------

local function GetRootPart()
    local char = LocalPlayer.Character
    return char and char:FindFirstChild("HumanoidRootPart")
end

local function FindQuestNPC(npcName)
    -- Procura NPCs de quest em workspace
    local questNPCs = workspace:FindFirstChild("QuestNPCs") or workspace:FindFirstChild("NPCs")
    if not questNPCs then return nil end

    for _, npc in ipairs(questNPCs:GetChildren()) do
        if npc:IsA("Model") and npc.Name == npcName then
            return npc
        end
    end
    return nil
end

local function FindQuestRemote()
    -- Blox Fruits usa remotes em Comm_ para quests
    local commFolder = ReplicatedStorage:FindFirstChild("Comm_")
    if not commFolder then return nil end

    return {
        StartQuest = commFolder:FindFirstChild("StartQuest"),
        CompleteQuest = commFolder:FindFirstChild("CompleteQuest"),
        GetQuest = commFolder:FindFirstChild("GetQuest"),
    }
end

local function GetPlayerQuestData()
    -- Verifica se o jogador já tem uma quest ativa
    local playerData = LocalPlayer:FindFirstChild("PlayerData") or LocalPlayer:FindFirstChild("Data")
    if playerData then
        local quest = playerData:FindFirstChild("Quest")
        if quest then
            return {
                Active = quest.Value ~= "",
                QuestName = quest.Value,
                Progress = playerData:FindFirstChild("QuestProgress") and playerData.QuestProgress.Value or 0,
                Target = playerData:FindFirstChild("QuestTarget") and playerData.QuestTarget.Value or 0,
            }
        end
    end
    return { Active = false }
end

------------------------------------------------------------
-- Funções públicas
------------------------------------------------------------

function QuestController:SetDependencies(deps)
    Movement = deps.Movement
    Mob      = deps.Mob
end

function QuestController:SetSettings(newSettings)
    for k, v in pairs(newSettings) do
        if Settings[k] ~= nil then
            Settings[k] = v
        end
    end
end

--- Aceita uma quest do NPC especificado.
-- @param npcName string nome do NPC de quest
-- @return boolean true se aceitou com sucesso
function QuestController:AcceptQuest(npcName)
    if not Settings.AutoQuest then return false end

    local questData = GetPlayerQuestData()
    if questData.Active then
        -- Já tem uma quest ativa
        CurrentQuest = questData.QuestName
        QuestInProgress = true
        return true
    end

    -- Procura o NPC
    local npc = FindQuestNPC(npcName)
    if not npc then
        warn("[QuestController] NPC de quest não encontrado: " .. tostring(npcName))
        return false
    end

    -- Move até o NPC
    local npcRoot = npc:FindFirstChild("HumanoidRootPart") or npc.PrimaryPart
    if npcRoot then
        Movement:MoveTo(npcRoot.Position)
        Movement:WaitUntilReached(10)
    end

    -- Dispara o remote para iniciar a quest
    local remotes = FindQuestRemote()
    if remotes and remotes.StartQuest then
        local success = remotes.StartQuest:InvokeServer(npcName)
        if success then
            CurrentQuest = npcName
            QuestInProgress = true
            return true
        end
    end

    return false
end

--- Verifica se a quest atual foi concluída.
-- @return boolean true se concluída
function QuestController:IsQuestComplete()
    local questData = GetPlayerQuestData()
    if not questData.Active then
        QuestInProgress = false
        return false
    end

    -- Verifica progresso
    if questData.Progress >= questData.Target then
        return true
    end

    return false
end

--- Entrega a quest atual ao NPC.
-- @param npcName string nome do NPC de quest
-- @return boolean true se entregou com sucesso
function QuestController:TurnInQuest(npcName)
    if not QuestInProgress then return false end

    -- Procura o NPC
    local npc = FindQuestNPC(npcName)
    if not npc then
        warn("[QuestController] NPC de quest não encontrado: " .. tostring(npcName))
        return false
    end

    -- Move até o NPC
    local npcRoot = npc:FindFirstChild("HumanoidRootPart") or npc.PrimaryPart
    if npcRoot then
        Movement:MoveTo(npcRoot.Position)
        Movement:WaitUntilReached(10)
    end

    -- Dispara o remote para completar a quest
    local remotes = FindQuestRemote()
    if remotes and remotes.CompleteQuest then
        local success = remotes.CompleteQuest:InvokeServer(npcName)
        if success then
            CurrentQuest = nil
            QuestInProgress = false
            return true
        end
    end

    return false
end

--- Retorna o nome da quest atual.
function QuestController:GetCurrentQuest()
    return CurrentQuest
end

--- Retorna se há uma quest em andamento.
function QuestController:IsQuestInProgress()
    return QuestInProgress
end

--- Retorna os dados da quest atual (nome, progresso, alvo).
function QuestController:GetQuestData()
    return GetPlayerQuestData()
end

return QuestController
