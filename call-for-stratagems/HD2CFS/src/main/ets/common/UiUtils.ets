export class DividerLine {
  strokeWidth: Length = 1
  startMargin: Length = 5
  endMargin: Length = 5
  color: ResourceColor = $r('app.color.divider')

  constructor(strokeWidth: Length = 1, startMargin: Length = 5, endMargin: Length = 5, color: ResourceColor = $r('app.color.divider')) {
    this.strokeWidth = strokeWidth
    this.startMargin = startMargin
    this.endMargin = endMargin
    this.color = color
  }
}

@Builder export function ListItemGroupHead(str: Resource) {
  Text(str)
    .width('100%')
    .padding({left: 10, bottom: 5})
    .fontColor($r('app.color.text_hint'))
}

@Builder export function PageHead(str: Resource) {
  Row() {
    Text(str)
      .fontWeight(FontWeight.Bold)
      .fontSize(20)
  }
  .height("100%")
  .margin({left: 6})
}