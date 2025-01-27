import { DatabaseDao } from './dao/DatabaseDao'
import { GroupDao } from './dao/GroupDao'
import { GroupStratagemsDao } from './dao/GroupStratagemsDao'
import { StratagemDao } from './dao/StratagemDao'
import DatabaseModel from './model/DatabaseModel'
import StratagemModel from './model/StratagemModel'

/**
 * 数据库服务
 */
class DatabaseService {
  // 数据访问层
  private groupDao: GroupDao = new GroupDao()
  private stratagemDao: StratagemDao = new StratagemDao()
  private groupStratagemsDao: GroupStratagemsDao = new GroupStratagemsDao()
  private databaseDao: DatabaseDao = new DatabaseDao()

  /**
   * 初始化数据库服务
   * @param context 上下文
   */
  initDBService(context: Context) {
    // 初始化数据访问层
    this.groupDao.init(context);
    this.stratagemDao.init(context);
    this.groupStratagemsDao.init(context);
    this.databaseDao.init(context);
  }

  /**
   * 获取所有数据库渠道
   * @returns 数据库渠道列表
   */
  async GetDbList(): Promise<DatabaseModel[]> {
    return await this.databaseDao.getDBList();
  }

  /**
   * 获取数据库渠道
   * @param dbId 数据库渠道id
   * @returns 数据库渠道
   */
  async GetDb(dbId: string): Promise<DatabaseModel> {
    return await this.databaseDao.getDB(dbId);
  }

  /**
   * 添加数据库渠道
   * @param db 数据库渠道信息
   */
  async addDb(db: DatabaseModel) {
    let value = await this.databaseDao.existDb(db.id);
    if (value) {
      this.databaseDao.updateDb(db);
    }
    else {
      this.databaseDao.addDb(db);
    }
  }

  /**
   * 删除数据库渠道
   * @param dbId 数据库渠道id
   */
  async deleteDb(dbId: string) {
    await this.databaseDao.deleteDb(dbId);
  }

  async getStratagemList(dbId: string): Promise<StratagemModel[]> {
    return await this.stratagemDao.getStratagemListByDBId(dbId);
  }

  /**
   * 添加战备
   * @param stratagem 战备信息
   */
  async addStratagem(stratagem: StratagemModel) {
    let value = await this.stratagemDao.existStratagem(stratagem.id, stratagem.dbId);
    if (value) {
      this.stratagemDao.updateStratagem(stratagem);
    }
    else {
      this.stratagemDao.addStratagem(stratagem);
    }
  }

  /**
   * 删除指定数据库渠道的所有战备
   * @param dbId 数据库渠道id
   */
  async deleteStratagems(dbId: string) {
    await this.stratagemDao.deleteGroupByDBId(dbId);
  }
}

let databaseService = new DatabaseService()

export default databaseService as DatabaseService