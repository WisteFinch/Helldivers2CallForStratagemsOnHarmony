import { relationalStore } from '@kit.ArkData'
import { Context } from '@kit.AbilityKit'
import { DATABASE_NAME } from '../../common/Constants'
import StratagemModel from '../model/StratagemModel'

/**
 * 战备数据访问层
 */
export class StratagemDao {
  private rdbStore?: relationalStore.RdbStore
  private tableName: string = 'stratagem'

  init(context: Context) {
    // 表SQL
    const sql = `CREATE TABLE IF NOT EXISTS stratagem (
                  id INTEGER NOT NULL,
                  dbId VARCHAR(255) NOT NULL,
                  name TEXT,
                  nameZh TEXT,
                  icon TEXT,
                  steps TEXT,
                  PRIMARY KEY (id, dbId))`;
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
   * 获取所有战备列表
   * @returns 战备列表
   */
  async getStratagemList(): Promise<StratagemModel[]> {
    if (this.rdbStore == null) {
      return [];
    }
    let predicates = new relationalStore.RdbPredicates(this.tableName);
    let res = await this.rdbStore?.query(predicates, ['id', 'dbId', 'name', 'nameZh', 'icon', 'steps']);
    let list: StratagemModel[] = [];
    while (!res.isAtLastRow) {
      res.goToNextRow();
      let id = res.getLong(res.getColumnIndex('id'));
      let dbId = res.getString(res.getColumnIndex('dbId'));
      let name = res.getString(res.getColumnIndex('name'));
      let nameZh = res.getString(res.getColumnIndex('nameZh'));
      let icon = res.getString(res.getColumnIndex('icon'));
      let steps: number[] = JSON.parse(res.getString(res.getColumnIndex('steps')));
      list.push(new StratagemModel(id, dbId, name, nameZh, icon, steps));
    }
    return list;
  }

  /**
   * 获取指定数据库渠道下所有战备列表
   * @returns 战备列表
   */
  async getStratagemListByDBId(dbId: string): Promise<StratagemModel[]> {
    if (this.rdbStore == null) {
      return [];
    }
    let predicates = new relationalStore.RdbPredicates(this.tableName);
    predicates.equalTo('dbId', dbId);
    let res = await this.rdbStore?.query(predicates, ['id', 'name', 'nameZh', 'icon', 'steps']);
    let list: StratagemModel[] = [];
    while (!res.isAtLastRow) {
      res.goToNextRow();
      let id = res.getLong(res.getColumnIndex('id'));
      let name = res.getString(res.getColumnIndex('name'));
      let nameZh = res.getString(res.getColumnIndex('nameZh'));
      let icon = res.getString(res.getColumnIndex('icon'));
      let steps: number[] = JSON.parse(res.getString(res.getColumnIndex('steps')));
      list.push(new StratagemModel(id, dbId, name, nameZh, icon, steps));
    }
    return list;
  }

  /**
   * 获取指定战备
   * @param id 战备id
   * @param dbId 数据库渠道id
   * @returns 战备
   */
  async getStratagem(id: number, dbId: string): Promise<StratagemModel> {
    if (this.rdbStore == null) {
      return new StratagemModel(-1, 'null', 'null', 'null', 'null', []);
    }
    let predicates = new relationalStore.RdbPredicates(this.tableName);
    predicates.equalTo('id', id);
    predicates.equalTo('dbId', dbId);
    let res = await this.rdbStore?.query(predicates, ['name', 'nameZh', 'icon', 'steps']);
    if (res.isAtLastRow) {
      return new StratagemModel(-1, 'null', 'null', 'null', 'null', []);
    } else {
      let name = res.getString(res.getColumnIndex('name'));
      let nameZh = res.getString(res.getColumnIndex('nameZh'));
      let icon = res.getString(res.getColumnIndex('icon'));
      let steps: number[] = JSON.parse(res.getString(res.getColumnIndex('steps')));
      return new StratagemModel(id, dbId, name, nameZh, icon, steps);
    }
  }

  /**
   * 新增战备
   * @param group 新的战备
   */
  addStratagem(stratagem: StratagemModel) {
    let id = stratagem.id;
    let dbId = stratagem.dbId;
    let name = stratagem.name;
    let nameZh = stratagem.nameZh;
    let icon = stratagem.icon;
    let steps = JSON.stringify(stratagem.steps);
    this.rdbStore?.insert(this.tableName,
      {
        'id': id,
        'dbId': dbId,
        'name': name,
        'nameZh': nameZh,
        'icon': icon,
        'steps': steps
      });
  }

  /**
   * 更新战备
   * @param stratagem 新的战备
   */
  updateStratagem(stratagem: StratagemModel) {
    let dbId = stratagem.dbId;
    let name = stratagem.name;
    let nameZh = stratagem.nameZh;
    let icon = stratagem.icon;
    let steps = JSON.stringify(stratagem.steps);
    let predicates = new relationalStore.RdbPredicates(this.tableName);
    predicates.equalTo('id', stratagem.id);
    predicates.equalTo('dbId', stratagem.dbId);
    this.rdbStore?.update({
      'dbId': dbId,
      'name': name,
      'nameZh': nameZh,
      'icon': icon,
      'steps': steps
    },
      predicates);
  }

  /**
   * 依据id删除战备
   * @param id 战备组id
   * @param dbId 数据库渠道id
   */
  deleteGroup(id: number, dbId: string) {
    let predicates = new relationalStore.RdbPredicates(this.tableName);
    predicates.equalTo('id', id);
    predicates.equalTo('dbId', dbId);
    this.rdbStore?.delete(predicates);
  }

  /**
   * 依据数据库渠道id删除战备
   * @param dbId 数据库渠道id
   */
  async deleteGroupByDBId(dbId: string) {
    let predicates = new relationalStore.RdbPredicates(this.tableName);
    predicates.equalTo('dbId', dbId);
    await this.rdbStore?.delete(predicates);
  }

  /**
   * 判断是否存在指定战备
   * @param id 战备id
   * @param dbId 数据库渠道id
   * @returns 数据库渠道id
   */
  async existStratagem(id: number, dbId: string): Promise<boolean> {
    let predicates = new relationalStore.RdbPredicates(this.tableName);
    predicates.equalTo('id', id);
    predicates.equalTo('dbId', dbId);
    let res = await this.rdbStore?.query(predicates);
    if (res == undefined) {
      return false;
    } else {
      return res.rowCount > 0;
    }
  }
}