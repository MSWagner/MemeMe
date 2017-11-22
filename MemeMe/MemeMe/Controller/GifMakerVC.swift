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
    @IBOutlet weak var topTextfield: UITextField!
    @IBOutlet weak var bottomTextfield: UITextField!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var placeholderImage: UIImageView!

    // MARK: - Bottom Bar Outlets
    @IBOutlet weak var cameraButton: UIBarButtonItem!
    @IBOutlet weak var albumButton: UIBarButtonItem!

    // MARK: - Keyboard Properties
    var keyboardHeight: CGFloat = 0 {
        didSet {
            view.frame.origin.y += keyboardHeight == 0 ? oldValue : -keyboardHeight
        }
    }

    // MARK: - Lifecycle Functions
    override func viewDidLoad() {
        super.viewDidLoad()
        proveImageSources()
        setTextAttributes(topTextfield)
        setTextAttributes(bottomTextfield)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        subscribeToKeyboardNotifications()

        let tapRecognizer: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        view.addGestureRecognizer(tapRecognizer)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        unsubscribeFromKeyboardNotifications()
    }

    // MARK: - IBAction Functions
    @IBAction func onCamera(_ sender: Any) {
        let picker = preparePicker(srcType: .camera)
        self.present(picker, animated: true, completion: nil)
    }

    @IBAction func onAlbum(_ sender: Any) {
        let picker = preparePicker(srcType: .photoLibrary)
        self.present(picker, animated: true, completion: nil)
    }

    // MARK: - Image Picker Functions
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

    // MARK: - Keyboard Functions
    private func subscribeToKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: .UIKeyboardWillShow, object: nil)

        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: .UIKeyboardWillHide, object: nil)
    }

    private func unsubscribeFromKeyboardNotifications() {
        NotificationCenter.default.removeObserver(self, name: .UIKeyboardWillShow, object: nil)

        NotificationCenter.default.removeObserver(self, name: .UIKeyboardWillHide, object: nil)
    }

    @objc private func keyboardWillShow(_ notification:Notification) {
        keyboardHeight = getKeyboardHeight(notification)
    }

    @objc private func keyboardWillHide(_ notification:Notification) {
        keyboardHeight = 0
    }

    private func getKeyboardHeight(_ notification:Notification) -> CGFloat {
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue
        return keyboardSize.cgRectValue.height
    }

    @objc private func hideKeyboard() {
        view.endEditing(true)
    }

    // MARK: - Textfield Functions
    private func setTextAttributes(_ textfield: UITextField) {
        let memeTextAttributes:[String: Any] = [
            NSAttributedStringKey.strokeColor.rawValue: UIColor.black,
            NSAttributedStringKey.foregroundColor.rawValue: UIColor.white,
            NSAttributedStringKey.font.rawValue: UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!,
            NSAttributedStringKey.strokeWidth.rawValue: -4]
        textfield.defaultTextAttributes = memeTextAttributes
        textfield.textAlignment = .center
    }
}

// MARK: - UIImagePickerControllerDelegate / UINavigationControllerDelegate
extension GifMakerVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [String : Any]) {
        guard let chosenImage = info[UIImagePickerControllerOriginalImage] as? UIImage else {
            self.dismiss(animated: true, completion: nil)
            // If the user choose as example a video or other false formats
            return
        }
        imageView.contentMode = .scaleAspectFit
        imageView.image = chosenImage

        placeholderImage.isHidden = true
        topTextfield.isHidden = false
        bottomTextfield.isHidden = false
        titleLabel.text = "Add Text"

        self.dismiss(animated: true, completion: nil)
    }

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.dismiss(animated: true, completion: nil)
    }
}

