//
//  ViewController.swift
//  MyMovableType
//
//  Created by haruhito on 2017/01/01.
//  Copyright © 2017年 Swift-Beginners. All rights reserved.
//

import UIKit
import SafariServices
import MTDataAPI_SDK
import SwiftyJSON
import SVProgressHUD

class ViewController: UIViewController , UISearchBarDelegate , UITableViewDataSource , UITableViewDelegate , SFSafariViewControllerDelegate {
  
  // Movable Type Data API SDK for Swift Instance
  let MTDataApi = DataAPI.sharedInstance
  
  override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view, typically from a nib.
    
    // Search Barのdelegate通知先を設定する
    searchText.delegate = self
    
    // 入力のヒントになる、プレースホルダを設定する
    searchText.placeholder = "検索したい焼き鳥を入力してください"
    
    // 入力が無い状態でも検索できるようにする
    searchText.enablesReturnKeyAutomatically = false
    
    // Table ViewのdataSourceを設定
    tableView.dataSource = self
    
    // Table Viewのdelegateを設定
    tableView.delegate = self
    
    // UIRefreshControlの設定
    refreshControl.attributedTitle = NSAttributedString(string: "引っ張って更新")
    refreshControl.addTarget(self, action: #selector(reloadSearch), for: UIControlEvents.valueChanged)
    tableView.addSubview(refreshControl)
    
    // 一覧表示
    searchRecipe(keyword: "")
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  @IBOutlet weak var searchText: UISearchBar!
  @IBOutlet weak var tableView: UITableView!
  
  // 表示するためのリスト（タプル配列）
  var tableList : [(category:String , name:String , link:String , image:String)] = []
  
  // PUIRefreshControl Instance
  let refreshControl = UIRefreshControl()
  
  func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
    // キーボードを閉じる
    view.endEditing(true)
    // デバックエリアに出力
    print(searchBar.text!)
    
    if let searchWord = searchBar.text {
      // 入力値がnilでなかったら、検索
      searchRecipe(keyword: searchWord)
    }
  }
  
  // searchRecipeメソッド
  // 第一引数：keyword 検索したいワード
  func searchRecipe(keyword : String) {
    // 設定値を取得する
    let defaults = UserDefaults.standard
    // ホスト名
    let mtHost = defaults.string(forKey: "mtHost")!
    // MovableTypeパス
    let mtPath = defaults.string(forKey: "mtPath")!
    // MovableType SiteID
    let mtSiteID = defaults.string(forKey: "mtSiteID")!
    
    // Movable Type Data API SDK for Swiftの初期設定
    MTDataApi.APIBaseURL = "http://\(mtHost)/\(mtPath)/mt-data-api.cgi"

    if (keyword.isEmpty) {
      SVProgressHUD.show()
      MTDataApi.listEntries(siteID: mtSiteID, options: ["limit":"20"], success: { (result, total) in
        SVProgressHUD.dismiss()
        if let items = result {
          self.addItem(items)
        }
      }) { (error) in
        //
        print(error ?? "listEntriesエラー")
        SVProgressHUD.showError(withStatus: error?["message"].stringValue ?? "不明なエラー")
      }
    } else {
      SVProgressHUD.show()
      MTDataApi.search(keyword, success: { (result, total) in
        SVProgressHUD.dismiss()
        if let items = result {
          self.addItem(items)
        }
      }, failure: { (error) in
        //
        print(error ?? "searchエラー")
        SVProgressHUD.showError(withStatus: error?["message"].stringValue ?? "不明なエラー")
      })
    }
  }
  
  // 引っ張ったら呼ばれるメソッド
  func reloadSearch() {
    if let searchWord = searchText.text {
      // 入力値がnilでなかったら、検索
      searchRecipe(keyword: searchWord)
    }
    refreshControl.endRefreshing()
  }
  
  func addItem(_ items: [JSON]) {
    // レシピのリストを初期化
    self.tableList.removeAll()
    
    // 取得しているレシピの数だけ処理
    for item in items {
      // カテゴリー名
      var category = ""
      if let categories = item["categories"].array {
        for itemCategory in categories {
          guard let label = itemCategory["label"].string else {
            continue
          }
          if category.characters.count > 0 {
            category += " > "
          }
          category += label
        }
      }
      
      // タイトルの名称
      guard let name = item["title"].string else {
        continue
      }
      // 掲載URL
      // urlからlinkに名称を変更しているのでご注意ください
      guard let link = item["permalink"].string else {
        continue
      }
      // 画像URL
      var image = ""
      if let assets = item["assets"].array {
        guard let thumnail = assets[0]["url"].string else {
          continue
        }
        image = thumnail
      }
      
      // １つの取得データをタプルでまとめて管理
      let recipe = (category,name,link,image)
      // 表示するためのリスト配列へ追加
      self.tableList.append(recipe)
      
    }
    //Table Viewを更新する
    self.tableView.reloadData()
  }
  
  // Cellの総数を返すdatasourceメソッド、必ず記述する必要があります
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    // レシピリストの総数
    return tableList.count
  }
  
  // Cellに値を設定するdatasourceメソッド。必ず記述する必要があります
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    //今回表示を行う、Cellオブジェクト（１行）を取得する
    let cell = tableView.dequeueReusableCell(withIdentifier: "recipeCell", for: indexPath)
    
    // レシピの名称設定
    cell.textLabel?.text = "\(tableList[indexPath.row].name)"
    
    // カテゴリ設定
    cell.detailTextLabel?.text = "\(tableList[indexPath.row].category)"
    
    // Assets画像のURLを取り出す
    let url = URL(string: tableList[indexPath.row].image)
    
    // URLから画像を取得
    cell.imageView?.sd_setImage(with: url, placeholderImage: UIImage(named: "dummy"))
    
    // 設定済みのCellオブジェクトを画面に反映
    return cell
  }
  
  // Cellが選択された際に呼び出されるdelegateメソッド
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    // ハイライト解除
    tableView.deselectRow(at: indexPath, animated: true)
    
    // URLをstring → URL型に変換
    let urlToLink = URL(string: tableList[indexPath.row].link)
    
    // SFSafariViewを開く
    let safariViewController = SFSafariViewController(url: urlToLink!)
    
    // delegateの通知先を自分自身
    safariViewController.delegate = self
    
    // SafariViewが開かれる
    present(safariViewController, animated: true, completion: nil)
  }
  
  // SafariViewが閉じられた時に呼ばれるdelegateメソッド
  func safariViewControllerDidFinish(_ controller: SFSafariViewController) {
    // SafariViewを閉じる
    dismiss(animated: true, completion: nil)
  }
}

