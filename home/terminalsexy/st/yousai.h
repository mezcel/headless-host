/* Terminal colors (16 first used in escape sequence) */
static const char *colorname[] = {

  /* 8 normal colors */
  [0] = "#666661", /* black   */
  [1] = "#992e2e", /* red     */
  [2] = "#4c3226", /* green   */
  [3] = "#a67c53", /* yellow  */
  [4] = "#4c7399", /* blue    */
  [5] = "#bf9986", /* magenta */
  [6] = "#d97742", /* cyan    */
  [7] = "#34302d", /* white   */

  /* 8 bright colors */
  [8]  = "#7f7f7a", /* black   */
  [9]  = "#b23636", /* red     */
  [10] = "#664233", /* green   */
  [11] = "#bf8f60", /* yellow  */
  [12] = "#5986b2", /* blue    */
  [13] = "#d9ae98", /* magenta */
  [14] = "#f2854a", /* cyan    */
  [15] = "#4c4742", /* white   */

  /* special colors */
  [256] = "#f5e7de", /* background */
  [257] = "#34302d", /* foreground */
};

/*
 * Default colors (colorname index)
 * foreground, background, cursor
 */
static unsigned int defaultfg = 257;
static unsigned int defaultbg = 256;
static unsigned int defaultcs = 257;

/*
 * Colors used, when the specific fg == defaultfg. So in reverse mode this
 * will reverse too. Another logic would only make the simple feature too
 * complex.
 */
static unsigned int defaultitalic = 7;
static unsigned int defaultunderline = 7;
