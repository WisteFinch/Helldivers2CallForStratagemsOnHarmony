import {
  INPUT_OPTIONS,
  INPUT_TYPE_OPTIONS,
  LANGUAGE_OPTIONS,
  PREFERENCES_DELAY,
  PREFERENCES_INPUT_DOWN,
  PREFERENCES_INPUT_DOWN_DSP,
  PREFERENCES_INPUT_LEFT,
  PREFERENCES_INPUT_LEFT_DSP,
  PREFERENCES_INPUT_OPEN,
  PREFERENCES_INPUT_OPEN_DSP,
  PREFERENCES_INPUT_RIGHT,
  PREFERENCES_INPUT_RIGHT_DSP,
  PREFERENCES_INPUT_UP,
  PREFERENCES_INPUT_UP_DSP,
  PREFERENCES_LANG_STRATAGEM,
  PREFERENCES_LANG_STRATAGEM_DSP,
  PREFERENCES_RETRY,
  PREFERENCES_SERVER_ADDR,
  PREFERENCES_SERVER_PORT,
  PREFERENCES_SIMPLIFIED_MODE,
  PREFERENCES_SYNC_PORT,
  PREFERENCES_TYPE_OPEN,
  PREFERENCES_TYPE_OPEN_DSP
} from "../common/Constants";
import PreferencesUtil from "../common/PreferencesUtil";
import { DividerLine, ListItemGroupHead, PageHead } from "../common/UiUtils";

@Component
export struct SettingsPage {
  @Consume('pageInfos') pageInfos: NavPathStack;
  @State divider: DividerLine = new DividerLine(1, 10, 10, $r('app.color.divider'))

  build() {
    NavDestination() {
      List({ space: 20 }) {
        // 连接
        ListItemGroup({ header: ListItemGroupHead($r('app.string.set_conn_hdr')) }) {
          ListItem() {
            List() {
              // 服务器地址
              ListItem() {
                Row({ space: 10 }) {
                  Text($r('app.string.set_conn_server'))
                    .fontWeight(FontWeight.Medium)
                    .layoutWeight(1)
                  TextInput({
                    placeholder: $r('app.string.set_conn_addr'),
                      text: PreferencesUtil.getVal(PREFERENCES_SERVER_ADDR, '127.0.0.1').toString()
                  })
                    .layoutWeight(2)
                    .onChange((value: string) => {
                      PreferencesUtil.putVal(PREFERENCES_SERVER_ADDR, value)
                    })
                  TextInput({
                    placeholder: $r('app.string.set_conn_port'),
                    text: PreferencesUtil.getVal(PREFERENCES_SERVER_PORT, 23333).toString()
                  })
                    .type(InputType.Number)
                    .layoutWeight(1)
                    .onChange((value: string) => {
                      PreferencesUtil.putVal(PREFERENCES_SERVER_PORT, Number(value))
                    })
                }
              }
              .margin(10)

              // 重试次数
              ListItem() {
                Row({ space: 10 }) {
                  Text($r('app.string.set_conn_retry'))
                    .fontWeight(FontWeight.Medium)
                    .layoutWeight(3)
                  TextInput({
                    text: PreferencesUtil.getVal(PREFERENCES_RETRY, 5).toString()
                  })
                    .type(InputType.Number)
                    .layoutWeight(1)
                    .onChange((value: string) => {
                      PreferencesUtil.putVal(PREFERENCES_RETRY, Number(value))
                    })
                }
              }
              .margin(10)

              // 扫码&测试连接
              ListItem() {
                Row() {
                  // 扫码
                  Button({ type: ButtonType.Normal, stateEffect: true }) {
                    Column({ space: 6 }) {
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
                    Column({ space: 6 }) {
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
            }
            .width("100%")
            .height("warp_content")
            .divider(this.divider)
          }
          .borderRadius(20)
          .backgroundColor($r('app.color.background_primary'))
        }

        // 同步
        ListItemGroup({ header: ListItemGroupHead($r('app.string.set_sync_hdr')) }) {
          ListItem() {
            List() {
              // 端口
              ListItem() {
                Row({ space: 10 }) {
                  Text($r('app.string.set_sync_port'))
                    .fontWeight(FontWeight.Medium)
                    .layoutWeight(3)
                  TextInput({
                    text: PreferencesUtil.getVal(PREFERENCES_SYNC_PORT, 23333).toString()
                  })
                    .type(InputType.Number)
                    .layoutWeight(1)
                    .onChange((value: string) => {
                    PreferencesUtil.putVal(PREFERENCES_SYNC_PORT, Number(value))
                  })
                }
              }
              .margin(10)

              // 输入延迟
              ListItem() {
                Row({ space: 10 }) {
                  Text($r('app.string.set_sync_delay'))
                    .fontWeight(FontWeight.Medium)
                    .layoutWeight(3)
                  TextInput({
                    text: PreferencesUtil.getVal(PREFERENCES_DELAY, 50).toString()
                  })
                    .type(InputType.Number)
                    .layoutWeight(1)
                    .onChange((value: string) => {
                      PreferencesUtil.putVal(PREFERENCES_DELAY, Number(value))
                    })
                  Text($r('app.string.set_unit_ms'))
                    .fontColor($r('app.color.text_hint'))
                }
              }
              .margin(10)

              // 输入：打开战略配备列表
              ListItem() {
                Row({ space: 10 }) {
                  Text($r('app.string.set_sync_input_open'))
                    .fontWeight(FontWeight.Medium)
                    .layoutWeight(2)
                  Select(INPUT_OPTIONS)
                    .layoutWeight(1)
                    .selected(Number(PreferencesUtil.getVal(PREFERENCES_INPUT_OPEN, 2)))
                    .value(PreferencesUtil.getVal(PREFERENCES_INPUT_OPEN_DSP, 'Left Ctrl').toString())
                    .onSelect((index: number, value: string) => {
                      PreferencesUtil.putVal(PREFERENCES_INPUT_OPEN, index)
                      PreferencesUtil.putVal(PREFERENCES_INPUT_OPEN_DSP, value)
                    })
                }
              }
              .margin(10)

              // 类型：打开战略配备列表
              ListItem() {
                Row({ space: 10 }) {
                  Text($r('app.string.set_sync_type_open'))
                    .fontWeight(FontWeight.Medium)
                    .layoutWeight(2)
                  Select(INPUT_TYPE_OPTIONS)
                    .layoutWeight(1)
                    .selected(Number(PreferencesUtil.getVal(PREFERENCES_TYPE_OPEN, 0)))
                    .value(PreferencesUtil.getVal(PREFERENCES_TYPE_OPEN_DSP, 'Hold').toString())
                    .onSelect((index: number, value:string) => {
                      PreferencesUtil.putVal(PREFERENCES_TYPE_OPEN, index)
                      PreferencesUtil.putVal(PREFERENCES_TYPE_OPEN_DSP, value)
                    })
                }
              }
              .margin(10)

              // 输入：上
              ListItem() {
                Row({ space: 10 }) {
                  Text($r('app.string.set_sync_input_up'))
                    .fontWeight(FontWeight.Medium)
                    .layoutWeight(2)
                  Select(INPUT_OPTIONS)
                    .layoutWeight(1)
                    .selected(Number(PreferencesUtil.getVal(PREFERENCES_INPUT_UP, 42)))
                    .value(PreferencesUtil.getVal(PREFERENCES_INPUT_UP_DSP, 'W').toString())
                    .onSelect((index: number, value: string) => {
                      PreferencesUtil.putVal(PREFERENCES_INPUT_UP, index)
                      PreferencesUtil.putVal(PREFERENCES_INPUT_UP_DSP, value)
                    })
                }
              }
              .margin(10)

              // 输入：下
              ListItem() {
                Row({ space: 10 }) {
                  Text($r('app.string.set_sync_input_down'))
                    .fontWeight(FontWeight.Medium)
                    .layoutWeight(2)
                  Select(INPUT_OPTIONS)
                    .layoutWeight(1)
                    .selected(Number(PreferencesUtil.getVal(PREFERENCES_INPUT_DOWN, 38)))
                    .value(PreferencesUtil.getVal(PREFERENCES_INPUT_DOWN_DSP, 'S').toString())
                    .onSelect((index: number, value:string) => {
                      PreferencesUtil.putVal(PREFERENCES_INPUT_DOWN, index)
                      PreferencesUtil.putVal(PREFERENCES_INPUT_DOWN_DSP, value)
                    })
                }
              }
              .margin(10)

              // 输入：左
              ListItem() {
                Row({ space: 10 }) {
                  Text($r('app.string.set_sync_input_left'))
                    .fontWeight(FontWeight.Medium)
                    .layoutWeight(2)
                  Select(INPUT_OPTIONS)
                    .layoutWeight(1)
                    .selected(Number(PreferencesUtil.getVal(PREFERENCES_INPUT_LEFT, 20)))
                    .value(PreferencesUtil.getVal(PREFERENCES_INPUT_LEFT_DSP, 'A').toString())
                    .onSelect((index: number, value: string) => {
                      PreferencesUtil.putVal(PREFERENCES_INPUT_LEFT, index)
                      PreferencesUtil.putVal(PREFERENCES_INPUT_LEFT_DSP, value)
                    })
                }
              }
              .margin(10)

              // 输入：右
              ListItem() {
                Row({ space: 10 }) {
                  Text($r('app.string.set_sync_input_right'))
                    .fontWeight(FontWeight.Medium)
                    .layoutWeight(2)
                  Select(INPUT_OPTIONS)
                    .layoutWeight(1)
                    .selected(Number(PreferencesUtil.getVal(PREFERENCES_INPUT_RIGHT, 23)))
                    .value(PreferencesUtil.getVal(PREFERENCES_INPUT_RIGHT_DSP, 'D').toString())
                    .onSelect((index: number, value: string) => {
                      PreferencesUtil.putVal(PREFERENCES_INPUT_RIGHT, index)
                      PreferencesUtil.putVal(PREFERENCES_INPUT_RIGHT_DSP, value)
                    })
                }
              }
              .margin(10)

              // 同步配置
              ListItem() {
                Button({ type: ButtonType.Normal, stateEffect: true }) {
                  Row({ space: 6 }) {
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
            }
            .width("100%")
            .height("warp_content")
            .divider(this.divider)
          }
          .borderRadius(20)
          .backgroundColor($r('app.color.background_primary'))
        }

        // 控制
        ListItemGroup({ header: ListItemGroupHead($r('app.string.set_ctrl_hdr')) }) {
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
                  Toggle({
                    type: ToggleType.Switch,
                    isOn: Boolean(PreferencesUtil.getVal(PREFERENCES_SIMPLIFIED_MODE, false))
                  })
                    .onChange((isOn: boolean) => {
                      PreferencesUtil.putVal(PREFERENCES_SIMPLIFIED_MODE, isOn)
                    })
                }
                .width("100%")
                .alignItems(VerticalAlign.Center)
              }
              .margin(10)

              // 语言：战略配备名称
              ListItem() {
                Row({ space: 10 }) {
                  Text($r('app.string.set_ctrl_lang_stratagem'))
                    .fontWeight(FontWeight.Medium)
                    .layoutWeight(2)
                  Select(LANGUAGE_OPTIONS)
                    .layoutWeight(1)
                    .selected(Number(PreferencesUtil.getVal(PREFERENCES_LANG_STRATAGEM, 0)))
                    .value(PreferencesUtil.getVal(PREFERENCES_LANG_STRATAGEM_DSP, 'System Language').toString())
                    .onSelect((index: number, value: string) => {
                      PreferencesUtil.putVal(PREFERENCES_LANG_STRATAGEM, index)
                      PreferencesUtil.putVal(PREFERENCES_LANG_STRATAGEM_DSP, value)
                    })
                }
              }
              .margin(10)
            }
            .width("100%")
            .height("warp_content")
            .divider(this.divider)
          }
          .borderRadius(20)
          .backgroundColor($r('app.color.background_primary'))
        }

        // 信息
        ListItemGroup({ header: ListItemGroupHead($r('app.string.set_info_hdr')) }) {
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
            }
            .width("100%")
            .height("warp_content")
            .divider(this.divider)
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
    .title(PageHead($r('app.string.set_page_title')))
    .onBackPressed(() => {
      this.pageInfos.pop()
      return true
    })
    .backgroundColor($r('app.color.background_secondary'))
  }
}
