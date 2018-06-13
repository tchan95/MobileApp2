//
//  BuildingTableViewController.swift
//  
//
//  Created by apple11 on 2018. 6. 1..
//

import UIKit

class BuildingTableViewController:UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate, ValueTransDelegate {
    @IBOutlet var searchBar : UISearchBar!
    var searchResult:[String] = []
    var itemTitleDocuments : [String] = []
    var coockieDelegate : ValueTransDelegate?
    var dpt:[String] = []
    var isloaded : Bool = false
    var selected : (String, String, String)?
    func getCoockieValue() -> [String : AnyObject] {
        var value = coockieDelegate?.getCoockieValue()
        if let item = selected{
            value![COOKEYS.dpt.rawValue] = item.0 as AnyObject
            value![COOKEYS.dpt_name.rawValue] = item.1 as AnyObject
            value![COOKEYS.room.rawValue] = item.2 as AnyObject
        }
        return value!
    }
    func getReservationInfoFromServer(){
        HttpHelper.Shared.Get(path: URLREQUEST.building_user.rawValue, success: {
            (result : String) in
            let data = result.data(using:.utf8)!
            do{
                if let json = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.allowFragments) as? [Dictionary<String, Any>]{
                    for i in 0..<json.count{
                        self.itemTitleDocuments.append(String(format:"%@ %@ %@", json[i]["DPT"] as! String, json[i]["DPT_NAME"] as! String, json[i]["ROOM"] as! String))
                    }
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
            print(result)
        }, failure: {
            (error: String) in
            print("loading building data error")
        })
    }
    override func loadView() {
        super.loadView()
        if !isloaded{
            getReservationInfoFromServer()
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.searchBar.delegate = self
        self.table.dataSource = self
        self.table.delegate = self
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let controller = segue.destination as! CalendarViewController
        controller.delegate = self
        print("go to calender view")
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchResult.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell { //set each cell
        let cell = tableView.dequeueReusableCell(withIdentifier: "building", for:indexPath)
        cell.textLabel?.text = searchResult[indexPath.row]
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(indexPath.row)
        let strArry = searchResult[indexPath.row].split(separator:" ").map(String.init)
        selected = (strArry[0],
                    strArry[1],
                    strArry[2])
        performSegue(withIdentifier: "CalendarTheme", sender: tableView.cellForRow(at: indexPath))
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText:String){
        print("[+] searchBar(_ searchBar: UISearchBar, textDidChange searchText:String): \(searchText)")
        if searchText != ""{
            self.searchResult = []
            for item in self.itemTitleDocuments{
                if item.contains(searchText){
                    self.searchResult.append(item)
                }
            }
        }else{
            self.searchResult = self.itemTitleDocuments
        }
        self.table.reloadData()
    }
    @IBOutlet weak var table: UITableView!
}
