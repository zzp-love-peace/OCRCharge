class StringUtil {
  public isContentEmpty(...contents: string[]): boolean {
    return contents.every(content => content.trim().length === 0)
  }
}

export default new StringUtil()