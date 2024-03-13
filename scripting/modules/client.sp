void Client_GetDesiredClass(int client) {
    char steam[MAX_AUTHID_LENGTH];

    GetClientAuthId(client, AuthId_Steam3, steam, sizeof(steam));
	
    int alliesClasses;
    int axisClasses;
    int class = Client_GetClass(client);
    int team = Client_GetTeam(client);

    g_alliesClasses.GetValue(steam, alliesClasses);
    g_axisClasses.GetValue(steam, axisClasses);

    if (team == Team_Allies) {
        UseCase_ClassLocked(client, team, class, alliesClasses);
		
    } else if (team == Team_Axis) {
        UseCase_ClassLocked(client, team, class, axisClasses);
    }
}

void Client_ChangeSettings(int target, int team, int class) {
    int alliesClasses;
    int axisClasses;
    int alliesWeapons;
    int axisWeapons;
    char steam[MAX_AUTHID_LENGTH];

    GetClientAuthId(target, AuthId_Steam3, steam, sizeof(steam));

    g_alliesClasses.GetValue(steam, alliesClasses);
    g_axisClasses.GetValue(steam, axisClasses);
    g_alliesWeapons.GetValue(steam, alliesWeapons);
    g_axisWeapons.GetValue(steam, axisWeapons);

    if (team == Team_Allies) {
        alliesClasses = Settings_SetClasses(target, team, class, alliesClasses, MESSAGE_SHOW_YES);
        alliesWeapons = Settings_WeaponsRemove(target, team, class, alliesClasses, alliesWeapons);
        Settings_ClassAllDisabledAllies(steam, target, team, alliesClasses, alliesWeapons);

    } else if (team == Team_Axis) {
        axisClasses = Settings_SetClasses(target, team, class, axisClasses, MESSAGE_SHOW_YES);
        axisWeapons = Settings_WeaponsRemove(target, team, class, axisClasses, axisWeapons);
        Settings_ClassAllDisabledAxis(steam, target, team, axisClasses, axisWeapons);
    }
}

void Client_ChangeSettingsUseWeapon(int target, int team, int class) {
    int alliesWeapons;
    int axisWeapons;
    char steam[MAX_AUTHID_LENGTH];
	
    GetClientAuthId(target, AuthId_Steam3, steam, sizeof(steam));
	
    g_alliesWeapons.GetValue(steam, alliesWeapons);
    g_axisWeapons.GetValue(steam, axisWeapons);
	
    if (team == Team_Allies) {
        alliesWeapons = Settings_SetClasses(target, team, class, alliesWeapons, MESSAGE_SHOW_NO);
        Settings_WeaponsEnable(target, team, class, alliesWeapons);

        g_alliesWeapons.SetValue(steam, alliesWeapons);
		
    } else if (team == Team_Axis) {
        axisWeapons = Settings_SetClasses(target, team, class, axisWeapons, MESSAGE_SHOW_NO);
        Settings_WeaponsEnable(target, team, class, axisWeapons);

        g_axisWeapons.SetValue(steam, axisWeapons);
    }

    Config_SavePlayerSettings(steam);
}

int Client_GetClass(int client) {
    return GetEntProp(client, Prop_Send, "m_iDesiredPlayerClass");
}

int Client_GetTeam(int client) {
    return GetClientTeam(client);
}
