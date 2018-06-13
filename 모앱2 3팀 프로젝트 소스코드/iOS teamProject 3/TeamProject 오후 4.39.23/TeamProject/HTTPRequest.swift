//
//  HTTPRequest.swift
//  TeamProject
//
//  Created by apple11 on 2018. 6. 3..
//  Copyright © 2018년 COMP420. All rights reserved.
//

import Foundation
public class HttpHelper{
    public static var Shared = HttpHelper();
    func Get(path: String, success: @escaping ((_ result: String) ->()),failure: @escaping ((_ error: String) ->())){
        let url = URL(string: path.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!)
        let session = URLSession.shared
        let dataTask = session.dataTask(with: url!){
            (data, response, error) in
            if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {
                failure("error : not 200")
                return
            }
            if let data = data {
                if let result = String(data: data, encoding: .utf8){
                    success(result)
                }else{
                    failure("\(error)")
                }
            }
        }
        dataTask.resume()
    }

    func Post(path: String, paras: String, success: @escaping ((_ result: String) -> ()), failure: @escaping ((_ error: String) -> ())){
        let url = URL(string: path)
        var request = URLRequest.init(url: url!)
        request.httpMethod = "POST"
        request.httpBody = paras.data(using: .utf8)
        print(request.httpBody!)
        let session = URLSession.shared
        let dataTask = session.dataTask(with: request){
            (data, respond, error) in
            if let httpStatus = respond as? HTTPURLResponse, httpStatus.statusCode != 200 {
                failure("error")
                return
            }
            if let data = data{
                if let result = String(data: data, encoding: .utf8){
                    success(result)
                }
            }else{
                failure("error")
            }
        }
        dataTask.resume()
    }
    func jsonObjectWithData(data:Data) -> NSDictionary?{
        var dict : NSDictionary? = nil
        do{
            let jsonObject = try JSONSerialization.jsonObject(with: data, options:JSONSerialization.ReadingOptions.allowFragments)
            dict = jsonObject as? NSDictionary
            print("The received data with json: \(dict)")
        }catch{
            print("server call back data, convers error:\(error)")
        }
        return dict
    }
}
class JsonHelper{
    static let Shared = JsonHelper()
    private let decoder = JSONDecoder()
    private let encoder = JSONEncoder()
    
    func ToJson<T: Codable> (_ obj: T) -> String{
        let data = try! self.encoder.encode(obj)
        let str = String(data: data, encoding:. utf8)!
        return str
    }
    func ToObject<T:Codable>(_ data: String) -> T{
        let obj = try! self.decoder.decode(T.self, from: data.data(using:.utf8)!)
        return obj
    }
    func GetData(_ str: String) -> Data{
        return str.data(using: .utf8)!
    }
    func GetJson(_ data: Data) -> String{
        return String(data: data, encoding: .utf8)!
    }
}
extension String{
    func toDictionary() -> [String:AnyObject]?{
        if !self.isEmpty{
            guard let data = self.data(using: .utf8) else { return nil}
            do{
                if let dictionary = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.allowFragments) as? [String: AnyObject]{
                    print(dictionary)
                    return dictionary
                }
            }catch{
                print("bulding json: ", error)
            }
        }
        return nil
    }
}
