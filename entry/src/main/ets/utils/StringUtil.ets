import { BarChartType } from '../model/ChartModel'
import Logger from './Logger'

class StringUtil {
  public isContentEmpty(...contents: string[]): boolean {
    return contents.every(content => content.trim().length === 0)
  }

  public isNullOrEmpty(content: string | null) {
    return content === null || content.trim().length === 0
  }

  public isNotNullOrEmpty(content: string | null) {
    return !this.isNullOrEmpty(content)
  }

  public isNumber(str: string): boolean {
    return !isNaN(Number(str))
  }

  public getNowFormatDate(): string {
    let nowDate = new Date(Date.now())
    return `${nowDate.getFullYear()}-${nowDate.getMonth() + 1}-${nowDate.getDate()}`
  }

  public getNowFormatMonthAndYear(): string {
    let nowDate = new Date(Date.now())
    let month = nowDate.getMonth() + 1
    return this.getFormatMonthAndYear(nowDate.getFullYear(), month)
  }

  public getFormatMonthAndYear(year: number, month: number) : string {
    let monthStr: string
    if (month > 9) {
      monthStr = month.toString()
    } else {
      monthStr = `0${month}`
    }
    return `${year}年/${monthStr}月`
  }

  public getBarChartXAxisData(type: BarChartType): string[] {
    let result: string[] = []
    let nowDate = new Date(Date.now())
    switch (type) {
      case BarChartType.TYPE_WEEK:
        for (let day = nowDate.getDay(); day > nowDate.getDay() - 7; day--) {
          result.push(`${this.getWeekDayFromDateDay((day + 7) % 7)}`)
        }
        result = result.reverse()
        break
      case BarChartType.TYPE_MONTH:
        let monthNum = nowDate.getMonth() + 1
        let date = nowDate.getDate()
        for (let i = 1; i <= date; i++) {
          result.push(`${monthNum}/${i}`)
        }
        break
      case BarChartType.TYPE_YEAR:
        let month = nowDate.getMonth() + 1
        for (let i = 1; i <= month; i++) {
          result.push(`${i}月`)
        }
        break
    }
    return result
  }

  private getWeekDayFromDateDay(dateDay: number): string {
    let result: string
    switch (dateDay) {
      case 0:
        result = '周日'
        break
      case 1:
        result = '周一'
        break
      case 2:
        result = '周二'
        break
      case 3:
        result = '周三'
        break
      case 4:
        result = '周四'
        break
      case 5:
        result = '周五'
        break
      case 6:
        result = '周六'
        break
    }
    return result
  }

  public convertDateString(input: string): string {
  // 使用正则表达式匹配并捕获年、月、日
  const regex = /(\d{4})年(\d{2})月(\d{2})日/;
  const match = input.match(regex);

  if (match) {
    // 解构匹配结果
    const [, year, month, day] = match;
    // 构建目标日期字符串
    const newYear = "2022";
    const formattedDate = `${newYear}-${month}-${day}`;

    return formattedDate;
  } else {
    throw new Error("输入的日期格式不正确");
  }
}
}

export default new StringUtil()