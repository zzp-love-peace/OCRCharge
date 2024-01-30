export interface Bill {
   billId: number,//唯一标识符
   labelId: number,//标签
   userId: number,
   money: number,//金额
   remark?: string,//备注
   time: string,
   shopkeeper: string
}

export interface Label {
   userId: number,
   labelId: number,
   labelName: string,
}