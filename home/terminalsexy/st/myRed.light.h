/* Terminal colors (16 first used in escape sequence) */
static const char *colorname[] = {

  /* 8 normal colors */
  [0] = "#000000", /* black   */
  [1] = "#cc0403", /* red     */
  [2] = "#19cb00", /* green   */
  [3] = "#cecb00", /* yellow  */
  [4] = "#ef9292", /* blue    */
  [5] = "#cb1ed1", /* magenta */
  [6] = "#d7f3f3", /* cyan    */
  [7] = "#e5e5e5", /* white   */

  /* 8 bright colors */
  [8]  = "#4d4d4d", /* black   */
  [9]  = "#3e0605", /* red     */
  [10] = "#23fd00", /* green   */
  [11] = "#fffd00", /* yellow  */
  [12] = "#e4567b", /* blue    */
  [13] = "#fd28ff", /* magenta */
  [14] = "#14ffff", /* cyan    */
  [15] = "#ffffff", /* white   */

  /* special colors */
  [256] = "#3c0f0f", /* background */
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
