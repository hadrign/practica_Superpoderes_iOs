//
//  KamikazeWarDataManager.swift
//  Kamikaze War
//
//  Created by Hadrian Grille Negreira on 12/06/2020.
//  Copyright © 2020 Hadrian Grille Negreira. All rights reserved.
//

import Foundation

struct KamikazeWarDataManager {
    private static let userDefault = UserDefaults.standard
    static let userDefaultsKey = "MaxScore"
    
    
    static func saveScore(_ score: Int) {
        userDefault.set(score, forKey: userDefaultsKey)
    }
    
    static func getScore() -> Int? {
        return userDefault.integer(forKey: userDefaultsKey)
    }
}
