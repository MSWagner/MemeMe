//
//  DetailVC.swift
//  MemeMe
//
//  Created by Matthias Wagner on 04.12.17.
//  Copyright © 2017 Michael Wagner. All rights reserved.
//

import UIKit

class DetailVC: UIViewController {

    // MARK: - IBOutlet Properties
    @IBOutlet weak var imageView: UIImageView!

    // MARK: - Image Propertie
    var image: UIImage?

    // MARK: - Lifecycle Functions
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.barTintColor = UIColor.white
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.tabBar.isHidden = true

        if let image = image {
            imageView.image = image
        } else {
            print("No Image There")
        }
    }

    override func viewDidDisappear(_ animated: Bool) {
        tabBarController?.tabBar.isHidden = false
    }
}
