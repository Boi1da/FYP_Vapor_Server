import App
import Foundation
import Alamofire
import ZIPFoundation


let config = try Config()
try config.setup()
let drop = try Droplet(config)
let scripts = Scripts()


var extractionComplete = false
drop.post("repositoryFiles") { request in
    
    //1) Check if we have recieved the name of the repoOwner and repoName
    // Throw an exception if we have not recieved either.
    
    guard let repoOwner = request.data["repoOwner"]?.string else {
        throw Abort.badRequest
    }
    guard let repoName = request.data["repoName"]?.string else {
        throw Abort.badRequest
    }
    
    //zipball or tarball
    guard let repoArchiveFormat = request.data["archive_format"]?.string else {
        throw Abort.badRequest
    }
    
    guard let repoRef = request.data["ref"]?.string else {
        throw Abort.badRequest
    }
    
    guard let repoLang = request.data["language"]?.string else {
        throw Abort.badRequest
    }
    
    //Send the request to github to return the zip file containing this projects file
    var url: String = "https://api.github.com/repos/\(repoOwner)/\(repoName)/\(repoArchiveFormat)/\(repoRef)"
    var result: Response!
    while true {
        result = try drop.client.get(url)
        guard result.status == .found else { break }
        url = result.headers["Location"]!
    }
    
    var documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
    let fileName = "\(repoName).zip"
    let zipFilePath = documentsURL.appendingPathComponent(fileName)
    
    
     //1) Create the destination for our downloaded file.
    let destination: DownloadRequest.DownloadFileDestination = { _, _ in
        documentsURL.appendPathComponent(fileName)
        
        // 2) Convert the zipFilePath into a string
        let filePathString = zipFilePath.absoluteString
        
        // 3) Unzip the file
        let fileManager = FileManager()
        var fileSourceURL = URL(fileURLWithPath: filePathString)

        
        
        //Run the script (CPD)
        scripts.startTask(pmdFilePath: "/Users/Armani/Desktop/pmd-bin-6.1.0/bin",minTokens: "75", projectPath: filePathString, language: repoLang, fileFormat: "txt", ruleSetPath: "/Users/Armani/Desktop/pmd-bin-6.1.0/bin/TechnicalDebt.xml")
        
        return (documentsURL, [.removePreviousFile])
    }
    
    let utilityQueue = DispatchQueue.global(qos: .utility)
    //Download the file from the URL and save it the documents directory
    Alamofire.download(url, to: destination).response { response in
        if response.error == nil {
            print("No errors!")
        }
        }.downloadProgress(queue: utilityQueue) { progress in
            print("Download Progress: \(progress.fractionCompleted)")
    }
    print("Zip File \(zipFilePath) has been extracted into \(documentsURL)")
    
    //Will change soon
    return fileName
}

drop.get("version") { request in
    let db = try drop.postgresql()
    let version = try db.raw("SELECT version()")
    return try JSON(node: ["version": version])
}

//Need to get two post requests from the
try drop.setup()
try drop.run()
