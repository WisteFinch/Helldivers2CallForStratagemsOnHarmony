import { relationalStore } from '@kit.ArkData'
import { Context } from '@kit.AbilityKit'
import { DATABASE_NAME } from '../../common/Constants'
import DatabaseModel from '../model/DatabaseModel'

/**
 * 数据库渠道数据访问层
 */
export class DatabaseDao {
  private rdbStore?: relationalStore.RdbStore
  private tableName: string = 'database_channel'

  init(context: Context) {
    // 表SQL
    const sql = `CREATE TABLE IF NOT EXISTS database_channel (
                  id TEXT PRIMARY KEY,
                  name TEXT,
                  nameZh TEXT,
                  url TEXT)`
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
   * 获取所有数据库渠道列表
   * @returns 数据库渠道列表
   */
  async getDBList(): Promise<DatabaseModel[]> {
    if (this.rdbStore == null) {
      return []
    }
    let predicates = new relationalStore.RdbPredicates(this.tableName)
    let res = await this.rdbStore?.query(predicates, ['id', 'name', 'nameZh', 'url'])
    let dbs: DatabaseModel[] = []
    while(!res.isAtLastRow){
      res.goToNextRow()
      let id = res.getString(res.getColumnIndex('id'))
      let name = res.getString(res.getColumnIndex('name'))
      let nameZh = res.getString(res.getColumnIndex('nameZh'))
      let url = res.getString(res.getColumnIndex('url'))
      dbs.push(new DatabaseModel(id, name, nameZh, url))
    }
    return dbs
  }

  /**
   * 获取指定数据库渠道
   * @param id 数据库渠道id
   * @returns 数据库渠道
   */
  async getDB(id: string): Promise<DatabaseModel>{
    if (this.rdbStore == null) {
      return new DatabaseModel('null', 'null', 'null', 'null')
    }
    let predicates = new relationalStore.RdbPredicates(this.tableName)
    predicates.equalTo('id', id)
    let res = await this.rdbStore?.query(predicates, ['name', 'nameZh', 'url'])
    let name = res.getString(res.getColumnIndex('name'))
    let nameZh = res.getString(res.getColumnIndex('nameZh'))
    let url = res.getString(res.getColumnIndex('url'))
    return new DatabaseModel(id, name, nameZh, url)
  }

  /**
   * 新增数据库渠道
   * @param db 新的数据库渠道
   */
  addGroup(db: DatabaseModel) {
    let id = db.id
    let name = db.name
    let nameZh = db.nameZh
    let url = db.url
    this.rdbStore?.insert(this.tableName, {'id': id, 'name': name, 'nameZh': nameZh, 'url': url})
  }

  /**
   * 更新数据库渠道
   * @param db 新的数据库渠道
   */
  updateGroup(db: DatabaseModel) {
    let name = db.name
    let nameZh = db.nameZh
    let url = db.url
    let predicates = new relationalStore.RdbPredicates(this.tableName)
    predicates.equalTo('id', db.id)
    this.rdbStore?.update({'name': name, 'nameZh': nameZh, 'url': url}, predicates)
  }

  /**
   * 删除数据库渠道
   * @param id 数据库渠道id
   */
  deleteGroup(id: string){
    let predicates = new relationalStore.RdbPredicates(this.tableName)
    predicates.equalTo('id', id)
    this.rdbStore?.delete(predicates)
  }
}