#if defined _class_blocker_config_included
 #endinput
#endif
#define _class_blocker_config_included

#define PERMISSIONS_USER (FPERM_U_READ | FPERM_U_WRITE | FPERM_U_EXEC)
#define PERMISSIONS_GROUP (FPERM_G_READ | FPERM_G_WRITE | FPERM_G_EXEC)
#define PERMISSIONS_OTHER (FPERM_O_READ | FPERM_O_EXEC | FPERM_O_WRITE)
#define PERMISSIONS (PERMISSIONS_USER | PERMISSIONS_GROUP | PERMISSIONS_OTHER)
#define CHAR_COLON ":"
#define CHAR_HYPHEN "-"
#define CHAR_U_UPPER "U"
#define CHAR_U_LOWER "u"
#define KEY_ALLIES_CLASSES "allies classes"
#define KEY_AXIS_CLASSES "axis classes"
#define KEY_ALLIES_WEAPONS "allies weapons"
#define KEY_AXIS_WEAPONS "axis weapons"
#define NO_VALUE 0
