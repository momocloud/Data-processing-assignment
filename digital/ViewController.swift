//
//  ViewController.swift
//  digital
//
//  Created by 王鲲宇 on 2019/9/11.
//  Copyright © 2019 王鲲宇. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITextFieldDelegate{

    
    var numOfData: Int = 0
    var data = [Double]()
    var confidenceInterval: Double = 0
    var maxSymbal = false
    
    @IBOutlet weak var confidenceInteval: UITextField!
    @IBOutlet weak var writeInHere: UITextField!
    @IBOutlet weak var writeInNotice: UILabel!
//    @IBAction func writeInData(_ sender: UIButton) {
//        writeIn()
//        writeInNoticeFunc()
//        writeInDataShow()
//    }
    @IBOutlet weak var currentDataShow: UILabel!
    @IBAction func writeOutData(_ sender: UIButton) {
        writeOutDataShow()
        writeOut()
    }
//    @IBAction func writeInConfidenceInterval(_ sender: UIButton) {
//        writeInConfidenceIntervalFunc()
//    }
    @IBOutlet weak var confidenceIntervalNotice: UILabel!
    @IBAction func resultIn(_ sender: UIButton) {
        switch numOfData {
        case 0 :
            if confidenceInterval == 0{
                confidenceIntervalNotice.text! = "数据不全哦！缺少置信概率～"
            }
            writeInNotice.text! = "数据不全哦！没有录入数据～"
        case 1...2:
            if confidenceInterval == 0{
                confidenceIntervalNotice.text! = "数据不全哦！缺少置信概率～"
            }
            writeInNotice.text! = "数据不全哦！至少需要三个数据～"
        case 3...20:
            if confidenceInterval == 0{
                confidenceIntervalNotice.text! = "数据不全哦！缺少置信概率～"
            } else {
                self.performSegue(withIdentifier: "switchIn", sender: self)
            }
        default:
        if confidenceInterval == 0{
                confidenceIntervalNotice.text! = "数据不全哦！缺少置信概率～"
            }
            writeInNotice.text! = "这是一个不应该存在的Bug🤣"
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        initWriteInHere()
        initConfidenceInterval()
        writeInNotice.adjustsFontSizeToFitWidth = true
        currentDataShow.adjustsFontSizeToFitWidth = true
        writeInNotice.numberOfLines = 2
        confidenceIntervalNotice.numberOfLines = 2
        confidenceIntervalNotice.adjustsFontSizeToFitWidth = true
        writeInHere.delegate = self
        confidenceInteval.delegate = self
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch textField {
        case writeInHere:
            writeIn()
            writeInNoticeFunc()
            writeInDataShow()
            writeInHere.text = ""
            return true
        case confidenceInteval:
            if writeInConfidenceIntervalFunc() {
                self.confidenceInteval.resignFirstResponder()
            }
            confidenceInteval.text = ""
            return true
        default:
            return false
        }
    }
    
    func initWriteInHere(){
        writeInHere.placeholder = "输入数据"
        writeInHere.isSecureTextEntry = false
        writeInHere.keyboardType = .numbersAndPunctuation
        writeInHere.clearButtonMode = .whileEditing
        writeInHere.returnKeyType = UIReturnKeyType.continue
    }
    
    func initConfidenceInterval(){
        confidenceInteval.placeholder = "输入置信概率（去掉百分号）"
        confidenceInteval.isSecureTextEntry = false
        confidenceInteval.keyboardType = .numbersAndPunctuation
        confidenceInteval.clearButtonMode = .whileEditing
        confidenceInteval.returnKeyType = UIReturnKeyType.join
    }
    
    func writeIn(){
        if let writeInData = Double(writeInHere.text!) {
            if numOfData == 20{
                maxSymbal = true
                return
            }
            data.append(writeInData)
            numOfData += 1
        }
    }
    
    func writeInNoticeFunc(){
        guard maxSymbal == false else {
            writeInNotice.text! = "数据太多了，暂支持20个数据～"
            return
        }
        if Double(writeInHere.text!) != nil {
            writeInNotice.text = "已成功录入第\(numOfData)个数据"
        } else {
            writeInNotice.text = "非法数据！\n当前已录入\(numOfData)个数据"
        }
    }
    
    func writeInDataShow(){
        guard maxSymbal == false else {
            maxSymbal = false
            return
        }
        if Double(writeInHere.text!) != nil {
            currentDataShow.text = currentDataShow.text! +  String(data[data.count - 1]) + ", "
            currentDataShow.numberOfLines = numOfData / 7 + 1
        }
    }

    func writeOut(){
        if numOfData != 0 {
            data.remove(at: data.index(before: data.endIndex))
        }
    }
    
    func writeOutDataShow(){
        if numOfData != 0 {
            var stringShow = currentDataShow.text!
            let startIndex = stringShow.index(stringShow.startIndex, offsetBy: (stringShow.count - String(data[data.count - 1]).count - 2))
            let endIndex = stringShow.index(stringShow.startIndex, offsetBy: stringShow.count - 1)
            stringShow.removeSubrange(startIndex...endIndex)
            currentDataShow.text! = stringShow
            currentDataShow.numberOfLines = numOfData / 7 + 1
            numOfData -= 1
            writeInNotice.text! = "删除成功！\n当前还有\(numOfData)个数据"
        }
        else {
            writeInNotice.text = "已无数据可删..."
        }
    }
    
    func writeInConfidenceIntervalFunc() -> Bool {
        if let confidenceInterval = Double(confidenceInteval.text!){
            if (confidenceInterval > 0 && confidenceInterval < 100) {
                switch confidenceInterval{
                case 90: fallthrough
                case 95: fallthrough
                case 97.5: fallthrough
                case 99: fallthrough
                case 99.5:
                    self.confidenceInterval = confidenceInterval / 100
                    confidenceIntervalNotice.text! = "当前置信概率为\(confidenceInterval)%"
                    return true
                default:
                    confidenceIntervalNotice.text! = "暂不支持～"
                    return false
                }
            }
        }
        if confidenceInterval == 0 {
            confidenceIntervalNotice.text! = "非法输入！请重新录入！\n当前没有置信概率"
        } else {
            confidenceIntervalNotice.text! = "非法输入！请重新录入！\n当前置信概率为\(confidenceInterval * 100)%"
        }
        return false
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.confidenceInteval.resignFirstResponder()
        self.writeInHere.resignFirstResponder()
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "switchIn" {
            let resultInPage = segue.destination as! ResultViewController
            resultInPage.data = self.data
            resultInPage.confidenceInterval = self.confidenceInterval
            
        }
    }
}

