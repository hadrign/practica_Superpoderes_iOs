//
//  GameViewModel.swift
//  Kamikaze War
//
//  Created by Hadrian Grille Negreira on 12/06/2020.
//  Copyright © 2020 Hadrian Grille Negreira. All rights reserved.
//

import Foundation


protocol GameCoordinatorDelegate: class {
    func gameExitButtonTapped()
}

protocol GameViewDelegate: class {
    
}

class GameViewModel {
    
    weak var viewDelegate: GameViewDelegate?
    weak var coordinatorDelegate: GameCoordinatorDelegate?
    let scoreDataManager: KamikazeWarDataManager
    
    init(dataManager: KamikazeWarDataManager) {
        self.scoreDataManager = dataManager
    }
    
    func exitButtonTapped(CurrentScore score: Int) {
        guard let scoreSaved = KamikazeWarDataManager.getScore() else { return }
        if score > scoreSaved {
          KamikazeWarDataManager.saveScore(score)
        }
        coordinatorDelegate?.gameExitButtonTapped()
    }
    
}
