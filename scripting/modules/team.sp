static char g_teamName[][] = {
    "Unassigned",
    "Spectator",
    "Allies",
    "Axis"
};

void Team_GetName(char[] teamName, int index) {
    strcopy(teamName, TEAM_NAME_LENGTH, g_teamName[index]);
}
