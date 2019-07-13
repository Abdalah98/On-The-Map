//
//  appConstants.swift
//  On The Map
//
//
//

import Foundation

struct EndPointURL {
    static let auth = "https://onthemap-api.udacity.com/v1/session"
    static let studentLocation = "https://onthemap-api.udacity.com/v1/StudentLocation?order=-updatedAt"
    
   static let studentLocationLimit = "https://onthemap-api.udacity.com/v1/StudentLocation?order=-updatedAt&limit=100"
    
    static let user = "https://www.udacity.com/api/users/"
}

