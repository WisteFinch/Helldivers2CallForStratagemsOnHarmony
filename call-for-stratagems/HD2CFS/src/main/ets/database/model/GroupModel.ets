/**
 * 战备组数据模型
 */
@Observed
export default class GroupModel {
  /**
   * 战备组id
   */
  id: number

  /**
   * 战备组名称
   */
  name: string

  /**
   * 战备列表
   */
  list: number[]

  constructor(id: number, name: string, list: number[]) {
    this.id = id
    this.name = name
    this.list = list
  }
}