/**
 * 数据库渠道数据模型
 */
@Observed
export default class DatabaseModel {
  /**
   * 渠道id
   */
  id: string

  /**
   * 英文名称
   */
  name: string

  /**
   * 中文名称
   */
  nameZh: string

  /**
   * 索引地址
   */
  url: string

  /**
   * 版本
   */
  ver: string

  /**
   * 顺序
   */
  idx: number

  constructor(id: string, name: string, nameZh: string, url: string, ver: string, idx: number) {
    this.id = id
    this.name = name
    this.nameZh = nameZh
    this.url = url
    this.ver = ver
    this.idx = idx
  }
}