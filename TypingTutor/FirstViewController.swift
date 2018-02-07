//
//  FirstViewController.swift
//  TypingTutor
//
//  Created by Sergey Lukjanov on 4/24/17.
//  Copyright © 2017 JinHe Wang. All rights reserved.
//

import UIKit
import SQLite

class FirstViewController: UIViewController, UITextFieldDelegate {
    @IBOutlet weak var answer: UILabel!
    @IBOutlet weak var startBut: UIButton!
    
    @IBOutlet weak var nameLabel:UILabel!
    @IBOutlet weak var timeLabel:UILabel!
    
    @IBOutlet weak var speedText:UITextField!
    @IBOutlet weak var testTextView:UITextView!
    @IBOutlet weak var answerText:UITextField!
    
    @IBOutlet weak var startTestBut: UIButton!
    
    var paragraphs: [String] = []
    var testPara: String = ""
    var nIndex: Int = 0
    var timer:Int = 180
    var speedPerMin:Int = 0
    var minute:Int = 2
    var wordCnt = 0
    var username: String = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        
        testTextView.text = ""
        speedText.text = ""
        
        if let path = Bundle.main.path(forResource: "federer", ofType: "txt") {
            do {
                let text = try String(contentsOfFile: path, encoding: String.Encoding.utf8)
                paragraphs = text.components(separatedBy: CharacterSet.newlines)
            }
            catch {
                print("Failed to read text from file")
            }
        } else {
            print("Failed to load file from app bundle")
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let defaults = UserDefaults.standard
        
        username = defaults.string(forKey: KUsername)!
        
        nameLabel.text = String.init(format: "Hello! %@", username)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func myFunc() {
        answerText.text = ""
        let tokons = testPara.components(separatedBy: CharacterSet.whitespacesAndNewlines)
        
        if (tokons.count <= nIndex) { return }
        
        let word = tokons[nIndex]
        
        var multi = [String : Any]()
        multi[NSForegroundColorAttributeName] = UIColor.red
        multi[NSFontAttributeName] = UIFont(name: "Arial", size: 20.0)
        
        let myAttribute = [ NSFontAttributeName: UIFont(name: "Arial", size: 20.0)! ]
        
        let myString = NSMutableAttributedString()
        
            let len = word.lengthOfBytes(using: String.Encoding.utf8)
            let pos = len / 2
            
            let left = NSAttributedString(string: word.substring(to: pos), attributes: myAttribute)
            let middle = NSAttributedString(string: word.substring(with: pos..<pos + 1), attributes: multi)
            let right = NSAttributedString(string: word.substring(from: pos + 1), attributes: myAttribute)
            
            myString.append(left)
            myString.append(middle)
            myString.append(right)

        
        testTextView.attributedText = myString
        nIndex = nIndex + 1
    }
    
    func counting() {
        DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(1000), execute: {
            let min = self.timer / 60
            let sec = self.timer % 60
            
            if (self.timer != 0) {
                self.counting()
            }
            else {
                self.end()
            }
            self.timeLabel.text = String.init(format: "%02d:%02d", min, sec)
            self.timer = self.timer - 1
        })
    }
    
    func end() {
        if (startBut.isHidden == false) { return }
        
        self.speedText.isHidden = false
        self.startBut.isHidden = false
        
        let myAttribute = [ NSFontAttributeName: UIFont(name: "Arial", size: 20.0)! ]
        self.testTextView.attributedText = NSAttributedString(string: self.testPara, attributes: myAttribute)
        
        do {
            let path = NSSearchPathForDirectoriesInDomains(
                .documentDirectory, .userDomainMask, true
                ).first!
            try FileManager.default.createDirectory(
                atPath: path, withIntermediateDirectories: true, attributes: nil
            )

            let db = try Connection("\(path)/db.sqlite3")
            
            let records = Table("records")
            
            let name = Expression<String>("name")
            let speed = Expression<Double>("speed")
            let regtime = Expression<String>("regtime")
            
            let currentDateTime = Date()
            
            // get the user's calendar
            let userCalendar = Calendar.current
            
            // choose which date and time components are needed
            let requestedComponents: Set<Calendar.Component> = [
                .year,
                .month,
                .day,
                .hour,
                .minute,
                .second
            ]
            
            // get the components
            let dateTimeComponents = userCalendar.dateComponents(requestedComponents, from: currentDateTime)
            
            let curTime = String.init(format: "%d/%02d/%02d %02d:%02d:%02d", dateTimeComponents.year!, dateTimeComponents.month!, dateTimeComponents.day!, dateTimeComponents.hour!, dateTimeComponents.minute!, dateTimeComponents.second!)
            
            let wordsPerMin = Double(wordCnt) / Double(minute)
            try db.run(records.insert(name <- username, speed <- wordsPerMin, regtime <- curTime))
        }
        catch {
            
        }
        
    }
    
    @IBAction func onStartTest(_ sender: Any) {
        
        nIndex = 0
        timer = 60 * minute
        wordCnt = 0
        
        let defaults = UserDefaults.standard
        let delay = defaults.integer(forKey: KDelay)
        
        speedPerMin = defaults.integer(forKey: KSpeed)
        if (speedText.text != nil && speedText.text != "") {
            speedPerMin = Int(speedText.text!)!
        }
        
        timeLabel.text = String.init(format: "%02d:00", minute)
        answer.text = String.init(format: "%d/%d", wordCnt, speedPerMin * minute)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(delay), execute: {
            
            self.speedText.isHidden = true
            self.startBut.isHidden = true
            
            let length = self.paragraphs.count
            
            let k: Int = Int(arc4random()) % length
            var sentence: String = self.paragraphs[k]
            if (k % 2 == 1) {
                sentence = self.paragraphs[k-1]
            }
            self.testPara = sentence
            self.myFunc()
            self.counting()
        })
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if (answerText.text != nil && testTextView.text == answerText.text) {
            wordCnt = wordCnt + 1
            answer.text = String.init(format: "%d/%d", wordCnt, speedPerMin * minute)
            myFunc()
        }
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
    }
}

extension String {
    func index(from: Int) -> Index {
        return self.index(startIndex, offsetBy: from)
    }
    
    func substring(from: Int) -> String {
        let fromIndex = index(from: from)
        return substring(from: fromIndex)
    }
    
    func substring(to: Int) -> String {
        let toIndex = index(from: to)
        return substring(to: toIndex)
    }
    
    func substring(with r: Range<Int>) -> String {
        let startIndex = index(from: r.lowerBound)
        let endIndex = index(from: r.upperBound)
        return substring(with: startIndex..<endIndex)
    }
}

