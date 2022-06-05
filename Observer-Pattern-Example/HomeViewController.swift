//
//  HomeViewController.swift
//  Observer-Pattern-Example
//
//  Created by Mac on 03/06/22.
//

import UIKit

class HomeViewController: UITableViewController {

    let userListObserver: UserListObserver = .shared
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
    }
    
    private func configureView() {
        title = "Users"
        // Subscription
        userListObserver.addObserver(observer: self)
        // Business logic
        userListObserver.getUserList()
    }
}

extension HomeViewController: UserDetailsObservable {
    func updateResult() {
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    func updateError(error: Error) {
        present(error)
    }
}

extension HomeViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        userListObserver.users?.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.textLabel?.text = userListObserver.users?[indexPath.row].name
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "DetailsViewController") as! DetailsViewController
        vc.name = userListObserver.users?[indexPath.row].name
        navigationController?.pushViewController(vc, animated: true)
    }
}
