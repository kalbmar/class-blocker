void Event_Create() {
    HookEvent("player_changeclass", Event_PlayerChangeClass);
}

public void Event_PlayerChangeClass(Event event, const char[] name, bool dontBroadcast) {
    int userId = event.GetInt("userid");
    int client = GetClientOfUserId(userId);

    Client_GetDesiredClass(client);
}
