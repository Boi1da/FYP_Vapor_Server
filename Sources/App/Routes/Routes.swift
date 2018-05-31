import Vapor
import Foundation


extension Droplet {
    func setupRoutes() throws {
        get("hello") { req in
            var json = JSON()
            try json.set("hello", "world")
            return json
        }

        get("plaintext") { req in
            return "Hello, world!"
        }
        
        //postgres -D /usr/local/var/postgres
        
        post("file") { request in
            guard let fileName = request.data["fileName"]?.string,
                let fileContents = request.data["fileContents"]?.string else {
                    throw Abort.badRequest
            }
            
            let file = FileContent(fileName: fileName, fileContents: fileContents)
            try file.save()
            
            
            return "Success! File Info: \n\(file.fileName) has been added! \n\(file.fileContents) \n\(String(describing: file.id?.wrapped))"
        }

        // response to requests to /info domain
        // with a description of the request
        get("info") { req in
            return req.description
        }

        get("description") { req in return req.description }
    
        
        try resource("posts", PostController.self)
    }
}

extension String {
    func base64Decoded() -> String? {
        if let data = Data(base64Encoded: self, options: .ignoreUnknownCharacters) {
            return String(data: data, encoding: .utf8)
        }
        return nil
    }
}



