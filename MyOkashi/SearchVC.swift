//
//  SearchVC.swift
//  MyOkashi
//
//  Created by User4 on 2018/03/15.
//  Copyright © 2018年 User4. All rights reserved.
//

import UIKit
import SafariServices

class SearchVC: UITableViewController,UISearchBarDelegate,SFSafariViewControllerDelegate {

    var imageCashe = NSCache<AnyObject, UIImage>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchText.delegate = self
        searchText.placeholder = "お菓子の名前を入力してください"
        
        
        let image = UIImage(named: "E382B9E382A4E383BCE38384E38080E382A4E383A9E382B9E38388.jpg")
        let imageView = UIImageView(frame: CGRect(x:0, y:0, width:self.tableView.frame.width, height:self.tableView.frame.height))
        imageView.contentMode = UIViewContentMode.scaleAspectFill
        imageView.image = image
        self.tableView.backgroundView = imageView
        

        
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBOutlet weak var searchText: UISearchBar!
    
    var okashiList : [(maker:String , name:String , price:String , link:URL , image:URL)] = []
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        view.endEditing(true)
        if let searchWord = searchBar.text {
            print(searchWord)
            searchOkashi(keyword: searchWord)
        }
    }
    
    struct ItemJson: Codable {
        let name: String?
        let maker: String?
        let id: String?
        let url: URL?
        let image: URL?
    }
    struct ResultJson: Codable {
        let item:[ItemJson]?
    }
    
    struct PriceJson: Codable {
        let price: String?
    }
    struct ResultPriceJson: Codable {
        let item:PriceJson?
    }
    

    func searchOkashi(keyword : String) {
        guard let keyword_encode = keyword.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else {
            return
        }
        guard let req_url = URL(string: "http://www.sysbird.jp/toriko/api/?apikey=guest&format=json&keyword=\(keyword_encode)&max=10&order=r") else {
            return
        }

        let req = URLRequest(url: req_url)
        let session = URLSession(configuration: .default, delegate: nil, delegateQueue: OperationQueue.main)
        let task = session.dataTask(with: req, completionHandler: {
            (data, response, error) in
            session.finishTasksAndInvalidate()
            do {
                let decoder = JSONDecoder()
                let json = try decoder.decode(ResultJson.self, from: data!)

                if let items = json.item {
                    self.okashiList.removeAll()
                    for item in items {
                        if let maker = item.maker , let name = item.name , let id = item.id ,let url = item.url , let image = item.image {
                            self.searchOkashiPrice(id: id ,maker: maker,name: name,url: url,image: image)
                        }
                    }
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                    }
                }

            } catch let error {
                print("エラーが出ました\(error)")
            }
        })
        task.resume()
    }
    
    func searchOkashiPrice(id: String,maker: String,name:String,url:URL,image:URL) {
        var returnPrice = ""
        
        guard let id_encode = id.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else {
            returnPrice = "取得できませんでした"
            return
        }
        guard let req_url = URL(string: "http://www.sysbird.jp/toriko/api/?apikey=guest&format=json&id=\(id_encode)") else {
            returnPrice = "取得できませんでした"
            return
        }
        
        let req = URLRequest(url: req_url)
        let session = URLSession(configuration: .default, delegate: nil, delegateQueue: OperationQueue.main)
        let task = session.dataTask(with: req, completionHandler: {
            (data, response, error) in
            session.finishTasksAndInvalidate()
            do {
                let decoder = JSONDecoder()
                let json = try decoder.decode(ResultPriceJson.self, from: data!)
                
                if let price = json.item {
                    if let price = price.price {
                        returnPrice = price + "円"
                        
                        }
                }
            } catch let error {
                print("エラーが出ました!!\(error)")
                returnPrice = "価格未登録"
                
            }
            let okashi = (maker,name,returnPrice,url,image)
            self.okashiList.append(okashi)
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        })
        task.resume()
        return
        
    }
    
    override func tableView(_ tableview: UITableView, numberOfRowsInSection section: Int) -> Int {
        return okashiList.count
    }
    
    override func tableView(_ tableview: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableview.dequeueReusableCell(withIdentifier: "okashiCell", for: indexPath) as? ItemTableViewCell else {
            return UITableViewCell()
        }
        
        cell.itemNameLabel.text = okashiList[indexPath.row].name
        cell.itemMakerLabel.text = okashiList[indexPath.row].maker
        cell.itemPriceLabel.text = okashiList[indexPath.row].price
        
        cell.backgroundColor = UIColor.clear
//        cell.contentView.backgroundColor = UIColor.clear
        cell.contentView.backgroundColor = UIColor.white.withAlphaComponent(0.80)
        
        cell.itemNameLabel.numberOfLines = 0
        cell.itemNameLabel.sizeToFit()
        
        
        //画像なしチェック
        guard let itemImageUrl = try? Data(contentsOf: okashiList[indexPath.row].image) else {
            print("画像なし")
            return cell
        }
        //キャッシュに画像があればキャッシュ画像を表示
        if let casheImage = imageCashe.object(forKey: itemImageUrl as AnyObject) {
            print("Cashe")
            cell.itemImageView.image = casheImage
            return cell
        }
        //画像をダウンロードして非同期で描画しキャッシュに保存
        if let imageData = try? Data(contentsOf: okashiList[indexPath.row].image) {
            DispatchQueue.main.async {
                cell.itemImageView.image = UIImage(data: imageData)
            }
            self.imageCashe.setObject(UIImage(data: imageData)!, forKey: itemImageUrl as AnyObject)
            print("Download")
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let safariViewController = SFSafariViewController(url: okashiList[indexPath.row].link)
        safariViewController.delegate = self
        present(safariViewController, animated: true, completion: nil)
    }
    
    func safariViewControllerDidFinish(_ controller: SFSafariViewController) {
        dismiss(animated: true, completion: nil)
    }
}







