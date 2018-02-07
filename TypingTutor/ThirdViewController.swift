//
//  ThirdViewController.swift
//  TypingTutor
//
//  Created by Sergey Lukjanov on 4/24/17.
//  Copyright © 2017 JinHe Wang. All rights reserved.
//

import UIKit

class ThirdViewController: UIViewController {
    
    @IBOutlet weak var speedText: UITextField!
    @IBOutlet weak var delayText: UITextField!
    @IBOutlet weak var usernameText: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let defaults = UserDefaults.standard
        
        let username = defaults.string(forKey: KUsername)
        let delay = defaults.integer(forKey: KDelay)
        let speed = defaults.integer(forKey: KSpeed)
        
        usernameText.text = username
        delayText.text = String.init(format: "%d", delay)
        speedText.text = String.init(format: "%d", speed)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onSave(_ sender: Any) {
        
        let defaults = UserDefaults.standard
        
        if (usernameText.text != "" && usernameText.text != nil) {
            defaults.setValue(usernameText.text, forKey: KUsername)
        }
        
        let delay:String = delayText.text!
        if (Int(delay) != 0) {
            defaults.setValue(Int(delay), forKey: KDelay)
        }
        
        let speed:String = speedText.text!
        if (Int(speed) != 0) {
            defaults.setValue(Int(speed), forKey: KSpeed)
        }
        defaults.synchronize()
    }
}
