import { relationalStore } from '@kit.ArkData'
import { Context } from '@kit.AbilityKit'
import GroupModel from '../model/GroupModel'
import { DATABASE_NAME } from '../../common/Constants'

/**
 * 战备组数据访问层
 */
export class GroupDao {
  private rdbStore?: relationalStore.RdbStore
  private tableName: string = 'stratagem_group'

  init(context: Context) {
    // 表SQL
    const sql = `CREATE TABLE IF NOT EXISTS stratagem_group (
                  id INTEGER PRIMARY KEY AUTOINCREMENT,
                  name TEXT)`;
    // 创建表
    relationalStore.getRdbStore(context, {
      name: DATABASE_NAME,
      securityLevel: relationalStore.SecurityLevel.S1
    },
      (_err, rdbStore) => {
      rdbStore.executeSql(sql)
      this.rdbStore = rdbStore
    });
  }

  /**
   * 获取所有战备组列表
   * @returns 战备组列表
   */
  async getGroupList(): Promise<GroupModel[]> {
    if (this.rdbStore == null) {
      return [];
    }
    let predicates = new relationalStore.RdbPredicates(this.tableName);
    let res = await this.rdbStore?.query(predicates, ['id', 'name']);
    let groups: GroupModel[] = [];
    while(!res.isAtLastRow){
      res.goToNextRow();
      let id = res.getLong(res.getColumnIndex('id'));
      let name = res.getString(res.getColumnIndex('name'));
      groups.push(new GroupModel(id, name, []));
    }
    return groups;
  }

  /**
   * 获取指定战备组
   * @param id 战备组id
   * @returns 战备组
   */
  async getGroup(id: number): Promise<GroupModel>{
    if (this.rdbStore == null) {
      return new GroupModel(-1, 'null', []);
    }
    let predicates = new relationalStore.RdbPredicates(this.tableName);
    predicates.equalTo('id', id);
    let res = await this.rdbStore?.query(predicates, ['name', 'list']);
    let name = res.getString(res.getColumnIndex('name'));
    return new GroupModel(id, name, []);
  }

  /**
   * 新增战备组
   * @param group 新的战备组
   */
  addGroup(group: GroupModel) {
    let id = group.id;
    let name = group.name;
    this.rdbStore?.insert(this.tableName, {'id': id, 'name': name});
  }

  /**
   * 更新战备组
   * @param group 新的战备组
   */
  updateGroup(group: GroupModel) {
    let name = group.name;
    let predicates = new relationalStore.RdbPredicates(this.tableName);
    predicates.equalTo('id', group.id);
    this.rdbStore?.update({'name': name}, predicates);
  }

  /**
   * 删除战备组
   * @param id 战备组id
   */
  deleteGroup(id: number){
    let predicates = new relationalStore.RdbPredicates(this.tableName);
    predicates.equalTo('id', id);
    this.rdbStore?.delete(predicates);
  }
}