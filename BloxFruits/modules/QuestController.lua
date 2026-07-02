-- Zenith-Hub/bloxfruits/modules/QuestController.lua (ATUALIZADO)
-- Responsabilidade: Gerenciar quests usando dados reais da IslandData

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local QuestController = {}

-- Dependências
local Movement = nil
local IslandData = nil -- Injetado pelo loader

-- Estado
local LocalPlayer = Players.LocalPlayer
local CurrentQuestData = nil

------------------------------------------------------------
-- Funções Privadas
------------------------------------------------------------

local function GetPlayerLevel()
    local data = LocalPlayer:FindFirstChild("Data")
    return data and data.Level and data.Level.Value or 1
end

local function HasActiveQuest()
    local gui = LocalPlayer.PlayerGui:FindFirstChild("Main")
    if not gui then return false end
    local questFrame = gui:FindFirstChild("Quest")
    return questFrame and questFrame.Visible
end

local function GetQuestTitleText()
    local gui = LocalPlayer.PlayerGui:FindFirstChild("Main")
    if not gui then return "" end
    local title = gui:FindFirstChild("Quest", true) 
        and gui.Quest:FindFirstChild("Container", true)
        and gui.Quest.Container:FindFirstChild("QuestTitle", true)
        and gui.Quest.Container.QuestTitle:FindFirstChild("Title")
    return title and title.Text or ""
end

------------------------------------------------------------
-- Funções Públicas
------------------------------------------------------------

function QuestController:SetDependencies(deps)
    Movement = deps.Movement
    IslandData = deps.IslandData
end

--- Verifica e aceita a quest correta para o nível atual automaticamente
-- @return boolean true se tem uma quest ativa válida
function QuestController:EnsureQuest()
    local level = GetPlayerLevel()
    local questInfo = IslandData:GetQuestForLevel(level)
    
    if not questInfo then
        warn("[QuestController] Nenhuma quest encontrada para o nível " .. level)
        return false
    end
    
    CurrentQuestData = questInfo
    
    -- Se já tem quest ativa, verifica se é a correta
    if HasActiveQuest() then
        local currentTitle = GetQuestTitleText()
        if string.find(currentTitle, questInfo.Mob) then
            return true -- Quest correta já ativa
        else
            -- Abandona quest errada
            pcall(function()
                ReplicatedStorage.Remotes.CommF_:InvokeServer("AbandonQuest")
            end)
            task.wait(0.5)
        end
    end
    
    -- Vai até o NPC e aceita a quest
    if Movement then
        Movement:MoveTo(questInfo.Pos.Position)
        Movement:WaitUntilReached(10)
    end
    
    pcall(function()
        ReplicatedStorage.Remotes.CommF_:InvokeServer("StartQuest", questInfo.Name)
    end)
    
    task.wait(1)
    return HasActiveQuest()
end

--- Retorna os dados da quest atual (Mob, Pos, Name)
function QuestController:GetCurrentQuestData()
    return CurrentQuestData
end

--- Verifica se a quest foi concluída pela UI
function QuestController:IsQuestComplete()
    if not HasActiveQuest() then return false end
    -- O Blox Fruits esconde a quest GUI quando completa
    -- Mas também podemos verificar se o progresso bateu
    -- Por simplicidade, verificamos se a GUI sumiu após farmar
    return not HasActiveQuest()
end

--- Retorna o nome do mob alvo da quest atual
function QuestController:GetTargetMobName()
    return CurrentQuestData and CurrentQuestData.Mob or nil
end

--- Retorna a posição de spawn dos mobs da quest atual
function QuestController:GetMobSpawnPosition()
    return CurrentQuestData and CurrentQuestData.Pos or nil
end

return QuestController
