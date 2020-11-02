/* Terminal colors (16 first used in escape sequence) */
static const char *colorname[] = {

  /* 8 normal colors */
  [0] = "#000000", /* black   */
  [1] = "#ff0100", /* red     */
  [2] = "#f98079", /* green   */
  [3] = "#cecb00", /* yellow  */
  [4] = "#ef9292", /* blue    */
  [5] = "#cb1ed1", /* magenta */
  [6] = "#89a2a2", /* cyan    */
  [7] = "#e5e5e5", /* white   */

  /* 8 bright colors */
  [8]  = "#4d4d4d", /* black   */
  [9]  = "#1d865f", /* red     */
  [10] = "#af583f", /* green   */
  [11] = "#a6a556", /* yellow  */
  [12] = "#e4567b", /* blue    */
  [13] = "#fd28ff", /* magenta */
  [14] = "#207373", /* cyan    */
  [15] = "#ffffff", /* white   */

  /* special colors */
  [256] = "#5e2020", /* background */
  [257] = "#d0a2a2", /* foreground */
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
