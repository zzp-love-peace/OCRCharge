import { PieChartBean } from '../view/chart/ChartInfoComponent';
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

export interface WeekChartData {
  weekSum: number,
  dayAverage: number,
  everyday: number[]
}

export interface MonthChartData {
  monthSum: number,
  dayAverage: number,
  everyday: number[]
}

export interface YearChartData {
  yearSum: number,
  monthSum: number[],
  monthAverage: number
}

export interface WeekLabelData {
  weekLabelData: PieChartBean[]
}

export interface MonthLabelData {
  monthLabelData: PieChartBean[]
}

export interface YearLabelData {
  yearLabelData: PieChartBean[]
}