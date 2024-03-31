static char g_weaponNames[][] = {
    "weapon_garand",
    "weapon_thompson",
    "weapon_bar",
    "weapon_spring",
    "weapon_30cal",
    "weapon_bazooka",
    "weapon_k98",
    "weapon_mp40",
    "weapon_mp44",
    "weapon_k98_scoped",
    "weapon_mg42",
    "weapon_pschreck"
};

void Weapon_GetName(char[] weaponName, int index) {
    strcopy(weaponName, WEAPON_NAME_LENGTH, g_weaponNames[index]);
}
