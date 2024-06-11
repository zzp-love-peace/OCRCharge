import axios, { AxiosResponse, AxiosStatic, HttpStatusCode } from '@ohos/axios'
import promptAction from '@ohos.promptAction'
import { HttpResponse, HttpResponseCode } from './HttpResonse'
import Logger from '../utils/Logger'

type OnPrepare = () => void

type OnRequestSuccess = () => void

export type OnDataSuccess<R = any> = (data: R, msg: string) => void

type OnDataFail = (code: number, msg: string) => void

type OnFail = (msg: string) => void

type OnError = (error: Error) => void

type OnFinish = () => void

interface HttpHelperStruct<R> {
  url: string,
  params?: any,
  data?: any,
  onPrepare?: OnPrepare,
  onRequestSuccess?: OnRequestSuccess,
  onDataSuccess?: OnDataSuccess<R>,
  onDataFail?: OnDataFail,
  onFail?: OnFail,
  onError?: OnError,
  onFinish?: OnFinish
}

export class HttpHelper {
  private static BASE_URL: string = 'http://192.168.96.141:9988/'

  private static instance: HttpHelper = new HttpHelper()

  private constructor() {
    axios.defaults.baseURL = HttpHelper.BASE_URL
    axios.defaults.timeout = 100000
  }

  public static getInstance(): HttpHelper {
    return this.instance
  }

  public setAuthToken(token: string) {
    axios.defaults.headers.common['Authorization'] = token
  }

  public get<R = any>(httpHelperStruct: HttpHelperStruct<R>) {
    if (httpHelperStruct.onPrepare) {
      httpHelperStruct.onPrepare()
    }
    axios.get<string, AxiosResponse<HttpResponse<R>>, null>(httpHelperStruct.url, {
      params: httpHelperStruct.params
    }).then((res) => {
      this.handleAxiosResponse<R>(res, httpHelperStruct.onRequestSuccess, httpHelperStruct.onDataSuccess, httpHelperStruct.onDataFail, httpHelperStruct.onFail)
    }).catch((error: Error) => {
      if (httpHelperStruct.onError) {
        httpHelperStruct.onError(error)
      } else {
        promptAction.showToast({ message: '出现异常了' })
        Logger.error(HttpHelper.BASE_URL + httpHelperStruct.url, `onError=>${error}`)
      }
    }).finally(() => {
      if (httpHelperStruct.onFinish) {
        httpHelperStruct.onFinish()
      }
    })
  }

  public post<R = any>(httpHelperStruct: HttpHelperStruct<R>) {
    if (httpHelperStruct.onPrepare) {
      httpHelperStruct.onPrepare()
    }
    axios.post<string, AxiosResponse<HttpResponse<R>>, null>(httpHelperStruct.url, httpHelperStruct.data, {
      params: httpHelperStruct.params
    }).then((res) => {
      this.handleAxiosResponse<R>(res, httpHelperStruct.onRequestSuccess, httpHelperStruct.onDataSuccess, httpHelperStruct.onDataFail, httpHelperStruct.onFail)
    }).catch((error: Error) => {
      if (httpHelperStruct.onError) {
        httpHelperStruct.onError(error)
      } else {
        promptAction.showToast({ message: '出现异常了' })
        Logger.error(HttpHelper.BASE_URL + httpHelperStruct.url, `onError=>${error}`)
      }
    }).finally(() => {
      if (httpHelperStruct.onFinish) {
        httpHelperStruct.onFinish()
      }
    })
  }

  public put<R = any>(httpHelperStruct: HttpHelperStruct<R>) {
    if (httpHelperStruct.onPrepare) {
      httpHelperStruct.onPrepare()
    }
    axios.put<string, AxiosResponse<HttpResponse<R>>, null>(httpHelperStruct.url, httpHelperStruct.data, {
      params: httpHelperStruct.params
    }).then((res) => {
      this.handleAxiosResponse<R>(res, httpHelperStruct.onRequestSuccess, httpHelperStruct.onDataSuccess, httpHelperStruct.onDataFail, httpHelperStruct.onFail)
    }).catch((error: Error) => {
      if (httpHelperStruct.onError) {
        httpHelperStruct.onError(error)
      } else {
        promptAction.showToast({ message: '出现异常了' })
        Logger.error(HttpHelper.BASE_URL + httpHelperStruct.url, `onError=>${error}`)
      }
    }).finally(() => {
      if (httpHelperStruct.onFinish) {
        httpHelperStruct.onFinish()
      }
    })
  }

  public getAxios(): AxiosStatic {
    return axios
  }

  public delete<R = any>(httpHelperStruct: HttpHelperStruct<R>) {
    if (httpHelperStruct.onPrepare) {
      httpHelperStruct.onPrepare()
    }
    axios.delete<string, AxiosResponse<HttpResponse<R>>, null>(httpHelperStruct.url, {
      params: httpHelperStruct.params
    }).then((res) => {
      this.handleAxiosResponse<R>(res, httpHelperStruct.onRequestSuccess, httpHelperStruct.onDataSuccess, httpHelperStruct.onDataFail, httpHelperStruct.onFail)
    }).catch((error: Error) => {
      if (httpHelperStruct.onError) {
        httpHelperStruct.onError(error)
      } else {
        promptAction.showToast({ message: '出现异常了' })
        Logger.error(HttpHelper.BASE_URL + httpHelperStruct.url, `onError=>${error}`)
      }
    }).finally(() => {
      if (httpHelperStruct.onFinish) {
        httpHelperStruct.onFinish()
      }
    })
  }

  private handleAxiosResponse<R = any>(res: AxiosResponse<HttpResponse<R>>, onRequestSuccess?: OnRequestSuccess,
                                       onDataSuccess?: OnDataSuccess<R>, onDataFail?: OnDataFail, onFail?: OnFail) {
    if (onRequestSuccess) {
      onRequestSuccess()
    }
    if (res.status == HttpStatusCode.Ok) {
      if (res.data.code == HttpResponseCode.success) {
        if (onDataSuccess) {
          onDataSuccess(res.data.data, res.data.msg)
          Logger.debug(res.config.url, `onDataSuccess=>{code:${res.data.code}, data:${JSON.stringify(res.data.data)},msg:${res.data.msg}}`)
        }
      } else {
        if (onDataFail) {
          onDataFail(res.data.code, res.data.msg)
        } else {
          promptAction.showToast({ message: res.data.msg })
          Logger.error(res.config.url, `onDataFail=>{code:${res.data.code}, data:${JSON.stringify(res.data.data)},msg:${res.data.msg}}`)
        }
      }
    } else {
      if (onFail) {
        onFail(res.statusText)
      } else {
        promptAction.showToast({ message: '网络不好，请重试' })
        Logger.error(res.config.url, `onFail=>${res.statusText}`)
      }
    }
  }
}