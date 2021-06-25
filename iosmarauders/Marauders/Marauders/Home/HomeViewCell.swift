//
//  HomeTableViewCell.swift
//  Marauders
//
//  Created by somsak on 22/1/2564 BE.
//

import Foundation
import UIKit

class HomeTableViewCell: UITableViewCell {
    
//    @IBOutlet private weak var collectionView: UICollectionView!
    
    @IBOutlet weak var profileImage: ImageIBDesignable!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var captionLabel: UILabel!
    @IBOutlet weak var postImageView: UIImageView!
//    @IBOutlet weak var imageCollectionView: UICollectionView!
    
    var timelineModel: TimelineModel? = nil
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setView(timeline: TimelineModel){
//        let base64EncodedString = timeline.image // Your Base64 Encoded String
//        if let imageData = Data(base64Encoded: base64EncodedString) {
//            let image = UIImage(data: imageData)
//            self.profileImage.image = image
//            self.postImage.image = image
//        }
        
        self.timelineModel = timeline
        
        self.nameLabel.text = timeline.name
        self.locationLabel.text = timeline.location
        self.timeLabel.text = timeline.time
        self.distanceLabel.text = "\(timeline.distance) k"
        self.captionLabel.text = timeline.caption
        
        // Create URL
        let url = URL(string: timeline.image)!
        
        // Fetch Image Data
        if let data = try? Data(contentsOf: url) {
            // Create Image and Update Image View
            self.profileImage.image = UIImage(data: data)
            self.postImageView.image = UIImage(data: data)
        }
    }
}

//extension HomeTableViewCell: UICollectionViewDelegate, UICollectionViewDataSource {
//    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        return 10
//    }
//
//    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//
//        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "imageCell", for: indexPath) as! HomeCollectionViewCell
//
//        cell.setImage(image: self.timelineModel!.image)
//
//        return cell
//    }
//}
//
//class HomeCollectionViewCell: UICollectionViewCell {
//
//    @IBOutlet weak var imageView: UIImageView!
//
//    func setImage(image: String){
//        // Create URL
//            let url = URL(string: image)!
//
//            // Fetch Image Data
//            if let data = try? Data(contentsOf: url) {
//                // Create Image and Update Image View
//                self.imageView.image = UIImage(data: data)
////                self.postImage.image = UIImage(data: data)
//            }
//    }
//}

