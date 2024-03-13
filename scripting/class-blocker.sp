#include <sourcemod>
#include <sdkhooks>
#include <morecolors>

#undef REQUIRE_PLUGIN
#include <adminmenu>

TopMenu g_adminMenu = null;
TopMenuObject g_menuClassLocker = INVALID_TOPMENUOBJECT;

#include "constant"

#include "modules/variables.sp"
#include "modules/helpers.sp"
#include "modules/client.sp"
#include "modules/event.sp"
#include "modules/hook.sp"
#include "modules/bits.sp"
#include "modules/config.sp"
#include "modules/menu.sp"
#include "modules/settings.sp"
#include "modules/message.sp"
#include "modules/use-case.sp"

public Plugin myinfo = {
    name = "Class blocker",
    author = "Kalbmar",
    description = "Personal class blocker for players",
    version = "0.1.0",
    url = "https://github.com/kalbmar/class-blocker",
};

public void OnPluginStart() {
    AdminMenuCreate();
    Config_BuildConfigPath();
    LoadTranslations("class-blocker.phrases");
    Helpers_Create();
    Event_Create();
    Config_PluginReload();
}

public void OnLibraryRemoved(const char[] name) {
    if (StrEqual(name, "adminmenu")) {
        g_adminMenu = null;
    }
}

void AdminMenuCreate() {
    TopMenu topMenu = GetAdminTopMenu();

    if (LibraryExists("adminmenu") && topMenu != null) {
        OnAdminMenuReady(topMenu);
    }
}

public void OnAdminMenuReady(Handle topMenu) {
    AdminMenuReady(topMenu);
}

public void AdminMenuReady(Handle topMenuHandle) {
    TopMenu topMenu = TopMenu.FromHandle(topMenuHandle);

    if (topMenu == g_adminMenu) {
        return;
    }

    g_adminMenu = topMenu;

    AdminMenu_Create();
}

public void OnClientPostAdminCheck(int client) {
    Config_ReadPlayerSettings(client);
    Hook_Create(client);
}

public void OnClientDisconnect(int client) {
    g_weaponsClassName[client].Clear();
}

public void OnMapEnd() {
    Helper_ClearCurrentSettings();
}

public void OnPluginEnd() {
    Helpers_Delete();
}
