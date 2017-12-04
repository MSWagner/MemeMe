//
//  tableVC.swift
//  MemeMe
//
//  Created by Matthias Wagner on 03.12.17.
//  Copyright © 2017 Michael Wagner. All rights reserved.
//

import UIKit

class TableVC: UITableViewController {

    // MARK: - TableView Properties
    private let reuseIdentifier = "MemeTableCell"

    // MARK: - Meme Propertie
    private var memes: [Meme] {
        return (UIApplication.shared.delegate as! AppDelegate).memes
    }

    // MARK: - Lifecycle Functions
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.tableFooterView = UIView()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }
}

// MARK: UITableview DataSource
extension TableVC {
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return memes.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! MemeTableCell

        cell.memeImage.image = memes[indexPath.row].memeImage
        cell.topLabel.text = memes[indexPath.row].topText
        cell.bottomLabel.text = memes[indexPath.row].bottomText

        return cell
    }
}

// MARK: - UITableview Delegates
extension TableVC {
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
}
