//
//  Data.swift
//  ScoutsArduIOS
//
//  Created by Lucas Vermeulen on 12/11/2019.
//  Copyright © 2019 Lucas Vermeulen. All rights reserved.
//

import Foundation
import Alamofire
import FacebookCore
import FacebookLogin


class DataController {
    var bearerToken: String = ""
    var userIsAuthenticated = false
    var baseUrl = "https://scoutsarduapinew.azurewebsites.net"
    var gebruiker: Gebruiker!
    static let shared = DataController()
    var myHistoryOpgehaald: Bool = false
    var stamHistoryOpgehaald: Bool = false
    var myHistory: [Winkelwagen] = []
    var stamHistory: [Winkelwagen] = []
    var loginManager = LoginManager()

    private init() { }

    func loginUser(email: String, password: String, completion: @escaping(Bool) -> Void) {
       let parameters: [String: String] = [
            "email": email,
            "password": password
        ]

        let headers: HTTPHeaders = [
            "Accept": "application/json",
            "Content-Type": "application/json"
        ]

        AF.request(baseUrl + "/api/Account/login", method: .post,
            parameters: parameters, encoder: JSONParameterEncoder.default, headers: headers)
            .validate(statusCode: 200..<300)
            .responseJSON { response in
                switch response.result {
                case let .success(bToken):
                    let stringToken: String = bToken as! String
                    self.bearerToken = "bearer " + stringToken
                    self.userIsAuthenticated = true
                    completion(true)
                    self.getLoggedInUser { (gbr) in
                        self.gebruiker = gbr
                    }
                case let .failure(error):
                    print(response)
                    print(response.result)
                    print(error)
                    completion(false)
                }
        }

    }
    
    func loginFacebookUser(email: String, voornaam: String, achternaam:String, completion: @escaping(Bool) -> Void) {
       let parameters: [String: String] = [
            "email": email,
            "voornaam": voornaam,
            "achternaam": achternaam
        ]

        let headers: HTTPHeaders = [
            "Accept": "application/json",
            "Content-Type": "application/json"
        ]

        AF.request(baseUrl + "/api/Account/facebooklogin", method: .post,
            parameters: parameters, encoder: JSONParameterEncoder.default, headers: headers)
            .validate(statusCode: 200..<300)
            .responseJSON { response in
                switch response.result {
                case let .success(bToken):
                    let stringToken: String = bToken as! String
                    self.bearerToken = "bearer " + stringToken
                    self.userIsAuthenticated = true
                    self.getLoggedInUser { (gbr) in
                        self.gebruiker = gbr
                        completion(true)
                    }
                case let .failure(error):
                    print(error)
                    completion(false)
                }
        }

    }


    func registerUser(email: String,
                  password: String,
                  voornaam: String,
                  achternaam: String,
                  passwordConfirmation: String,
                  telNr: String,
                  completion: @escaping(Bool) -> Void) {
    let parameters: [String: String] = [
        "email": email,
        "password": password,
        "voornaam": voornaam,
        "achternaam": achternaam,
        "passwordConfirmation": password,
        "foto": "string",
        "telNr": telNr,
        "type": "1"
    ]
        let headers: HTTPHeaders = [
            "Accept": "application/json",
            "Content-Type": "application/json"
        ]

        AF.request(baseUrl + "/api/Account/register", method: .post,
            parameters: parameters, encoder: JSONParameterEncoder.default, headers: headers)
            .validate(statusCode: 200..<300)
            .responseJSON { response in
                switch response.result {
                case let .success(bToken):
                    let stringToken: String = bToken as! String
                    self.bearerToken = "bearer " + stringToken
                    self.userIsAuthenticated = true
                    self.getLoggedInUser { (gbr) in
                        self.gebruiker = gbr
                        completion(true)
                    }
                case let .failure(error):
                    print(error)
                    completion(false)
                }
        }

    }

    func getWinkelwagenItems(completion: @escaping([WinkelwagenItemAantal]) -> Void) {
        let url = URL(string: baseUrl + "/api/Winkelwagen/WinkelwagenItems")!
        let task = URLSession.shared.dataTask(with: url) {
            (data: Data?, response: URLResponse?, error: Error?) in
            let jsonDecoder = JSONDecoder()
            if let data = data {
                let winkelwagenItem = try?
                jsonDecoder.decode([WinkelwagenItem].self, from: data)
                var winkelwagenItemAantal: [WinkelwagenItemAantal] = []
                for item in winkelwagenItem! {
                    let wia = WinkelwagenItemAantal(id: item.id, aantal: 0, item: item)
                    winkelwagenItemAantal.append(wia)
                }
                completion(winkelwagenItemAantal)
            }
        }
        task.resume()
    }

    func GetWinkelwagensOfGebruiker(completion: @escaping([Winkelwagen]) -> Void) {
        let url = URL(string: baseUrl + "/api/Winkelwagen/winkelwagens")!
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue(bearerToken, forHTTPHeaderField: "Authorization")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        let task = URLSession.shared.dataTask(with: request) {
            (data: Data?, response: URLResponse?, error: Error?) in
            let jsonDecoder = JSONDecoder()
            if let data = data {
                let winkelwagens = try? jsonDecoder.decode([Winkelwagen].self, from: data)
                completion(winkelwagens!)
            }
        }
        task.resume()
    }

    func GetWinkelwagensOfAllUsers(completion: @escaping([Winkelwagen]) -> Void) {
        let url = URL(string: baseUrl + "/api/Winkelwagen/stamhistoriek")!
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue(bearerToken, forHTTPHeaderField: "Authorization")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        let task = URLSession.shared.dataTask(with: request) {
            (data: Data?, response: URLResponse?, error: Error?) in
            let jsonDecoder = JSONDecoder()
            if let data = data {
                let winkelwagens = try? jsonDecoder.decode([Winkelwagen].self, from: data)
                completion(winkelwagens!)
            }
        }
        task.resume()
    }

    func getLoggedInUser(completion: @escaping(Gebruiker) -> Void) {
        if let gbr = gebruiker {
            completion(gbr)
        } else {
            let url = URL(string: baseUrl + "/api/Account/")!
            var request = URLRequest(url: url)
            request.httpMethod = "GET"
            request.setValue(bearerToken, forHTTPHeaderField: "Authorization")
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            request.addValue("application/json", forHTTPHeaderField: "Accept")
            let task = URLSession.shared.dataTask(with: request) {
                (data: Data?, response: URLResponse?, error: Error?) in
                let jsonDecoder = JSONDecoder()
                if let data = data {
                    let gebruiker = try?
                    jsonDecoder.decode(Gebruiker.self, from: data)
                    completion(gebruiker!)
                }
            }
            task.resume()
        }
    }

    func postWinkelwagen(winkelwagen: Winkelwagen, completion: @escaping(Winkelwagen) -> Void) {
        let url = URL(string: baseUrl + "/api/Winkelwagen/")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        let jsonData = try? JSONSerialization.data(withJSONObject: winkelwagen.short)
        request.httpBody = jsonData
        request.setValue(bearerToken, forHTTPHeaderField: "Authorization")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        let task = URLSession.shared.dataTask(with: request) {
            (data: Data?, response: URLResponse?, error: Error?) in
            let jsonDecoder = JSONDecoder()
                 if let data = data {
                        let winkelwagen = try? jsonDecoder.decode(Winkelwagen.self, from: data)
                        completion(winkelwagen!)
                           }
            
        }
        task.resume()
    }

   func putGebruiker(voornaam: String, achternaam: String, telnr: String, completion: @escaping(Bool) -> Void) {
    let urlwithData = "/api/Account"
    let data: [String: String] = [
               "voornaam": voornaam,
               "achternaam": achternaam,
               "telnr": telnr,
           ]
    let jsonData = try? JSONSerialization.data(withJSONObject: data)
    let url = URL(string: baseUrl + urlwithData)!
    var request = URLRequest(url: url)
    request.httpBody = jsonData
    request.httpMethod = "PUT"
        request.setValue(bearerToken, forHTTPHeaderField: "Authorization")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        let task = URLSession.shared.dataTask(with: request) {
            (data: Data?, response: URLResponse?, error: Error?) in
            let jsonDecoder = JSONDecoder()
            if let httpResponse = response as? HTTPURLResponse {
                   print(httpResponse.statusCode)
               }
            if data != nil {
                let gebruiker = try?
                    jsonDecoder.decode(Gebruiker.self, from: data!)
                self.gebruiker = gebruiker
                completion(true)
            }        }
        task.resume()
        
    }





}
