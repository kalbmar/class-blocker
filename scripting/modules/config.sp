static char g_configPlayersPath[PLATFORM_MAX_PATH];

void Config_BuildConfigPath() {
    BuildPath(Path_SM, g_configPlayersPath, sizeof(g_configPlayersPath), "configs/class-blocker");

    if (!DirExists(g_configPlayersPath)) {
        CreateDirectory(g_configPlayersPath, PERMISSIONS);
    }
}

void Config_PluginReload() {
    for (int client = 1; client <= MaxClients; client++) {
        if (IsClientConnected(client)) {
            Config_ReadPlayerSettings(client);
            Client_GetDesiredClass(client);
        }
    }
}

void Config_ReadPlayerSettings(int client) {
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

    KeyValues kv = new KeyValues("Player settings");

    kv.ImportFromFile(playerSettingsPath);

    alliesClasses = kv.GetNum(KEY_ALLIES_CLASSES);
    axisClasses = kv.GetNum(KEY_AXIS_CLASSES);
    alliesWeapons = kv.GetNum(KEY_ALLIES_WEAPONS);
    axisWeapons = kv.GetNum(KEY_AXIS_WEAPONS);
	
    ReplaceString(steam, sizeof(steam), CHAR_U_LOWER, CHAR_U_UPPER);
    ReplaceString(steam, sizeof(steam), CHAR_HYPHEN, CHAR_COLON);

    g_alliesClasses.SetValue(steam, alliesClasses);
    g_axisClasses.SetValue(steam, axisClasses);
    g_alliesWeapons.SetValue(steam, alliesWeapons);
    g_axisWeapons.SetValue(steam, axisWeapons);

    Config_LoadWeaponsUseSettings(client, Team_Allies, alliesWeapons);
    Config_LoadWeaponsUseSettings(client, Team_Axis, axisWeapons);
 
    delete kv;
}

void Config_LoadWeaponsUseSettings(int client, int team, int weapons) {
    for (int i = 0; i < WEAPON_TEAM_AMOUNT; i++) {
        if (Bit_Check(weapons, i)) {
            char weaponName[WEAPON_NAME_LENGTH];
            int weaponNameIndex;

            weaponNameIndex = (team - Team_Allies) * WEAPON_TEAM_AMOUNT + i;
            Weapon_GetName(weaponName, weaponNameIndex);
            
            g_weaponsClassName[client].SetValue(weaponName, NO_VALUE);
        }
    }
}

void Config_SavePlayerSettings(char[] steam) {
    KeyValues kv = new KeyValues("Player settings");

    char playerSettingsPath[PLATFORM_MAX_PATH];
    int alliesClasses;
    int axisClasses;
    int alliesWeapons;
    int axisWeapons;

    g_alliesClasses.GetValue(steam, alliesClasses);
    g_axisClasses.GetValue(steam, axisClasses);
    g_alliesWeapons.GetValue(steam, alliesWeapons);
    g_axisWeapons.GetValue(steam, axisWeapons);

    ReplaceString(steam, MAX_AUTHID_LENGTH, CHAR_U_UPPER, CHAR_U_LOWER);
    ReplaceString(steam, MAX_AUTHID_LENGTH, CHAR_COLON, CHAR_HYPHEN);
	
    Format(playerSettingsPath, sizeof(playerSettingsPath), "%s/%s.txt", g_configPlayersPath, steam);

    kv.SetNum(KEY_ALLIES_CLASSES, alliesClasses);
    kv.SetNum(KEY_AXIS_CLASSES, axisClasses);
    kv.SetNum(KEY_ALLIES_WEAPONS, alliesWeapons);
    kv.SetNum(KEY_AXIS_WEAPONS, axisWeapons);
	
    kv.Rewind();
    kv.ExportToFile(playerSettingsPath);

    delete kv;
}
