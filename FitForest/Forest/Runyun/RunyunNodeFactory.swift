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
        return Runyun()
    }
    
    func createFromSeed(seedType: SeedType) -> Runyun? {
        let newRunyun = Runyun()
        newRunyun.size = CGSize(width: 275, height: 200)
        return newRunyun
    }
        
}
