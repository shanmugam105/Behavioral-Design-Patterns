//
//  DetailsViewController.swift
//  Observer-Pattern-Example
//
//  Created by Mac on 05/06/22.
//

import UIKit

class DetailsViewController: UIViewController {
    @IBOutlet weak var nameLabel: UILabel!
    var name: String?
    override func viewDidLoad() {
        super.viewDidLoad()
        guard let name = name else { return }
        nameLabel.text = "Welcome \(String(describing: name))!"
    }
}
