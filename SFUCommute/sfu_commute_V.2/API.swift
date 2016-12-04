//
//  API.swift
//  sfu_commute_V.2
//
//  Created by Tianxiong He on 2016-11-02.
//  Copyright © 2016 jyotsna jaswal. All rights reserved.
//

import Foundation
import Alamofire

enum API : URLRequestConvertible {
    
    static let baseURL = "http://54.69.64.180"
    
    case signUp(parameters: Parameters)
    case signIn(parameters: Parameters)
    case sendCodeMessage(parameters: Parameters)
    case verifyCodeMessage(code: String)
    case forgotPassword(parameters: Parameters)
    case ride(parameters: Parameters)
    case getRide(parameters: Parameters)
    case readRide(rideID: Int)
    case requestRide(rideID: Int)
    case deleteRide(rideID :Int)
    
    var method : HTTPMethod {
        switch self{
        case .signUp, .signIn:
            return .post
        case .sendCodeMessage:
            return .post
        case .verifyCodeMessage:
            return .get
        case .forgotPassword:
            return .post
        case .ride:
            return .post
        case .getRide:
            return .get
        case .readRide:
            return .get
        case .requestRide:
            return .put
        case .deleteRide:
            return .delete
        }
    }
    
    var path : String {
        switch self {
        case .signUp:
            return "/signup"
        case .signIn:
            return "/signin"
        case .sendCodeMessage:
            return "/verify/text"
        case .verifyCodeMessage:
            return "/verify/text"
        case .forgotPassword:
            return "/forgot"
        case .ride:
            return "/ride"
        case .getRide:
            return "/ride"
        case .readRide:
            return "/ride/"
        case .requestRide(let rideID):
            return "/ride/request/\(rideID)"   //I'm not too sure about these one
        case .deleteRide(let rideID):
            return "/ride/\(rideID)"
    
        }
    }

    func asURLRequest() throws -> URLRequest {
        let url = try API.baseURL.asURL()
        
        var urlRequest = URLRequest(url: url.appendingPathComponent(path))
        urlRequest.httpMethod = method.rawValue
        
        switch self {
        case .signUp(let parameters), .signIn(let parameters):
            urlRequest = try URLEncoding.default.encode(urlRequest, with: parameters)
        case .sendCodeMessage(let parameters):
            urlRequest = try URLEncoding.default.encode(urlRequest, with: parameters)
        case .verifyCodeMessage(let code):
            urlRequest = try URLEncoding.default.encode(urlRequest, with: ["code": code])
        case .forgotPassword(let parameters):
            urlRequest = try URLEncoding.default.encode(urlRequest, with: parameters)
        case .ride(let parameters):
            urlRequest = try URLEncoding.default.encode(urlRequest, with: parameters)
        case .getRide(let parameters):
            urlRequest = try URLEncoding.default.encode(urlRequest, with: parameters)
        case .readRide(let variable):
            urlRequest = try URLEncoding.default.encode(urlRequest, with: ["variable": variable]) // not sure about this one
        case .requestRide(let rideID):
            urlRequest = try URLEncoding.default.encode(urlRequest, with: ["rideid": rideID])
        case .deleteRide(let rideID):
            urlRequest = try URLEncoding.default.encode(urlRequest, with: ["rideid": rideID])
        default:
            break
        }
        return urlRequest
    }
}

class AccessTokenAdapter: RequestAdapter {
    private let accessToken: String
    
    init(accessToken: String) {
        self.accessToken = accessToken
    }
    
    func adapt(_ urlRequest: URLRequest) throws -> URLRequest {
        var urlRequest = urlRequest
        
        if urlRequest.url!.absoluteString.hasPrefix("http://54.69.64.180") {
            urlRequest.setValue(accessToken, forHTTPHeaderField: "Authorization")
        }
        
        return urlRequest
    }
}

let AuthorizedRequest = SessionManager()


