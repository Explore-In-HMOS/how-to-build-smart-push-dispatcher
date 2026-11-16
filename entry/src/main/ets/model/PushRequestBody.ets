import { Payload } from "./Payload"
import { PushOptions } from "./PushOptions"
import { Target } from "./Target"

export interface PushRequestBody {
  payload: Payload
  target: Target
  pushOptions: PushOptions
}