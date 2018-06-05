import App
import Foundation
import Alamofire
import ZIPFoundation


let config = try Config()
try config.setup()
let drop = try Droplet(config)
let scripts = Scripts()

let zipManager = ZipManagement()
let downloadManager = DownloadManager()

var documentsDirectory = zipManager.getDocumentsDirectory()
let utilityQueue = DispatchQueue.global(qos: .utility)

drop.post("repositoryFiles") { request in
    
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
    
    //Get the url from the initial returned response
    var url: String = "https://api.github.com/repos/\(repoOwner)/\(repoName)/\(repoArchiveFormat)/\(repoRef)"
    var result: Response!
    while true {
        result = try drop.client.get(url)
        guard result.status == .found else { break }
        url = result.headers["Location"]!
    }
    downloadManager.downloadZipFile(fileName: repoName, sourceURL: url)


    /*5)Run the script (CPD)
     scripts.startTask(pmdFilePath: "/Users/Armani/Desktop/pmd-bin-6.1.0/bin",minTokens: "75", projectPath: filePathString, language: repoLang, fileFormat: "txt", ruleSetPath: "/Users/Armani/Desktop/pmd-bin-6.1.0/bin/TechnicalDebt.xml")
     */
    return repoName
}

drop.get("version") { request in
    let db = try drop.postgresql()
    let version = try db.raw("SELECT version()")
    return try JSON(node: ["version": version])
}

//Need to get two post requests from the
try drop.setup()
try drop.run()
