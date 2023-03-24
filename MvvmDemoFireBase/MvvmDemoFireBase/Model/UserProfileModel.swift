//
//  UserProfileModel.swift
//  MvvmDemoFireBase
//
//  Created by mac on 03/11/22.
//

import Foundation

protocol Convertable: Codable {}

struct UserProfileModel: Convertable {
    let name: String?
    let email: String?
    let id: String?
}
