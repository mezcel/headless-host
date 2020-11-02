/* Terminal colors (16 first used in escape sequence) */
static const char *colorname[] = {

  /* 8 normal colors */
  [0] = "#151515", /* black   */
  [1] = "#ac4142", /* red     */
  [2] = "#90a959", /* green   */
  [3] = "#f4bf75", /* yellow  */
  [4] = "#6a9fb5", /* blue    */
  [5] = "#aa759f", /* magenta */
  [6] = "#75b5aa", /* cyan    */
  [7] = "#d0d0d0", /* white   */

  /* 8 bright colors */
  [8]  = "#505050", /* black   */
  [9]  = "#ac4142", /* red     */
  [10] = "#90a959", /* green   */
  [11] = "#f4bf75", /* yellow  */
  [12] = "#6a9fb5", /* blue    */
  [13] = "#aa759f", /* magenta */
  [14] = "#75b5aa", /* cyan    */
  [15] = "#f5f5f5", /* white   */

  /* special colors */
  [256] = "#f5f5f5", /* background */
  [257] = "#303030", /* foreground */
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
