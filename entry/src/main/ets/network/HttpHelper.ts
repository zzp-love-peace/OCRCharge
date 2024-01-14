import axios, { AxiosError, AxiosResponse, HttpStatusCode } from '@ohos/axios'
import promptAction from '@ohos.promptAction'
import { HttpResponse, HttpResponseCode } from './HttpResonse'
import Logger from '../utils/Logger'

type OnPrepare = () => {}

type OnRequestSuccess = () => {}

type OnDataSuccess<R = any> = (data: R, msg: string) => {}

type OnDataFail = (code: number, msg: string) => {}

type OnFail = (msg: string) => {}

type OnError = (error: Error) => {}

type OnFinish = () => {}

export class HttpHelper {

  private static BASE_URL: string = ''

  private static AUTH_TOKEN: string

  private static instance: HttpHelper = new HttpHelper()

  private constructor() {
    axios.defaults.baseURL = HttpHelper.BASE_URL
    axios.defaults.timeout = 5000
    axios.defaults.headers.common['Authorization'] = HttpHelper.AUTH_TOKEN
  }

  public static getInstance(): HttpHelper {
    return this.instance
  }

  public setAuthToken(token: string) {
    HttpHelper.AUTH_TOKEN = token
  }

  public get<R = any>(url: string, params: any, onPrepare?: OnPrepare, onRequestSuccess?: OnRequestSuccess,
      onDataSuccess?: OnDataSuccess<R>, onDataFail?: OnDataFail, onFail?: OnFail, onError?: OnError, onFinish?: OnFinish) {
    if (onPrepare) {
      onPrepare()
    }
    axios.get<string, AxiosResponse<HttpResponse<R>>, null>(url, { params: params }).then((res) => {
      this.handleAxiosResponse<R>(res, onRequestSuccess, onDataSuccess, onDataFail, onFail)
    }).catch((error: Error) => {
      if (onError) {
        onError(error)
      } else {
        promptAction.showToast({message: '出现异常了'})
        Logger.error(HttpHelper.BASE_URL + url ,`onError=>${error}`)
      }
    }).finally(() => {
      if (onFinish) {
        onFinish()
      }
    })
  }

  public post<R = any>(url: string, data: any, onPrepare?: OnPrepare, onRequestSuccess?: OnRequestSuccess,
      onDataSuccess?: OnDataSuccess<R>, onDataFail?: OnDataFail, onFail?: OnFail, onError?: OnError, onFinish?: OnFinish) {
    if (onPrepare) {
      onPrepare()
    }
    axios.post<string, AxiosResponse<HttpResponse<R>>, null>(url, data).then((res) => {
      this.handleAxiosResponse<R>(res, onRequestSuccess, onDataSuccess, onDataFail, onFail)
    }).catch((error: Error) => {
      if (onError) {
        onError(error)
      } else {
        promptAction.showToast({message: '出现异常了'})
        Logger.error(HttpHelper.BASE_URL + url ,`onError=>${error}`)
      }
    }).finally(() => {
      if (onFinish) {
        onFinish()
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
        }
      } else {
        if (onDataFail) {
          onDataFail(res.data.code, res.data.msg)
        } else {
          promptAction.showToast({message:  `获取数据失败:${res.data.msg}`})
          Logger.error(res.config.url ,`onDataFail=>${res.data.data}`)
        }
      }
    } else {
      if (onFail) {
        onFail(res.statusText)
      } else {
        promptAction.showToast({message: '网络不好，请重试'})
        Logger.error(res.config.url ,`onFail=>${res.statusText}`)
      }
    }
  }
}