//
//  BuildingInfoMgmtViewController.swift
//  TeamProject
//
//  Created by apple11 on 2018. 6. 8..
//  Copyright © 2018년 COMP420. All rights reserved.
//

import UIKit

private let reuseIdentifier = "Cell"

class BuildingInfoMgmtViewController: UIViewController,UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate, ValueTransDelegate {
    
    @IBOutlet var searchBar : UISearchBar!
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    @IBAction func onAddBtnItem(_ sender: UIBarButtonItem){
        selected = Dictionary<String, Any>()
        selected![COOKEYS.building_edit_mode.rawValue] = BUILDING_EDIT_MODE.insert.rawValue
        performSegue(withIdentifier: "buildingEditTheme", sender: self)
    }
    var searchResult:[Dictionary<String, Any>] = []
    var itemTitleDocuments : [Dictionary<String, Any>] = []
    var coockieDelegate : ValueTransDelegate?
    var isloaded : Bool = false
    var selected : Dictionary<String, Any>?
    
    func getCoockieValue() -> [String: AnyObject] {
        return selected! as [String : AnyObject]
    }
    
    override func loadView() {
        super.loadView()
        if !isloaded{
            self.spinner.startAnimating()
            self.getBuildingInfo()
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.searchBar.delegate = self
        self.table.dataSource = self
        self.table.delegate = self
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        getBuildingInfo()
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let controller = segue.destination as! BuildingInfoEditViewController
        controller.delegate = self
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchResult.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell { //set each cell
        let cell = tableView.dequeueReusableCell(withIdentifier: "building_mg", for:indexPath)
        cell.textLabel?.text = String(format: "%@ %@ %@",
                                      searchResult[indexPath.row][COOKEYS.dpt.rawValue] as! String,
                                      searchResult[indexPath.row][COOKEYS.dpt_name.rawValue] as! String,
                                      searchResult[indexPath.row][COOKEYS.room.rawValue] as! String
        )
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(indexPath.row)
        selected = searchResult[indexPath.row]
        selected![COOKEYS.building_edit_mode.rawValue] = BUILDING_EDIT_MODE.edit.rawValue
        performSegue(withIdentifier: "buildingEditTheme", sender: self)
    }
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText:String){
        print("[+] searchBar(_ searchBar: UISearchBar, textDidChange searchText:String): \(searchText)")
        if searchText != ""{
            self.searchResult = []
            for item in self.itemTitleDocuments{
                let temp = String(format: "%@ %@ %@", item[COOKEYS.dpt.rawValue] as! String, item[COOKEYS.dpt_name.rawValue] as! String, item[COOKEYS.room.rawValue] as! String)
                if temp.contains(searchText){
                    self.searchResult.append(item)
                }
            }
        }else{
            self.searchResult = self.itemTitleDocuments
        }
        self.table.reloadData()
    }
    @IBOutlet weak var table: UITableView!
    func addBuildingInfo(body: String){
        HttpHelper.Shared.Post(path: URLREQUEST.building_mg_insert.rawValue,
                               paras: body,
                               success: {
                                (result: String) in
                                DispatchQueue.main.async {
                                    self.getBuildingInfo()
                                }
        },
                               failure: { (err:String) in
                                DispatchQueue.main.async {
                                    self.spinner.stopAnimating()
                                }
        })
        self.spinner.startAnimating()
    }
    
    func getBuildingInfo(){
        HttpHelper.Shared.Get(path: URLREQUEST.building_mg.rawValue, success: {
            (result : String) in
            let data = result.data(using:.utf8)!
            do{
                if let json = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.allowFragments) as? [Dictionary<String, Any>]{
                    self.itemTitleDocuments = json
                    DispatchQueue.main.async{
                        self.isloaded = true
                        self.searchResult = self.itemTitleDocuments
                        self.table.reloadData()
                    }
                }else{
                    print("error!")
                }
            }catch let err as NSError{
                print(err)
            }
            DispatchQueue.main.async{
                self.spinner.stopAnimating()
            }
            print(result)
        }, failure: {
            (error: String) in
            DispatchQueue.main.async{
                self.spinner.stopAnimating()
            }
            print("loading building data error")
        })
    }
    
    func deleteBuilding(body: String){
        HttpHelper.Shared.Post(path: URLREQUEST.building_mg_delete.rawValue,
                               paras: body,
                               success: {
                                (result: String) in
                                DispatchQueue.main.async {
                                    self.getBuildingInfo()
                                }
        },
                               failure: { (err:String) in
                                DispatchQueue.main.async {
                                    self.spinner.stopAnimating()
                                }
        })
        self.spinner.startAnimating()
    }
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let delete = UITableViewRowAction(style: .normal,
                                              title: "삭제") {
                                                (action, index) in
                                                print("삭제 \(index.row) : \(self.searchResult[index.row][COOKEYS.building_id.rawValue] as! Int)")
                                                let body = String(format: "%@=%d",
                                                                  COOKEYS.building_id.rawValue, self.searchResult[index.row][COOKEYS.building_id.rawValue] as! Int
                                                )
                                                self.deleteBuilding(body: body)
                                                self.alertShow(title: "삭제되었습니다.")
        }
        delete.backgroundColor = UIColor.red
        return [delete]
    }
}
