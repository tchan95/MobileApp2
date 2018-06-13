//
//  MenuViewController.swift
//  TeamProject
//
//  Created by apple11 on 2018. 5. 31..
//  Copyright © 2018년 COMP420. All rights reserved.
//

import UIKit

class MenuViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, ValueTransDelegate {
    let itemTitleDocuments = [USER_STATUS.user.rawValue:["예약하기","예약 현황 확인"],
                              USER_STATUS.manager.rawValue:["예약 정보 처리","시스템 관리"]]
    let itemDetailDocuments = [USER_STATUS.user.rawValue: ["공유 공간을 예약합니다.", "내가 예약한 공간을 확인합니다."],
                               USER_STATUS.manager.rawValue:["예약된 공간의 예약여부를 처리합니다.", "공유 공간 시스템을 관리합니다."]]
    var user_status : String?
    var delegate : ValueTransDelegate?
    func getCoockieValue() -> [String : AnyObject] {
        let value = delegate?.getCoockieValue()
        return value!
    }
    override func loadView() {
        super.loadView()
        user_status = delegate?.getCoockieValue()[COOKEYS.usr_status.rawValue] as! String
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.table.dataSource = self
        self.table.delegate = self
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "예약하기"{
            print("go")
            let controller = segue.destination as! BuildingTableViewController
            controller.coockieDelegate = self
        }else if segue.identifier == "예약 현황 확인"{
            print("go to 예약 현황 확인")
            let controller = segue.destination as! BookCheckViewController
            controller.delegate = self
        }
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemTitleDocuments.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell { //set each cell
        let cell = tableView.dequeueReusableCell(withIdentifier: "UserMenuCell", for:indexPath)
        cell.textLabel?.text = itemTitleDocuments[user_status!]?[indexPath.row] ?? "unknown" // set the title of a cell
        cell.detailTextLabel?.text = itemDetailDocuments[user_status!]?[indexPath.row] ?? "unknown"
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(indexPath.row)
        performSegue(withIdentifier: itemTitleDocuments[user_status!]![indexPath.row], sender: tableView.cellForRow(at: indexPath))
    }
    @IBOutlet weak var table: UITableView!
   
}
class MenuTableViewCell: UITableViewCell{
    var titleLabel:UILabel?
    var linkLabel: UILabel?
}
