/**
 * 战备数据模型
 */
@Observed
export default class StratagemModel {
  /**
   * 战备id
   */
  id: number

  /**
   * 数据库渠道id
   */
  dbId: string

  /**
   * 战备英文名
   */
  name: string

  /**
   * 战备中文名
   */
  nameZh: string

  /**
   * 战备图标名
   */
  icon: string

  /**
   * 战备输入
   */
  steps: number[]

  constructor(id: number, dbId: string, name: string, nameZh: string, icon: string, steps: number[]) {
    this.id = id
    this.dbId = dbId
    this.name = name
    this.nameZh = nameZh
    this.icon = icon
    this.steps = steps
  }
}