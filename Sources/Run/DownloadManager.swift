//
//  DownloadManager.swift
//  pokemonPackageDescription
//
//  Created by Armani on 05/06/2018.
//

import Foundation
import Alamofire

class DownloadManager {
    
    func downloadZipFile(fileName: String, sourceURL: String){
        let zipManager = ZipManagement()
        let documentsDirectory = zipManager.getDocumentsDirectory()
        let utilityQueue = DispatchQueue.global(qos: .utility)
        var response: DefaultDownloadResponse?
        
        
        //1) Create the destination for our downloaded file.
        let destination: DownloadRequest.DownloadFileDestination = { _, _ in
            let filePath = documentsDirectory.appendingPathComponent(fileName)
            
            return (filePath, [.removePreviousFile])
        }
        
        //2) Download the file from the URL and save it the documents directory
        Alamofire.download(sourceURL, to: destination).downloadProgress(queue: utilityQueue) {
                progress in
            print("DownloadProgress: \(progress.fractionCompleted)")
        }
            //Run after file has been downloaded!
            .response(queue: utilityQueue){ _ in
                zipManager.unzipFile(sourceLocationInLocal: documentsDirectory.appendingPathComponent(fileName), fileName: fileName)
        }
    }
}
