static TopMenu g_adminMenu = null;
static TopMenuObject g_menuClassLocker = INVALID_TOPMENUOBJECT;

static int g_target[MAXPLAYERS + 1];
static int g_targetClass[MAXPLAYERS + 1];

void AdminMenu_Create() {
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

    AdminMenu_Ready();
}

void AdminMenu_Destroy() {
    g_adminMenu = null;
}

void AdminMenu_Ready() {
    g_menuClassLocker = g_adminMenu.FindCategory(ADMINMENU_PLAYERCOMMANDS);

    if (g_menuClassLocker != INVALID_TOPMENUOBJECT) {
        g_adminMenu.AddItem(PLUGIN_NAME, AdminMenuHandler_ClassBlock, g_menuClassLocker);
    }
}

public void AdminMenuHandler_ClassBlock(TopMenu topmenu, TopMenuAction action, TopMenuObject topobj_id, int param, char[] buffer, int maxlength) {
    if (action == TopMenuAction_DisplayOption) {
       Format(buffer, maxlength, "%T", PLUGIN_NAME, param);
		
    } else if (action == TopMenuAction_SelectOption) {
        Menu_PlayersList(param);
    }
}

void Menu_PlayersList(int client) {
    Class_LoadIndexName(client);

    Menu menu = new Menu(MenuHandler_Settings);

    menu.SetTitle("%T", MENU_SELECT_PLAYER, client);

    PlayersList_AddItem(menu);

    menu.Display(client, MENU_TIME_FOREVER);
}

public int MenuHandler_Settings(Menu menu, MenuAction action, int param1, int param2) {
    if (action == MenuAction_Select) {
        char info[ITEM_LENGTH];
		
        menu.GetItem(param2, info, sizeof(info));

        int userId = StringToInt(info);
        int target = GetClientOfUserId(userId);
		
        if (target == CLIENT_NOT_FOUND) {
            Menu_PlayersList(param1);
            Message_PlayerNotAvailable(param1);
			
        } else {
		    Menu_SelectClass(param1, target);
        }

    } else if (action == MenuAction_End) {
        delete menu;
    }

    return 0;
}

void Menu_SelectClass(int client, int target) {
    Menu menu = new Menu(MenuHandler_SelectClass);

    menu.SetTitle("%T", MENU_SELECT_CLASS, client);

    char className[CLASS_NAME_LENGTH];
	
    for (int i = 0; i < Class_GetAmount(); i++) {
        Class_GetName(className, i)

        Class_AddItem(menu, className, client);
    }

    g_target[client] = GetClientUserId(target);
	
    menu.ExitBackButton = true;
    menu.Display(client, MENU_TIME_FOREVER);
}

public int MenuHandler_SelectClass(Menu menu, MenuAction action, int param1, int param2) {
    if (action == MenuAction_Select) {
        int target = GetClientOfUserId(g_target[param1]);
        int classIndex;
        char info[ITEM_LENGTH];

        menu.GetItem(param2, info, sizeof(info));

        classIndex = Class_GetValue(info);

        if (target == CLIENT_NOT_FOUND) {
            Menu_PlayersList(param1);
            Message_PlayerNotAvailable(param1);

        } else {
            Menu_SelectTeam(param1, target, classIndex);
        }
		
    } else if (action == MenuAction_Cancel && param2 == MenuCancel_ExitBack) {
		Menu_PlayersList(param1);
		
    } else if (action == MenuAction_End) {
        delete menu;
    }

    return 0;
}

void Menu_SelectTeam(int client, int target, int class) {
    Menu menu = new Menu(MenuHandler_SelectTeam);

    menu.SetTitle("%T", MENU_SELECT_TEAMS, client);
    
    int alliesClasses;
    int axisClasses;
    int alliesWeapons;
    int axisWeapons;
    char steam[MAX_AUTHID_LENGTH];

    GetClientAuthId(target, AuthId_Steam3, steam, sizeof(steam));

    alliesClasses = Client_GetAlliesClasses(steam);
    axisClasses = Client_GetAxisClasses(steam);
    alliesWeapons = Client_GetAlliesWeapons(steam);
    axisWeapons = Client_GetAxisWeapons(steam);
	
    Team_AddItem(menu, ITEM_ALLIES, client, Class_IsEnable(class, alliesClasses));
    Team_AddItem(menu, ITEM_AXIS, client, Class_IsEnable(class, axisClasses));
    menu.AddItem("", "", ITEMDRAW_SPACER);
    UseWeapon_AddItem(menu, ITEM_WEAPON_USE_ALLIES, client, Class_IsEnable(class, alliesWeapons), Class_IsEnable(class, alliesClasses));
    UseWeapon_AddItem(menu, ITEM_WEAPON_USE_AXIS, client, Class_IsEnable(class, axisWeapons), Class_IsEnable(class, axisClasses));

    g_targetClass[client] = class;
    g_target[client] = GetClientUserId(target);

    menu.ExitBackButton = true;
    menu.Display(client, MENU_TIME_FOREVER);
}

public int MenuHandler_SelectTeam(Menu menu, MenuAction action, int param1, int param2) {
    if (action == MenuAction_Select) {
        char info[ITEM_LENGTH];
        int target = GetClientOfUserId(g_target[param1]);
        int classIndex = g_targetClass[param1];

        menu.GetItem(param2, info, sizeof(info));
		
        if (target == CLIENT_NOT_FOUND) {
            Menu_PlayersList(param1);
            Message_PlayerNotAvailable(param1);

        } else if (StrEqual(info, ITEM_ALLIES)){
            Client_ChangeSettings(target, Team_Allies, classIndex);
            Menu_SelectTeam(param1, target, classIndex);
			
        } else if (StrEqual(info, ITEM_AXIS)){
            Client_ChangeSettings(target, Team_Axis, classIndex);
            Menu_SelectTeam(param1, target, classIndex);
			
        } else if (StrEqual(info, ITEM_WEAPON_USE_ALLIES)) {
            Client_ChangeSettingsUseWeapon(target, Team_Allies, classIndex);
            Menu_SelectTeam(param1, target, classIndex);

        } else if (StrEqual(info, ITEM_WEAPON_USE_AXIS)) {
            Client_ChangeSettingsUseWeapon(target, Team_Axis, classIndex);
            Menu_SelectTeam(param1, target, classIndex);
        }
				
    } else if (action == MenuAction_Cancel && param2 == MenuCancel_ExitBack) {
        Menu_PlayersList(param1);
		
    } else if (action == MenuAction_End) {
        delete menu;
    }

    return 0;
}

void PlayersList_AddItem(Menu menu) {
    for (int client = 1; client <= MaxClients; client++) {
        if (IsClientInGame(client) && !IsFakeClient(client)) {
            int userId = GetClientUserId(client);
            char number[ITEM_LENGTH];
            char name[PLAYER_NAME_LENGTH];
			
            IntToString(userId, number, sizeof(number));
            Format(name, sizeof(name), "%N", client);
			
            menu.AddItem(number, name);
        }
    }
}

void Class_AddItem(Menu menu, const char[] format, int client) {
    char item[ITEM_LENGTH];

    Format(item, sizeof(item), "%T", format, client);

    menu.AddItem(item, item);
}

void Team_AddItem(Menu menu, const char[] name, int client, bool enabled) {
    char buffer[ITEM_LENGTH];

    Format(buffer, sizeof(buffer), "%T [%T]", name, client, enabled ? "Disabled" : "Enabled", client);

    menu.AddItem(name, buffer);
}

void UseWeapon_AddItem(Menu menu, const char[] name, int client, bool enabled, bool flagEnable) {
    char buffer[ITEM_LENGTH];

    Format(buffer, sizeof(buffer), "%T [%T]", name, client, enabled ? "Forbidden" : "Allowed", client);

    menu.AddItem(name, buffer, flagEnable ? ITEMDRAW_DEFAULT : ITEMDRAW_DISABLED);
}
