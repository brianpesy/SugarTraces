//
//  StatsViewController.swift
//  SugarTraces
//
//  Created by Brian Sy on 26/09/2019.
//  Copyright © 2019 Brian Sy. All rights reserved.
//

import UIKit
import Charts

var loggedReadings = [Int]()
var loggedDates = [String]()

extension ViewController: IAxisValueFormatter {

    func stringForValue(_ value: Double, axis: AxisBase?) -> String {
        return loggedDates[Int(value)]
    }
}

class StatsViewController: UIViewController, ChartViewDelegate {
    
    @IBOutlet weak var barChartView: BarChartView!
    weak var axisFormatDelegate: IAxisValueFormatter?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        loadLoggedData()
        
    }
    
    func loadLoggedData(){
        var savedReadings = defaults.array(forKey: Keys.savedReadings) as? [Int] ?? [Int]()
        loggedReadings = savedReadings
        
        var savedDates = defaults.array(forKey: Keys.savedDates) as? [String] ?? [String]()
        loggedDates = savedDates
    }
    
    func chartValueSelected(chartView: ChartViewBase, entry: ChartDataEntry, dataSetIndex: Int, highlight: Highlight){
        
    }
    
    func setColor(value: Double) -> UIColor{
        //Red: Below, Blue: Normal, Yellow: Above

        if(value > 69 && value < 151){
            return UIColor.blue
        }
        else if(value < 70){
            return UIColor.red
        }
        else if(value > 150){
            return UIColor.yellow
        }

        else { //In case anything goes wrong
            return UIColor.black
        }
    }
    
    func prepareLegend() {
        barChartView.legend.textColor = UIColor.gray

        let aboveLegend = LegendEntry()
        aboveLegend.label = "Above"
        aboveLegend.form = .square
        aboveLegend.formColor = UIColor.red

        let normalLegend = LegendEntry()
        normalLegend.label = "Normal"
        normalLegend.form = .square
        normalLegend.formColor = UIColor.blue
        
        let belowLegend = LegendEntry()
        belowLegend.label = "Below"
        belowLegend.form = .square
        belowLegend.formColor = UIColor.yellow

        barChartView.legend.extraEntries = [aboveLegend, normalLegend, belowLegend]
    }
    
    func setChartValues(entryX: [String], entryY: [Int]){
        //Readings are the y axis, dates are labeled at the x axis
        barChartView.noDataText = "You need to provide data for the chart."
        var dataEntries:[BarChartDataEntry] = []
        if entryX.count > 5 {
            for i in 0..<5{ //entryX.count for everything
                let dataEntry = BarChartDataEntry(x: Double(i), y: Double(entryY[i]), data: loggedReadings as AnyObject?)
                dataEntries.append(dataEntry)
            }
        } else {
            for i in 0..<entryX.count{ //entryX.count for everything
                let dataEntry = BarChartDataEntry(x: Double(i), y: Double(entryY[i]), data: loggedReadings as AnyObject?)
                dataEntries.append(dataEntry)
            }
        }

        let chartDataSet = BarChartDataSet(entries: dataEntries, label: "Blood Glucose (mg/dL)")
        let chartData = BarChartData(dataSet: chartDataSet)
        
        //Color condition
        var tempColors = [UIColor]()
        if entryX.count > 5 {
            for i in 0..<5 {
                tempColors.append(setColor(value: Double(entryY[i])))
            }
        } else {
            for i in 0..<entryX.count {
                tempColors.append(setColor(value: Double(entryY[i])))
            }
        }

        chartDataSet.colors = tempColors

        //Legend preparation
        prepareLegend()
        
        barChartView.data = chartData
        let xAxisValue = barChartView.xAxis
        
        var dateArr = [String]()
        
        for x in entryX { //00-00-0000 00:00:00
            var x = x
            x.insert("\n", at: x.index(x.startIndex, offsetBy: 10))
            dateArr.append(String(x))
        }
        
        xAxisValue.valueFormatter = IndexAxisValueFormatter(values: dateArr)
        barChartView.xAxis.granularity = 1
        barChartView.extraTopOffset = 20
        barChartView.fitScreen()

    }
    
    override func viewWillAppear(_ animated: Bool) {

        //Loading the data that was saved
        loadLoggedData()
        
        //Make the line graph
        if (!loggedDates.isEmpty){
            setChartValues(entryX: loggedDates, entryY: loggedReadings)
        }
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
