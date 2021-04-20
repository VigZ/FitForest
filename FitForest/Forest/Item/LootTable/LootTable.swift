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
                if let jsonName = json["name"] as? String {
                    name = jsonName
                }
                if let jsonItems = json["items"] as? [[String: AnyObject]] {
                    items = jsonItems
                }
            }
            
            
        }
        catch {
            print(error.localizedDescription)
        }
        return nil
    }
    
}
