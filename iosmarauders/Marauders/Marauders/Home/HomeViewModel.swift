//
//  HomeViewModel.swift
//  Marauders
//
//  Created by somsak on 22/1/2564 BE.
//

import Foundation
import Alamofire
import SwiftyJSON
import CryptoSwift

protocol HomeViewModelDelegate {
    func didFinishFetchData(_ timeline: [TimelineModel])
}

class HomeViewModel{

    private var homeViewModelDelegate: HomeViewModelDelegate?

    init(view: HomeViewModelDelegate) {
        self.homeViewModelDelegate = view
    }
    
    var response: [TimelineModel] = [] {
        didSet {
            self.homeViewModelDelegate?.didFinishFetchData(response)
        }
    }
    
    func register(latitude: Double, longitude: Double){
        
//        let WebServiceURLTimeLine = "http://192.168.2.227:8080/timeLine/\(latitude)&\(longitude)"
////        let WebServiceURLTimeLine = "http://192.168.2.227:8080/timeLine"
//
////        var urlRequest = URLRequest(url:  URL(string: WebServiceURLTimeLine.addingPercentEncoding(withAllowedCharacters:  CharacterSet.urlQueryAllowed)!)!)
//
//        let service = ServiceWrapper()
//        var urlRequest = URLRequest(url:  URL(string: WebServiceURLTimeLine)!)
//
//        urlRequest.httpMethod = HTTPMethod.get.rawValue
//        urlRequest.timeoutInterval = 10 // secs
//
//        service.serviceResponse(request: urlRequest) { (response, status) in
////            print("response", response)
//            if status == .success {
//                let json: JSON = JSON(response as Any)
//
//                var timeline: [TimelineModel] = []
//
//                for index in json.arrayValue{
//                    timeline.append(TimelineModel(
//                        userID: index["user_id"].stringValue,
//                        location: index["location"].stringValue,
//                        image: index["image"].stringValue,
//                        caption: index["caption"].stringValue,
//                        latitude: index["latitude"].doubleValue,
//                        longitude: index["longitude"].doubleValue
//                    ))
//                }
//                self.response = timeline
//            }
//        }
        
        var timeline: [TimelineModel] = []
        timeline.append(TimelineModel(
                            userID: "1111",
                            profile: "https://notebookspec.com/web/wp-content/uploads/2020/12/google-image-search-1.png",
                            name: "somsak",
                            location: "banyang",
                            image: "https://notebookspec.com/web/wp-content/uploads/2020/12/google-image-search-1.png",
                            caption: "i'm happy",
                            time: "12.35",
                            distance: "1",
                            latitude: 2222.2,
                            longitude: 3333.3)
        )
        
        self.response = timeline
    }
}

