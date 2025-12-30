-- PERMANENT BACKSPACE DROP BUTTON v4.1
-- GitHub Repo Version - Mobile Compatible
local Players = game:GetService("Players")
local player = Players.LocalPlayer
local UIS = game:GetService("UserInputService")

-- ================= CONFIGURATION =================
local BUTTON_CONFIG = {
    Text = "BACKSPACE/DROP",
    Size = UDim2.new(0, 170, 0, 42),
    Position = UDim2.new(1, -175, 0, 15), -- Top-right corner
    Colors = {
        Text = Color3.fromRGB(255, 60, 60),    -- Red
        Background = Color3.fromRGB(90, 90, 90) -- Gray
    },
    Transparency = 0.15 -- 15% (visible but subtle)
}

-- ================= GUI SETUP =================
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "BackspaceDropGUI"
screenGui.Parent = game:GetService("CoreGui")
screenGui.ResetOnSpawn = false
screenGui.IgnoreGuiInset = true

local dropButton = Instance.new("TextButton")
dropButton.Name = "BackspaceButton"
dropButton.Text = BUTTON_CONFIG.Text
dropButton.Font = Enum.Font.GothamMedium
dropButton.TextSize = 14
dropButton.TextColor3 = BUTTON_CONFIG.Colors.Text
dropButton.TextTransparency = BUTTON_CONFIG.Transparency
dropButton.BackgroundColor3 = BUTTON_CONFIG.Colors.Background
dropButton.BackgroundTransparency = BUTTON_CONFIG.Transparency
dropButton.BorderSizePixel = 0
dropButton.AutoButtonColor = false
dropButton.Size = BUTTON_CONFIG.Size
dropButton.Position = BUTTON_CONFIG.Position
dropButton.Visible = true
dropButton.Active = true
dropButton.Draggable = false
dropButton.ZIndex = 999

-- Styling
local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 8)
corner.Parent = dropButton

local stroke = Instance.new("UIStroke")
stroke.Color = Color3.fromRGB(120, 120, 120)
stroke.Thickness = 1.5
stroke.Transparency = 0.2
stroke.Parent = dropButton

-- ================= DROP FUNCTION =================
local function safeDropItem()
    -- Check character
    if not player.Character then
        print("[Backspace] No character found")
        return
    end
    
    -- Find equipped tool
    local tool = player.Character:FindFirstChildWhichIsA("Tool")
    if not tool then
        local originalText = dropButton.Text
        dropButton.Text = "NO TOOL!"
        task.wait(0.8)
        dropButton.Text = originalText
        return
    end
    
    -- Visual feedback
    local originalText = dropButton.Text
    local originalColor = dropButton.BackgroundColor3
    dropButton.Text = "DROPPING..."
    dropButton.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
    
    -- Async drop to prevent freeze
    task.spawn(function()
        pcall(function()
            -- Unequip first
            tool.Parent = player.Backpack or workspace
            
            -- Position in front of character
            local root = player.Character:FindFirstChild("HumanoidRootPart")
            if root then
                local lookVector = root.CFrame.LookVector
                local dropPosition = root.Position + (lookVector * 4) + Vector3.new(0, 2, 0)
                
                task.wait(0.1) -- Server sync
                
                -- Move to workspace
                tool.Parent = workspace
                if tool:FindFirstChild("Handle") then
                    tool:PivotTo(CFrame.new(dropPosition))
                end
            end
            
            print("[Backspace] ✅ Dropped: " .. tool.Name)
        end)
    end)
    
    -- Success feedback
    task.wait(0.4)
    dropButton.Text = "DROPPED ✓"
    dropButton.BackgroundColor3 = Color3.fromRGB(80, 180, 80)
    
    task.wait(0.7)
    dropButton.Text = originalText
    dropButton.BackgroundColor3 = originalColor
end

-- ================= EVENT HANDLERS =================
dropButton.MouseButton1Click:Connect(safeDropItem)
dropButton.TouchTap:Connect(safeDropItem)

-- Backspace hotkey support
UIS.InputBegan:Connect(function(input, gameProcessed)
    if not gameProcessed and input.KeyCode == Enum.KeyCode.Backspace then
        safeDropItem()
    end
end)

-- ================= FINALIZE =================
dropButton.Parent = screenGui

-- Cleanup any duplicates
for _, gui in pairs(game:GetService("CoreGui"):GetChildren()) do
    if gui.Name == "BackspaceDropGUI" and gui ~= screenGui then
        gui:Destroy()
    end
end

-- Startup log
print("╔══════════════════════════════════════╗")
print("║     BACKSPACE DROP v4.1 LOADED       ║")
print("║     GitHub Repo - Permanent          ║")
print("║     Pojok Kanan Atas - Fixed         ║")
print("║     No Freeze - Natural Drop         ║")
print("╚══════════════════════════════════════╝")
