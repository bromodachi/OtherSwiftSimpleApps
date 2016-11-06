//
//  CSVReader.swift
//  pokedex
//
//  Created by c.uraga on 2016/09/04.
//  Copyright © 2016年 c.uraga. All rights reserved.
//

import Foundation

class CSVReader {
    
    public var headers:  [String] = []
    public var rows: [Dictionary<String, String>] = []
    public var columns = Dictionary<String, String>()
    
    var delimiter = CharacterSet(charactersIn: ",")
    init(fileName: String?, delimeter: CharacterSet, encoding:UInt ) {
        if let csvContent = fileName {
            self.delimiter = delimeter
            var lines: [String] = []
            let newLine = NSCharacterSet.newlines
            csvContent.trimmingCharacters(in: newLine).enumerateLines { line, _ in  lines.append(line)
            }
            headers = self.getColumns(fromLines: lines)
            rows = self.getRows(fromLines: lines)
        }
        //below is for Mac.
   //     let downloadDirectoryPath = NSHomeDirectory()
        //let csvFileUrl = URL(fileURLWithPath: "\(downloadDirectoryPath)/Desktop/pokemon.csv")
        
 /*       do {
            //let data = try Data(contentsOf: csvFileUrl)
            //let content =  try String(data: data, encoding: String.Encoding.utf8)
            //try String String(contentsOfURL: NSURL(string: url_string)!, encoding: NSUTF8StringEncoding)
            var lines: [String] = []
            let newLine = NSCharacterSet.newlines
            content?.trimmingCharacters(in: newLine).enumerateLines { line, _ in  lines.append(line)
            }
            headers = self.getColumns(fromLines: lines)
            rows = self.getRows(fromLines: lines)
        } catch{
            //catch an error
            print(error)
        }*/
    }
    
    
    public convenience init(contentsOfURL url: String) throws {
        let comma = CharacterSet(charactersIn: ",")
        let csvString: String?
        do {
            csvString = try String(contentsOfFile: url, encoding: String.Encoding.utf8)
        } catch _ {
            csvString = nil
        }
        try self.init(fileName: csvString,delimeter:comma, encoding:String.Encoding.utf8.rawValue)
    }
    func getColumns(fromLines lines: [String]) -> [String]{
        return lines[0].components(separatedBy: ",")
    }
    
    func getRows(fromLines lines: [String]) -> [Dictionary<String, String>] {
        var rows = [Dictionary<String, String>] ()
        for (currentIndex, line) in lines.enumerated()  {
            if currentIndex == 0{
                continue
            }
            var row = Dictionary<String, String> ()
            let values = line.components(separatedBy: ",")
            for (index, header ) in headers.enumerated() {
                row[header] = values[index]
                //print("\(values.count) index: \(header)")
                
            }
            rows.append(row)
        }
        return rows
    }
    
    //from mark's.
    func parseColumns(fromLines lines: [String]) -> Dictionary<String, [String]> {
        var columns = Dictionary<String, [String]>()
        
        for header in self.headers {
            let column = self.rows.map { row in row[header] != nil ? row[header]! : "" }
            columns[header] = column
        }
        
        return columns
    }
    
}
