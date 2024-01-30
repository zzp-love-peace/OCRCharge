import { Label } from '../model/ResponseModel'
import Logger from './Logger'
class LabelUtil {

  private labelList: Label[]

  public initLabelList(labels: Label[]) {
    this.labelList = labels
  }

  public getLabelList(): Label[] {
    return this.labelList
  }

  public getLabelNameFormId(labelId: number): string {
    let res = ""
    this.labelList.forEach(label => {
      if (label.labelId === labelId) {
        res =  label.labelName
      }
    });
    return res
  }

  public getLabelIdFromName(labelName: string): number {
    let res = -1
    this.labelList.forEach(label => {
      if (label.labelName === labelName) {
        res = label.labelId
      }
    });
    if (res === -1) throw Error("标签名不存在")
    return res
  }

  public isContainLabelName(labelName: string) : boolean {
    this.labelList.forEach(label => {
      if (label.labelName === labelName) {
        return true
      }
    });
    return false
  }
}

export default new LabelUtil()