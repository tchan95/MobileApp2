//
//  CheckReservationMenuItem.swift
//  TeamProject
//
//  Created by apple11 on 2018. 5. 31..
//  Copyright © 2018년 COMP420. All rights reserved.
//

import UIKit

class MenuTableViewController: UITableViewController {
    var itemTitleDocuments = ["예약하기","예약 현황 확인"]
    var itemDetailDocuments = ["공유 공간을 예약합니다", "내가 예약한 공간을 확인합니다"]
    // MARK: - UITableViewDataSource
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 0
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return itemTitleDocuments.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "UserMenuCell", for:indexPath)
        cell.textLabel?.text = itemTitleDocuments[indexPath.row]
//        cell.detailTextLabel?.text = itemDetailDocuments[indexPath.row]
        /**customer Lab11 50:42**/
//        if let myTVCell = cell as? MenuTableViewCell{
//            myTVCell
//        }
//        print("return")
        return cell
    }

}

