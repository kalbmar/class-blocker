#if defined _cb_constant_included
 #endinput
#endif
#define _cb_constant_included

enum {
	Team_Unassigned = 0,
	Team_Spectator,
	Team_Allies,
	Team_Axis
};

#define PLUGIN_NAME "Class blocker"
#define KEY_ALLIES_CLASSES "allies classes"
#define KEY_AXIS_CLASSES "axis classes"
#define KEY_ALLIES_WEAPONS "allies weapons"
#define KEY_AXIS_WEAPONS "axis weapons"
#define CLASS_ASSAULT 1
#define CLASS_ALL_DISABLE 63
#define CLASS_NAME_LENGTH 32
#define CHAR_COLON ":"
#define CHAR_HYPHEN "-"
#define CHAR_U_UPPER "U"
#define CHAR_U_LOWER "u"
#define MENU_SELECT_PLAYER "Select player"
#define MENU_SELECT_TEAMS "Select team"
#define MENU_SELECT_CLASS "Select class"
#define ITEM_LENGTH 128
#define ITEM_BOTH_TEAMS "Both teams"
#define ITEM_ALLIES "Allies"
#define ITEM_AXIS "Axis"
#define ITEM_WEAPON_USE_ALLIES "Weapon use Allies"
#define ITEM_WEAPON_USE_AXIS "Weapon use Axis"
#define CLIENT_NOT_FOUND 0
#define PLAYER_NAME_LENGTH 32
#define WEAPON_NAME_LENGTH 20
#define WEAPON_NOT_FOUND -1
#define WEAPON_TEAM_AMOUND 6
#define NO_VALUE 0
#define MESSAGE_SHOW_YES true
#define MESSAGE_SHOW_NO false
#define PERMISSIONS_USER (FPERM_U_READ | FPERM_U_WRITE | FPERM_U_EXEC)
#define PERMISSIONS_GROUP (FPERM_G_READ | FPERM_G_WRITE | FPERM_G_EXEC)
#define PERMISSIONS_OTHER (FPERM_O_READ | FPERM_O_EXEC | FPERM_O_WRITE)
#define PERMISSIONS (PERMISSIONS_USER | PERMISSIONS_GROUP | PERMISSIONS_OTHER)
