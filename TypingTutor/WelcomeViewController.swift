//
//  WelcomeViewController.swift
//  TypingTutor
//
//  Created by Sergey Lukjanov on 4/24/17.
//  Copyright © 2017 JinHe Wang. All rights reserved.
//

import UIKit

class WelcomeViewController: UIViewController {
    
    @IBOutlet weak var usernameText: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onStart(_ sender: Any) {
        if (usernameText.text == "" || usernameText.text == nil) {
            self.showAlert(withTitle: "Warning!", message: "Please enter your name.")
            return
        }
        let defaults = UserDefaults.standard
        defaults.set(usernameText.text, forKey: KUsername)
        defaults.synchronize()
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let mainViewController = storyboard.instantiateViewController(withIdentifier: "homeVC") as! UITabBarController
        self.present(mainViewController, animated: true, completion: nil)
    }

    /*
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if (usernameText.text == "") {
            return
        }
        if (segue.identifier == "segueHome"){
            
            let defaults = UserDefaults.standard
            defaults.set(usernameText.text, forKey: KUsername)
            defaults.synchronize()
        }
    }
 */
}

extension UIViewController {
    func showAlert(withTitle title: String, message: String?) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    func setViewMovedUp(up movedUp:Bool, view content:UIView, offset xOffset:CGFloat){
        UIView.animate(withDuration: 0.3) {
            var rect:CGRect = content.frame
            if(movedUp){
                rect.origin.y -= xOffset
            }else{
                rect.origin.y += xOffset
            }
            content.frame = rect
        }
    }
    
}
