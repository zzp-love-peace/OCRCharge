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
}

export default new StringUtil()