//
//  HomeViewController.swift
//  Observer-Pattern-Example
//
//  Created by Mac on 03/06/22.
//

import UIKit

class HomeViewController: UITableViewController {
    let userListObserver: UserListObserver = UserListObserver()
    override func viewDidLoad() {
        super.viewDidLoad()
        userListObserver.addObserver(observer: self)
    }
}

extension HomeViewController: NetworkObservable {
    func updateResult() {
        
    }
    
    func updateError() {
        
    }
}
