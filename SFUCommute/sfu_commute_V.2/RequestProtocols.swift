//
//  File.swift
//  sfu_commute_V.2
//
//  Created by jyotsna jaswal on 2016-10-22.
//  Copyright © 2016 jyotsna jaswal. All rights reserved.
//

/*
import Foundation

let url:URL = URL(string: "http://54.69.64.180/")!
var request = URLRequest(url: URL(string: "http://54.69.64.180/")!)
request.httpMethod = "POST"

let postString = "{"email": emailText , "password": passwordText}"
request.httpBody = postString.data(using: .utf8)
let task = URLSession.shared.dataTask(with: request) { data, response, error in
    guard let data = data, error == nil else {                                                 // check for fundamental networking error
        print("error=\(error)")
        return
    }

    if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {           // check for http errors
        print("statusCode should be 200, but is \(httpStatus.statusCode)")
        print("response = \(response)")
    }

    let responseString = String(data: data, encoding: .utf8)
    print("responseString = \(responseString)")
}
task.resume()

 */
