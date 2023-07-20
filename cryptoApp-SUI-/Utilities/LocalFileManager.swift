//
//  LocalFileManager.swift
//  cryptoApp-SUI-
//
//  Created by Borisov Nikita on 24.07.2023.
//

import Foundation
import SwiftUI

class LocalFileManager {
    
    static let instance = LocalFileManager()
    private init() { }
    
    func saveImage(image: UIImage, imageName: String, folderName: String) {
        
        createFolderIfNedded(folderName: folderName)
        
        guard let data = image.pngData(),
              let url = getUrlForImage(imageName: imageName, folderName: folderName)
        else { return }
        
        do {
            try data.write(to: url)
        } catch let error {
            print(error.localizedDescription)
        }
    }
    
    func getImage(imageName: String, folderName: String) -> UIImage? {
        guard
            let url = getUrlForImage(imageName: imageName, folderName: folderName),
            FileManager.default.fileExists(atPath: url.path) else {
            return nil
        }
        return UIImage(contentsOfFile: url.path)
    }
    
    private func createFolderIfNedded(folderName: String) {
        
        guard let url = getUrlForFolder(folderName: folderName) else { return }
        
        if !FileManager.default.fileExists(atPath: url.path) {
            do {
                try FileManager.default.createDirectory(at: url, withIntermediateDirectories: true)
            } catch let error {
                print("Error creating directory. \(folderName). \(error.localizedDescription)")
            }
        }
    }
    
    private func getUrlForFolder(folderName: String) -> URL? {
        
        guard let url = FileManager.default.urls(for: .cachesDirectory, in: .allDomainsMask).first else { return nil }
        
        return url.appendingPathExtension(folderName)
        
    }
    
    private func getUrlForImage(imageName: String, folderName: String) -> URL? {
        
        guard let folderUrl = getUrlForFolder(folderName: folderName) else { return nil }
        
        return folderUrl.appendingPathExtension(imageName + ".png")
        
    }
    
}
