local mat_default = Material("arc9/arccw_bird.png")
local mat_new = Material("arc9/plus.png")
local mat_reset = Material("arc9/reset.png")
local nextpreset = 0

function SWEP:CreateHUD_Presets(scroll)
    local plusbtn = vgui.Create("DButton", scroll)
    plusbtn:SetSize(ScreenScale(48), ScreenScale(48))
    plusbtn:DockMargin(ScreenScale(2), 0, 0, 0)
    plusbtn:Dock(LEFT)
    plusbtn:SetText("")
    scroll:AddPanel(plusbtn)

    plusbtn.DoClick = function(self2)
        if nextpreset > CurTime() then return end
        nextpreset = CurTime() + 1
        self:SavePreset(os.date("%y%m%d%H%M%S", os.time()))
        surface.PlaySound("arc9/shutter.ogg")

        timer.Simple(0.5, function()
            if IsValid(self:GetOwner()) then
                self:GetOwner():ScreenFade(SCREENFADE.IN, Color(255, 255, 255, 45), 0.5, 0)
                if self:GetCustomize() then
                    self:CreateHUD_Bottom()
                end
            end
        end)
    end

    plusbtn.Paint = function(self2, w, h)
        local col1 = ARC9.GetHUDColor("fg")
        local name = "NEW"
        local icon = mat_new
        local hasbg = false

        if self2:IsHovered() then
            col1 = ARC9.GetHUDColor("shadow")
            surface.SetDrawColor(ARC9.GetHUDColor("shadow"))
            surface.DrawRect(ScreenScale(1), ScreenScale(1), w - ScreenScale(1), h - ScreenScale(1))

            if self2:IsHovered() then
                surface.SetDrawColor(ARC9.GetHUDColor("hi"))
            else
                surface.SetDrawColor(ARC9.GetHUDColor("fg"))
            end

            surface.DrawRect(0, 0, w - ScreenScale(1), h - ScreenScale(1))
            hasbg = true
        else
            surface.SetDrawColor(ARC9.GetHUDColor("shadow", 100))
            surface.DrawRect(0, 0, w, h)
        end

        if !hasbg then
            surface.SetDrawColor(ARC9.GetHUDColor("shadow"))
            surface.SetMaterial(icon)
            surface.DrawTexturedRect(ScreenScale(2), ScreenScale(2), w - ScreenScale(1), h - ScreenScale(1))
        end

        surface.SetDrawColor(col1)
        surface.SetMaterial(icon)
        surface.DrawTexturedRect(ScreenScale(1), ScreenScale(1), w - ScreenScale(1), h - ScreenScale(1))

        if !hasbg then
            surface.SetTextColor(ARC9.GetHUDColor("shadow"))
            surface.SetTextPos(ScreenScale(14), ScreenScale(1))
            surface.SetFont("ARC9_10")
            self:DrawTextRot(self2, name, 0, 0, ScreenScale(3), ScreenScale(1), ScreenScale(46), true)
        end

        surface.SetTextColor(col1)
        surface.SetTextPos(ScreenScale(13), 0)
        surface.SetFont("ARC9_10")
        self:DrawTextRot(self2, name, 0, 0, ScreenScale(2), 0, ScreenScale(46), false)
    end

    local resetbtn = vgui.Create("DButton", scroll)
    resetbtn:SetSize(ScreenScale(48), ScreenScale(48))
    resetbtn:DockMargin(ScreenScale(2), 0, 0, 0)
    resetbtn:Dock(LEFT)
    resetbtn:SetText("")
    scroll:AddPanel(resetbtn)

    resetbtn.DoClick = function(self2)
        surface.PlaySound("arc9/uninstall.wav")
        self:ClearPreset()
    end

    resetbtn.Paint = function(self2, w, h)
        local col1 = ARC9.GetHUDColor("fg")
        local name = "RESET"
        local icon = mat_reset
        local hasbg = false

        if self2:IsHovered() then
            col1 = ARC9.GetHUDColor("shadow")
            surface.SetDrawColor(ARC9.GetHUDColor("shadow"))
            surface.DrawRect(ScreenScale(1), ScreenScale(1), w - ScreenScale(1), h - ScreenScale(1))

            if self2:IsHovered() then
                surface.SetDrawColor(ARC9.GetHUDColor("hi"))
            else
                surface.SetDrawColor(ARC9.GetHUDColor("fg"))
            end

            surface.DrawRect(0, 0, w - ScreenScale(1), h - ScreenScale(1))
            hasbg = true
        else
            surface.SetDrawColor(ARC9.GetHUDColor("shadow", 100))
            surface.DrawRect(0, 0, w, h)
        end

        if !hasbg then
            surface.SetDrawColor(ARC9.GetHUDColor("shadow"))
            surface.SetMaterial(icon)
            surface.DrawTexturedRect(ScreenScale(2), ScreenScale(2), w - ScreenScale(1), h - ScreenScale(1))
        end

        surface.SetDrawColor(col1)
        surface.SetMaterial(icon)
        surface.DrawTexturedRect(ScreenScale(1), ScreenScale(1), w - ScreenScale(1), h - ScreenScale(1))

        if !hasbg then
            surface.SetTextColor(ARC9.GetHUDColor("shadow"))
            surface.SetTextPos(ScreenScale(14), ScreenScale(1))
            surface.SetFont("ARC9_10")
            self:DrawTextRot(self2, name, 0, 0, ScreenScale(3), ScreenScale(1), ScreenScale(46), true)
        end

        surface.SetTextColor(col1)
        surface.SetTextPos(ScreenScale(13), 0)
        surface.SetFont("ARC9_10")
        self:DrawTextRot(self2, name, 0, 0, ScreenScale(2), 0, ScreenScale(46), false)
    end

    for _, preset in pairs(self:GetPresets()) do
        if preset == "autosave" then continue end
        local filename = ARC9.PresetPath .. self:GetPresetBase() .. "/" .. preset .. "." .. ARC9.PresetIconFormat
        local btn = vgui.Create("DButton", scroll)
        btn:SetSize(ScreenScale(48), ScreenScale(48))
        btn:DockMargin(ScreenScale(2), 0, 0, 0)
        btn:Dock(LEFT)
        btn:SetText("")
        scroll:AddPanel(btn)
        btn.preset = preset

        if file.Exists(filename, "DATA") then
            btn.icon = Material("data/" .. filename, "smooth")
        end

        btn.DoClick = function(self2)
            self:LoadPreset(preset)
            surface.PlaySound("arc9/preset_install.ogg")
        end

        btn.DoRightClick = function(self2)
            self:DeletePreset(preset)
            surface.PlaySound("arc9/preset_delete.ogg")
            self:CreateHUD_Bottom()
        end

        btn.Paint = function(self2, w, h)
            local col1 = ARC9.GetHUDColor("fg")
            local icon = self2.icon or mat_default
            local hasbg = false

            if self2:IsHovered() then
                col1 = ARC9.GetHUDColor("shadow")
                surface.SetDrawColor(ARC9.GetHUDColor("shadow"))
                surface.DrawRect(ScreenScale(1), ScreenScale(1), w - ScreenScale(1), h - ScreenScale(1))

                if self2:IsHovered() then
                    surface.SetDrawColor(ARC9.GetHUDColor("hi"))
                else
                    surface.SetDrawColor(ARC9.GetHUDColor("fg"))
                end

                surface.DrawRect(0, 0, w - ScreenScale(1), h - ScreenScale(1))
                hasbg = true
            else
                surface.SetDrawColor(ARC9.GetHUDColor("shadow", 100))
                surface.DrawRect(0, 0, w, h)
            end

            if not hasbg then
                surface.SetDrawColor(ARC9.GetHUDColor("shadow"))
                surface.SetMaterial(icon)
                surface.DrawTexturedRect(ScreenScale(2), ScreenScale(2), w - ScreenScale(1), h - ScreenScale(1))
            end

            surface.SetDrawColor(col1)
            surface.SetMaterial(icon)
            surface.DrawTexturedRect(ScreenScale(1), ScreenScale(1), w - ScreenScale(1), h - ScreenScale(1))
        end
    end
end