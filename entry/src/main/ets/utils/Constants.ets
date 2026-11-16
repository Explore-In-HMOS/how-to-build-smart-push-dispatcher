import { JWTHeader } from "../model/JWTHeader";
import { JWTPayload } from "../model/JWTPayload";

const now = Math.floor(Date.now() / 1000)

export const header: JWTHeader = {
  kid: 'your_kid',
  typ: 'JWT',
  alg: 'PS256'
}

export const payload: JWTPayload = {
  aud: 'https://oauth-login.cloud.huawei.com/oauth2/v3/token',
  iss: 'your_iss',
  exp: now + 3600,
  iat: now
}

export const endpoint = 'https://push-api.cloud.huawei.com/v3/<projectId>/messages:send'

export const privateKey = 'YOUR_PRIVATE_KEY'