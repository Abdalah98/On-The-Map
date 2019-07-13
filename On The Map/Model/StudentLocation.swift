//
//  StudentLocation.swift
//  On The Map
//
// Copyright © 2019 AH Abdalah. All rights reserved.


import Foundation

struct StudentLocation: Codable {
    let results: [LocationModel]?
}

struct LocationModel : Codable {
    let objectId : String?
    let mediaURL : String?
    let firstName : String?
    let lastName : String?
    let longitude : Double?
    let latitude : Double?
}
