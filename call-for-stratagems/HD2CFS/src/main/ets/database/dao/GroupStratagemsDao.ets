import { relationalStore } from '@kit.ArkData'
import { Context } from '@kit.AbilityKit'
import GroupStratagemsModel from '../model/GroupStratagemsModel'
import { DATABASE_NAME } from '../../common/Constants'

/**
 * 战备组-战备数据访问层
 */
export class GroupStratagemsDao {
  private rdbStore?: relationalStore.RdbStore
  private tableName: string = 'group_stratagems'

  init(context: Context) {
    // 表SQL
    const sql = `CREATE TABLE IF NOT EXISTS group_stratagems (
                  id INTEGER PRIMARY KEY AUTOINCREMENT,
                  groupId INTEGER,
                  stratagemId INTEGER,
                  dbId TEXT)`
    // 创建表
    relationalStore.getRdbStore(context, {
      name: DATABASE_NAME,
      securityLevel: relationalStore.SecurityLevel.S1
    },
      (_err, rdbStore) => {
        rdbStore.executeSql(sql)
        this.rdbStore = rdbStore
      })
  }

  /**
   * 获取所有战备组-战备列表
   * @returns 战备组-战备列表
   */
  async getList(): Promise<GroupStratagemsModel[]> {
    if (this.rdbStore == null) {
      return []
    }
    let predicates = new relationalStore.RdbPredicates(this.tableName)
    let res = await this.rdbStore?.query(predicates, ['id', 'groupId', 'stratagemId', 'dbId'])
    let list: GroupStratagemsModel[] = []
    while(!res.isAtLastRow){
      res.goToNextRow()
      let id = res.getLong(res.getColumnIndex('id'))
      let groupId = res.getLong(res.getColumnIndex('groupId'))
      let stratagemId = res.getLong(res.getColumnIndex('stratagemId'))
      let dbId = res.getString(res.getColumnIndex('dbId'))
      list.push(new GroupStratagemsModel(id, groupId, stratagemId, dbId))
    }
    return list
  }

  /**
   * 获取指定战备组的战备组-战备列表
   * @param groupId 战备组id
   * @returns 战备组-战备列表
   */
  async getListByGroupId(groupId: number): Promise<GroupStratagemsModel[]>{
    if (this.rdbStore == null) {
      return []
    }
    let predicates = new relationalStore.RdbPredicates(this.tableName)
    predicates.equalTo('groupId', groupId)
    let res = await this.rdbStore?.query(predicates, ['id', 'stratagemId', 'dbId'])
    let list: GroupStratagemsModel[] = []
    while(!res.isAtLastRow){
      res.goToNextRow()
      let id = res.getLong(res.getColumnIndex('id'))
      let stratagemId = res.getLong(res.getColumnIndex('stratagemId'))
      let dbId = res.getString(res.getColumnIndex('dbId'))
      list.push(new GroupStratagemsModel(id, groupId, stratagemId, dbId))
    }
    return list
  }

  /**
   * 新增战备组-战备
   * @param db 新的战备组-战备
   */
  addGroup(gs: GroupStratagemsModel) {
    let id = gs.id
    let groupId = gs.groupId
    let stratagemId = gs.stratagemId
    let dbId = gs.dbId
    this.rdbStore?.insert(this.tableName, {'id': id, 'groupId': groupId, 'stratagemId': stratagemId, 'dbId': dbId})
  }

  /**
   * 依据战备组id删除数据库渠道
   * @param groupId 战备组id
   */
  deleteGroup(groupId: number){
    let predicates = new relationalStore.RdbPredicates(this.tableName)
    predicates.equalTo('groupId', groupId)
    this.rdbStore?.delete(predicates)
  }
}