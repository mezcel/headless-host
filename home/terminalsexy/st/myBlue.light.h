/* Terminal colors (16 first used in escape sequence) */
static const char *colorname[] = {

  /* 8 normal colors */
  [0] = "#42fe00", /* black   */
  [1] = "#161b3b", /* red     */
  [2] = "#83a9fc", /* green   */
  [3] = "#fded02", /* yellow  */
  [4] = "#00d5fb", /* blue    */
  [5] = "#e34abe", /* magenta */
  [6] = "#68d8fe", /* cyan    */
  [7] = "#ffcece", /* white   */

  /* 8 bright colors */
  [8]  = "#5c5855", /* black   */
  [9]  = "#382e57", /* red     */
  [10] = "#223746", /* green   */
  [11] = "#fded02", /* yellow  */
  [12] = "#91deff", /* blue    */
  [13] = "#b82293", /* magenta */
  [14] = "#1f3a43", /* cyan    */
  [15] = "#ffc5c5", /* white   */

  /* special colors */
  [256] = "#035199", /* background */
  [257] = "#ffffff", /* foreground */
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
