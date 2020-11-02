/* See LICENSE file for copyright and license details. */

/* appearance */
static const unsigned int borderpx  = 1;	/* border pixel of windows */
static const unsigned int snap      = 7;	/* snap pixel */
static const int showbar            = 1;	/* 0 means no bar */
static const int topbar             = 1;	/* 0 means bottom bar */
static const char *fonts[]          = { "monospace:size=10" };
static const char dmenufont[]       = "monospace:size=10";
static const char col_gray1[]       = "#222222";
static const char col_gray2[]       = "#444444";
static const char col_gray3[]       = "#bbbbbb";
static const char col_gray4[]       = "#eeeeee";
static const char col_cyan[]        = "#005577";
static const char col_purple[]		= "#4B405F";
static const char col_rust[]		= "#A93A3A";
static const char col_rose[]		= "#98616B";
static const char col_baby_blue[]	= "#0065FE";
static const char col_battle_gray[]	= "#CBCBCB";
static const char col_white[]		= "#FFFFFF";
static const char col_cream[]		= "#EDEDED";
static const char col_solarized1[]	= "#C0C0C0";
static const char col_solarized2[]	= "#006060";
static const char col_solarized3[]	= "#003030";
static const char col_black[]		= "#000000";
static const char col_white1[]		= "#FFFFFF";
static const char col_nord1[]		= "#8EBBBA";
static const char col_nord2[]		= "#2D333F";

static const char *colors[][3]      = {
	/*               bar fg         bg bg         border   */
	//[SchemeNorm] = { col_gray3, col_gray1, col_gray2 },		// default theme
	//[SchemeNorm] = { col_gray1, col_battle_gray, col_purple },	// blue cream theme
	//[SchemeNorm] = { col_solarized1, col_solarized2, col_purple },	// dark solarized theme
	//[SchemeNorm] = { col_white1, col_black, col_white1 },	// bw
	[SchemeNorm] = { col_black, col_white1, col_white1 },	// bw-neg

	/*               bar fg         bg bg         border   */
	//[SchemeSel]  = { col_gray4, col_cyan,  col_cyan  },		// default theme
	//[SchemeSel]  = { col_gray4, col_purple, col_purple  },	// purple theme
	//[SchemeSel]  = { col_gray4, col_rust, col_rose },			// red theme
	//[SchemeSel]  = { col_white, col_baby_blue, col_baby_blue },	// blue cream theme
	//[SchemeSel]  = { col_solarized1, col_solarized3, col_solarized2 },	// dark solarized theme
	//[SchemeSel]  = { col_black, col_white1, col_white1 },	// bw
	[SchemeSel]  = { col_white1, col_black, col_black },	// bw-neg
};
