//
//  ViewController.swift
//  MemeMe
//
//  Created by Matthias Wagner on 16.11.17.
//  Copyright © 2017 Michael Wagner. All rights reserved.
//

import UIKit

class GifMakerVC: UIViewController {
    // MARK: - Navigation Bar Outlets
    @IBOutlet weak var shareButton: UIBarButtonItem!
    @IBOutlet weak var topBarLabel: UILabel!
    
    // MARK: - Image View Outlets
    @IBOutlet weak var topTextfield: UITextField!
    @IBOutlet weak var bottomTextfield: UITextField!
    @IBOutlet weak var imageView: UIImageView!

    // MARK: - Bottom Bar Outlets
    @IBOutlet weak var cameraButton: UIBarButtonItem!
    @IBOutlet weak var albumButton: UIBarButtonItem!
    @IBOutlet weak var bottomToolbar: UIToolbar!

    // MARK: - Keyboard Properties
    private var keyboardHeight: CGFloat = 0 {
        didSet {
            if bottomTextfield.isEditing {
                view.frame.origin.y += keyboardHeight == 0 ? oldValue : -keyboardHeight
            }
        }
    }

    // MARK: - Meme Properties
    private var isMemeImageComplete: Bool = false

    // MARK: - Appdelegate Propertie
    private let appDelegate = UIApplication.shared.delegate as! AppDelegate

    // MARK: - Lifecycle Functions
    override func viewDidLoad() {
        super.viewDidLoad()
        proveImageSources()
        setToLaunchState()

        configureTextfields()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        subscribeToKeyboardNotifications()
        subscribeToDeviceOrientationNotifications()

        let tapRecognizer: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        view.addGestureRecognizer(tapRecognizer)

        tabBarController?.tabBar.isHidden = true
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        configureTextfields()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        unsubscribeFromKeyboardNotifications()
        unsubscribeFromDeviceOrientationNotifications()

        tabBarController?.tabBar.isHidden = false
    }

    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        configureTextfields() // To shrink Textsize following the different Textfield heights on landscape/portrait
    }

    // MARK: - IBAction Functions
    @IBAction func onCamera(_ sender: Any) {
        prepareAndPresentPicker(srcType: .camera)
    }

    @IBAction func onAlbum(_ sender: Any) {
        prepareAndPresentPicker(srcType: .photoLibrary)
    }

    @IBAction func onShare(_ sender: Any) {
        let memeImage = generateMemedImage()

        let activityVC = UIActivityViewController(activityItems: [memeImage], applicationActivities: [])
        present(activityVC, animated: true, completion: nil)

        activityVC.completionWithItemsHandler = { activity, completed, items, error in
            if completed && error == nil {
                print("Save")
                self.save()
                return
            }
        }
    }

    @IBAction func onCancel(_ sender: Any) {
        setToLaunchState()
        dismiss(animated: true, completion: nil)
    }

    // MARK: - UI Setup
    private func setToLaunchState() {
        imageView.contentMode = .scaleAspectFit
        imageView.image = #imageLiteral(resourceName: "placeholder")
        topTextfield.text = "ADD TOP TEXT"
        topTextfield.isHidden = true
        bottomTextfield.text = "ADD BOTTOM TEXT"
        bottomTextfield.isHidden = true
        topBarLabel.text = "Choose your image"
        shareButton.isEnabled = false
    }
    
    // MARK: - Image Functions
    private func proveImageSources() {
        if !UIImagePickerController.isSourceTypeAvailable(.camera) {
            cameraButton.isEnabled = false
        }

        if !UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            albumButton.isEnabled = false
        }
    }

    private func prepareAndPresentPicker(srcType: UIImagePickerControllerSourceType) {
        let picker = UIImagePickerController()
        picker.sourceType = srcType
        picker.allowsEditing = false
        picker.mediaTypes = UIImagePickerController.availableMediaTypes(for: srcType)!
        picker.delegate = self

        present(picker, animated: true, completion: nil)
    }

    private func proveIsMemeImageReady() {
        if (topTextfield.text != "ADD TOP TEXT") && (bottomTextfield.text != "ADD BOTTOM TEXT") {
            topBarLabel.text = "Share your Meme"
            shareButton.isEnabled = true
        } else {
            topBarLabel.text = "Add Text"
            shareButton.isEnabled = false
        }
    }

    private func save() {
        guard let image = imageView.image, let topText = topTextfield.text, let bottomText = bottomTextfield.text else {
            return
        }

        let memeImage = generateMemedImage()
        let meme = Meme(topText: topText, bottomText: bottomText, image: image, memeImage: memeImage)
        appDelegate.memes.append(meme)
    }

    private func generateMemedImage() -> UIImage {
        // Render view to an image
        UIGraphicsBeginImageContext(view.frame.size)
        view.drawHierarchy(in: view.frame, afterScreenUpdates: true)
        let memedImage: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()

        return cropImage(memedImage)
    }

    private func cropImage(_ image: UIImage) -> UIImage {
        let yAxisImageView = imageView.frame.origin.y // Image start below the navigationbar
        let cropRect = CGRect(x: 0, y: yAxisImageView + 1, width: imageView.frame.width, height: imageView.frame.height - 2) // insets to get a clean cut
        let cgImage = image.cgImage?.cropping(to: cropRect)
        let newImage = UIImage(cgImage: cgImage!)

        return newImage
    }

    // MARK: - DeviceOrientation Functions
    private func subscribeToDeviceOrientationNotifications() {
        // Hide Keyboard with DeviceOrientation Transition
        NotificationCenter.default.addObserver(self, selector: #selector(hideKeyboard), name: .UIDeviceOrientationDidChange, object: nil)
    }

    private func unsubscribeFromDeviceOrientationNotifications() {
        NotificationCenter.default.removeObserver(self, name: .UIDeviceOrientationDidChange, object: nil)
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

    // MARK: - Textfield UI Function
    private func configureTextfields() {
        topTextfield.delegate = self
        bottomTextfield.delegate = self

        setTextAttributes(topTextfield)
        setTextAttributes(bottomTextfield)
    }

    private func setTextAttributes(_ textfield: UITextField) {
        let textSize: CGFloat = UIDevice.current.orientation.isLandscape ? 30 : 40

        let memeTextAttributes:[String: Any] = [
            NSAttributedStringKey.strokeColor.rawValue: UIColor.black,
            NSAttributedStringKey.foregroundColor.rawValue: UIColor.white,
            NSAttributedStringKey.font.rawValue: UIFont(name: "HelveticaNeue-CondensedBlack", size: textSize)!,
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
            // If the user choose as example a video or other false formats
            dismiss(animated: true, completion: nil)
            return
        }
        imageView.contentMode = .scaleAspectFit
        imageView.image = chosenImage

        topTextfield.isHidden = false
        bottomTextfield.isHidden = false
        topBarLabel.text = "Add Text"
        proveIsMemeImageReady()

        dismiss(animated: true, completion: nil)
    }

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
}

// MARK: - UITextFieldDelegate
extension GifMakerVC: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.text = ""
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        hideKeyboard()
        return true
    }

    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField.text == "" {
            let placeString = textField == topTextfield ? "TOP" : "BOTTOM"
            textField.text = "ADD \(placeString) TEXT"
            return
        }
        proveIsMemeImageReady()
    }
}

