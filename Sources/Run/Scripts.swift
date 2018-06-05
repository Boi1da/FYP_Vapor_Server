//
//  Scripts.swift
//  pokemon
//
//  Created by Armani on 16/04/2018.
//

import Foundation


class Scripts {
    
    @objc dynamic var isRunning = false
    var resultsString : String!
    var buildTask : Process!
    var outputPipe : Pipe!
    var duplicatedLinesCount : Int!
    var complexityLinesCount : Int!
    var launchPath = "/Users/Armani/pokemon/RunPMD.command"
    
    //Duplication!
    func startTask(pmdFilePath : String,minTokens : String, projectPath : String, language : String, fileFormat : String, ruleSetPath : String ){
        //Append parameters into array
        var arguments:[String] = []
        arguments.append(minTokens)
        arguments.append(projectPath)
        arguments.append(language)
        arguments.append(pmdFilePath)
        arguments.append(fileFormat)
        arguments.append(ruleSetPath)
        
        print("The parameters for our arguments are \(arguments)")
        runScript(arguments)
    }

    func runScript(_ arguments:[String]){
        resultsString = String()
        isRunning = true
        let taskQueue = DispatchQueue.global(qos: DispatchQoS.QoSClass.background)
        taskQueue.async {
            self.buildTask = Process()
            self.buildTask.launchPath = self.launchPath
        
            self.buildTask.arguments = arguments
            self.buildTask.terminationHandler = {
                task in
                DispatchQueue.main.async(execute: {
                    self.isRunning = false
                })
            }
            let pipe = Pipe()
            self.buildTask.standardOutput = pipe
            self.buildTask.launch()
            
            let data = pipe.fileHandleForReading.readDataToEndOfFile()
            let output: String = NSString(data: data, encoding: String.Encoding.utf8.rawValue)! as String
            print(output)
            
            
            self.resultsString = output
    
            print(self.resultsString)
            
            self.buildTask.waitUntilExit()
        }
    }
}


