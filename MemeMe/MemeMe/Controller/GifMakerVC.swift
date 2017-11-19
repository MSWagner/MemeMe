//
//  ViewController.swift
//  MemeMe
//
//  Created by Matthias Wagner on 16.11.17.
//  Copyright © 2017 Michael Wagner. All rights reserved.
//

import UIKit

class GifMakerVC: UIViewController {
    // MARK: - Top Bar Outlets
    @IBOutlet weak var titleLabel: UILabel!

    // MARK: - Image View Outlets
    @IBOutlet weak var topLabel: UILabel!
    @IBOutlet weak var bottomLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var placeholderImage: UIImageView!

    // MARK: - Bottom Bar Outlets
    @IBOutlet weak var cameraButton: UIBarButtonItem!
    @IBOutlet weak var albumButton: UIBarButtonItem!

    // MARK: - Lifecycle Functions
    override func viewDidLoad() {
        super.viewDidLoad()
        proveImageSources()
    }

    // MARK: - Image Picker Functions
    @IBAction func onCamera(_ sender: Any) {
        let picker = preparePicker(srcType: .camera)
        self.present(picker, animated: true, completion: nil)
    }

    @IBAction func onAlbum(_ sender: Any) {
        let picker = preparePicker(srcType: .photoLibrary)
        self.present(picker, animated: true, completion: nil)
    }

    private func proveImageSources() {
        if !UIImagePickerController.isSourceTypeAvailable(.camera) {
            cameraButton.isEnabled = false
        }

        if !UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            albumButton.isEnabled = false
        }
    }

    private func preparePicker(srcType: UIImagePickerControllerSourceType) -> UIImagePickerController {
        let tmpPicker = UIImagePickerController()
        tmpPicker.sourceType = srcType
        tmpPicker.allowsEditing = false
        tmpPicker.mediaTypes = UIImagePickerController.availableMediaTypes(for: srcType)!
        tmpPicker.delegate = self

        return tmpPicker
    }
}

// MARK: - UIImagePickerControllerDelegate / UINavigationControllerDelegate
extension GifMakerVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [String : Any]) {
        let chosenImage = info[UIImagePickerControllerOriginalImage] as! UIImage
        imageView.contentMode = .scaleAspectFit
        imageView.image = chosenImage

        placeholderImage.isHidden = true
        topLabel.isHidden = false
        bottomLabel.isHidden = false
        titleLabel.text = "Add Text"

        self.dismiss(animated: true, completion: nil)
    }

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.dismiss(animated: true, completion: nil)
    }
}

