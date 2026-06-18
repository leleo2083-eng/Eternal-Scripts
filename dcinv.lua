-- Solis Hub — minimal welcome panel, matches Solis UI v2.1
-- No tabs, no sidebar, just clean branded content

local TweenService     = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local Players          = game:GetService("Players")

local player    = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

local DISCORD_INVITE = "https://discord.gg/A93WCDvaut"
local LOGO_ASSET     = "rbxassetid://105894109382235"

if playerGui:FindFirstChild("SolisHub") then
    playerGui:FindFirstChild("SolisHub"):Destroy()
end

local C = {
    WindowBg     = Color3.fromRGB(20, 20, 20),
    CardBg       = Color3.fromRGB(24, 24, 24),
    Border       = Color3.fromRGB(35, 35, 35),
    Element      = Color3.fromRGB(31, 31, 31),
    ElementHover = Color3.fromRGB(38, 38, 38),
    BadgeIdle    = Color3.fromRGB(34, 34, 34),
    White        = Color3.fromRGB(255, 255, 255),
    TextGray     = Color3.fromRGB(154, 154, 154),
    TextDim      = Color3.fromRGB(139, 139, 139),
    Success      = Color3.fromRGB(105, 166, 124),
    CloseRed     = Color3.fromRGB(190, 60, 60),
    MinYellow    = Color3.fromRGB(255, 195, 0),
    Discord      = Color3.fromRGB(88, 101, 242),
}

local TWEEN = TweenInfo.new(0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
local function tw(i, p) TweenService:Create(i, TWEEN, p):Play() end

local function make(class, props)
    local inst = Instance.new(class)
    if inst:IsA("GuiObject") then inst.BorderSizePixel = 0 end
    if inst:IsA("GuiButton") then inst.AutoButtonColor = false end
    if inst:IsA("TextLabel") or inst:IsA("TextButton") then
        inst.Font = Enum.Font.Gotham
        inst.TextColor3 = C.White
        inst.TextSize = 13
    end
    for k, v in pairs(props) do if k ~= "Parent" then inst[k] = v end end
    inst.Parent = props.Parent
    return inst
end

local function corner(p, r) return make("UICorner", { CornerRadius = UDim.new(0, r), Parent = p }) end
local function circle(p) return make("UICorner", { CornerRadius = UDim.new(1, 0), Parent = p }) end
local function stroke(p) return make("UIStroke", { Color = C.Border, Thickness = 1, ApplyStrokeMode = Enum.ApplyStrokeMode.Border, Parent = p }) end

-- Gui
local gui = make("ScreenGui", {
    Name = "SolisHub", ResetOnSpawn = false, IgnoreGuiInset = true,
    ZIndexBehavior = Enum.ZIndexBehavior.Sibling, DisplayOrder = 10, Parent = playerGui,
})

-- Window
local main = make("Frame", {
    Size = UDim2.fromOffset(340, 300),
    Position = UDim2.fromScale(0.5, 0.5),
    AnchorPoint = Vector2.new(0.5, 0.5),
    BackgroundColor3 = C.WindowBg,
    ClipsDescendants = true,
    Parent = gui,
})
corner(main, 12)
stroke(main)

-- Controls
local closeBtn = make("TextButton", {
    Text = "", AnchorPoint = Vector2.new(1, 0),
    Position = UDim2.new(1, -8, 0, 8),
    Size = UDim2.fromOffset(14, 14),
    BackgroundColor3 = C.CloseRed, ZIndex = 12, Parent = main,
})
circle(closeBtn)

local minBtn = make("TextButton", {
    Text = "", AnchorPoint = Vector2.new(1, 0),
    Position = UDim2.new(1, -28, 0, 8),
    Size = UDim2.fromOffset(14, 14),
    BackgroundColor3 = C.MinYellow, ZIndex = 12, Parent = main,
})
circle(minBtn)

-- Logo
local logoFrame = make("Frame", {
    AnchorPoint = Vector2.new(0.5, 0),
    Position = UDim2.new(0.5, 0, 0, 28),
    Size = UDim2.fromOffset(56, 56),
    BackgroundColor3 = C.Element,
    Parent = main,
})
corner(logoFrame, 28)
stroke(logoFrame)

make("ImageLabel", {
    Image = LOGO_ASSET, BackgroundTransparency = 1,
    Position = UDim2.fromOffset(6, 6),
    Size = UDim2.new(1, -12, 1, -12),
    ScaleType = Enum.ScaleType.Fit, Parent = logoFrame,
})

-- Title
make("TextLabel", {
    Text = "Solis", Font = Enum.Font.GothamBold, TextSize = 18,
    BackgroundTransparency = 1,
    AnchorPoint = Vector2.new(0.5, 0),
    Position = UDim2.new(0.5, 0, 0, 92),
    Size = UDim2.new(1, 0, 0, 22),
    Parent = main,
})

-- Subtitle
make("TextLabel", {
    Text = "Join our Discord for updates and support.",
    Font = Enum.Font.Gotham, TextSize = 11,
    TextColor3 = C.TextDim, TextWrapped = true,
    BackgroundTransparency = 1,
    AnchorPoint = Vector2.new(0.5, 0),
    Position = UDim2.new(0.5, 0, 0, 116),
    Size = UDim2.new(1, -48, 0, 16),
    Parent = main,
})

-- Card
local card = make("Frame", {
    AnchorPoint = Vector2.new(0.5, 0),
    Position = UDim2.new(0.5, 0, 0, 148),
    Size = UDim2.new(1, -32, 0, 0),
    AutomaticSize = Enum.AutomaticSize.Y,
    BackgroundColor3 = C.CardBg,
    Parent = main,
})
corner(card, 10)
stroke(card)
make("UIPadding", { PaddingTop = UDim.new(0,12), PaddingBottom = UDim.new(0,12), PaddingLeft = UDim.new(0,14), PaddingRight = UDim.new(0,14), Parent = card })
make("UIListLayout", { FillDirection = Enum.FillDirection.Vertical, SortOrder = Enum.SortOrder.LayoutOrder, Padding = UDim.new(0, 8), Parent = card })

-- Status row
local statusRow = make("Frame", { Size = UDim2.new(1, 0, 0, 22), BackgroundTransparency = 1, Parent = card })

make("TextLabel", {
    Text = "Status", Font = Enum.Font.GothamMedium, TextSize = 12,
    TextColor3 = C.TextGray, TextXAlignment = Enum.TextXAlignment.Left,
    BackgroundTransparency = 1, Size = UDim2.new(0.5, 0, 1, 0), Parent = statusRow,
})

local sPill = make("Frame", {
    AnchorPoint = Vector2.new(1, 0.5), Position = UDim2.new(1, 0, 0.5, 0),
    Size = UDim2.fromOffset(78, 18), BackgroundColor3 = C.BadgeIdle, Parent = statusRow,
})
corner(sPill, 5)

local sDot = make("Frame", {
    AnchorPoint = Vector2.new(0, 0.5), Position = UDim2.new(0, 7, 0.5, 0),
    Size = UDim2.fromOffset(5, 5), BackgroundColor3 = C.Success, Parent = sPill,
})
circle(sDot)

make("TextLabel", {
    Text = "CONNECTED", Font = Enum.Font.GothamBold, TextSize = 8,
    TextColor3 = C.TextGray, TextXAlignment = Enum.TextXAlignment.Left,
    BackgroundTransparency = 1, Position = UDim2.fromOffset(18, 0),
    Size = UDim2.new(1, -22, 1, 0), Parent = sPill,
})

-- Separator
make("Frame", { Size = UDim2.new(1, 0, 0, 1), BackgroundColor3 = C.Border, Parent = card })

-- Discord button
local dBtn = make("TextButton", {
    Text = "", Size = UDim2.new(1, 0, 0, 32),
    BackgroundColor3 = C.Element, Parent = card,
})
corner(dBtn, 6)

local dDot = make("Frame", {
    AnchorPoint = Vector2.new(0, 0.5), Position = UDim2.new(0, 10, 0.5, 0),
    Size = UDim2.fromOffset(5, 5), BackgroundColor3 = C.Discord, ZIndex = 3, Parent = dBtn,
})
circle(dDot)

local dLabel = make("TextLabel", {
    Text = "Copy Discord Invite", Font = Enum.Font.GothamMedium, TextSize = 12,
    TextColor3 = C.TextGray, TextXAlignment = Enum.TextXAlignment.Left,
    BackgroundTransparency = 1, Position = UDim2.fromOffset(22, 0),
    Size = UDim2.new(1, -74, 1, 0), Parent = dBtn,
})

local cBadge = make("Frame", {
    AnchorPoint = Vector2.new(1, 0.5), Position = UDim2.new(1, -8, 0.5, 0),
    Size = UDim2.fromOffset(40, 16), BackgroundColor3 = C.BadgeIdle, ZIndex = 3, Parent = dBtn,
})
corner(cBadge, 4)

local cLabel = make("TextLabel", {
    Text = "COPY", Font = Enum.Font.GothamBold, TextSize = 8,
    TextColor3 = C.TextDim, BackgroundTransparency = 1,
    Size = UDim2.fromScale(1, 1), ZIndex = 4, Parent = cBadge,
})

-- Bottom status
local botStatus = make("Frame", {
    AnchorPoint = Vector2.new(0, 1), Position = UDim2.new(0, 0, 1, 0),
    Size = UDim2.new(1, 0, 0, 28), BackgroundTransparency = 1, Parent = main,
})

local bDot = make("Frame", {
    AnchorPoint = Vector2.new(0, 0.5), Position = UDim2.new(0, 16, 0.5, 0),
    Size = UDim2.fromOffset(5, 5), BackgroundColor3 = C.Success, Parent = botStatus,
})
circle(bDot)

make("TextLabel", {
    Text = "Solis is ready", Font = Enum.Font.GothamMedium, TextSize = 10,
    TextColor3 = C.TextDim, TextXAlignment = Enum.TextXAlignment.Left,
    BackgroundTransparency = 1, Position = UDim2.fromOffset(26, 0),
    Size = UDim2.new(1, -40, 1, 0), Parent = botStatus,
})

-- ═══════════ LOGIC ═══════════

dBtn.MouseEnter:Connect(function() tw(dBtn, {BackgroundColor3 = C.ElementHover}); tw(dLabel, {TextColor3 = C.White}) end)
dBtn.MouseLeave:Connect(function() tw(dBtn, {BackgroundColor3 = C.Element}); tw(dLabel, {TextColor3 = C.TextGray}) end)

dBtn.MouseButton1Click:Connect(function()
    pcall(function()
        if setclipboard then setclipboard(DISCORD_INVITE)
        elseif toclipboard then toclipboard(DISCORD_INVITE)
        end
    end)
    dLabel.Text = "Copied!"
    cLabel.Text = "DONE"
    tw(dDot, {BackgroundColor3 = C.Success})
    tw(cLabel, {TextColor3 = C.Success})
    task.delay(2, function()
        if not dLabel.Parent then return end
        dLabel.Text = "Copy Discord Invite"
        cLabel.Text = "COPY"
        tw(dDot, {BackgroundColor3 = C.Discord})
        tw(cLabel, {TextColor3 = C.TextDim})
    end)
end)

closeBtn.MouseButton1Click:Connect(function() gui:Destroy() end)

local minimized = false
minBtn.MouseButton1Click:Connect(function()
    minimized = not minimized
    main.Visible = not minimized
end)

-- Drag
local dragging, dragStart, startPos = false, nil, nil
main.InputBegan:Connect(function(input)
    if input.UserInputType ~= Enum.UserInputType.MouseButton1 and input.UserInputType ~= Enum.UserInputType.Touch then return end
    local pos = Vector2.new(input.Position.X, input.Position.Y)
    for _, b in ipairs({closeBtn, minBtn, dBtn}) do
        local p, s = b.AbsolutePosition, b.AbsoluteSize
        if pos.X >= p.X and pos.X <= p.X+s.X and pos.Y >= p.Y and pos.Y <= p.Y+s.Y then return end
    end
    dragging = true; dragStart = input.Position; startPos = main.Position
    input.Changed:Connect(function() if input.UserInputState == Enum.UserInputState.End then dragging = false end end)
end)
UserInputService.InputChanged:Connect(function(input)
    if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
        local d = input.Position - dragStart
        main.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset+d.X, startPos.Y.Scale, startPos.Y.Offset+d.Y)
    end
end)
