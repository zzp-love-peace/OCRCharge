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

  public getLabelNameList(): string[] {
    return this.labelList.map(label => label.labelName)
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

  public getLabelIdFromName(labelName: string): number | null {
    let res = null
    this.labelList.forEach(label => {
      if (label.labelName === labelName) {
        res = label.labelId
      }
    });
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