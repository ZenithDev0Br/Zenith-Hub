-- Zenith-Hub/bloxfruits/ui.lua
-- Interface oficial do Zenith Hub usando Wand UI (Redz V5 Remake)
-- Responsabilidade: Conectar a UI aos Controllers sem conter lógica de jogo.

local UI = {}

-- Carregamento da biblioteca (URL confirmada)
local success, Library = pcall(function()
    return loadstring(game:HttpGet(
        "https://raw.githubusercontent.com/tlredz/Library/refs/heads/main/redz-V5-remake/main.luau"
    ))()
end)

if not success or not Library then
    warn("[Zenith UI] Falha ao carregar Wand UI. Verifique sua conexão.")
    return
end

-- Referências aos controllers (injetadas via Initialize)
local FarmController = nil
local DataModules = {}

function UI:Initialize(dependencies)
    FarmController = dependencies.Farm
    DataModules = dependencies.Data or {}
    
    if not FarmController then
        warn("[Zenith UI] FarmController não encontrado. A UI não funcionará corretamente.")
        return
    end

    -- Criação da Janela Principal
    local Window = Library:MakeWindow({
        Title = "Zenith Hub",
        SubTitle = "Blox Fruits | by ZenithDev",
        ScriptFolder = "Zenith-Hub"
    })

    -- ==========================================
    -- TAB: MAIN FARM
    -- ==========================================
    local Main = Window:MakeTab({
        Title = "Main",
        Icon = "Home"
    })

    Main:AddSection("Auto Farm Controls")

    Main:AddDropdown({
        Name = "Farm Mode",
        Description = "Selecione o tipo de farm",
        Options = {"Level", "Bone", "Material", "Boss"},
        Default = "Level",
        Flag = "FarmMode",
        Callback = function(Value)
            FarmController:SetSettings({ Mode = Value })
        end
    })

    Main:AddToggle({
        Name = "Enable Auto Farm",
        Description = "Inicia o ciclo automático",
        Default = false,
        Flag = "AutoFarm",
        Callback = function(Value)
            if Value then
                FarmController:Start()
            else
                FarmController:Stop()
            end
        end
    })

    Main:AddToggle({
        Name = "Auto Quest",
        Description = "Aceita quests automaticamente",
        Default = true,
        Flag = "AutoQuest",
        Callback = function(Value)
            FarmController:SetSettings({ AutoQuest = Value })
        end
    })

    Main:AddDropdown({
        Name = "Select Weapon",
        Description = "Tipo de arma usada no farm",
        Options = {"Melee", "Sword", "Gun", "Blox Fruit"},
        Default = "Melee",
        Flag = "Weapon",
        Callback = function(Value)
            FarmController:SetSettings({ SelectedWeapon = Value })
        end
    })

    Main:AddSection("Combat Settings")

    Main:AddToggle({
        Name = "Fast Attack",
        Description = "Aumenta velocidade de ataque",
        Default = true,
        Flag = "FastAttack",
        Callback = function(Value)
            FarmController:SetSettings({ FastAttack = Value })
        end
    })

    Main:AddSlider({
        Name = "Attack Distance",
        Description = "Distância máxima para atacar",
        Min = 5,
        Max = 50,
        Default = 20,
        Increment = 1,
        Flag = "AttackDistance",
        Callback = function(Value)
            FarmController:SetSettings({ AttackDistance = Value })
        end
    })

    Main:AddSection("Movement Settings")

    Main:AddToggle({
        Name = "Bring Mobs",
        Description = "Agrupa inimigos próximos",
        Default = true,
        Flag = "BringMobs",
        Callback = function(Value)
            FarmController:SetSettings({ BringMobs = Value })
        end
    })

    Main:AddSlider({
        Name = "Mob Distance",
        Description = "Raio para agrupar mobs",
        Min = 50,
        Max = 300,
        Default = 150,
        Increment = 10,
        Flag = "MobDistance",
        Callback = function(Value)
            FarmController:SetSettings({ MobDistance = Value })
        end
    })

    Main:AddToggle({
        Name = "NoClip",
        Description = "Remove colisão durante farm",
        Default = true,
        Flag = "NoClip",
        Callback = function(Value)
            FarmController:SetSettings({ NoClip = Value })
        end
    })

    Main:AddSection("Status")
    
    local StatusLabel = Main:AddParagraph("Current Status", "Idle")
    
    -- Atualização dinâmica do status
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
    -- TAB: SETTINGS
    -- ==========================================
    local Settings = Window:MakeTab({
        Title = "Settings",
        Icon = "Settings"
    })

    Settings:AddSection("General")

    Settings:AddToggle({
        Name = "Auto Save Config",
        Description = "Salva configurações automaticamente",
        Default = true,
        Flag = "AutoSave"
    })

    Settings:AddSlider({
        Name = "UI Scale",
        Description = "Tamanho da interface",
        Min = 0.6,
        Max = 1.6,
        Default = 1.0,
        Increment = 0.1,
        Callback = function(Value)
            Library:SetUIScale(Value)
        end
    })

    Settings:AddSection("Advanced Combat")

    Settings:AddDropdown({
        Name = "Fast Attack Mode",
        Description = "Método de ataque rápido",
        Options = {"Tool", "Remote", "Hybrid"},
        Default = "Hybrid",
        Flag = "FastAttackMode",
        Callback = function(Value)
            FarmController:SetSettings({ FastAttackMode = Value })
        end
    })

    Settings:AddSlider({
        Name = "Attack Speed",
        Description = "Intervalo entre ataques (segundos)",
        Min = 0.05,
        Max = 0.5,
        Default = 0.1,
        Increment = 0.05,
        Flag = "AttackSpeed",
        Callback = function(Value)
            FarmController:SetSettings({ AttackSpeed = Value })
        end
    })

    -- ==========================================
    -- TAB: EXTRAS (EXPANSÃO FUTURA)
    -- ==========================================
    local Extras = Window:MakeTab({
        Title = "Extras",
        Icon = "Star"
    })

    Extras:AddSection("Future Modules")
    
    Extras:AddParagraph("Coming Soon", "Auto Raid\nAuto Sea Events\nAuto CDK\nAuto Materials\nAuto Race V4")

    Extras:AddButton({
        Name = "Rejoin Server",
        Description = "Reconecta no mesmo servidor",
        Callback = function()
            game:GetService("TeleportService"):Teleport(game.PlaceId, game.Players.LocalPlayer)
        end
    })

    Extras:AddButton({
        Name = "Copy JoinScript",
        Description = "Copia link do servidor",
        Callback = function()
            local code = game:GetService("TeleportService"):GetJoinScript(game.Players.LocalPlayer)
            setclipboard(code)
            Window:Notify({
                Title = "Copied!",
                Content = "JoinScript copiado para a área de transferência",
                Duration = 3
            })
        end
    })

    -- ==========================================
    -- TAB: INFO
    -- ==========================================
    local Info = Window:MakeTab({
        Title = "Info",
        Icon = "Info"
    })

    Info:AddParagraph(
        "Zenith Hub",
        "Version: v1.0\nStatus: Development\nArchitecture: Modular Professional"
    )

    Info:AddSection("Features")
    
    Info:AddParagraph("Implemented", "• Auto Farm (Level/Bone/Material/Boss)\n• Auto Quest\n• Bring Mobs\n• Fast Attack (Tool/Remote/Hybrid)\n• NoClip\n• Auto Weapon Selection")
    
    Info:AddParagraph("Coming Soon", "• Auto Raid\n• Auto Sea Events\n• Auto CDK\n• Auto Race V4\n• Auto Materials")

    Info:AddSection("Credits")
    
    Info:AddParagraph("Development", "ZenithDev\nArchitecture: Modular Professional\nUI: Wand UI (Redz V5 Remake)")

    -- Notificação de inicialização
    Window:Notify({
        Title = "Zenith Hub Loaded",
        Content = "Architecture initialized successfully.",
        Duration = 5,
        Image = "rbxassetid://7040410130"
    })
end

return UI
