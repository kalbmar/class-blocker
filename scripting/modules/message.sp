void Message_ClassLock(int client, int team, int class) {
    char className[CLASS_NAME_LENGTH];
    char teamName[TEAM_NAME_LENGTH]; 

    Class_GetName(className, class);
    Team_GetName(teamName, team);
    PrintHintText(client, "%t", "Class locked", className, teamName);
    PrintToChat(client, "%t%t", "Prefix", "Class locked", className, teamName);
}

void Message_ClassUnlock(int client, int team, int class) {
    char className[CLASS_NAME_LENGTH];
    char teamName[TEAM_NAME_LENGTH]; 

    Class_GetName(className, class);
    Team_GetName(teamName, team);
    PrintToChat(client, "%t%t", "Prefix", "Class unlocked", className, teamName);
}

void Message_PlayerNotAvailable(int client) {
    PrintToChat(client, "%t%t", "Prefix", "Player is no longer available");
}
