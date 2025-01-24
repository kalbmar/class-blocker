void Hook_Create(int client) {
    SDKHook(client, SDKHook_WeaponCanUse, Hook_WeaponCanUse);
}

public Action Hook_WeaponCanUse(int client, int weapon) {
    if (weapon == WEAPON_NOT_FOUND) {
        return Plugin_Continue;
    }
	
    char weaponName[WEAPON_NAME_LENGTH];
	
    GetEntityClassname(weapon, weaponName, sizeof(weaponName));

    if (!Client_IsWeaponsEnabled(client, weaponName)) {
        return Plugin_Continue;
    }

    return Plugin_Handled;
}
