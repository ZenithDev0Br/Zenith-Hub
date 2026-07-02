-- Zenith-Hub/bloxfruits/ui.lua
-- Interface oficial do Zenith Hub usando Wand UI (Redz V5 Remake)
-- Responsabilidade: Conectar a UI aos Controllers sem conter lógica de jogo.

local UI = {}

-- Carregamento seguro da biblioteca
local success, Library = pcall(function()
    return loadstring(game:HttpGet("https://raw.githubusercontent.com/tlredz/Library/refs/heads/main/redz-V5-remake/main.luau"))()
end)

if not success or not Library then
    warn("[Zenith UI] Falha ao carregar Wand UI. Verifique sua conexão ou whitelist.")
    return
end

-- Referências aos controllers (injetadas via Initialize)
local FarmController = nil

function UI:Initialize(dependencies)
    FarmController = dependencies.Farm
    
    if not FarmController then
        warn("[Zenith UI] FarmController não encontrado. A UI não funcionará corretamente.")
        return
    end

    -- Criação da Janela Principal
    local Window = Library:MakeWindow({
        Title = "Zenith Hub | Blox Fruits",
        SubTitle = "Professional Modular Architecture",
        ScriptFolder = "ZenithHub_BF" -- Pasta para salvar flags/configs
    })

    -- ==========================================
    -- TAB: MAIN FARM
    -- ==========================================
    local MainTab = Window:MakeTab({ Title = "Main Farm", Icon = "Sword" })

    MainTab:AddSection("Auto Farm Controls")

    MainTab:AddDropdown({
        Name = "Farm Mode",
        Description = "Selecione o tipo de farm desejado",
        Options = { "Level", "Bone", "Material", "Boss" },
        Default = "Level",
        Flag = "FarmMode",
        Callback = function(Value)
            FarmController:SetSettings({ Mode = Value })
        end
    })

    MainTab:AddToggle({
        Name = "Enable Auto Farm",
        Description = "Inicia o ciclo automático de farm",
        Default = false,
        Flag = "AutoFarmEnabled",
        Callback = function(Value)
            if Value then
                FarmController:Start()
            else
                FarmController:Stop()
            end
        end
    })

    MainTab:AddToggle({
        Name = "Auto Quest",
        Description = "Aceita e entrega quests automaticamente",
        Default = true,
        Flag = "AutoQuest",
        Callback = function(Value)
            FarmController:SetSettings({ AutoQuest = Value })
        end
    })

    MainTab:AddDropdown({
        Name = "Select Weapon Type",
        Description = "Tipo de arma usada no farm",
        Options = { "Melee", "Sword", "Gun", "Blox Fruit" },
        Default = "Melee",
        Flag = "SelectedWeapon",
        Callback = function(Value)
            FarmController:SetSettings({ SelectedWeapon = Value })
        end
    })

    MainTab:AddSection("Status")
    
    -- Atualização dinâmica do status
    local StatusLabel = MainTab:AddParagraph("Current Status", "Idle")
    
    task.spawn(function()
        while task.wait(0.5) do
            if FarmController then
                local phase = FarmController:GetCurrentPhase()
                local enabled = FarmController:IsEnabled()
                StatusLabel:SetDescription(
                    string.format("State: %s | Active: %s", 
                        phase or "Unknown", 
                        tostring(enabled)
                    )
                )
            end
        end
    end)

    -- ==========================================
    -- TAB: SETTINGS & COMBAT
    -- ==========================================
    local SettingsTab = Window:MakeTab({ Title = "Settings", Icon = "Settings" })

    SettingsTab:AddSection("Combat Configuration")

    SettingsTab:AddSlider({
        Name = "Attack Distance",
        Description = "Distância máxima para atacar mobs",
        Min = 10,
        Max = 60,
        Increment = 1,
        Default = 20,
        Flag = "AttackDistance",
        Callback = function(Value)
            FarmController:SetSettings({ AttackDistance = Value })
        end
    })

    SettingsTab:AddSlider({
        Name = "Mob Bring Range",
        Description = "Raio para agrupar inimigos próximos",
        Min = 50,
        Max = 300,
        Increment = 10,
        Default = 150,
        Flag = "BringRange",
        Callback = function(Value)
            FarmController:SetSettings({ MobDistance = Value })
        end
    })

    SettingsTab:AddToggle({
        Name = "Bring Mobs",
        Description = "Agrupa inimigos em um único ponto",
        Default = true,
        Flag = "BringMobs",
        Callback = function(Value)
            FarmController:SetSettings({ BringMobs = Value })
        end
    })

    SettingsTab:AddToggle({
        Name = "Fast Attack",
        Description = "Aumenta a velocidade de ataque (Tool/Remote)",
        Default = true,
        Flag = "FastAttack",
        Callback = function(Value)
            FarmController:SetSettings({ FastAttack = Value })
        end
    })

    SettingsTab:AddToggle({
        Name = "NoClip",
        Description = "Remove colisão do personagem durante o farm",
        Default = true,
        Flag = "NoClip",
        Callback = function(Value)
            FarmController:SetSettings({ NoClip = Value })
        end
    })

    -- ==========================================
    -- TAB: EXTRAS (EXPANSÃO FUTURA)
    -- ==========================================
    local ExtrasTab = Window:MakeTab({ Title = "Extras", Icon = "Star" })
    
    ExtrasTab:AddSection("Future Modules")
    ExtrasTab:AddParagraph("Coming Soon", "Auto Raid\nAuto Sea Events\nAuto CDK\nAuto Materials")
    
    ExtrasTab:AddButton({
        Name = "Rejoin Server",
        Description = "Reconecta no mesmo servidor",
        Callback = function()
            game:GetService("TeleportService"):Teleport(game.PlaceId, game.Players.LocalPlayer)
        end
    })

    -- Notificação de inicialização
    Window:Notify({
        Title = "Zenith Hub Loaded",
        Content = "Architecture initialized successfully.",
        Duration = 5,
        Image = "rbxassetid://7040410130"
    })
end

return UI
