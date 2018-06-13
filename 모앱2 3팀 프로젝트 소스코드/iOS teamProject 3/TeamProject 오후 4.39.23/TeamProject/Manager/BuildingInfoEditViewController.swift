//
//  BuildingInfoEditViewController.swift
//  
//
//  Created by apple11 on 2018. 6. 8..
//

import UIKit

class BuildingInfoEditViewController: UIViewController {
    var isForInsert: Bool = true
    var delegate: ValueTransDelegate?
    var dict : [String: AnyObject] = [:]
    @IBOutlet var bNoFiled : UITextField?
    @IBOutlet var dptFiled: UITextField?
    @IBOutlet var dptNameFiled: UITextField?
    @IBOutlet var floorFiled : UITextField?
    @IBOutlet var roomFiled : UITextField?
    @IBOutlet var midFiled : UITextField?
    var building_id : Int?
    
    func loadBuildingInfoToFileds(){
        bNoFiled?.text = dict[COOKEYS.building_num.rawValue] as? String
        dptFiled?.text = dict[COOKEYS.dpt.rawValue] as? String
        dptNameFiled?.text = dict[COOKEYS.dpt_name.rawValue] as? String
        floorFiled?.text = dict[COOKEYS.floor.rawValue] as? String
        roomFiled?.text = dict[COOKEYS.room.rawValue] as? String
        midFiled?.text = dict[COOKEYS.building_mid.rawValue] as? String
        building_id = dict[COOKEYS.building_id.rawValue] as? Int
    }
    override func loadView() {
        super.loadView()
        dict = (delegate?.getCoockieValue())!
        self.isForInsert = dict[COOKEYS.building_edit_mode.rawValue] as! Int == BUILDING_EDIT_MODE.insert.rawValue
        if isForInsert == false{
            loadBuildingInfoToFileds()
        }
    }
    func isInputCorrect() -> Bool{
        return (bNoFiled?.text?.contains(" "))! || (bNoFiled?.text?.isEmpty)! ||
            (dptFiled?.text?.contains(" "))! || (dptFiled?.text?.isEmpty)! ||
            (dptNameFiled?.text?.contains(" "))! || (dptNameFiled?.text?.isEmpty)! ||
            (floorFiled?.text?.contains(" "))! || (floorFiled?.text?.isEmpty)! || (floorFiled?.text?.contains("층"))! == false ||
            (roomFiled?.text?.contains(" "))! || (roomFiled?.text?.isEmpty)! ||
            (midFiled?.text?.contains(" "))! || (midFiled?.text?.isEmpty)!
    }
    @IBAction func onSubmitBtn(_ sender: UIButton){
        if isInputCorrect() {
            alertShow(title: "내용을 입력해 주세요.")
            return
        }
        let numInput : String = (bNoFiled?.text)!
        
        if Int(numInput) != nil{
            let prebody:String = String(format: "%@=%@&%@=%@&%@=%@&%@=%@&%@=%@&%@=%@",
                                     COOKEYS.building_num.rawValue, (bNoFiled?.text)!,
                                     COOKEYS.dpt.rawValue, (dptFiled?.text)!,
                                     COOKEYS.dpt_name.rawValue, (dptNameFiled?.text)!,
                                     COOKEYS.floor.rawValue, (floorFiled?.text)!,
                                     COOKEYS.room.rawValue, (roomFiled?.text)!,
                                     COOKEYS.building_mid.rawValue, (midFiled?.text)!)
            if isForInsert{
                let body = prebody
                print("asd")
                insertNewBuildingInfoToServer(body: body)
            }else{
                let body = String(format:"%@&%@=%d", prebody,
                                  COOKEYS.building_id.rawValue, building_id!)
                print(body)
                editOldBuildingInfoToServer(body: body)
            }
        }else{
            alertShow(title: "잘못된 형식입니다.\n다시 입력해 주세요.")
        }
    }
    func insertNewBuildingInfoToServer(body: String){
        HttpHelper.Shared.Post(path: URLREQUEST.building_mg_insert.rawValue,
                               paras: body,
                               success: {
                                (result: String) in
                                DispatchQueue.main.async {
                                    print("insert successful")
                                }
                                self.gobackToListView()
        },
                               failure: { (err:String) in
                                DispatchQueue.main.async {
                                    print("failure")
                                }
                                self.gobackToListView()
        })
    }
    func gobackToListView(){
        DispatchQueue.main.async {
            [weak self] in
            let cls: AnyClass? = BuildingInfoMgmtViewController.self
            for controller: UIViewController in (self?.navigationController?.viewControllers)!{
                if controller.isKind(of: cls!){
                    self?.navigationController?.popToViewController(controller, animated: true)
                }
            }
        }
    }
    func editOldBuildingInfoToServer(body: String){
        HttpHelper.Shared.Post(path: URLREQUEST.building_mg_update.rawValue,
                               paras: body,
                               success: {
                                (result: String) in
                                DispatchQueue.main.async {
                                    print("insert successful")
                                }
                                self.gobackToListView()
        },
                               failure: { (err:String) in
                                DispatchQueue.main.async {
                                    print("failure")
                                }
                                self.gobackToListView()
        })
    }
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
