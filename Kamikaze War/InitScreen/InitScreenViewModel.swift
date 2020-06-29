//
//  InitScreenViewModel.swift
//  Kamikaze War
//
//  Created by Hadrian Grille Negreira on 12/06/2020.
//  Copyright © 2020 Hadrian Grille Negreira. All rights reserved.
//

import Foundation

protocol InitScreenCoordinatorDelegate: class {
    func startGameTapped()
    func EndGameTapped()
}

protocol InitScreenViewDelegate: class {
    func ScoreFetched(score: String?)
}

class InitScreenViewModel {
    weak var viewDelegate: InitScreenViewDelegate?
    weak var coordinatorDelegate: InitScreenCoordinatorDelegate?
    var labelMaxScore: String?
    //ver se tenemos que añadir algo más
    let userDefaultScore: KamikazeWarDataManager
    
    //añadir aqui los delegate si son necesarios, si no utilizamos el notification centre
    
    init(maxScoreDataManager: KamikazeWarDataManager) {
        self.userDefaultScore = maxScoreDataManager
    }
    
    func viewWasLoaded() {
        let scoreSaved = KamikazeWarDataManager.getScore()
        if scoreSaved == nil {
            labelMaxScore = "Score: 0"
        } else {
           labelMaxScore = "Score: \(scoreSaved ?? 1)"
        }
        
        self.viewDelegate?.ScoreFetched(score: labelMaxScore)
        print("salindo do viewWasLoaded() \(scoreSaved ?? 1)")
        
    }
    
    func startGame() {
        coordinatorDelegate?.startGameTapped()
    }
}
