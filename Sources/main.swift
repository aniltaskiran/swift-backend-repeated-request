//
//  main.swift
//  Perfect Repeater Demo
//
//  Created by Jonathan Guthrie on 2017-03-07.
//    Copyright (C) 2017 PerfectlySoft, Inc.
//
//===----------------------------------------------------------------------===//
//
// This source file is part of the Perfect.org open source project
//
// Copyright (c) 2015 - 20176 PerfectlySoft Inc. and the Perfect project authors
// Licensed under Apache License v2.0
//
// See http://perfect.org/licensing.html for license information
//
//===----------------------------------------------------------------------===//
//

import PerfectRepeater
import Foundation


let c = {
    () -> Bool in
    let url = URL(string: "http://188.166.48.177:8181/api/v1/repeatFunc")!
    var request = URLRequest(url: url)
    request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
    request.httpMethod = "POST"
    // prepare json data
    
    let json = ["as":"as"]
    
    let jsonData = try? JSONSerialization.data(withJSONObject: json)
    request.httpBody = jsonData
    
    let task = URLSession.shared.dataTask(with: request) { data, response, error in
        guard let data = data, error == nil else {                                                 // check for fundamental networking error
            print("error=\(String(describing: error))")
            return
        }
        
        if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {           // check for http errors
            print("statusCode should be 200, but is \(httpStatus.statusCode)")
            print("response = \(String(describing: response))")
        }
        
        let responseString = String(data: data, encoding: .utf8)
        print("responseString = \(String(describing: responseString))")
        
        do {
            guard let ResponseJson = try JSONSerialization.jsonObject(with: data, options: []) as? [String: AnyObject] else {
                print("error trying to convert data to JSON")
                return
            }
            print("The ResponseJson is: " + ResponseJson.description)
            
            guard let responseSuccess = ResponseJson["success"] as? Int else {
                print("Could not get ResponseJson from JSON")
                return
            }
            print("The ResponseJson is: ")
            print(responseSuccess)
        } catch  {
            print("error trying to convert data to JSON")
            return
        }
    }
    task.resume()
    return true
}


Repeater.exec(timer: 5.0, callback: c)

var shouldKeepRunning = true        // change this `false` to stop the application from running
let theRL = RunLoop.current         // Need a reference to the current run loop
while shouldKeepRunning && theRL.run(mode: .defaultRunLoopMode, before: .distantFuture) {  }

