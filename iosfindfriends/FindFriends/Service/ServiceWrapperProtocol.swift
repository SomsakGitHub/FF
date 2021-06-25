//
//  ServiceWrapperProtocol.swift
//  FindFriends
//
//  Created by somsak.kaeworasan on 9/1/2564 BE.
//

import Foundation
import Alamofire
import SwiftyJSON

protocol ServiceWrapperProtocol {
    func serviceResponse(request: URLRequest, completion: @escaping (Data?,statusWebService) -> Void)
}
