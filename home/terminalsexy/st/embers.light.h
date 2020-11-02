/* Terminal colors (16 first used in escape sequence) */
static const char *colorname[] = {

  /* 8 normal colors */
  [0] = "#16130f", /* black   */
  [1] = "#826d57", /* red     */
  [2] = "#57826d", /* green   */
  [3] = "#6d8257", /* yellow  */
  [4] = "#6d5782", /* blue    */
  [5] = "#82576d", /* magenta */
  [6] = "#576d82", /* cyan    */
  [7] = "#a39a90", /* white   */

  /* 8 bright colors */
  [8]  = "#5a5047", /* black   */
  [9]  = "#826d57", /* red     */
  [10] = "#57826d", /* green   */
  [11] = "#6d8257", /* yellow  */
  [12] = "#6d5782", /* blue    */
  [13] = "#82576d", /* magenta */
  [14] = "#576d82", /* cyan    */
  [15] = "#dbd6d1", /* white   */

  /* special colors */
  [256] = "#dbd6d1", /* background */
  [257] = "#433b32", /* foreground */
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
