//
//  CollectionVC.swift
//  MemeMe
//
//  Created by Matthias Wagner on 03.12.17.
//  Copyright © 2017 Michael Wagner. All rights reserved.
//

import UIKit

class CollectionVC: UICollectionViewController {

    // MARK: - CollectionView Properties
    private let reuseIdentifier = "MemeCollectionCell"
    private let itemsPerRow: CGFloat = 3
    private let sectionInsets = UIEdgeInsets(top: 10.0, left: 10.0, bottom: 10.0, right: 10.0)

    private var memes: [Meme] {
        return (UIApplication.shared.delegate as! AppDelegate).memes
    }

    private var selectedImage: UIImage?

    // MARK: - Lifecycle Functions
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        collectionView?.reloadData()
    }

    // MARK: - Navigation Functions
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "SegueFromCollectionToDetailVC") {
            let detailVC = segue.destination as! DetailVC
            if let image = selectedImage {
                detailVC.image = image
            }
        }
    }
}

// MARK: UICollectionView DataSource
extension CollectionVC {
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return memes.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! MemeCollectionCell

        cell.memeImage.image = memes[indexPath.row].memeImage
        return cell
    }
}

// MARK: - UICollectionView DelegateFlowLayout
extension CollectionVC : UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {

        let paddingSpace = sectionInsets.left * (itemsPerRow + 1)
        let availableWidth = view.frame.width - paddingSpace
        let widthPerItem = availableWidth / itemsPerRow

        return CGSize(width: widthPerItem, height: widthPerItem)
    }

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        return sectionInsets
    }

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return sectionInsets.left
    }

    override func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        selectedImage = memes[indexPath.row].memeImage
        return true
    }
}
