//
//  ItemSearchResultSet.swift
//  MyOkashi
//
//  Created by User4 on 2018/03/17.
//  Copyright © 2018年 User4. All rights reserved.
//

//import Foundation
//
//public class ItemSearchResultSet {
//    
//    var okashiList : [(maker:String , name:String , price:String , link:URL , image:URL)] = []
//    
//    
//    struct ItemJson: Codable {
//        let name: String?
//        let maker: String?
//        let id:String?
//        let price: String?
//        let url: URL?
//        let image: URL?
//    }
//    
//    struct ResultJson: Codable {
//        let item:[ItemJson]?
//    }
//
//
//    func searchOkashi(keyword : String) {
//        guard let keyword_encode = keyword.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else {
//            return
//        }
//        guard let req_url = URL(string: "http://www.sysbird.jp/toriko/api/?apikey=guest&format=json&keyword=\(keyword_encode)&max=10&order=r") else {
//            return
//        }
//        print(req_url)
//        
//        let req = URLRequest(url: req_url)
//        let session = URLSession(configuration: .default, delegate: nil, delegateQueue: OperationQueue.main)
//        let task = session.dataTask(with: req, completionHandler: {
//            (data, response, error) in
//            session.finishTasksAndInvalidate()
//            do {
//                let decoder = JSONDecoder()
//                let json = try decoder.decode(ResultJson.self, from: data!)
//                
//                if let items = json.item {
//                    self.okashiList.removeAll()
//                    for item in items {
//                        if let maker = item.maker , let name = item.name , let id = item.id ,let link = item.url , let image = item.image {
//                            let price = "9999"
//                            let okashi = (maker,name,price,link,image)
//                            self.okashiList.append(okashi)
//                        }
//                    }
//                    
////                    DispatchQueue.main.async {
////                        self.tableView.reloadData()
////                    }
//                    
//                    if let okashidbg = self.okashiList.first {
//                        print("--------------------------")
//                        print("okashiList[0] = \(okashidbg)")
//                    }
//                }
//                
//            } catch let error {
//                print("エラーが出ました\(error)")
//            }
//        })
//        task.resume()
//    }
//
//}


