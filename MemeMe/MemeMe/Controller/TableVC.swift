//
//  tableVC.swift
//  MemeMe
//
//  Created by Matthias Wagner on 03.12.17.
//  Copyright © 2017 Michael Wagner. All rights reserved.
//

import UIKit

class TableVC: UITableViewController {

    // MARK: - Meme Propertie
    private lazy var memes: [Meme] = {
        return (UIApplication.shared.delegate as! AppDelegate).memes
    }()

    // MARK: - Lifecycle Functions
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    // MARK: - Tableview Datasource
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return memes.count
    }
}
