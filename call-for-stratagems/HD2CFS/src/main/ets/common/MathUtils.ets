/**
 * 限制数值至[0,1]
 * @param num 数值
 * @returns 限制后值
 */
export function  clamp01(num: number): number {
  return Math.min(Math.max(num, 0), 1)
}