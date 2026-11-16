import { ClickAction } from "./ClickAction"

export interface NotificationBody {
  category: string
  title: string
  body: string
  clickAction: ClickAction
  foregroundShow: boolean
}