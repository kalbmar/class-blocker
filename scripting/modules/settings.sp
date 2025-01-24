int Settings_WeaponsRemove(int target, int team, int class, int classes, int weapons) {
    if (!Class_IsEnable(class, classes)) {
        char weaponName[WEAPON_NAME_LENGTH];
        int weaponNameIndex;
		
        weaponNameIndex = (team - Team_Allies) * WEAPON_TEAM_AMOUNT + class;
        weapons = Bit_Remove(weapons, class);
        Weapon_GetName(weaponName, weaponNameIndex);
        
        Client_RemoveWeaponClassName(target, weaponName);
    }

    return weapons;
}

void Settings_WeaponsEnable(int target, int team, int class, int weapons) {
    int weaponNameIndex;
    char weaponName[WEAPON_NAME_LENGTH];

    weaponNameIndex = (team - Team_Allies) * WEAPON_TEAM_AMOUNT + class;
    Weapon_GetName(weaponName, weaponNameIndex);
		
    if (Class_IsEnable(class, weapons)) {
        Client_SetWeaponsSettings(target, weaponName);
		
    } else {
        Client_RemoveWeaponClassName(target, weaponName);
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
