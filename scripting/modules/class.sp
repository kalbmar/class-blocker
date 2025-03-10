static StringMap g_classNameIndex;

static char g_className[][] = {
    "Rifleman",
    "Assault",
    "Support",
    "Sniper",
    "Mg",
    "Rocket"
};

void Class_LoadIndexName(int client) {
    g_classNameIndex = new StringMap();

    char className[CLASS_NAME_LENGTH];

    for (int i = 0; i < Class_GetAmount(); i++) {
        Class_GetName(className, i);
        Format(className, sizeof(className), "%T", className, client);

        g_classNameIndex.SetValue(className, i);
    }
}

void Class_AllDisabledAllies(char[] steam, int target, int team, int alliesClasses, int alliesWeapons) {
    if (alliesClasses == CLASS_ALL_DISABLE) {
        char weaponName[WEAPON_NAME_LENGTH];
        int weaponNameIndex;
        
        weaponNameIndex = (team - Team_Allies) * WEAPON_TEAM_AMOUNT + CLASS_ASSAULT;
        alliesClasses = Bit_Remove(alliesClasses, CLASS_ASSAULT);
        alliesWeapons = Bit_Remove(alliesWeapons, CLASS_ASSAULT);
        Weapon_GetName(weaponName, weaponNameIndex);

        Client_RemoveWeaponClassName(target, weaponName);
    }

    Client_SetAlliesClasses(steam, alliesClasses);
    Client_SetAlliesWeapons(steam, alliesWeapons);

    Config_SavePlayerSettings(steam);
}

void Class_AllDisabledAxis(char[] steam, int target, int team, int axisClasses, int axisWeapons) {
    if (axisClasses == CLASS_ALL_DISABLE) {
        int weaponNameIndex;
        char weaponName[WEAPON_NAME_LENGTH];
        
        weaponNameIndex = (team - Team_Allies) * WEAPON_TEAM_AMOUNT + CLASS_ASSAULT;
        axisClasses = Bit_Remove(axisClasses, CLASS_ASSAULT);
        axisWeapons = Bit_Remove(axisWeapons, CLASS_ASSAULT);
        Weapon_GetName(weaponName, weaponNameIndex);

        Client_RemoveWeaponClassName(target, weaponName);
    }

    Client_SetAxisClasses(steam, axisClasses);
    Client_SetAxisWeapons(steam, axisWeapons);

    Config_SavePlayerSettings(steam);
}

int Class_GetValue(const char[] key) {
    int value;

    g_classNameIndex.GetValue(key, value);

    return value;
}

void Class_GetName(char[] className, int index) {
    strcopy(className, CLASS_NAME_LENGTH, g_className[index]);
}

int Class_GetAmount() {
    return sizeof(g_className);
}

bool Class_IsEnable(int class, int classes) {
    bool classEnable = Bit_Check(classes, class);

    return classEnable;
}

void Class_DestroySettings() {
    delete g_classNameIndex;
}
