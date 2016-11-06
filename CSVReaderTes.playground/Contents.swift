//: Playground - noun: a place where people can play

import UIKit
import Foundation

var str = "Hello, playground"

class CSVReader {
    
    public var headers:  [String] = []
    public var rows: [Dictionary<String, String>] = []
    public var columns = Dictionary<String, String>()
    
    var delimeter = NSCharacterSet(charactersIn: ",")
    init(fileName: String, delimeter: NSCharacterSet, encoding:UInt ) {
        let downloadDirectoryPath = NSHomeDirectory()
        let csvFileUrl = URL(fileURLWithPath: "\(downloadDirectoryPath)/Desktop/pokemon.csv")
    
        do {
            let data = try Data(contentsOf: csvFileUrl)
            let content =  try String(data: data, encoding: String.Encoding.utf8)
            //try String String(contentsOfURL: NSURL(string: url_string)!, encoding: NSUTF8StringEncoding)
            print(content)
        
        } catch{

            print(error)
        }
    }
}

let downloadDirectoryPath = NSHomeDirectory()
let csvFileUrl = URL(fileURLWithPath: "\(downloadDirectoryPath)/Desktop/pokemon.csv")

do {
    let data = try Data(contentsOf: csvFileUrl)
    let content =  try String(data: data, encoding: String.Encoding.utf8)
    //try String String(contentsOfURL: NSURL(string: url_string)!, encoding: NSUTF8StringEncoding)
    print(content)
    
} catch{
    
    print(error)
}
CSVReader(fileName: "pokedex", delimeter: NSCharacterSet(), encoding: 8)