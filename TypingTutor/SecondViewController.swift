//
//  SecondViewController.swift
//  TypingTutor
//
//  Created by Sergey Lukjanov on 4/24/17.
//  Copyright © 2017 JinHe Wang. All rights reserved.
//

import UIKit
import SQLite

class TypingData {
    
    var name: String = ""
    var speed: Double = 0.0
}

class SecondViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var topUserTableView: UITableView!
    @IBOutlet weak var curUserTableView: UITableView?
    
    var resultData: Array<Any> = []
    var resultTopData: Array<Any> = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        resultData.removeAll()
        resultTopData.removeAll()
        
        let defaults = UserDefaults.standard
        let username = defaults.string(forKey: KUsername)
        
        do {
            let path = NSSearchPathForDirectoriesInDomains(
                .documentDirectory, .userDomainMask, true
                ).first!
            
            let db = try Connection("\(path)/db.sqlite3")
            
            let records = Table("records")
            
            let name = Expression<String>("name")
            let speed = Expression<Double>("speed")
            //let regtime = Expression<String>("regtime")
            
            for record in try db.prepare(records.select(name, speed)
                .filter(name == username!)
                .order(speed.desc)
                .limit(3, offset: 1)) {
                    
                    let data = TypingData()
                    
                    data.name = record[name]
                    data.speed = record[speed]
                    
                    resultData.append(data)
            }
            
            for record in try db.prepare(records.select(name, speed)
                .filter(name != username!)
                .order(speed.desc)
                .group(name)
                .limit(10, offset: 1)) {
                    
                    let data = TypingData()
                    
                    data.name = record[name]
                    data.speed = record[speed]
                    
                    resultTopData.append(data)
            }
            
            curUserTableView?.reloadData()
            topUserTableView?.reloadData()
        }
        catch {
            
        }
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (tableView == curUserTableView) {
            return resultData.count
        }
        return resultTopData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if (tableView == curUserTableView) {
            let cell = curUserTableView?.dequeueReusableCell(withIdentifier: "customCell", for: indexPath) as! CustomCell
            let record = resultData[indexPath.row] as! TypingData
            cell.nameTxt.text = record.name
            cell.speedTxt.text = String.init(format: "%.1f words per min", record.speed)
            
            return cell
        }
        let cell = topUserTableView?.dequeueReusableCell(withIdentifier: "topCustomCell", for: indexPath) as! CustomCell
        let record = resultTopData[indexPath.row] as! TypingData
        cell.name1Txt.text = record.name
        cell.speed1Txt.text = String.init(format: "%.1f words per min", record.speed)
        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
}

