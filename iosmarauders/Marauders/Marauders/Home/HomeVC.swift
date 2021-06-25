//
//  HomeVC.swift
//  Marauders
//
//  Created by somsak on 28/1/2564 BE.
//

import UIKit

class HomeVC: BaseVC, HomeViewModelDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    
    private var viewModel: HomeViewModel!
    var latLongData = [0.0, 0.0]
    
    var timeline: [TimelineModel] = []

    override func viewDidLoad() {
        super.viewDidLoad()

        self.viewModel = HomeViewModel(view: self)
        
        self.fetchData()
    }
    
    func fetchData(){
        self.viewModel.register(latitude: self.latLongData[0], longitude: self.latLongData[1])
    }
    
    func didFinishFetchData(_ timeline: [TimelineModel]) {
        self.stopLoading()
        self.timeline.append(contentsOf: timeline)
        self.timeline.append(contentsOf: timeline)
        self.tableView.reloadData()
    }
}

extension HomeVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.timeline.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 555
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let timeLineCell = tableView.dequeueReusableCell(withIdentifier: "timeLineCell", for: indexPath) as! HomeTableViewCell
        
        timeLineCell.setView(timeline: self.timeline[indexPath.row])
        
        return timeLineCell
    }
}
