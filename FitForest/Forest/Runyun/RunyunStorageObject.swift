//
//  RunyunStorageObject.swift
//  FitForest
//
//  Created by Kyle Vigorito on 5/5/21.
//

import Foundation

class RunyunStorageObject: NSObject, NSCoding {
    
    var name: String = ""
    var locationState: ItemState = .inInventory
    var accessory: Accessory?
    var observedStepsRemaining: Int
    var seedType: SeedType
    var leafType: LeafType

    init(name: String, locationState: ItemState, accessory: Accessory?, observedStepsRemaining: Int, seedType: SeedType, leafType: LeafType) {
        self.name = name
        self.locationState = locationState
        self.accessory = accessory
        self.observedStepsRemaining = observedStepsRemaining
        self.seedType = seedType
        self.leafType = leafType
    }
    
    func encode(with coder: NSCoder) {
        
        guard let keyedCoder = coder as? NSKeyedArchiver else {
                    fatalError("Must use Keyed Coding")
                }
        coder.encode(self.name, forKey: "name")
        coder.encode(self.accessory, forKey: "accessory")
        coder.encode(self.observedStepsRemaining, forKey: "observedStepsRemaining")
        
        do {
            try keyedCoder.encodeEncodable(self.locationState, forKey: "locationState")
            try keyedCoder.encodeEncodable(self.seedType, forKey: "seedType")
        } catch {
            print(error)
        }
        

    }
    
    required convenience init?(coder: NSCoder) {
        
        guard let keyedDecoder = coder as? NSKeyedUnarchiver else {
            fatalError("Must use Keyed Coding")
        }
        
        let locationState = keyedDecoder.decodeDecodable(ItemState.self, forKey: "locationState") ?? .inForest
        let seedType = keyedDecoder.decodeDecodable(SeedType.self, forKey: "seedType") ?? .red
        let leafType = keyedDecoder.decodeDecodable(LeafType.self, forKey: "leafType") ?? .standard
        let observedStepsRemaining = coder.decodeInteger(forKey: "observedStepsRemaining")
        guard let name = coder.decodeObject(forKey: "name") as? String,
              let accessory = coder.decodeObject(forKey: "accessory") as? Accessory?
       else { return nil }
        self.init(
            name:name,
            locationState: locationState,
            accessory: accessory,
            observedStepsRemaining: observedStepsRemaining,
            seedType: seedType,
            leafType: leafType
                  )
   }
    
    
}
