// Config
local cfgWebsite = "https://www.elhostingservices.com"
local cfgForum = "https://www.elhostingservices.com"
local cfgRules = "https://www.elhostingservices.com"

local cfgServers = {}
cfgServers[ "DarkRP" ] = "YOUR_SERVER_IP_HERE"
cfgServers[ "StarWarsRP" ] = "YOUR_SERVER_IP_HERE"

local font = "DermaLarge"

// CONFIG END

if SERVER then
	resource.AddFile( "materials/elgc.png" )
	return
end

local logo = Material( "elgc.png" )

local function Fuck()
	hook.Remove( "PostDrawTranslucentRenderables", "Draw3D2D" )
	hook.Remove( "CalcView", "ButtonTest" )
	hook.Remove( "HUDPaint", "DrawLogo" )
	elEscape:Remove()
	if IsValid( serverPanel ) then
		serverPanel:Remove()
	end
	gui.EnableScreenClicker( false )
end

local function Paint( self, w, h )
	if self:IsHovered() then
		draw.RoundedBox( 0, 0, 0, w, h, Color( 226, 87, 44 ) )
		draw.RoundedBox( 0, 10, 0, w - 10, h, Color( 31, 31, 31 ) )
	else
		draw.RoundedBox( 0, 10, 0, w - 10, h, Color( 38, 38, 38 ) )
	end
end

local function CreateFancyShit()
	elEscape = vgui.Create( "DPanel" )
	elEscape:SetSize( 400, 400 )
	elEscape.Paint = function( self, w, h )
		draw.RoundedBox( 0, 0, 0, w, h, Color( 56, 56, 56 ) )
		draw.RoundedBox( 0, 10, 10, w - 20, h - 20, Color( 38, 38, 38 ) )
	end
	elEscape:DockPadding( 0, 20, 10, 20 )
	elEscape:SetPos( 50, ScrH() - 450 )
	elEscape:MakePopup()

	local resume = vgui.Create( "DButton", elEscape )
	resume:Dock( TOP )
	resume:SetTall( 60 )
	resume.Paint = Paint
	resume:SetFont( font )
	resume:SetText( "Resume" )
	resume:SetTextColor( Color( 255, 255, 255 ) )
	resume.DoClick = function()
		Fuck()
	end

	local disconnect = vgui.Create( "DButton", elEscape )
	disconnect:Dock( TOP )
	disconnect:SetTall( 60 )
	disconnect.Paint = Paint
	disconnect:SetFont( font )
	disconnect:SetText( "Disconnect" )
	disconnect:SetTextColor( Color( 255, 255, 255 ) )
	disconnect.DoClick = function()
		RunConsoleCommand( "disconnect" )
	end

	local servers = vgui.Create( "DButton", elEscape )
	servers:Dock( TOP )
	servers:SetTall( 60 )
	servers.Paint = Paint
	servers:SetFont( font )
	servers:SetText( "Servers" )
	servers:SetTextColor( Color( 255, 255, 255 ) )
	servers.DoClick = function()
		if not IsValid( serverPanel ) then
			elEscape:MoveTo( 550, ScrH() - 450, 0.5 )

			serverPanel = vgui.Create( "DPanel" )
			serverPanel:SetPos( -450, ScrH() - 450 )
			serverPanel:SetSize( 400, 400 )
			serverPanel.Paint = function( self, w, h )
				draw.RoundedBox( 0, 0, 0, w, h, Color( 56, 56, 56 ) )
				draw.RoundedBox( 0, 10, 10, w - 20, h - 20, Color( 38, 38, 38 ) )
			end
			serverPanel:DockPadding( 0, 20, 10, 20 )
			serverPanel:MakePopup()
			serverPanel:MoveTo( 50, ScrH() - 450, 0.5 )

			for k,v in pairs( cfgServers ) do
				local srv = vgui.Create( "DButton", serverPanel )
				srv:Dock( TOP )
				srv:SetTall( 60 )
				srv.Paint = Paint
				srv:SetFont( font )
				srv:SetText( k )
				srv:SetTextColor( Color( 255, 255, 255 ) )
				srv.DoClick = function()
					LocalPlayer():ConCommand( "connect " .. v )
				end
			end

			local close = vgui.Create( "DButton", serverPanel )
			close:Dock( BOTTOM )
			close:SetTall( 60 )
			close.Paint = Paint
			close:SetFont( font )
			close:SetText( "Back" )
			close:SetTextColor( Color( 255, 255, 255 ) )
			close.DoClick = function()
				elEscape:MoveTo( 50, ScrH() - 450, 0.5 )
				serverPanel:MoveTo( -450, ScrH() - 450, 0.5, 0, 1, function()
					serverPanel:Remove()
				end )
			end
		end
	end


	local website = vgui.Create( "DButton", elEscape )
	website:Dock( TOP )
	website:SetTall( 60 )
	website.Paint = Paint
	website:SetFont( font )
	website:SetText( "Website" )
	website:SetTextColor( Color( 255, 255, 255 ) )
	website.DoClick = function()
		gui.OpenURL( cfgWebsite )
	end

	local forum = vgui.Create( "DButton", elEscape )
	forum:Dock( TOP )
	forum:SetTall( 60 )
	forum.Paint = Paint
	forum:SetFont( font )
	forum:SetText( "Forum" )
	forum:SetTextColor( Color( 255, 255, 255 ) )
	forum.DoClick = function()
		gui.OpenURL( cfgForum )
	end

	local rules = vgui.Create( "DButton", elEscape )
	rules:Dock( TOP )
	rules:SetTall( 60 )
	rules.Paint = Paint
	rules:SetFont( font )
	rules:SetText( "Rules" )
	rules:SetTextColor( Color( 255, 255, 255 ) )
	rules.DoClick = function()
		gui.OpenURL( cfgRules )
	end

	hook.Add( "HUDPaint", "DrawLogo", function()
		surface.SetMaterial( logo )
		surface.SetDrawColor( Color( 255, 255, 255, 255 ) )
		surface.DrawTexturedRect( 50, ScrH() - 850, 400, 400 )
	end )
end

hook.Add( "RenderScene", "PauseMenu", function()
	if input.IsKeyDown( KEY_ESCAPE ) and gui.IsGameUIVisible() then
		gui.HideGameUI()
		if not IsValid( elEscape ) then
			CreateFancyShit()
		end
	end
end )