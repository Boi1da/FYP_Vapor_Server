//
//  FileContent.swift
//  pokemonPackageDescription
//
//  Created by Armani on 11/03/2018.
//
import PostgreSQLProvider


final class FileContent: Model {
    
    let fileName: String
    let fileContents: String
    
    init(fileName: String, fileContents: String) {
        self.fileName = fileName
        self.fileContents = fileContents
    }
    
    var storage = Storage()
    
    
    
    init(row: Row) throws {
        self.fileName = try row.get("fileName")
        self.fileContents = try row.get("fileContents")
    }
 
}

extension FileContent: RowRepresentable {
    func makeRow() throws -> Row {
        var row = Row()
        try row.set("fileName", fileName)
        try row.set("fileContents", fileContents)
        return row
    }
}

extension FileContent: Preparation {
   
    static func prepare(_ database: Database) throws {
        try database.create(self, closure: {
            (file) in
            file.id()
            file.string("fileName")
            file.string("fileContents")
        })
    }
    
    static func revert(_ database: Database) throws {
        try database.delete(self)
    }
}





