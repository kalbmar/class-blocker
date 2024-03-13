void Message_ClassLock(int client, int team, int class) {
    PrintHintText(client, "%t", "Class locked", g_className[class], g_teamName[team]);
    CPrintToChat(client, "%t%t", "Prefix", "Class locked", g_className[class], g_teamName[team]);
}

void Message_ClassUnlock(int client, int team, int class) {
    CPrintToChat(client, "%t%t", "Prefix", "Class unlocked", g_className[class], g_teamName[team]);
}

void Message_PlayerNotAvailable(int client) {
    CPrintToChat(client, "%t%t", "Prefix", "Player is no longer available");
}
