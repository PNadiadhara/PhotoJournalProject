//
//  PhotoJournalDetailViewController.swift
//  PhotoJournal
//
//  Created by Pritesh Nadiadhara on 1/17/19.
//  Copyright © 2019 Pritesh Nadiadhara. All rights reserved.
//

import UIKit

class PhotoJournalDetailViewController: UIViewController {
    
    var photoDescriptionPlaceholder = "Enter Image Caption"

    @IBOutlet weak var photoDescriptionTextView: UITextView!
    @IBOutlet weak var selectedPhoto: UIImageView!
    @IBOutlet weak var openCameraButton: UIBarButtonItem!
    @IBOutlet weak var photoLibraryButton: UIBarButtonItem!
    @IBOutlet weak var cancelPhotoPostButton: UIBarButtonItem!
    @IBOutlet weak var savePhotoPostButton: UIBarButtonItem!
    private var imagePickerViewController = UIImagePickerController()
   
    override func viewDidLoad() {
        super.viewDidLoad()
        title = ""
        setTextToDefaultText()
        setUpImagePickerViewController()
        photoDescriptionTextView.delegate = self
    }
    
    
    private func setUpImagePickerViewController() {
        imagePickerViewController.delegate = self
        if !UIImagePickerController.isSourceTypeAvailable(.camera){
            openCameraButton.isEnabled = false
        }

    }
    
    private func setTextToDefaultText() {
        photoDescriptionTextView.text = photoDescriptionPlaceholder
        photoDescriptionTextView.textColor = .lightGray
        
        
        
    }
    private func showImagePickerController() {
        present(imagePickerViewController, animated: true, completion: nil)
    }
    
    @IBAction func cancelButtonPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func photoLibraryButtonPressed(_ sender: UIBarButtonItem) {
        imagePickerViewController.sourceType = .photoLibrary
        showImagePickerController()
        
    }
    @IBAction func saveButtonPressed(_ sender: UIBarButtonItem) {
        guard let photoDescriptionToBeSaved = photoDescriptionTextView.text,
            let photoImageToBeSaved = selectedPhoto.image?.jpegData(compressionQuality: 0.5) else { fatalError("some Error")}
        let date = Date()
        let isoDateFormatter = ISO8601DateFormatter()
        isoDateFormatter.formatOptions = [.withFullDate,
                                         .withFullTime,
                                         .withInternetDateTime,
                                         .withTimeZone,
                                         .withDashSeparatorInDate ]
        let timeStamp = isoDateFormatter.string(from: date)
        let photoToPost = Photo.init(description: photoDescriptionToBeSaved, imageData: photoImageToBeSaved, createdAt: timeStamp)
        
        PhotoJournalModel.addItem(photo: photoToPost)
        
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func cameraButtonPressed(_ sender: Any) {
        
    }
    
}

extension PhotoJournalDetailViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            selectedPhoto.image = image
            //SavePhotoJournal(image: image)
        } else {
            print("original image is nil")
        }
        dismiss(animated: true, completion: nil)
    }
    
}

extension PhotoJournalDetailViewController: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        if photoDescriptionTextView.text == photoDescriptionPlaceholder {
            textView.text = ""
            textView.textColor = .black
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if photoDescriptionTextView.text == "" {
            textView.text = photoDescriptionPlaceholder
        }
        
    }
}
