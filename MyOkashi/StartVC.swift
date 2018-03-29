//
//  StartVC.swift
//  MyOkashi
//
//  Created by User4 on 2018/03/04.
//  Copyright © 2018年 User4. All rights reserved.
//

import UIKit

class StartVC: UIViewController {
    
    var kind = 0
    
    @IBOutlet weak var startBtnView: UIButton!
    @IBOutlet weak var registBtnView: UIButton!
    @IBOutlet weak var editBtnView: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let userDefaults = UserDefaults.standard
        if let value = userDefaults.string(forKey: "kind") {
            print(value)
            
            if value == "登録済み" {
                kind = 1
            }
        }
        
        switch kind {
        case 0://会員登録なし
            startBtnView.isHidden = true
            registBtnView.isHidden = false
            editBtnView.isHidden = true
        case 1://会員登録あり
            startBtnView.isHidden = false
            registBtnView.isHidden = true
            editBtnView.isHidden = false
        default:
            return
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func startButtonAction(_ sender: Any) {
        performSegue(withIdentifier: "gotoLogin",sender: nil)
    }
    
    @IBAction func MemberRegistAction(_ sender: Any) {
        performSegue(withIdentifier: "gotoRegist",sender: nil)
    }
    
    @IBAction func MemberEditAction(_ sender: Any) {
        performSegue(withIdentifier: "gotoRegist",sender: nil)
    }
    
    func update() {
        loadView()
    }
    
    func gotoSearch() {
        performSegue(withIdentifier: "gotoSearch",sender: nil)
    }
    
}
