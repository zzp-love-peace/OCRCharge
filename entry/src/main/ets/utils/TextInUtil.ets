import axios, { AxiosResponse, HttpStatusCode } from '@ohos/axios'
import buffer from '@ohos.buffer';
import fs from '@ohos.file.fs';
import Logger from './Logger';
import { BillCropResult, BillsCropData, TextInResult } from '../model/TextInModel';
import { MediaBean } from '../media/MediaBean';
import LabelUtil from './LabelUtil';
import { HttpHelper } from '../network/HttpHelper';
import { HttpResponse } from '../network/HttpResonse';
import StringUtil from './StringUtil';

class TextInUtil {
  private appId: string = "66b10f26d7bc91850673ce0ddb70d1c5"
  private secretCode: string = "f84011e8e0a03404d744afd441bc9c71"

  public async billsCrop(imageData: MediaBean): Promise<BillCropResult> {
    let url = "https://api.textin.com/robot/v1.0/api/bills_crop"
    try {
      let file = await fs.open(imageData.localUrl, fs.OpenMode.READ_ONLY)
      let bufSize = 4096
      try {
        let fileBufSize: number = 0
        let readLen: number
        do {
          let buf = new ArrayBuffer(bufSize)
          readLen = await fs.read(file.fd, buf)
          fileBufSize += readLen
        } while (readLen === bufSize)

        let fileBuf = new ArrayBuffer(fileBufSize)
        let resReadLen = await fs.read(file.fd, fileBuf, { offset: 0 })
        try {
          let response = await axios.post<string, AxiosResponse<TextInResult<BillsCropData>>, ArrayBuffer>(url, fileBuf, {
            headers: {
              'connection': 'Keep-Alive',
              'Content-Type': 'application/octet-stream',
              'x-ti-app-id': this.appId,
              'x-ti-secret-code': this.secretCode
            },
            responseType: 'json'
          })
          if (response.data.result.object_list.length > 0) {
            let billCropObjet = response.data.result.object_list[0]
            let billType = billCropObjet.kind_description
            let billPrice = ''
            let billTime = ''
            let billShopkeeper = ''
            if (!LabelUtil.isContainLabelName(billType)) {
              let addBillRes = await HttpHelper.getInstance().getAxios()
                .put<string, AxiosResponse<HttpResponse<number>>, null>("/label/add", null, {
                  params: { labelName: billType }
                })
              if (addBillRes.status == HttpStatusCode.Ok) {
                LabelUtil.addNewLabel(addBillRes.data.data, billType)
              } else {
                billType = ''
              }
            }
            switch (billCropObjet.type) {
              case "train_ticket":
                billCropObjet.item_list.forEach(item => {
                  if (item.key === "price") {
                    billPrice = item.value
                  } else if (item.key === "departure_date") {
                    billTime = item.value
                  }
                })
                break
              case "shop_receipt":
                billCropObjet.item_list.forEach(item => {
                  if (item.key === "money") {
                    billPrice = item.value
                  } else if (item.key === "date") {
                    billTime = item.value
                  } else if (item.key === "shop") {
                    billShopkeeper = item.value.substring(0, 20)
                  }
                })
                break
              case "vat_special_invoice":
              case "vat_electronic_special_invoice":
              case "vat_electronic_invoice":
              case "vat_common_invoice":
              case "vat_electronic_toll_invoice":
              case "machine_printed_invoice":
              case "blockchain_electronic_invoice":
              case "vat_electronic_invoice_new":
              case "vat_electronic_special_invoice_new":
                billCropObjet.item_list.forEach(item => {
                  if (item.key === "vat_invoice_price_list") {
                    billPrice = item.value
                  } else if (item.key === "vat_invoice_issue_date") {
                    billTime = StringUtil.convertDateString(item.value)
                  } else if (item.key === "vat_invoice_seller_name") {
                    billShopkeeper = item.value.substring(0, 20)
                  }
                })
                break
            }
            return {
              "billPrice": billPrice,
              "billType": billType,
              "billTime": billTime,
              "billShopkeeper": billShopkeeper
            }
          }
        } catch (err) {
          Logger.error("TextIn识别接口出错: " + err.message + ", error code: " + err.code)
        }
      } catch (error) {
        Logger.error("read file data failed with error message: " + error.message + ", error code: " + error.code)
      } finally {
        fs.closeSync(file)
      }
    } catch (e) {
      Logger.error("open file failed with error message: " + e.message + ", error code: " + e.code)
    }
  }
}

export default new TextInUtil()