/* See LICENSE file for copyright and license details. */

/* appearance */
static const unsigned int borderpx  = 2;	/* border pixel of windows */
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
static const char col_nord2[]		= "#2E3440";


static const char *colors[][3]      = {
	/*               bar fg         bg bg         border   */
	[SchemeNorm] = { col_gray3, col_gray1, col_gray2 },		// default theme

	/*               bar fg         bg bg         border   */
	//[SchemeSel]  = { col_gray4, col_nord2, col_nord1  },	// purple theme
	[SchemeSel]  = { col_nord1, col_nord2, col_cyan },	// purple theme
};

/* tagging */
static const char *tags[] = { "1", "2", "3", "4", "5", "6", "7", "8", "9" };

static const Rule rules[] = {
	/* xprop(1):
	 *	WM_CLASS(STRING) = instance, class
	 *	WM_NAME(STRING) = title
	 */
	/* class      instance    title       tags mask     isfloating   monitor */
	{ "Gimp",     NULL,       NULL,       0,            1,           -1 },
	{ "Firefox",  NULL,       NULL,       1 << 8,       0,           -1 },
};

/* layout(s) */
static const float mfact     = 0.55; /* factor of master area size [0.05..0.95] */
static const int nmaster     = 1;    /* number of clients in master area */
static const int resizehints = 0;    /* 1 means respect size hints in tiled resizals */

#include "layouts.c"
static const Layout layouts[] = {
	/* symbol     arrange function */
	{ "[]=",      tile },    /* first entry is default */
	{ "><>",      NULL },    /* no layout function means floating behavior */
	{ "[M]",      monocle },
	{ "HHH",      grid },
};

/* key definitions */
#define MODKEY Mod1Mask
#define TAGKEYS(KEY,TAG) \
	{ MODKEY,                       KEY,      view,           {.ui = 1 << TAG} }, \
	{ MODKEY|ControlMask,           KEY,      toggleview,     {.ui = 1 << TAG} }, \
	{ MODKEY|ShiftMask,             KEY,      tag,            {.ui = 1 << TAG} }, \
	{ MODKEY|ControlMask|ShiftMask, KEY,      toggletag,      {.ui = 1 << TAG} },

/* helper for spawning shell commands in the pre dwm-5.0 fashion */
#define SHCMD(cmd) { .v = (const char*[]){ "/bin/sh", "-c", cmd, NULL } }

/* commands */
static char dmenumon[2] = "0"; /* component of dmenucmd, manipulated in spawn() */
static const char *dmenucmd[]	= { \
	"dmenu_run", "-i", \
	"-m", dmenumon, \
	"-fn", dmenufont, \
	"-nb", col_battle_gray, \
	"-nf", col_gray1, \
	"-sb", col_nord2, \
	"-sf", col_nord1, \
	/*"-l", "30", \*/
	"-p", "dmenu:" , NULL };
static const char *termcmd[] 	= { "st", NULL };
static const char *xtermcmd[] 	= { "xterm", NULL };
static const char *gimpcmd[] 	= { "gimp", NULL };
static const char *mousepadcmd[] = { "mousepad", NULL };
static const char *geanycmd[] 	= { "geany", NULL };
/*static const char *chromiumcmd[] = { "chromium", NULL };*/
static const char *firefoxcmd[]	= { "firefox", NULL };
static const char *pcmanfmcmd[]	= { "pcmanfm", NULL };
/*static const char *thunarcmd[]	= { "thunar", NULL };*/
static const char *alsamixercmd[] = { "st", "alsamixer" };

static Key keys[] = {
	/* modifier                     key        function        argument */
	{ MODKEY,                       XK_p,      spawn,          {.v = dmenucmd } },
	{ MODKEY|ShiftMask,             XK_Return, spawn,          {.v = termcmd } },
	{ MODKEY,                       XK_b,      togglebar,      {0} },
	{ MODKEY|ShiftMask,             XK_j,      rotatestack,    {.i = +1 } },
	{ MODKEY|ShiftMask,             XK_k,      rotatestack,    {.i = -1 } },
	{ MODKEY,                       XK_j,      focusstack,     {.i = +1 } },
	{ MODKEY,                       XK_k,      focusstack,     {.i = -1 } },
	{ MODKEY,                       XK_i,      incnmaster,     {.i = +1 } },
	{ MODKEY,                       XK_d,      incnmaster,     {.i = -1 } },
	{ MODKEY,                       XK_h,      setmfact,       {.f = -0.05} },
	{ MODKEY,                       XK_l,      setmfact,       {.f = +0.05} },
	{ MODKEY,                       XK_Return, zoom,           {0} },
	{ MODKEY,                       XK_Tab,    view,           {0} },
	{ MODKEY|ShiftMask,             XK_c,      killclient,     {0} },
	{ MODKEY,                       XK_t,      setlayout,      {.v = &layouts[0]} },
	{ MODKEY,                       XK_f,      setlayout,      {.v = &layouts[1]} },
	{ MODKEY,                       XK_m,      setlayout,      {.v = &layouts[2]} },
	{ MODKEY,                       XK_g,      setlayout,      {.v = &layouts[3]} },
	{ MODKEY,                       XK_space,  setlayout,      {0} },
	{ MODKEY|ShiftMask,             XK_space,  togglefloating, {0} },
	{ MODKEY,                       XK_0,      view,           {.ui = ~0 } },
	{ MODKEY|ShiftMask,             XK_0,      tag,            {.ui = ~0 } },
	{ MODKEY,                       XK_comma,  focusmon,       {.i = -1 } },
	{ MODKEY,                       XK_period, focusmon,       {.i = +1 } },
	{ MODKEY|ShiftMask,             XK_comma,  tagmon,         {.i = -1 } },
	{ MODKEY|ShiftMask,             XK_period, tagmon,         {.i = +1 } },
	TAGKEYS(                        XK_1,                      0)
	TAGKEYS(                        XK_2,                      1)
	TAGKEYS(                        XK_3,                      2)
	TAGKEYS(                        XK_4,                      3)
	TAGKEYS(                        XK_5,                      4)
	TAGKEYS(                        XK_6,                      5)
	TAGKEYS(                        XK_7,                      6)
	TAGKEYS(                        XK_8,                      7)
	TAGKEYS(                        XK_9,                      8)
	{ MODKEY|ShiftMask,             XK_q,      quit,           {0} },
	{ MODKEY|ShiftMask,             XK_g,      spawn,          {.v = geanycmd } },
	{ MODKEY|ShiftMask,             XK_w,      spawn,          {.v = firefoxcmd } },
	{ MODKEY|ShiftMask,             XK_f,      spawn,          {.v = pcmanfmcmd } },
	{ MODKEY|ShiftMask,             XK_x,      spawn,          {.v = xtermcmd } },
	{ MODKEY|ShiftMask,             XK_a,      spawn,          {.v = alsamixercmd } },
};

/* button definitions */
/* click can be ClkTagBar, ClkLtSymbol, ClkStatusText, ClkWinTitle, ClkClientWin, or ClkRootWin */
static Button buttons[] = {
	/* click                event mask      button          function        argument */
	{ ClkLtSymbol,          0,              Button1,        setlayout,      {0} },
	{ ClkLtSymbol,          0,              Button3,        setlayout,      {.v = &layouts[2]} },
	{ ClkWinTitle,          0,              Button2,        zoom,           {0} },
	{ ClkStatusText,        0,              Button2,        spawn,          {.v = termcmd } },
	{ ClkClientWin,         MODKEY,         Button1,        movemouse,      {0} },
	{ ClkClientWin,         MODKEY,         Button2,        togglefloating, {0} },
	{ ClkClientWin,         MODKEY,         Button3,        resizemouse,    {0} },
	{ ClkTagBar,            0,              Button1,        view,           {0} },
	{ ClkTagBar,            0,              Button3,        toggleview,     {0} },
	{ ClkTagBar,            MODKEY,         Button1,        tag,            {0} },
	{ ClkTagBar,            MODKEY,         Button3,        toggletag,      {0} },
};
