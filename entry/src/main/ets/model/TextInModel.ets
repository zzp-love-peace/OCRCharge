export interface BillCropResult {
  billPrice: string,
  billType: string,
  billTime: string,
  billShopkeeper: string
}

export interface TextInResult<T = any> {
  code: number,
  duration: number,
  message: string,
  result: T,
  version: string
}

export interface BillsCropData {
  object_list: BillCropObject[]
}

export interface BillCropObject {
  class: string,
  image_angle: number,
  item_list: BillCropItem[],
  position: number[],
  rotated_image_height: number,
  rotated_image_width: number,
  type: string, //行程单、商户小票、火车票等票据类型
  type_description: string,
  kind: string, //交通、办公、日用等票据大类
  kind_description: string,
}

export interface BillCropItem {
  description: string,
  key: string,
  position: number[],
  value: string
}

