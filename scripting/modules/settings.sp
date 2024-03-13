int Settings_WeaponsRemove(int target, int team, int class, int classes, int weapons) {
    if (!Settings_IsClassEnable(class, classes)) {
        int weaponNameIndex = (team - Team_Allies) * WEAPON_TEAM_AMOUND + class;
		
        weapons = Bit_Remove(weapons, class);
        g_weaponsClassName[target].Remove(g_weaponsName[weaponNameIndex]);
    }

    return weapons;
}

void Settings_WeaponsEnable(int target, int team, int class, int weapons) {
    int weaponNameIndex;

    weaponNameIndex = (team - Team_Allies) * WEAPON_TEAM_AMOUND + class;
		
    if (Settings_IsClassEnable(class, weapons)) {
        g_weaponsClassName[target].SetValue(g_weaponsName[weaponNameIndex], NO_VALUE);
		
    } else {
        g_weaponsClassName[target].Remove(g_weaponsName[weaponNameIndex]);
    }
}

int Settings_SetClasses(int target, int team, int class, int classes, bool showMessage) {
    bool classEnable;
	
    classes = Bit_Invert(classes, class);

    if (!showMessage) {
        return classes;
    }

    if (classes == CLASS_ALL_DISABLE) {
        return classes;
    }
	
    classEnable = Bit_Check(classes, class);

    if (classEnable) {
        UseCase_ClassLock(target, team, class);
		
    } else {
        UseCase_ClassUnlock(target, team, class);
    }

    return classes;
}

void Settings_ClassAllDisabledAllies(char[] steam, int target, int team, int alliesClasses, int alliesWeapons) {
    if (alliesClasses == CLASS_ALL_DISABLE) {
        int weaponNameIndex = (team - Team_Allies) * WEAPON_TEAM_AMOUND + CLASS_ASSAULT;
	
        alliesClasses = Bit_Remove(alliesClasses, CLASS_ASSAULT);
        alliesWeapons = Bit_Remove(alliesWeapons, CLASS_ASSAULT);

        g_weaponsClassName[target].Remove(g_weaponsName[weaponNameIndex]);
    }

    g_alliesClasses.SetValue(steam, alliesClasses);
    g_alliesWeapons.SetValue(steam, alliesWeapons);

    Config_SavePlayerSettings(steam);
}

void Settings_ClassAllDisabledAxis(char[] steam, int target, int team, int axisClasses, int axisWeapons) {
    if (axisClasses == CLASS_ALL_DISABLE) {
        int weaponNameIndex = (team - Team_Allies) * WEAPON_TEAM_AMOUND + CLASS_ASSAULT;
	
        axisClasses = Bit_Remove(axisClasses, CLASS_ASSAULT);
        axisWeapons = Bit_Remove(axisWeapons, CLASS_ASSAULT);

        g_weaponsClassName[target].Remove(g_weaponsName[weaponNameIndex]);
    }

    g_axisClasses.SetValue(steam, axisClasses);
    g_axisWeapons.SetValue(steam, axisWeapons);

    Config_SavePlayerSettings(steam);
}

bool Settings_IsClassEnable(int class, int classes) {
    bool classEnable = Bit_Check(classes, class);

    return classEnable;
}
