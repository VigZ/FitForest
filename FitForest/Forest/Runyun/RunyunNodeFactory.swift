//
//  RunyunFactory.swift
//  FitForest
//
//  Created by Kyle Vigorito on 4/26/21.
//

import Foundation
import SpriteKit

class RunyunNodeFactory {
    static var sharedInstance = RunyunNodeFactory()

    func createRunyunNode(runyun : RunyunStorageObject)-> Runyun?{
        let newRunyun = Runyun(runyunStorageObject: runyun)
        newRunyun.size = CGSize(width: 275, height: 200)
        return newRunyun
    }
    
    func createFromSeed(seedType: SeedType) -> Runyun? {
        // add switch for observed steps int based on seed type
        // create Loot Table for leaftype and assign
        
        let newRSO = RunyunStorageObject(name: "", locationState: .inForest, accessory: nil, observedStepsRemaining: 100, seedType: seedType, leafType: .standard, seedling: true)
        GameData.sharedInstance.inventory.addRunyun(runyun: newRSO)
        let newRunyun = Runyun(runyunStorageObject: newRSO)
        newRunyun.size = CGSize(width: 275, height: 200)
        return newRunyun
    }
        
}
