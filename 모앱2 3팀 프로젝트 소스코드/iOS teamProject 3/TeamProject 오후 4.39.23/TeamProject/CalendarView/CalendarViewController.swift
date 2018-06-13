//
//  CalendarViewController.swift
//  TeamProject
//
//  Created by apple11 on 2018. 6. 1..
//  Copyright © 2018년 COMP420. All rights reserved.
//

import UIKit
enum MyTheme {
    case light
    case dark
}
class CalendarViewController: UIViewController,CalendarViewCellDelegate, ValueTransDelegate {
    func onClickCell(with indentifier: String ,_ sender : Any?) {
        performSegue(withIdentifier: indentifier, sender: sender)
    }
    
    func getCoockieValue() -> [String : AnyObject] {
        var value = delegate?.getCoockieValue()
        value!["DATE"] = String(format:"%4d-%02d-%02d",self.calenderView.currentYear, self.calenderView.currentMonthIndex, self.calenderView.selectedDay) as AnyObject
        return value!
    }
    
    var theme = MyTheme.light
    var delegate : ValueTransDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "날짜 선택"
        self.navigationController?.navigationBar.isTranslucent=false
        self.view.backgroundColor=Style.bgColor
        
        view.addSubview(calenderView)
        calenderView.topAnchor.constraint(equalTo: view.topAnchor, constant: 10).isActive=true
        calenderView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -12).isActive=true
        calenderView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 12).isActive=true
        calenderView.heightAnchor.constraint(equalToConstant: 365).isActive=true
        calenderView.clickDelegate = self
        let rightBarBtn = UIBarButtonItem(title: "Dark", style: .plain, target: self, action: #selector(rightBarBtnAction))
        self.navigationItem.rightBarButtonItem = rightBarBtn
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        calenderView.myCollectionView.collectionViewLayout.invalidateLayout()
    }
    
    @objc func rightBarBtnAction(sender: UIBarButtonItem) {
        if theme == .dark {
            sender.title = "Dark"
            theme = .light
            Style.themeLight()
        } else {
            sender.title = "Light"
            theme = .dark
            Style.themeDark()
        }
        self.view.backgroundColor=Style.bgColor
        calenderView.changeTheme()
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?){
        let controller = segue.destination as! TimeViewController
        controller.delegate = self
    }
    let calenderView: CalenderView = {
        let v=CalenderView(theme: MyTheme.light)
        v.translatesAutoresizingMaskIntoConstraints=false
        return v
    }()
    
}
