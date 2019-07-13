//
//  AuthModel.swift
//  On The Map
//
// Copyright © 2019 AH Abdalah. All rights reserved.

import Foundation

struct AuthModel: Codable {
    let session: Session?
    let account: Account?
}

struct Session: Codable {
    let expiration: String?
    let id: String?
}

struct Account: Codable {
    let key: String?
    let registered: Bool?
}
