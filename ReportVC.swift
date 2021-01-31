//
//  ReportVC.swift
//  ProjectMoney
//
//  Created by Ethan Son on 2020/12/31.
//

import UIKit
import Charts

class ReportVC: UIViewController {
    
    //MARK: - BottomBarButtons
    @IBOutlet weak var botBarAccountBtn: UIButton!
    @IBOutlet weak var botBarReportBtn: UIButton!
    @IBOutlet weak var botBarBudgetBtn: UIButton!
    @IBOutlet weak var botBarSettingsBtn: UIButton!
    @IBOutlet weak var monthlyExpensePieChart: PieChartView!
    @IBOutlet weak var monthlyExpenseLastSixMonthBarChart: BarChartView!
    @IBOutlet weak var expensesByPayee: PieChartView!
    
    var firstCategoriesFromDB: [FirstCategoryEntity] = []
    var transactionsFromDB: [TransactionEntity] = []
    var firstCategoryNameArray: [String] = []
    var firstCategoryIdArray: [Int] = []
    var totalAmountByCategory: [Int] = []
    
    var payeeArray: [String] = []
    var totalAmountByPayee: [Int] = []
    
    var sixMonthsArray: [String] = []
    var totalAmountByMonth: [Int] = []
    
    var dataFormatter: DataFormatter = DataFormatter()

    //MARK: - ViewDidLoad Function
    override func viewDidLoad() {
        super.viewDidLoad()
        
        uiConfig()
        
        
        firstCategoriesFromDB = AccountVC.db.readFirstCategory()
        transactionsFromDB = AccountVC.db.readTransaction()
        expenseTrendByCategoryChartData()
        expenseTrendByPayeeChartData()
        monthlyExpenseLastSixMonth()
        
        pieChartMaker(pieChart: monthlyExpensePieChart, dataPoints: firstCategoryNameArray, values: totalAmountByCategory.map{ sqrt(Double($0 * $0)) })
        
        pieChartMaker(pieChart: expensesByPayee, dataPoints: payeeArray, values: totalAmountByPayee.map{ sqrt(Double($0 * $0)) })
        
        barChartMaker(barChartView: monthlyExpenseLastSixMonthBarChart, dataPoints: Array(sixMonthsArray), values: totalAmountByMonth.map{ sqrt(Double($0 * $0)) })
    }

    //MARK: - UI Configuration
    fileprivate func uiConfig() {

    }
    
    fileprivate func expenseTrendByCategoryChartData() {
        
        for firstcategory in firstCategoriesFromDB {
            firstCategoryNameArray.append(firstcategory.name)
            firstCategoryIdArray.append(firstcategory.id)
        }

        for i in firstCategoryIdArray {
            var result = 0
            let x = transactionsFromDB.filter{ $0.firstCategory_Id == i }
            for j in x {
                result = result + j.amount
            }
            totalAmountByCategory.append(result)
        }
    }
    
    fileprivate func expenseTrendByPayeeChartData() {
        
        var payeeTotalAmountDictionary: [String : Int] = [:]

        for transaction in transactionsFromDB {
            
            if (payeeTotalAmountDictionary.index(forKey: transaction.payee) == nil) {
                payeeTotalAmountDictionary[transaction.payee] = transaction.amount
                } else {
                payeeTotalAmountDictionary.updateValue(payeeTotalAmountDictionary[transaction.payee, default: 0] + transaction.amount, forKey: transaction.payee)
            }
        }
        payeeArray = Array(payeeTotalAmountDictionary.keys)
        totalAmountByPayee = Array(payeeTotalAmountDictionary.values)
        
        print("\(payeeArray), \(payeeArray.count)")
        print("\(totalAmountByPayee), \(totalAmountByPayee.count)")
    }
    
    
    
    fileprivate func monthlyExpenseLastSixMonth() {
        
        var monthTotalAmountDictionary: [String : Int] = [:]

        for transaction in transactionsFromDB {
            
            if (monthTotalAmountDictionary.index(forKey: String(transaction.date.prefix(7))) == nil) {
                monthTotalAmountDictionary[String(transaction.date.prefix(7))] = transaction.amount
                } else {
                    monthTotalAmountDictionary.updateValue(monthTotalAmountDictionary[String(transaction.date.prefix(7)), default: 0] + transaction.amount, forKey: String(transaction.date.prefix(7)))
            }
        }
        let sorted = monthTotalAmountDictionary.sorted(by: {$0.0 < $1.0})
        sixMonthsArray = Array(sorted.map{$0.key})
        sixMonthsArray.removeSubrange(6...)
        totalAmountByMonth = Array(sorted.map{$0.value})
        totalAmountByMonth.removeSubrange(6...)
        
    }
    
    
    
    func barChartMaker(barChartView: BarChartView, dataPoints: [String], values: [Double]) {
        var dataEntries: [BarChartDataEntry] = []
        
        
        
        let legend = barChartView.legend
            legend.enabled = false
//            legend.horizontalAlignment = .right
//            legend.verticalAlignment = .top
//            legend.orientation = .vertical
//            legend.drawInside = true
//            legend.yOffset = 10.0;
//            legend.xOffset = 10.0;
//            legend.yEntrySpace = 0.0;
            
            
        let xaxis = barChartView.xAxis
//            xaxis.valueFormatter = axisFormatDelegate
            xaxis.drawGridLinesEnabled = false
            xaxis.labelPosition = .bottom
            xaxis.valueFormatter = IndexAxisValueFormatter(values: dataPoints)
//            xaxis.granularity = 1
            
            
        let leftAxisFormatter = NumberFormatter()
//            leftAxisFormatter.maximumFractionDigits = 1
            leftAxisFormatter.numberStyle = .decimal
            
        let yaxis = barChartView.leftAxis
            yaxis.spaceTop = 0.1
            yaxis.axisMinimum = 0
            yaxis.drawGridLinesEnabled = true
            yaxis.drawLabelsEnabled = false
        
        let format = NumberFormatter()
            format.numberStyle = .decimal
        let formatter = DefaultValueFormatter(formatter: format)
            
            barChartView.rightAxis.enabled = false
        
        
        
        for i in 0..<dataPoints.count {
          let dataEntry = BarChartDataEntry(x: Double(i), y: Double(values[i]))
          dataEntries.append(dataEntry)
        }
        let barChartDataSet = BarChartDataSet(entries: dataEntries, label: nil)
            barChartDataSet.colors = colorsOfCharts(numbersOfColor: dataPoints.count)
        let barChartData = BarChartData(dataSet: barChartDataSet)
            barChartData.setValueFormatter(formatter)
        
        barChartView.data = barChartData
        barChartView.doubleTapToZoomEnabled = false
        
        barChartView.animate(xAxisDuration: 1.5, yAxisDuration: 1.5, easingOption: .linear)
    }
    
    
    func pieChartMaker(pieChart: PieChartView, dataPoints: [String], values: [Double]) {
      
      // 1. Set ChartDataEntry
      var dataEntries: [ChartDataEntry] = []
      for i in 0..<dataPoints.count {
        let dataEntry = PieChartDataEntry(value: values[i], label: dataPoints[i], data: dataPoints[i] as AnyObject)
        dataEntries.append(dataEntry)
      }
      // 2. Set ChartDataSet
        let pieChartDataSet = PieChartDataSet(entries: dataEntries, label: nil)
      pieChartDataSet.colors = colorsOfCharts(numbersOfColor: dataPoints.count)
      // 3. Set ChartData
      let pieChartData = PieChartData(dataSet: pieChartDataSet)
      let format = NumberFormatter()
      format.numberStyle = .decimal
      let formatter = DefaultValueFormatter(formatter: format)
      pieChartData.setValueFormatter(formatter)
      // 4. Assign it to the chart’s data
        pieChart.data = pieChartData
        
        pieChart.animate(xAxisDuration: 1.5, yAxisDuration: 1.5)
    }
    
    private func colorsOfCharts(numbersOfColor: Int) -> [UIColor] {
      var colors: [UIColor] = []
      for _ in 0..<numbersOfColor {
        let red = Double(Int.random(in: 100...255))
        let green = Double(Int.random(in: 100...255))
        let blue = Double(Int.random(in: 100...255))
        let color = UIColor(red: CGFloat(red/255), green: CGFloat(green/255), blue: CGFloat(blue/255), alpha: 1)
        colors.append(color)
      }
      return colors
    }
    
    //MARK: - IBAction Bottom Bar Buttons

    @IBAction func botBarAccountBtnClicked(_ sender: UIButton) {
        exchangeMainView(viewControllerId: "AccountVCId")
    }
    
    @IBAction func botBarReporBtnClicked(_ sender: UIButton) {
    }
    
    @IBAction func botBarBudgetBtnClicked(_ sender: UIButton) {
        exchangeMainView(viewControllerId: "BudgetVCId")
    }
    
    @IBAction func botBarSettingsBtnClicked(_ sender: UIButton) {
        exchangeMainView(viewControllerId: "naviToSettings")
    }
    
    func exchangeMainView(viewControllerId: String) {
        let storyboards = UIStoryboard.init(name: "Main", bundle: nil)
        let uvcs = storyboards.instantiateViewController(identifier: viewControllerId)
        uvcs.modalPresentationStyle = .fullScreen
        self.present(uvcs, animated: false, completion: nil)
    }
    
}
