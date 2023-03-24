//
//  MoyaManager.swift
//  MvvmDemoFireBase
//
//  Created by mac on 19/11/22.
//

import UIKit
import Moya

//MARK: - API key: - adf1d5885c5b42cbae8f0a95f84b83a9

enum Demo {
    case Everything(q: String, from: String, sortBy: String, apiKey: String)
}

extension Demo: TargetType {
    var baseURL: URL {
        return URL(string: "https://newsapi.org/v2")!
    }
    
    var path: String {
        switch self {
        case .Everything:
            return "/everything"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .Everything:
            return .get
        }
    }
    
    var task: Task {
        switch self {
        case .Everything(let q, let from, let sortBy, let apiKey):
            return .requestParameters(parameters: ["q":q, "from": from, "sortBy": sortBy, "apiKey": apiKey], encoding: URLEncoding.queryString)
        }
    }
    
    var headers: [String : String]? {
        switch self {
        case .Everything:
            return ["Content-Type": "application/json"]
        }
    }
    
    
}
