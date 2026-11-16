import { cryptoFramework } from '@kit.CryptoArchitectureKit'
import util from '@ohos.util'
import { header, payload, privateKey, endpoint } from '../utils/Constants'
import { AAID, pushService } from '@kit.PushKit'
import { http } from '@kit.NetworkKit'
import { PushResponse } from '../model/PushResponse'
import { PushRequestBody } from '../model/PushRequestBody'

export class HomeViewModel {
  async getPushToken(): Promise<string> {
    try {
      let token = await pushService.getToken()
      console.info(`Succeeded in getting push token ${token}`)
      return token
    } catch (err) {
      let error = err as BusinessError
      console.error(`Failed to get push token: ${error.code + error.message}`)
      return ''
    }
  }

  async getAAID(): Promise<string> {
    try {
      const aaid: string = await AAID.getAAID();
      console.info(`Succeeded in getting AAID: ${aaid}`)
      return aaid
    } catch (err) {
      let e: BusinessError = err as BusinessError;
      console.error(`Failed to get AAID: ${e.code + e.message}`)
      return ''
    }
  }

  base64UrlEncodeBytes(data: Uint8Array): string {
    const helper = new util.Base64Helper()
    let base64 = helper.encodeToStringSync(data)
    return base64
      .replace(/\+/g, '-')
      .replace(/\//g, '_')
      .replace(/=/g, '')
  }

  base64UrlEncodeString(str: string): string {
    return this.base64UrlEncodeBytes(new util.TextEncoder().encodeInto(str))
  }

  async getJWT(): Promise<string> {
    try {
      const encodedHeader = this.base64UrlEncodeString(JSON.stringify(header))
      const encodedPayload = this.base64UrlEncodeString(JSON.stringify(payload))
      const signingInput = `${encodedHeader}.${encodedPayload}`
      console.info('Step 1: signingInput OK')

      let pemKey = privateKey.replace(/\\n/g, '\n').trim()
      console.info(`Step 2: pemKey OK, starts with: ${pemKey.substring(0, 30)}`)

      const generator = cryptoFramework.createAsyKeyGenerator('RSA4096')
      console.info('Step 3: generator OK')

      const keyPair = await generator.convertPemKey(null, pemKey)
      console.info('Step 4: keyPair OK')

      // "RSA|PSS|SHA256|MGF1_SHA256" — boyut belirtme
      const signer = cryptoFramework.createSign('RSA|PSS|SHA256|MGF1_SHA256')
      console.info('Step 5: signer OK')

      await signer.init(keyPair.priKey)
      console.info('Step 6: init OK')

      // Salt length ayrıca set et
      signer.setSignSpec(cryptoFramework.SignSpecItem.PSS_SALT_LEN_NUM, 32)
      console.info('Step 7: saltLen OK')

      const inputBlob: cryptoFramework.DataBlob = {
        data: new util.TextEncoder().encodeInto(signingInput)
      }
      const signResult = await signer.sign(inputBlob)
      console.info('Step 8: sign OK')

      const encodedSignature = this.base64UrlEncodeBytes(signResult.data)
      const jwt = `${signingInput}.${encodedSignature}`
      console.info(`JWT = ${jwt}`)
      return jwt

    } catch (err) {
      console.error('getJWT HATA code: ' + (err as BusinessError).code)
      console.error('getJWT HATA message: ' + (err as BusinessError).message)
      return ''
    }
  }

  async sendNotification(title: string, body: string): Promise<PushResponse> {
    try {
      const jwt = await this.getJWT()
      const pushToken = await this.getPushToken()

      const requestBody: PushRequestBody = {
        payload: {
          notification: {
            category: 'MARKETING',
            title: title,
            body: body,
            clickAction: {
              actionType: 0
            },
            foregroundShow: true
          }
        },
        target: {
          token: [pushToken]
        },
        pushOptions: {
          testMessage: true,
          ttl: 86400
        }
      }
      const request = http.createHttp()
      const response = await request.request(endpoint, {
        method: http.RequestMethod.POST,
        header: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ' + `${jwt}`,
          'push-type': 0
        },
        extraData: JSON.stringify(requestBody)
      }
      )

      const resultStr = response.result as string
      const result = JSON.parse(resultStr) as PushResponse

      return result

    } catch (err) {
      console.error('sendNotification ERROR: ' + (err as BusinessError).message)
      return { code: '-1', msg: (err as BusinessError).message } as PushResponse
    }
  }
}
