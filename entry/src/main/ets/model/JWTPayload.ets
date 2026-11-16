export interface JWTPayload {
  aud: string
  iss: string
  exp: number
  iat: number
}