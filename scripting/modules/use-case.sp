void UseCase_ClassLocked(int client, int team, int class, int classes) {
    if (Bit_Check(classes, class)) {
        ChangeClientTeam(client, Team_Spectator);
        Message_ClassLock(client, team, class);
    }
}

void UseCase_ClassLock(int target, int team, int class) {
    int currentClass;
    int currentTeam;

    currentClass = Client_GetClass(target);
    currentTeam = GetClientTeam(target);

    if (currentTeam == team && currentClass == class) {
        ChangeClientTeam(target, Team_Spectator);
        Message_ClassLock(target, team, class);
    }
}

void UseCase_ClassUnlock(int target, int team, int class) {
    Message_ClassUnlock(target, team, class);
}
