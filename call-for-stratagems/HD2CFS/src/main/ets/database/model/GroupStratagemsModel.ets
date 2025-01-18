/**
 * 战备组-战备数据模型
 */
@Observed
export default class GroupStratagemsModel {
  /**
   * id
   */
  id: number

  /**
   * 战备组id
   */
  groupId: number

  /**
   * 战备id
   */
  stratagemId: number

  /**
   * 数据库渠道id
   */
  dbId: string

  constructor(id: number, groupId: number, stratagemId: number, dbId: string) {
    this.id = id
    this.groupId = groupId
    this.stratagemId = stratagemId
    this.dbId = dbId
  }
}