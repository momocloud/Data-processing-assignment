//
//  ResultViewController.swift
//  digital
//
//  Created by 王鲲宇 on 2019/9/12.
//  Copyright © 2019 王鲲宇. All rights reserved.
//

import UIKit

class ResultViewController: UIViewController {
    let crisis900 = [1.148, 1.425, 1.602, 1.729, 1.828, 1.909, 1.977, 2.036, 2.088, 2.134, 2.175, 2.213, 2.247, 2.279, 2.309, 2.335, 2.361, 2.385]
    let crisis950 = [1.153, 1.463, 1.672, 1.822, 1.938, 2.032, 2.110, 2.176, 2.234, 2.285, 2.331, 2.371, 2.409, 2.443, 2.475, 2.501, 2.532, 2.557]
    let crisis975 = [1.155, 1.481, 1.715, 1.887, 2.020, 2.126, 2.215, 2.290, 2.355, 2.412, 2.462, 2.507, 2.549, 2.585, 2.620, 2.651, 2.681, 2.709]
    let crisis990 = [1.155, 1.481, 1.715, 1.887, 2.020, 2.126, 2.215, 2.290, 2.355, 2.412, 2.462, 2.507, 2.549, 2.585, 2.620, 2.650, 2.681, 2.709]
    let crisis995 = [1.155, 1.496, 1.764, 1.973, 2.139, 2.274, 2.387, 2.482, 2.564, 2.636, 2.699, 2.755, 2.806, 2.852, 2.894, 2.932, 2.968, 3.001]
    
    let concrisis900 = [2.920 ,2.353 ,2.132 ,1.943 ,1.895 ,1.860 ,1.833 ,1.812 ,1.796 ,1.782 ,1.771 ,1.761 ,1.753 ,1.746 ,1.740 ,1.734 ,1.729 ,1.725]
    let concrisis950 = [4.303 ,3.182 ,2.776 ,2.571 ,2.447 ,2.365 ,2.306 ,2.262 ,2.228 ,2.201 ,2.179 ,2.160 ,2.145 ,2.131 ,2.120 ,2.110 ,2.101 ,2.093]
    let concrisis975 = [6.205 ,4.177 ,3.495 ,3.163 ,2.969 ,2.841 ,2.752 ,2.685 ,2.634 ,2.593 ,2.560 ,2.533 ,2.510 ,2.490 ,2.473 ,2.458 ,2.445 ,2.433]
    let concrisis990 = [9.925 ,5.841 ,4.604 ,4.032 ,3.707 ,3.499 ,3.355 ,3.250 ,3.169 ,3.106 ,3.055 ,3.012 ,2.977 ,2.947 ,2.921 ,2.898 ,2.878 ,2.861]
    let concrisis995 = [14.089 ,7.453 ,5.598 ,4.773 ,4.317 ,4.029 ,3.833 ,3.690 ,3.581 ,3.497 ,3.428 ,3.372 ,3.326 ,3.286 ,3.252 ,3.222 ,3.197 ,3.174]
    
    
    var numOfData: Int = 0
    var data = [Double]()
    var confidenceInterval: Double = 0
    //pass in
    
    
    var isBadGayHere = false
    var isFindBadGayHere = false
    var dataString = String()
    var sum: Double = 0
    var average: Double = 0
    var standardDeviatioEstimate: Double = 0
    var absArray = [Double]()
    var stand: Double = 0
    var checkArray = [Double]()
    var checkAbsMaximum: Double = 0
    var checkAbsMaximumPosition: Int = 0
    //init in
    
    var distanceArray = [Double]()
    //final judge
    
    
    @IBOutlet weak var averageLabel: UILabel!
    @IBOutlet weak var standardDeviatioEstimateLabel: UILabel!
    @IBOutlet weak var confidenceIntevalArrayLabel: UILabel!
    @IBAction func resultOut(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    @IBOutlet weak var badGayShowHere: UILabel!
    @IBOutlet weak var currentDataShow: UILabel!
    @IBAction func findNow(_ sender: UIButton) {
        isFindBadGayHere = true
        guard checkAbsMaximum > stand else{
            badGayShowHere.text! = "恭喜！没有坏值了～"
            isBadGayHere = false
            return
        }
        badGayShowHere.text! = "至少存在一个存在坏值，是第\(checkAbsMaximumPosition + 1)个数据，即\(data[checkAbsMaximumPosition])"
        isBadGayHere = true
    }
    @IBAction func pickOutBadGay(_ sender: UIButton) {
        guard isFindBadGayHere else {
            badGayShowHere.text! = "还没有寻找坏值呐～"
            return
        }
        guard isBadGayHere else {
            badGayShowHere.text! = "没有坏值呢～"
            return
        }
        guard numOfData > 3 else{
            badGayShowHere.text! = "数据已经减少到了3个了，无法再减少了～"
            return
        }
        data.remove(at: checkAbsMaximumPosition)
        initFunc()
        showResult()
        badGayShowHere.text! = "这个坏值去除成功～请重新寻找坏值至没有坏值～"
    }
    @IBOutlet weak var judgeLabel: UILabel!
    @IBAction func judgeButton(_ sender: UIButton) {
        if judgeMalikovFunc() {
            if judgeAbeHemmetFunc() {
                judgeLabel.text! = "发现累进性系统误差\n发现周期性系统误差"
            } else {
                judgeLabel.text! = "发现累进性系统误差\n未发现周期性系统误差"
            }
        } else {
            if judgeAbeHemmetFunc() {
                judgeLabel.text! = "未发现累进性系统误差\n发现周期性系统误差"
            } else {
                judgeLabel.text! = "未发现累进性系统误差\n未发现周期性系统误差"
            }
        }
        confidenceIntevalArrayLabel.text! = "置信区间：" + getDoubleNumShow(doubleNum: confidenceIntervalArrayCreate()[0], offset: 2) + "~" +
        getDoubleNumShow(doubleNum: confidenceIntervalArrayCreate()[1], offset: 2)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        currentDataShow.adjustsFontSizeToFitWidth = true
        initFunc()
        showResult()
        badGayShowHere.adjustsFontSizeToFitWidth = true
        judgeLabel.adjustsFontSizeToFitWidth = true
        judgeLabel.numberOfLines = 2
        badGayShowHere.numberOfLines = 3
    }
    
    func initDataString(){
        dataString = data.description
        dataString.remove(at: dataString.startIndex)
        dataString.remove(at: dataString.index(before: dataString.endIndex))
    }
    
    func initFunc(){
        initNumOfData()
        initSum()
        initAverage()
        initStandardDeviatioEstimate()
        initDistanceArray()
        initAbsArray()
        initDataString()
        initStand()
        initCheckArray()
        initCheckMaximum()
        currentDataShow.numberOfLines = numOfData / 7 + 1
        isBadGayHere = false
        isFindBadGayHere = false
    }
    
    func initSum(){
        sum = 0
        for index in data {
            sum += index
        }
    }
    
    func initNumOfData(){
        numOfData = data.count
    }
    
    func initStand(){
        switch confidenceInterval {
        case 0.90:
            stand = standardDeviatioEstimate * crisis900[numOfData.positionOfArray]
        case 0.95:
            stand = standardDeviatioEstimate * crisis950[numOfData.positionOfArray]
        case 0.975:
            stand = standardDeviatioEstimate * crisis975[numOfData.positionOfArray]
        case 0.99:
            stand = standardDeviatioEstimate * crisis990[numOfData.positionOfArray]
        case 0.995:
            stand = standardDeviatioEstimate * crisis995[numOfData.positionOfArray]
        default:
            stand = 0
        }
    }
    
    func initDistanceArray(){
        distanceArray = []
        for item in data {
            distanceArray.append(item - average)
        }
    }
    
    func initAbsArray(){
        absArray = []
        for item in data {
            absArray.append(abs(item - average))
        }
    }

    func initStandardDeviatioEstimate(){
        standardDeviatioEstimate = 0
        for index in data {
            standardDeviatioEstimate += pow(index, 2)
        }
        standardDeviatioEstimate = pow((standardDeviatioEstimate -  Double(numOfData) * pow(average, 2)) / Double((numOfData - 1)), 0.5)
    }
    
    func initAverage(){
        average = sum / Double(numOfData)
    }
    
    func initCheckArray(){
        checkArray = []
        for item in data {
            checkArray.append(abs(item - average))
        }
    }
    
    func initCheckMaximum(){
        checkAbsMaximum = checkArray[0]
        checkAbsMaximumPosition = 0
        for index in 0..<checkArray.count {
            if checkArray[index] > checkAbsMaximum {
                checkAbsMaximum = checkArray[index]
                checkAbsMaximumPosition = index
            }
        }
    }
    
    func judgeMalikovFunc() -> Bool {
        let isOdd = (numOfData%2 != 0) ? true : false
        var sumLeft: Double = 0
        var sumrRight: Double = 0
        var middleInLeft = 0
        switch isOdd {
        case true:
            middleInLeft = (numOfData + 1) / 2 - 1
        default:
            middleInLeft = numOfData / 2 - 1
        }
        let middleInRight = middleInLeft + 1
        for index in 0...middleInLeft {
            sumLeft += distanceArray[index]
        }
        for index in middleInRight...(numOfData - 1){
            sumrRight += distanceArray[index]
        }
        let judgeM: Double = abs(sumLeft - sumrRight)
        if judgeM < checkAbsMaximum {
            return false
        } else {
            return true
        }
    }
    
    func judgeAbeHemmetFunc() -> Bool {
        var judgeA: Double = 0
        for index in 0...(numOfData - 2) {
            judgeA += distanceArray[index] * distanceArray[index + 1]
        }
        judgeA = abs(judgeA)
        let judgeAStandard = pow(standardDeviatioEstimate, 2) * pow(Double(numOfData - 1), 0.5)
        if judgeA < judgeAStandard{
            return false
        } else {
            return true
        }
    }
    
    func getDoubleNumShow(doubleNum: Double, offset: Int) -> String{
        var index = 1
        var midVar = abs(doubleNum * 10.0)
        guard midVar != 0 else {
            return "0.00"
        }
        while midVar < 1 {
            midVar *= 10
            index += 1
        }
        let numShow = String(format: "%.\(index + offset)f", doubleNum)
        return numShow
    }
    
    func confidenceIntervalArrayCreate() -> [Double] {
        var confidenceIntervalArray = [Double]()
        var selArray = [Double]()
        switch confidenceInterval {
        case 0.9:
            selArray = concrisis900
        case 0.95:
            selArray = concrisis950
        case 0.975:
            selArray = concrisis975
        case 0.99:
            selArray = concrisis990
        case 0.995:
            selArray = concrisis995
        default:
            return [0,0]
        }
        let averageStandardDeviatioEstimate = standardDeviatioEstimate / pow(Double(numOfData), 0.5)
        confidenceIntervalArray.append(average - selArray[numOfData.positionOfArray] * averageStandardDeviatioEstimate)
        confidenceIntervalArray.append(average + selArray[numOfData.positionOfArray] * averageStandardDeviatioEstimate)
        return confidenceIntervalArray
    }
    
    func showResult(){
        averageLabel.text! = "均值：" + getDoubleNumShow(doubleNum: average, offset: 1)
        standardDeviatioEstimateLabel.text! = "标准偏差估计值：" + getDoubleNumShow(doubleNum: standardDeviatioEstimate, offset: 2)
        currentDataShow.text! = "当前剩余数据：" + dataString
    }
}

extension Int{
    var positionOfArray: Int{
        return self - 3
    }
}
