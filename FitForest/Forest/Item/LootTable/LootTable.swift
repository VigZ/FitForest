//
//  LootTable.swift
//  FitForest
//
//  Created by Kyle Vigorito on 4/20/21.
//

import Foundation

struct LootTable {
    typealias Item = [String:AnyObject]
    var name: String
    var items: [Item]
    
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
    
    private func assignRanges() -> [String: Range<Int>] {
        var rangeDict = [String: Range<Int>]()
        var lastInt = 1
        
        for item in items {
            let name = item["name"] as! String
            let weight = item["itemWeight"] as! Int
            let highValue = lastInt + weight
            rangeDict[name] = lastInt..<highValue
            lastInt = highValue
        }
        return rangeDict
    }
    
    private func pickRandomValue() -> String? {
        let limit = sumWeights()
        let rangeDict = assignRanges()
        print(rangeDict)
        let randomNumber = Int.random(in: 1...limit)
        for (key, value) in rangeDict {
            if value.contains(randomNumber) {
                return key
            }
        }
        return nil //TODO Add error handling here.
    }
    
    func pickRandomItem() -> Item? {
        let randomValue = pickRandomValue()
        for item in items {
            if item["name"] as? String == randomValue {
                return item
            }
        }
        return nil
    }
}
