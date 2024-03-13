StringMap g_alliesClasses;
StringMap g_axisClasses;
StringMap g_alliesWeapons;
StringMap g_axisWeapons;
StringMap g_classNameIndex;
StringMap g_weaponsClassName[MAXPLAYERS + 1];

void Helpers_Create() {
    g_alliesClasses = new StringMap();
    g_axisClasses = new StringMap();
    g_alliesWeapons = new StringMap();
    g_axisWeapons = new StringMap();

    for (int client = 1; client <= MaxClients; client++) {
        g_weaponsClassName[client] = new StringMap();
    }
}

void Helpers_LoadClassNameIndex(int client) {
    g_classNameIndex = new StringMap();

    char className[ITEM_LENGTH];

    for (int i = 0; i < sizeof(g_className); i++) {
        Format(className, sizeof(className), "%T", g_className[i], client);

        g_classNameIndex.SetValue(className, i);
    }
}

void Helper_ClearCurrentSettings() {
    g_alliesClasses.Clear();
    g_axisClasses.Clear();
    g_alliesWeapons.Clear();
    g_axisWeapons.Clear();
}

void Helpers_Delete() {
    delete g_alliesClasses;
    delete g_axisClasses;
    delete g_alliesWeapons;
    delete g_axisWeapons;
    delete g_classNameIndex;
	
    for (int i = 1; i <= MaxClients; i++) {
        delete g_weaponsClassName[i];
    }
}
