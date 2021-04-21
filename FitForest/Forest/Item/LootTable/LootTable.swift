//
//  LootTable.swift
//  FitForest
//
//  Created by Kyle Vigorito on 4/20/21.
//

import Foundation

struct LootTable {
    var name: String
    var items: [[String:AnyObject]]
    
    init?(data:Data) {
        do {
            
           let json = try JSONSerialization.jsonObject(with: data, options: [])
            if let json = json as? Dictionary<String, AnyObject> {
                if let jsonName = json["name"] as? String, let jsonItems = json["items"] as? [[String: AnyObject]] {
                    name = jsonName
                    items = jsonItems
                }
                else {
                    return nil
                }
            }else {
                return nil
            }
            
        }
        catch {
            print(error.localizedDescription)
            return nil
        }
    }
    
    private func sumWeights() -> Int {
       var sum = 0
        for item in items {
            sum += item["itemWeight"] as! Int
        }
        return sum
    }
    
    private func assignRanges() -> [String: ClosedRange<Int>] {
        var rangeDict = [String:ClosedRange<Int>]()
        var lastInt = 1
        
        for item in items {
            let name = item["name"] as! String
            let weight = item["itemWeight"] as! Int
            rangeDict[name] = lastInt...(lastInt + weight)
            lastInt = weight + 1
        }
        return rangeDict
    }
    
    func pickRandomItem() -> String? {
        let limit = sumWeights()
        let rangeDict = assignRanges()
        let randomNumber = Int.random(in: 1...limit)
        for (key, value) in rangeDict {
            if value.contains(randomNumber) {
                return key
            }
        }
        return nil
    }
    
}
