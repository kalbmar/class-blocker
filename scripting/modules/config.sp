static char g_configPlayersPath[PLATFORM_MAX_PATH];

void Config_BuildConfigPath() {
    BuildPath(Path_SM, g_configPlayersPath, sizeof(g_configPlayersPath), "configs/class-blocker");

    if (!DirExists(g_configPlayersPath)) {
        CreateDirectory(g_configPlayersPath, PERMISSIONS);
    }
}

void Config_PluginReload() {
    for (int client = 1; client <= MaxClients; client++) {
        if (IsClientInGame(client)) {
            Config_ReadPlayerSettings(client, CLIENT_HOOK_ACTIVE_NO);
            Client_GetDesiredClass(client);
        }
    }
}

void Config_ReadPlayerSettings(int client, bool isHookActive) {
    if (!isHookActive) {
        SDKHook(client, SDKHook_WeaponCanUse, Hook_WeaponCanUse);
    }

    char steam[MAX_AUTHID_LENGTH];
    char playerSettingsPath[PLATFORM_MAX_PATH];

    GetClientAuthId(client, AuthId_Steam3, steam, sizeof(steam));
    ReplaceString(steam, MAX_AUTHID_LENGTH, CHAR_U_UPPER, CHAR_U_LOWER);
    ReplaceString(steam, sizeof(steam), CHAR_COLON, CHAR_HYPHEN);
    Format(playerSettingsPath, sizeof(playerSettingsPath), "%s/%s.txt", g_configPlayersPath, steam);

    if (!FileExists(playerSettingsPath)) {
        return;
    }

    int alliesClasses;
    int axisClasses;
    int alliesWeapons;
    int axisWeapons;

    KeyValues kv = Config_CreateKeyValues();

    kv.ImportFromFile(playerSettingsPath);

    alliesClasses = kv.GetNum(KEY_ALLIES_CLASSES);
    axisClasses = kv.GetNum(KEY_AXIS_CLASSES);
    alliesWeapons = kv.GetNum(KEY_ALLIES_WEAPONS);
    axisWeapons = kv.GetNum(KEY_AXIS_WEAPONS);
	
    ReplaceString(steam, sizeof(steam), CHAR_U_LOWER, CHAR_U_UPPER);
    ReplaceString(steam, sizeof(steam), CHAR_HYPHEN, CHAR_COLON);

    Client_SetAlliesClasses(steam, alliesClasses);
    Client_SetAxisClasses(steam, axisClasses);
    Client_SetAlliesWeapons(steam, alliesWeapons);
    Client_SetAxisWeapons(steam, axisWeapons);

    Config_LoadWeaponsUseSettings(client, Team_Allies, alliesWeapons);
    Config_LoadWeaponsUseSettings(client, Team_Axis, axisWeapons);
 
    Config_DestroyKeyValues(kv);
}

void Config_LoadWeaponsUseSettings(int client, int team, int weapons) {
    for (int i = 0; i < WEAPON_TEAM_AMOUNT; i++) {
        if (Bit_Check(weapons, i)) {
            char weaponName[WEAPON_NAME_LENGTH];
            int weaponNameIndex;

            weaponNameIndex = (team - Team_Allies) * WEAPON_TEAM_AMOUNT + i;
            Weapon_GetName(weaponName, weaponNameIndex);
            
            Client_SetWeaponsSettings(client, weaponName);
        }
    }
}

void Config_SavePlayerSettings(char[] steam) {
    KeyValues kv = Config_CreateKeyValues();

    char playerSettingsPath[PLATFORM_MAX_PATH];
    int alliesClasses;
    int axisClasses;
    int alliesWeapons;
    int axisWeapons;

    alliesClasses = Client_GetAlliesClasses(steam);
    axisClasses = Client_GetAxisClasses(steam);
    alliesWeapons = Client_GetAlliesWeapons(steam);
    axisWeapons = Client_GetAxisWeapons(steam);

    ReplaceString(steam, MAX_AUTHID_LENGTH, CHAR_U_UPPER, CHAR_U_LOWER);
    ReplaceString(steam, MAX_AUTHID_LENGTH, CHAR_COLON, CHAR_HYPHEN);
	
    Format(playerSettingsPath, sizeof(playerSettingsPath), "%s/%s.txt", g_configPlayersPath, steam);

    kv.SetNum(KEY_ALLIES_CLASSES, alliesClasses);
    kv.SetNum(KEY_AXIS_CLASSES, axisClasses);
    kv.SetNum(KEY_ALLIES_WEAPONS, alliesWeapons);
    kv.SetNum(KEY_AXIS_WEAPONS, axisWeapons);
	
    kv.Rewind();
    kv.ExportToFile(playerSettingsPath);

    Config_DestroyKeyValues(kv);
}

KeyValues Config_CreateKeyValues() {
    KeyValues kv = new KeyValues("Player settings");

    return kv;
}

void Config_DestroyKeyValues(KeyValues kv) {
    delete kv;
}
