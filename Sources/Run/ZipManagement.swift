//
//  ZipManagement.swift
//  pokemonPackageDescription
//
//  Created by Armani on 31/05/2018.
//

import Foundation
import ZIPFoundation


class ZipManagement {
    
    let fileManager = FileManager()

    func unzipFile(sourceLocationInLocal: URL, fileName: String) {
        //Create the path to our documents directory
        let documentsDirectory = getDocumentsDirectory()
        //documentsURL.appendingPathComponent(fileName)
        do {
            print("The source location is: \(sourceLocationInLocal)")
            print("The file name is: \(fileName)")
            try fileManager.unzipItem(at: sourceLocationInLocal, to: documentsDirectory as URL)
        } catch {
            print("We encountered an error: \(error)")
        }
    }
    
    //Created to make readability of main.swift easier
    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .downloadsDirectory, in: .userDomainMask)
        let tempDirectory = paths[0]
        return tempDirectory
    }
}
