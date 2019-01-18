//
//  ViewController.swift
//  PhotoJournal
//
//  Created by Pritesh Nadiadhara on 1/16/19.
//  Copyright © 2019 Pritesh Nadiadhara. All rights reserved.
//

import UIKit

class PhotoJournalViewController: UIViewController {
    


    @IBOutlet weak var addNewPhotoButton: UIBarButtonItem!
    @IBOutlet weak var photoJournalCollectionView: UICollectionView!
    private var arrayOfPhotoJournalEntries = [Photo]() {
        didSet{
            DispatchQueue.main.async {
                self.photoJournalCollectionView.reloadData()
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        arrayOfPhotoJournalEntries = PhotoJournalModel.getPhotos()
        photoJournalCollectionView.dataSource = self
        print(DataPersistenceManager.documentsDirectory())
    }
    
    override func viewWillAppear(_ animated: Bool) {
       super.viewWillAppear(animated)
        arrayOfPhotoJournalEntries = PhotoJournalModel.getPhotos()
        photoJournalCollectionView.reloadData()
    }


    @IBAction func moreOptionsButtonPressed(_ sender: UIButton) {
        let actionSheet = UIAlertController(title: "Options", message: "", preferredStyle: .actionSheet)
        
        let deleteAction = UIAlertAction(title: "Delete", style: .destructive) { (action) -> Void in
            PhotoJournalModel.delete(atIndex: sender.tag)
            self.arrayOfPhotoJournalEntries.remove(at: sender.tag)
            self.photoJournalCollectionView.reloadData()
            PhotoJournalModel.save()
        }
        
//        let editAction = UIAlertAction(title: "Edit", style: .cancel) { _ in
//            let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
//            guard let photoJournalDetailViewController = storyboard.instantiateViewController(withIdentifier: "addPostViewController") as? PhotoJournalDetailViewController else {return}
//            photoJournalDetailViewController.modalPresentationStyle = .currentContext
//            self.navigationController?.present(photoJournalDetailViewController, animated: true, completion: nil)
//        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { _ in
            self.dismiss(animated: true, completion: nil)
        }
       let shareAction = UIAlertAction(title: "Share", style: .default) { _ in
        self.shareJournal(atIndex: sender.tag)
            
        }
        
        //actionSheet.addAction(editAction)
        actionSheet.addAction(deleteAction)
        actionSheet.addAction(shareAction)
        actionSheet.addAction(cancelAction)
        present(actionSheet, animated: true, completion: nil)
        
    }
    
    private func shareJournal(atIndex: Int) {
        if let imageToShare = UIImage(data: arrayOfPhotoJournalEntries[atIndex].imageData) {
            let captionToShare = arrayOfPhotoJournalEntries[atIndex].description
            let activityViewController = UIActivityViewController(activityItems: [imageToShare, captionToShare], applicationActivities: nil)
            present(activityViewController, animated: true)
        }
    }
    
    @IBAction func addPhotoButtonPressed(_ sender: UIBarButtonItem) {
        let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
        guard let photoJournalDetailViewController = storyboard.instantiateViewController(withIdentifier: "addPostViewController") as? PhotoJournalDetailViewController else {return}
        photoJournalDetailViewController.modalPresentationStyle = .currentContext
        self.navigationController?.present(photoJournalDetailViewController, animated: true, completion: nil)
    }
}

extension PhotoJournalViewController : UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return PhotoJournalModel.getPhotos().count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = photoJournalCollectionView.dequeueReusableCell(withReuseIdentifier: "PhotoPostCell", for: indexPath) as? PhotoJournalPostCollectionViewCell else {return UICollectionViewCell()}
        let currentPhotoJournalPost = arrayOfPhotoJournalEntries[indexPath.item]
        cell.photoJournalPostImage.image = UIImage(data: currentPhotoJournalPost.imageData)
        cell.photoJournalPostDescription.text = currentPhotoJournalPost.description
        cell.photoJournalPostDate.text = currentPhotoJournalPost.dateFormattedString
        cell.layer.cornerRadius = 20.0
        cell.UIActionSheetMoreOptionsButton.tag = indexPath.item
        cell.UIActionSheetMoreOptionsButton.addTarget(self, action: #selector(moreOptionsButtonPressed(_:)), for: .touchUpInside)
        return cell
    }
    
    
}

