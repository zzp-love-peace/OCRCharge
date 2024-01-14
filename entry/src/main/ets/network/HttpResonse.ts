export interface HttpResponse<T = any> {
  code: number,
  data: T,
  msg: string
}

export enum HttpResponseCode {
  success = 200,
  fail = 501
}