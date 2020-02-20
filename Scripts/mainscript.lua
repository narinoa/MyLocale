local locale = ""
local wtMainPanel = mainForm:GetChildChecked( "MainPanel", false )
local wtLocale =  wtMainPanel:GetChildChecked( "Text", false )
wtMainPanel:Show(true)
wtLocale:Show(true)
local p = wtLocale:GetPlacementPlain()
		p.alignX = WIDGET_ALIGN_CENTER 
		p.alignY = WIDGET_ALIGN_CENTER
		p.sizeX = 95
		p.posX = 30
		p.sizeY = 65
		p.posY = 15
		wtLocale:SetPlacementPlain(p)
function GetMyLocale()
locale = common.GetLocale():ToUpper()
wtLocale:SetVal("name", locale) 
wtLocale:SetClassVal("class", "LogColorLightRed")
end

function AutoChangeLocale()
if Switch then
	local l = common.GetLocale()
	if tostring(l)~=tostring(LocalName) then
	common.SetLocale( LocalName )
		end
	end
end

local IsAOPanelEnabled = GetConfig( "EnableAOPanel" ) or GetConfig( "EnableAOPanel" ) == nil

function onAOPanelStart( params )
	if IsAOPanelEnabled then
	local SetVal = { val1 = locale, class1 = "LogColorLightRed" } 
	local params = { header =  SetVal , ptype =  "text" , size = 50 } 
	userMods.SendEvent( 'AOPANEL_SEND_ADDON', { name = common.GetAddonName(), sysName = common.GetAddonName(), param = params } )
		wtMainPanel:Show( false )
	end 
end

function onAOPanelChange( params )
	if params.unloading and params.name == "UserAddon/AOPanelMod" then
		wtMainPanel:Show( true )
	end
end

function onAOPanelUpdate(params)
	local SetVal = { val1 = locale, class1 = "LogColorLightRed" } 
	userMods.SendEvent( "AOPANEL_UPDATE_ADDON", { sysName = common.GetAddonName(), header = SetVal } )
end

function enableAOPanelIntegration( enable )
	IsAOPanelEnabled = enable
	SetConfig( "EnableAOPanel", enable )
	if enable then
		onAOPanelStart()
	else
		wtMainPanel:Show( true )
	end
end

function Init()
GetMyLocale()
common.RegisterEventHandler( onAOPanelStart, "AOPANEL_START" )
common.RegisterEventHandler( onAOPanelChange, "EVENT_ADDON_LOAD_STATE_CHANGED" )
common.RegisterEventHandler(GetMyLocale, "EVENT_LOCALE_CHANGED")
common.RegisterEventHandler(onAOPanelUpdate, "EVENT_LOCALE_CHANGED")
DnD.Init(wtMainPanel,wtMainPanel, true, true, nil, KBF_SHIFT )
end

if (avatar.IsExist()) then Init()
else common.RegisterEventHandler(Init, "EVENT_AVATAR_CREATED")	
end