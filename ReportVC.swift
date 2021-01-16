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
    
    var sixMonthsArray: Set<String> = []
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
        sixMonthsArray = Set(monthTotalAmountDictionary.keys)
        totalAmountByMonth = Array(monthTotalAmountDictionary.values)
        
    }
    
    
    
    func barChartMaker(barChartView: BarChartView, dataPoints: [String], values: [Double]) {
        var dataEntries: [BarChartDataEntry] = []
        for i in 0..<dataPoints.count {
          let dataEntry = BarChartDataEntry(x: Double(i), y: Double(values[i]))
          dataEntries.append(dataEntry)
        }
        let chartDataSet = BarChartDataSet(entries: dataEntries, label: nil)
        let chartData = BarChartData(dataSet: chartDataSet)
        barChartView.data = chartData
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
      format.numberStyle = .none
      let formatter = DefaultValueFormatter(formatter: format)
      pieChartData.setValueFormatter(formatter)
      // 4. Assign it to the chart’s data
        pieChart.data = pieChartData
    }
    
    private func colorsOfCharts(numbersOfColor: Int) -> [UIColor] {
      var colors: [UIColor] = []
      for _ in 0..<numbersOfColor {
        let red = Double(arc4random_uniform(256))
        let green = Double(arc4random_uniform(256))
        let blue = Double(arc4random_uniform(256))
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
        exchangeMainView(viewControllerId: "SettingsVCId")
    }
    
    func exchangeMainView(viewControllerId: String) {
        let storyboards = UIStoryboard.init(name: "Main", bundle: nil)
        let uvcs = storyboards.instantiateViewController(identifier: viewControllerId)
        uvcs.modalPresentationStyle = .fullScreen
        self.present(uvcs, animated: false, completion: nil)
    }
    
}
