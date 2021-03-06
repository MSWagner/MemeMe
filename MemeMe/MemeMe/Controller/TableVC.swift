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

    private var selectedImage: UIImage?

    // MARK: - Lifecycle Functions
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.tableFooterView = UIView()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }

    // MARK: - Navigation Functions
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "SegueFromTableToDetailVC") {
            let detailVC = segue.destination as! DetailVC
            if let image = selectedImage {
                detailVC.image = image
            }
        }
    }
}

// MARK: UITableviewDataSource
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

// MARK: - UITableviewDelegate
extension TableVC {
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }

    override func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        selectedImage = memes[indexPath.row].memeImage
        return indexPath
    }
   
}
