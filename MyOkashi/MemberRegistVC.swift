//
//  MemberRegistVC.swift
//  MyOkashi
//
//  Created by User4 on 2018/03/04.
//  Copyright © 2018年 User4. All rights reserved.
//

import UIKit
import SwiftCop

let swiftCop: SwiftCop = SwiftCop()

class MemberRegistVC: UIViewController, UITextFieldDelegate {
    
    private let userDefaults = UserDefaults.standard
    
    @IBOutlet weak var lastnameText: UITextField!
    @IBOutlet weak var firstnameText: UITextField!
    @IBOutlet weak var mailaddressText: UITextField!
    @IBOutlet weak var passwordText: UITextField!
    @IBOutlet weak var bornPicker: UIDatePicker!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let value = userDefaults.string(forKey: "kind") {
            if value == "登録済み" {
                setup()
            }
        }
        
        swiftCop.addSuspect(Suspect(view: lastnameText, sentence: "名前（姓）が入力されていません", trial: Trial.length(.minimum, 1)))
        swiftCop.addSuspect(Suspect(view: firstnameText, sentence: "名前（名）が入力されていません", trial: Trial.length(.minimum, 1)))
        swiftCop.addSuspect(Suspect(view: passwordText, sentence: "パスワードが入力されていません", trial: Trial.length(.minimum, 1)))
        swiftCop.addSuspect(Suspect(view: mailaddressText, sentence: "メールアドレスを正しく入力してください", trial: Trial.email))
        
        lastnameText.delegate = self
        firstnameText.delegate = self
        passwordText.delegate = self
        mailaddressText.delegate = self

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    

    @IBAction func registButtonAction(_ sender: Any) {
        if let guilty = swiftCop.isGuilty(lastnameText) {
            lastnameText?.becomeFirstResponder()
            alert(sentence: guilty.sentence)
        } else if let guilty = swiftCop.isGuilty(firstnameText) {
            firstnameText?.becomeFirstResponder()
            alert(sentence: guilty.sentence)
        } else if let guilty = swiftCop.isGuilty(passwordText) {
            passwordText?.becomeFirstResponder()
            alert(sentence: guilty.sentence)
        } else if let guilty = swiftCop.isGuilty(mailaddressText) {
            mailaddressText?.becomeFirstResponder()
            alert(sentence: guilty.sentence)
        } else {
            
            registEntry()
            
            if let navigationController = self.presentingViewController as? UINavigationController,
                let controller = navigationController.topViewController as? StartVC {
                controller.update()
            }
            
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    @IBAction func eraseButtonAction(_ sender: Any) {
        eraseEntry()
        if let navigationController = self.presentingViewController as? UINavigationController,
            let controller = navigationController.topViewController as? StartVC {
            controller.update()
        }
        self.dismiss(animated: true, completion: nil)
    }
    
    private func registEntry() {
        let member = MemberData(
            lastname :self.lastnameText.text!,
            firstname :self.firstnameText.text!,
            password :self.passwordText.text!,
            mailaddress :self.mailaddressText.text!,
            born :self.bornPicker.date + 32400
        )

        let archive = NSKeyedArchiver.archivedData(withRootObject: member)
        userDefaults.set(archive, forKey:"member")
        userDefaults.set("登録済み", forKey: "kind")
        userDefaults.synchronize()
        
    }
    
    private func eraseEntry() {
        print("erase")
        userDefaults.removePersistentDomain(forName: "member")
        userDefaults.set("登録なし", forKey: "kind")
        userDefaults.synchronize()
    }
    
    private func setup() {
        guard let data = userDefaults.object(forKey: "member") as? Data else {
            return
        }
        
        if let unarchive = NSKeyedUnarchiver.unarchiveObject(with: data) as? MemberData {
            lastnameText.text = unarchive.lastname
            firstnameText.text = unarchive.firstname
            passwordText.text = unarchive.password
            mailaddressText.text = unarchive.mailaddress
            bornPicker.date = unarchive.born!

        }
    }
    
    func alert(sentence :String) {
        let alertController = UIAlertController(title: "注意", message: sentence, preferredStyle: .alert)
        let defaultAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(defaultAction)
        present(alertController, animated: true, completion: nil)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool{
        textField.resignFirstResponder()
        return true
    }
    

}
