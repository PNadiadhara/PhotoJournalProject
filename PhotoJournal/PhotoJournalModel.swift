//
//  PhotoJournalModel.swift
//  PhotoJournal
//
//  Created by Pritesh Nadiadhara on 1/17/19.
//  Copyright © 2019 Pritesh Nadiadhara. All rights reserved.
//

import Foundation

final class PhotoJournalModel {
    private static let filename = "PhotoJournalPhotosAndDesc.plist"
    private static var photos = [Photo]()
    
    static func getPhotos() -> [Photo]{
        let path = DataPersistenceManager.filepathToDocumentsDirectory(filename: filename).path
        if FileManager.default.fileExists(atPath: path) {
            if let data = FileManager.default.contents(atPath: path) {
                do {
                    photos = try PropertyListDecoder().decode([Photo].self, from: data)
                }catch {
                    print("property list decoding error: \(error)")
                }
            } else {
                print("aata is nil")
            }
        } else {
            print("\(filename) does not exist")
        }
        photos = photos.sorted {$0.date > $1.date}
        return photos
    }
    static func addItem(photo: Photo){
        photos.append(photo)
        save()
    }
    static func delete(atIndex index: Int){
        photos.remove(at: index)
    }
    
    static func save() {
        let path = DataPersistenceManager.filepathToDocumentsDirectory(filename: filename)
        do {
            let data = try PropertyListEncoder().encode(photos)
            try data.write(to: path, options: Data.WritingOptions.atomic)
        } catch {
            print("Property list encoding error: \(error)")
        }
    }
}
