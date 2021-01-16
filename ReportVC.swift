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
     
    var firstCategoriesFromDB: [FirstCategoryEntity] = []
    var transactionsFromDB: [TransactionEntity] = []
    var firstCategoryNameArray: [String] = []
    var firstCategoryIdArray: [Int] = []
    var totalAmountOnCategory: [Int] = []
    
//    let players = ["Ozil", "Ramsey", "Laca", "Auba", "Xhaka", "Torreira"]
//    let goals = [555678, 12342, 101886, 444444, 992777, 1160000, 1972222]
    
    //MARK: - ViewDidLoad Function
    override func viewDidLoad() {
        super.viewDidLoad()
        
        uiConfig()
        
        
        firstCategoriesFromDB = AccountVC.db.readFirstCategory()
        transactionsFromDB = AccountVC.db.readTransaction()

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
            totalAmountOnCategory.append(result)
        }
        
        
        customizeChart(dataPoints: firstCategoryNameArray, values: totalAmountOnCategory.map{ sqrt(Double($0 * $0)) })

    }

    //MARK: - UI Configuration
    fileprivate func uiConfig() {
        
         
    }
    
    func customizeChart(dataPoints: [String], values: [Double]) {
      
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
        monthlyExpensePieChart.data = pieChartData
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
