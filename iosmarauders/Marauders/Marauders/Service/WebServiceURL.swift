//
//  WebServiceURL.swift
//  Marauders
//
//  Created by somsak on 22/1/2564 BE.
//

import Foundation

class WebServiceURL {
    
    static let rootURL = "http://127.0.0.1:3000"
    
    //Service list.
    static var authentication = "\(rootURL)/user/authentication"
    static var register = "\(rootURL)/user/register"
    static var forgotPassword = "\(rootURL)/user/forgotPassword"
    static var login = "\(rootURL)/user/login"
    static var timeLine = "\(rootURL)/timeLine"
}
