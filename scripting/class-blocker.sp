#include <sourcemod>
#include <sdkhooks>
#undef REQUIRE_PLUGIN
#include <adminmenu>

#include "class-blocker/client"
#include "class-blocker/config"
#include "class-blocker/menu"
#include "class-blocker/class"
#include "class-blocker/team"
#include "class-blocker/weapon"

#include "modules/client.sp"
#include "modules/class.sp"
#include "modules/team.sp"
#include "modules/weapon.sp"
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
    version = "1.0.1",
    url = "https://github.com/kalbmar/class-blocker",
};

public void OnPluginStart() {
    AdminMenu_Create();
    Config_BuildConfigPath();
    LoadTranslations("class-blocker.phrases");
    Client_CreateBufferSettings();
    Event_Create();
    Config_PluginReload();
}

public void OnLibraryRemoved(const char[] name) {
    if (StrEqual(name, "adminmenu")) {
        AdminMenu_Destroy();
    }
}

public void OnClientPostAdminCheck(int client) {
    Config_ReadPlayerSettings(client, CLIENT_HOOK_ACTIVE_YES);
    Hook_Create(client);
}

public void OnClientDisconnect(int client) {
    Client_ClearWeaponClassName(client);
}

public void OnMapEnd() {
    Client_ClearCurrentSettings();
}

public void OnPluginEnd() {
    Client_DestroySettings();
    Class_DestroySettings();
}
