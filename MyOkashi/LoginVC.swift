//
//  LoginVC.swift
//  MyOkashi
//
//  Created by User4 on 2018/03/04.
//  Copyright © 2018年 User4. All rights reserved.
//

import UIKit
import AudioToolbox

class LoginVC: UIViewController, UITextFieldDelegate {
    
    private let userDefaults = UserDefaults.standard

    @IBOutlet weak var mailaddressText: UITextField!
    @IBOutlet weak var passwordText: UITextField!
    @IBOutlet weak var incorrectImage: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        passwordText.delegate = self
        mailaddressText.delegate = self
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func loginButtonAction(_ sender: Any) {

        guard let data = userDefaults.object(forKey: "member") as? Data else {
            return
        }
        if let unarchive = NSKeyedUnarchiver.unarchiveObject(with: data) as? MemberData {
            let password = unarchive.password!
            let mailaddress = unarchive.mailaddress!
            
            if (passwordText.text == password && mailaddressText.text == mailaddress) {
                
                if let navigationController = self.presentingViewController as? UINavigationController,
                    let controller = navigationController.topViewController as? StartVC {
                    controller.gotoSearch()
                    self.dismiss(animated: true, completion: nil)
                }
                
            } else {
                incorrectImage.isHidden = false
                AudioServicesPlaySystemSound(1021)
            }
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool{
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        incorrectImage.isHidden =  true
        return
    }


}
