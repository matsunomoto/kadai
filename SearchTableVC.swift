//
//  SearchTableVC.swift
//  MyOkashi
//
//  Created by User4 on 2018/03/10.
//  Copyright © 2018年 User4. All rights reserved.
//

import UIKit

class SearchTableVC: UItableViewController,UISearchBarDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchText.delegate = self
        searchText.placeholder = "お菓子の名前を入力してください"
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    @IBOutlet var tableView: UITableView!
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        view.endEditing(true)
        if let searchWord = searchBar.text {
            print(searchWord)
            searchOkashi(keyword: searchWord)
        }
    }
    
    func searchOkashi(keyword : String) {
        guard let keyword_encode = keyword.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else {
            return
        }
        guard let req_url = URL(string: "http://www.sysbird.jp/toriko/api/?apikey=guest&format=json&keyword=\(keyword_encode)&max=10&order=r") else {
            return
        }
        print(req_url)
    }
    
    
    
    
    
    
    
    
    
}

