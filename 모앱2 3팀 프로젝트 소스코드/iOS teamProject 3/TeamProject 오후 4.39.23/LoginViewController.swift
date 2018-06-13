//
//  LoginViewController.swift
//  TeamProject
//
//  Created by apple11 on 2018. 5. 30..
//  Copyright © 2018년 COMP420. All rights reserved.
//

import UIKit
import SwiftyJSON
class LoginViewController: UIViewController, ValueTransDelegate {
    func getCoockieValue() -> [String : AnyObject] {
        return self.dict
    }
    
    var dict : [String: AnyObject] = [:]
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    @IBOutlet weak var idTextView : UITextField!
    @IBOutlet weak var pwTextView : UITextField!
    @IBAction func onLoginBtn(_ sender : UIButton){
        let id = idTextView.text ?? ""
        let pw = pwTextView.text ?? ""
        let body = "id=\(id)&pw=\(pw)"
        if id.isEmpty || pw.isEmpty{
            var alert: UIAlertController!
            alert = UIAlertController.init(title: "ERROR", message: "아이디와 비밀번호를 입력해주세요.", preferredStyle: UIAlertControllerStyle.alert)
            let cancelAction = UIAlertAction.init(title: "cancel", style: UIAlertActionStyle.cancel) { (action:UIAlertAction) in
                print("[+] LOGIN : 력")
            }
            alert.addAction(cancelAction)
            self.present(alert, animated: true, completion: nil)
            return
        }
        var state = -1
        self.spinner.startAnimating()
        HttpHelper.Shared.Post(path: URLREQUEST.login.rawValue,
                               paras: body,
                               success: {
                                (result : String) in
                                DispatchQueue.main.async {
                                    self.spinner.stopAnimating()
                                }
                                let data = result.data(using:.utf8)!

                                do{
                                    if let json = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.allowFragments) as? [Dictionary<String, Any>]{
                                        self.dict[COOKEYS.id.rawValue] = id as AnyObject
                                        self.dict[COOKEYS.name.rawValue] = json[0][COOKEYS.name.rawValue] as AnyObject
                                        self.dict[COOKEYS.s_id.rawValue] = json[0][COOKEYS.s_id.rawValue] as AnyObject
                                        state = json[0][COOKEYS.usr_status.rawValue] as! Int
                                        DispatchQueue.main.async {
                                            if state == 0{
                                                self.dict[COOKEYS.usr_status.rawValue] = USER_STATUS.user.rawValue as AnyObject
                                                print(USER_STATUS.user.rawValue)
                                            }else{
                                                self.dict[COOKEYS.usr_status.rawValue] = USER_STATUS.manager.rawValue as AnyObject
                                                print(USER_STATUS.manager.rawValue)
                                            }
                                            self.idTextView.text = ""
                                            self.pwTextView.text = ""
                                            self.performSegue(withIdentifier: SEGUEINDENTIFIER.user_menu_theme.rawValue, sender: sender)
                                        }
                                    }else{
                                        print("error!")
                                    }
                                }catch let err as NSError{
                                    print(err)
                                }
        },
                               failure: {
                                (error: String) in
                                DispatchQueue.main.async {
                                    self.spinner.stopAnimating()
                                    var alert: UIAlertController!
                                    alert = UIAlertController.init(title: "ERROR", message: "아이디와 비밀번호를 확인해주세요.", preferredStyle: UIAlertControllerStyle.alert)
                                    let cancelAction = UIAlertAction.init(title: "cancel", style: UIAlertActionStyle.cancel) { (action:UIAlertAction) in
                                        print("[+] LOGIN : ERROR")
                                    }
                                    alert.addAction(cancelAction)
                                    self.present(alert, animated: true, completion: nil)
                                }
                                print("failure")

        })
        // multithread async
    }
    // MARK: - Navigation
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "userMenu"{
            print("go")
            let controller = segue.destination as! MenuViewController
            controller.delegate = self
        }
    }
}
extension LoginViewController{
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool{
        if self.isInputRuleAndBlank(str: string) || string == ""{
            return true
        }else{
            return false
        }
    }
    func isInputRuleAndBlank(str: String) -> Bool{
        let pattern = "^[a-zA-Z\\u4E00-\\u9FA5\\d\\s]*$"
        let pred = NSPredicate(format:"SELF MATCHES %@", pattern)
        let isMatch = pred.evaluate(with: str)
        return isMatch
    }
    func getSubString(str: String) -> String{
        if str.characters.count > 15{
            return str[0..<(15)]
        }
        return str
    }
    func disable_emoji(str:String)->String{
        let regex = try!NSRegularExpression.init(pattern: "[^\\u0020-\\u007E\\u00A0-\\u00BE\\u2E80-\\uA4CF\\uF900-\\uFAFF\\uFE30-\\uFE4F\\uFF00-\\uFFEF\\u0080-\\u009F\\u2000-\\u201f\r\n]", options: .caseInsensitive)
        
        let modifiedString = regex.stringByReplacingMatches(in: str, options: NSRegularExpression.MatchingOptions(rawValue: 0), range: NSRange.init(location: 0, length: str.characters.count), withTemplate: "")
        return modifiedString
    }
}
extension String{
    subscript(r: Range<Int>)->String{
        get{
            let startIndex = self.index(self.startIndex, offsetBy: r.lowerBound)
            let endIndex = self.index(self.startIndex, offsetBy: r.upperBound)
            return  String(self[Range(startIndex..<endIndex)])
        }
    }
}
class BuildLoginInfoModel:Codable{
    init(id: String, pw:String){
        self.id = id
        self.pw = pw
    }
    required init(from decoder: Decoder) throws{
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(String.self, forKey: .id)
        pw = try container.decode(String.self, forKey: .pw)
    }
    var id : String?
    var pw : String?
    enum CodingKeys: String, CodingKey{
        case id
        case pw
    }
}
extension BuildLoginInfoModel{
    func encode(to encoder: Encoder) throws{
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(pw, forKey: .pw)
    }
}
