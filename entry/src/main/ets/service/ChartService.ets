import { HttpHelper, OnDataSuccess } from '../network/HttpHelper'

export class ChartService {
  public getMonthExpenseData(year: number, month: number, onDataSuccess: OnDataSuccess) {
    HttpHelper.getInstance()
      .get({
        url: "chart/getMonthInfor",
        params: { year: year.toString(), month: month.toString() },
        onDataSuccess: onDataSuccess
      })
  }

  public getWeekExpenseData(onDataSuccess: OnDataSuccess) {
    HttpHelper.getInstance()
      .get({
        url: "chart/getWeekInfor",
        onDataSuccess: onDataSuccess
      })
  }

  public getMonthIncomeData(year: number, month: number, onDataSuccess: OnDataSuccess) {
    HttpHelper.getInstance()
      .get({
        url: "chart/getMonthIncome",
        params: { year: year.toString(), month: month.toString() },
        onDataSuccess: onDataSuccess
      })
  }

  public getWeekIncomeData(onDataSuccess: OnDataSuccess) {
    HttpHelper.getInstance()
      .get({
        url: "chart/getWeekIncome",
        onDataSuccess: onDataSuccess
      })
  }

  public getWeekLabelExpense(onDataSuccess: OnDataSuccess) {
    HttpHelper.getInstance()
      .get({
        url: "chart/getWeekLabelExpense",
        onDataSuccess: onDataSuccess
      })
  }

  public getWeekLabelIncome(onDataSuccess: OnDataSuccess) {
    HttpHelper.getInstance()
      .get({
        url: "chart/getWeekLabelIncome",
        onDataSuccess: onDataSuccess
      })
  }

  public getMonthLabelExpense(year: number, month: number, onDataSuccess: OnDataSuccess) {
    HttpHelper.getInstance()
      .get({
        url: "chart/getMonthLabelExpense",
        params: { year: year.toString(), month: month.toString() },
        onDataSuccess: onDataSuccess
      })
  }

  public getMonthLabelIncome(year: number, month: number, onDataSuccess: OnDataSuccess) {
    HttpHelper.getInstance()
      .get({
        url: "chart/getMonthLabelIncome",
        params: { year: year.toString(), month: month.toString() },
        onDataSuccess: onDataSuccess
      })
  }

  public getYearExpenseData(year: number, onDataSuccess: OnDataSuccess) {
    HttpHelper.getInstance()
      .get({
        url: "chart/getYearInfor",
        params: { year: year.toString() },
        onDataSuccess: onDataSuccess
      })
  }

  public getYearIncomeData(year: number, onDataSuccess: OnDataSuccess) {
    HttpHelper.getInstance()
      .get({
        url: "chart/getYearIncome",
        params: { year: year.toString() },
        onDataSuccess: onDataSuccess
      })
  }

  public getYearLabelExpense(year: number, onDataSuccess: OnDataSuccess) {
    HttpHelper.getInstance()
      .get({
        url: "chart/getYearLabelExpense",
        params: { year: year.toString() },
        onDataSuccess: onDataSuccess
      })
  }

  public getYearLabelIncome(year: number, onDataSuccess: OnDataSuccess) {
    HttpHelper.getInstance()
      .get({
        url: "chart/getYearLabelIncome",
        params: { year: year.toString() },
        onDataSuccess: onDataSuccess
      })
  }
}