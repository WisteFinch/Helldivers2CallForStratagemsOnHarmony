import { DividerLine } from "../Util";

@Component
export struct SettingsPage {
  @Consume('pageInfos') pageInfos: NavPathStack;

  @State divider: DividerLine = new DividerLine(1, 10, 10, $r('app.color.divider'))

  @Builder itemHead(res: Resource) {
    Text(res)
      .width('100%')
      .padding({left: 10, bottom: 5})
      .fontColor($r('app.color.text_hint'))
  }

  @Builder pageHead() {
    Row() {
      Text($r('app.string.set_page_title'))
        .fontWeight(FontWeight.Bold)
        .fontSize(20)
    }
    .height("100%")
    .margin({left: 6})
  }

  build() {
    NavDestination() {
      List({space: 20}) {
        // 连接
        ListItemGroup({ header: this.itemHead($r('app.string.set_conn_hdr'))}) {
          ListItem() {
            List() {
              // 服务器地址
              ListItem() {
                Row({space: 10}){
                  Text($r('app.string.set_conn_ip'))
                    .fontWeight(FontWeight.Medium)
                    .layoutWeight(1)
                  TextInput({placeholder: $r('app.string.set_conn_ip_addr')})
                    .layoutWeight(2)
                  TextInput({placeholder: $r('app.string.set_conn_ip_port')})
                    .layoutWeight(1)
                }
              }
              .margin(10)

              // 重试次数
              ListItem() {
                Row({space: 10}){
                  Text($r('app.string.set_conn_retry'))
                    .fontWeight(FontWeight.Medium)
                    .layoutWeight(3)
                  TextInput()
                    .layoutWeight(1)
                }
              }
              .margin(10)

              // 扫码&测试连接
              ListItem() {
                Row(){
                  // 扫码
                  Button({ type: ButtonType.Normal, stateEffect: true }) {
                    Column({space: 6}) {
                      Image($r('app.media.ic_scan'))
                        .width(40)
                        .height(40)
                        .fillColor($r('app.color.hyperlink'))
                      Text($r('app.string.set_conn_scan'))
                        .fontWeight(FontWeight.Medium)
                        .fontColor($r('app.color.hyperlink'))
                    }
                    .alignItems(HorizontalAlign.Center)
                  }
                  .height("100%")
                  .borderRadius(20)
                  .backgroundColor($r('app.color.background_primary'))
                  .layoutWeight(1)

                  // 测试连接
                  Button({ type: ButtonType.Normal, stateEffect: true }) {
                    Column({space: 6}) {
                      Image($r('app.media.ic_sync'))
                        .width(40)
                        .height(40)
                        .fillColor($r('app.color.hyperlink'))
                      Text($r('app.string.set_conn_test'))
                        .fontWeight(FontWeight.Medium)
                        .fontColor($r('app.color.hyperlink'))
                    }
                    .alignItems(HorizontalAlign.Center)
                  }
                  .height("100%")
                  .borderRadius(20)
                  .backgroundColor($r('app.color.background_primary'))
                  .layoutWeight(1)
                }
                .alignItems(VerticalAlign.Center)
                .height(80)
              }
            }.divider(this.divider)
          }
          .borderRadius(20)
          .backgroundColor($r('app.color.background_primary'))
        }

        // 同步
        ListItemGroup({ header: this.itemHead($r('app.string.set_sync_hdr'))}) {
          ListItem() {
            List() {
              // 端口
              ListItem() {
                Row({ space: 10 }) {
                  Text($r('app.string.set_sync_port'))
                    .fontWeight(FontWeight.Medium)
                    .layoutWeight(3)
                  TextInput()
                    .layoutWeight(1)
                }
              }
              .margin(10)

              // 延迟
              ListItem() {
                Row({space: 10}){
                  Text($r('app.string.set_sync_delay'))
                    .fontWeight(FontWeight.Medium)
                    .layoutWeight(3)
                  TextInput()
                    .layoutWeight(1)
                  Text($r('app.string.set_unit_ms'))
                    .fontColor($r('app.color.text_hint'))
                }
              }
              .margin(10)

              // 同步配置
              ListItem() {
                Button({ type: ButtonType.Normal, stateEffect: true }) {
                  Row({space: 6}) {
                    Text($r('app.string.set_sync_apply'))
                      .fontWeight(FontWeight.Medium)
                      .fontColor($r('app.color.hyperlink'))
                  }
                  .alignItems(VerticalAlign.Center)
                }
                .align(Alignment.Start)
                .width("100%")
                .height(60)
                .borderRadius(20)
                .backgroundColor($r('app.color.background_primary'))
                .padding(10)
              }
            }.divider(this.divider)
          }
          .borderRadius(20)
          .backgroundColor($r('app.color.background_primary'))
        }

        // 控制
        ListItemGroup({ header: this.itemHead($r('app.string.set_ctrl_hdr'))}) {
          ListItem() {
            List() {
              // 精简模式
              ListItem() {
                Row() {
                  Column() {
                    Text($r('app.string.set_ctrl_simplified_mode'))
                      .fontWeight(FontWeight.Medium)
                    Text($r('app.string.set_ctrl_simplified_mode_desc'))
                      .fontColor($r('app.color.text_hint'))
                  }
                  .alignItems(HorizontalAlign.Start)
                  .width("80%")
                  Blank()
                  Toggle({ type: ToggleType.Switch, isOn: false })
                }
                .width("100%")
                .alignItems(VerticalAlign.Center)
              }
              .margin(10)
            }.divider(this.divider)
          }
          .borderRadius(20)
          .backgroundColor($r('app.color.background_primary'))
        }

        // 信息
        ListItemGroup({ header: this.itemHead($r('app.string.set_info_hdr'))}) {
          ListItem() {
            List() {
              // 数据库
              ListItem() {
                Button({ type: ButtonType.Normal, stateEffect: true }) {
                  Row() {
                    Column() {
                      Text($r('app.string.set_info_db'))
                        .fontColor($r('app.color.hyperlink'))
                        .fontWeight(FontWeight.Medium)
                      Text("[hd2_db] 2024-12-26T14:02:42Z")
                        .fontColor($r('app.color.text_hint'))
                    }
                    .alignItems(HorizontalAlign.Start)
                    Blank()
                    Text($r('app.string.set_info_latest'))
                      .fontColor($r('app.color.text_hint'))
                  }
                  .width("100%")
                  .alignItems(VerticalAlign.Center)
                }
                .align(Alignment.Start)
                .width("100%")
                .height(60)
                .borderRadius(20)
                .backgroundColor($r('app.color.background_primary'))
                .padding(10)
              }

              // 软件
              ListItem() {
                Button({ type: ButtonType.Normal, stateEffect: true }) {
                  Row() {
                    Column() {
                      Text($r('app.string.set_info_app'))
                        .fontColor($r('app.color.hyperlink'))
                        .fontWeight(FontWeight.Medium)
                      Text("v1.0.0")
                        .fontColor($r('app.color.text_hint'))
                    }
                    .alignItems(HorizontalAlign.Start)
                    Blank()
                    Text($r('app.string.set_info_latest'))
                      .fontColor($r('app.color.text_hint'))
                  }
                  .width("100%")
                  .alignItems(VerticalAlign.Center)
                }
                .align(Alignment.Start)
                .width("100%")
                .height(60)
                .borderRadius(20)
                .backgroundColor($r('app.color.background_primary'))
                .padding(10)
              }

              // 关于
              ListItem() {
                Button({ type: ButtonType.Normal, stateEffect: true }) {
                  Text($r('app.string.set_info_about'))
                    .fontColor($r('app.color.hyperlink'))
                    .fontWeight(FontWeight.Medium)
                }
                .align(Alignment.Start)
                .width("100%")
                .height(60)
                .borderRadius(20)
                .backgroundColor($r('app.color.background_primary'))
                .padding(10)
              }
            }.divider(this.divider)
          }
          .borderRadius(20)
          .backgroundColor($r('app.color.background_primary'))
        }
      }
      .width("100%")
      .height("100%")
      .padding('16')
      .backgroundColor($r('app.color.background_secondary'))
    }
    .title(this.pageHead)
    .onBackPressed(() => {
      this.pageInfos.pop()
      return true
    })
    .backgroundColor($r('app.color.background_secondary'))
  }
}
