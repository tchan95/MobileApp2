//
//  Config.swift
//  TeamProject
//
//  Created by apple11 on 2018. 6. 2..
//  Copyright © 2018년 COMP420. All rights reserved.
//

import Foundation
import UIKit
protocol ValueTransDelegate:class{
    func getCoockieValue() -> [String: AnyObject]
}
enum URLREQUEST: String{
    case login = "http://155.230.28.150:8081/login"
    case building_user = "http://155.230.28.150:8081/building_user"
    case building_mg = "http://155.230.28.150:8081/building_mg"
    case building_mg_delete = "http://155.230.28.150:8081/building_mg_delete"
    case building_mg_insert = "http://155.230.28.150:8081/building_mg_insert"
    case building_mg_update = "http://155.230.28.150:8081/building_mg_update"
    case reservation_check = "http://155.230.28.150:8081/reservation/check"
    case reservation_submit = "http://155.230.28.150:8081/reservation/insert"
    case reservation_cancel = "http://155.230.28.150:8081/reservation/cancel"
    case reservation_mg_get = "http://155.230.28.150:8081/reservation/mg/query"
    case reservation_mg_denied = "http://155.230.28.150:8081/reservation/mg/denied"
    case reservation_mg_permission = "http://155.230.28.150:8081/reservation/mg/permission"
}
enum SEGUEINDENTIFIER: String{
    case user_menu_theme = "userMenu"
    case 예약하기 = "예약하기"
    case 예약_현황_확인 = "예약 현황 확인"
    case calendar_theme = "CalendarTheme"
    case time_list_theme = "TimeListTheme"
    case reservation_submit_theme = "reservationSubmitTheme"
}
enum COOKEYS:String{
    case id = "id"
    case name = "NAME"
    case s_id = "S_ID"
    case usr_status = "state"
    case dpt = "DPT"
    case dpt_name = "DPT_NAME"
    case room = "ROOM"
    case date = "DATE"
    case start_time = "S_TIME"
    case end_time = "F_TIME"
    case rocate = "ROCATE"
    case period = "PERIOD"
    case reservation_state = "STATE"
    case reservation_no = "NUM"
    case building_id = "B_ID"
    case building_num = "B_NUM"
    case floor = "FLOOR"
    case building_edit_mode = "BUIDING_EDIT"
    case building_mid = "M_ID"
}
enum BUILDING_EDIT_MODE: Int{
    case insert = 0
    case edit = 1
}

enum LOGINRESPONSE: Int{
    case MANAGER = 1
    case USER = 0
}
enum HTTPRequestType{
    case GET
    case POST
}
enum USER_STATUS: String{
    case user = "user"
    case manager = "manager"
}
enum state: Int{
    case denied = -1
    case reservating = 0
    case permission = 1
}

