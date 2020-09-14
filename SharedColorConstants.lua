NORMAL_FONT_COLOR_CODE		= "|cffffd200";
HIGHLIGHT_FONT_COLOR_CODE	= "|cffffffff";
RED_FONT_COLOR_CODE			= "|cffff2020";
GREEN_FONT_COLOR_CODE		= "|cff20ff20";
GRAY_FONT_COLOR_CODE		= "|cff808080";
YELLOW_FONT_COLOR_CODE		= "|cffffff00";
LIGHTYELLOW_FONT_COLOR_CODE	= "|cffffff9a";
ORANGE_FONT_COLOR_CODE		= "|cffff7f3f";
ACHIEVEMENT_COLOR_CODE		= "|cffffff00";
BATTLENET_FONT_COLOR_CODE	= "|cff82c5ff";
DISABLED_FONT_COLOR_CODE	= "|cff7f7f7f";
FONT_COLOR_CODE_CLOSE		= "|r";

NORMAL_FONT_COLOR			= CreateColor(1.0, 0.82, 0.0);
WHITE_FONT_COLOR			= CreateColor(1.0, 1.0, 1.0);
HIGHLIGHT_FONT_COLOR		= CreateColor(1.0, 1.0, 1.0);
RED_FONT_COLOR				= CreateColor(1.0, 0.1, 0.1);
DIM_RED_FONT_COLOR			= CreateColor(0.8, 0.1, 0.1);
DULL_RED_FONT_COLOR			= CreateColor(0.75, 0.15, 0.15);
BLUE_FONT_COLOR				= CreateColor(0, 0.749, 0.953);
GREEN_FONT_COLOR			= CreateColor(0.1, 1.0, 0.1);
GRAY_FONT_COLOR				= CreateColor(0.5, 0.5, 0.5);
YELLOW_FONT_COLOR			= CreateColor(1.0, 1.0, 0.0);
LIGHTYELLOW_FONT_COLOR		= CreateColor(1.0, 1.0, 0.6);
DARKYELLOW_FONT_COLOR		= CreateColor(1.0, 0.82, 0.0);
ORANGE_FONT_COLOR			= CreateColor(1.0, 0.5, 0.25);
PASSIVE_SPELL_FONT_COLOR	= CreateColor(0.77, 0.64, 0.0);
BATTLENET_FONT_COLOR 		= CreateColor(0.510, 0.773, 1.0);
TRANSMOGRIFY_FONT_COLOR		= CreateColor(1, 0.5, 1);
DISABLED_FONT_COLOR			= CreateColor(0.498, 0.498, 0.498);
LIGHTBLUE_FONT_COLOR		= CreateColor(0.53, 0.67, 1.0);
LIGHTGRAY_FONT_COLOR		= CreateColor(0.6, 0.6, 0.6);
PAPER_FRAME_EXPANDED_COLOR	= CreateColor(0.929, 0.788, 0.620);
PAPER_FRAME_COLLAPSED_COLOR = CreateColor(0.827, 0.659, 0.463);
ARTIFACT_BAR_COLOR 			= CreateColor(0.901, 0.8, 0.601);
WARBOARD_OPTION_TEXT_COLOR	= CreateColor(0.28, 0.02, 0.02);
DEFAULT_CHAT_CHANNEL_COLOR	= CreateColor(1.0, 0.753, 0.753);
DIM_GREEN_FONT_COLOR		= CreateColor(0.251, 0.753, 0.251); -- Used for officer chat in guilds.
BLACK_FONT_COLOR			= CreateColor(0.0, 0.0, 0.0);
LINK_FONT_COLOR				= CreateColor(102.0 / 255.0, 187.0 / 255.0, 255.0 / 255.0); -- Light blue that we use for system links. E.g. calendar events and nydus links in the shop.
SEPIA_COLOR					= CreateColor(0.565, 0.377, 0.157);
HIGHLIGHT_LIGHT_BLUE		= CreateColor(0.243, 0.570, 1);
CORRUPTION_COLOR			= CreateColor(0.584, 0.428, 0.82);
LORE_TEXT_BODY_COLOR		= CreateColor(0.792, 0.776, 0.741);
RARE_MISSION_COLOR			= CreateColor(0, 0.012, 0.291);
TUTORIAL_FONT_COLOR			= CreateColor(0.8, 0.8, 0.8);
DARKGRAY_COLOR				= CreateColor(0.4, 0.4, 0.4);

QUEST_OBJECTIVE_FONT_COLOR = CreateColor(0.8, 0.8, 0.8);
QUEST_OBJECTIVE_HIGHLIGHT_FONT_COLOR = HIGHLIGHT_FONT_COLOR;
QUEST_OBJECTIVE_DISABLED_FONT_COLOR	= DISABLED_FONT_COLOR;
QUEST_OBJECTIVE_DISABLED_HIGHLIGHT_FONT_COLOR = LIGHTGRAY_FONT_COLOR;

AREA_NAME_FONT_COLOR = CreateColor(1.0, 0.9294, 0.7607);
AREA_DESCRIPTION_FONT_COLOR = HIGHLIGHT_FONT_COLOR;
INVASION_FONT_COLOR = CreateColor(0.78, 1, 0);
INVASION_DESCRIPTION_FONT_COLOR = CreateColor(1, 0.973, 0.035);

FACTION_BAR_COLORS = {
	[1] = {r = 0.8, g = 0.3, b = 0.22},
	[2] = {r = 0.8, g = 0.3, b = 0.22},
	[3] = {r = 0.75, g = 0.27, b = 0},
	[4] = {r = 0.9, g = 0.7, b = 0},
	[5] = {r = 0, g = 0.6, b = 0.1},
	[6] = {r = 0, g = 0.6, b = 0.1},
	[7] = {r = 0, g = 0.6, b = 0.1},
	[8] = {r = 0, g = 0.6, b = 0.1},
};

MATERIAL_TEXT_COLOR_TABLE = {
	["Default"] = {0.18, 0.12, 0.06},
	["Stone"] = {1.0, 1.0, 1.0},
	["Parchment"] = {0.18, 0.12, 0.06},
	["Marble"] = {0, 0, 0},
	["Silver"] = {0.12, 0.12, 0.12},
	["Bronze"] = {0.18, 0.12, 0.06},
	["ParchmentLarge"] = {.141, 0, 0}
};

MATERIAL_TITLETEXT_COLOR_TABLE = {
	["Default"] = {0, 0, 0},
	["Stone"] = {0.93, 0.82, 0},
	["Parchment"] = {0, 0, 0},
	["Marble"] = {0.93, 0.82, 0},
	["Silver"] = {0.93, 0.82, 0},
	["Bronze"] = {0.93, 0.82, 0},
	["ParchmentLarge"] = {.208, 0, 0}
};

FRIENDS_BNET_NAME_COLOR = CreateColor(0.510, 0.773, 1.0);
FRIENDS_BNET_BACKGROUND_COLOR = CreateColor(0, 0.694, 0.941, 0.05);
FRIENDS_WOW_NAME_COLOR = CreateColor(0.996, 0.882, 0.361);
FRIENDS_WOW_BACKGROUND_COLOR = CreateColor(1.0, 0.824, 0.0, 0.05);
FRIENDS_GRAY_COLOR = CreateColor(0.486, 0.518, 0.541);
FRIENDS_OFFLINE_BACKGROUND_COLOR = CreateColor(0.588, 0.588, 0.588, 0.05);
FRIENDS_BNET_NAME_COLOR_CODE = "|cff82c5ff";
FRIENDS_BROADCAST_TIME_COLOR_CODE = "|cff4381a8"
FRIENDS_WOW_NAME_COLOR_CODE = "|cfffde05c";
FRIENDS_OTHER_NAME_COLOR_CODE = "|cff7b8489";

COMMON_GRAY_COLOR		= CreateColor(0.65882,	0.65882,	0.65882);
UNCOMMON_GREEN_COLOR	= CreateColor(0.08235,	0.70196,	0.0);
RARE_BLUE_COLOR			= CreateColor(0.0,		0.56863,	0.94902);
EPIC_PURPLE_COLOR		= CreateColor(0.78431,	0.27059,	0.98039);
LEGENDARY_ORANGE_COLOR	= CreateColor(1.0,		0.50196,	0.0);
ARTIFACT_GOLD_COLOR		= CreateColor(0.90196,	0.8,		0.50196);
HEIRLOOM_BLUE_COLOR		= CreateColor(0.0,		0.8,		1);

PLAYER_FACTION_COLORS = { [0] = CreateColor(0.90, 0.05, 0.07), [1] = CreateColor(0.29, 0.33, 0.91) }
PLAYER_FACTION_COLORS_HEX = { [0] = "ffe50d12", [1] = "ff4a54e8" }

TOOLTIP_DEFAULT_COLOR = CreateColor(1, 1, 1);
TOOLTIP_DEFAULT_BACKGROUND_COLOR = CreateColor(0.09, 0.09, 0.19);
