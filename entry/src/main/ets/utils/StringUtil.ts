class StringUtils {
  public isContentEmpty(...contents: string[]) {
    return contents.every(content => content.trim().length === 0)
  }
}

export default new StringUtils()