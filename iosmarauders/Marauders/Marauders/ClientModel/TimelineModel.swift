//
//  TimelineModel.swift
//  Marauders
//
//  Created by somsak on 22/1/2564 BE.
//

import Foundation

class TimelineModel {
    var userID, profile, name, location, caption, time, distance, image: String
    var latitude, longitude : Double
    
    init(userID: String, profile: String, name: String, location: String, image: String, caption: String, time: String, distance: String, latitude: Double, longitude: Double) {
        self.userID = userID
        self.profile = profile
        self.name = name
        self.location = location
        self.image = image
        self.caption = caption
        self.time = time
        self.distance = distance
        self.latitude = latitude
        self.longitude = longitude
    }
}
