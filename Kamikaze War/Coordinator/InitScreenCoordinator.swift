//
//  InitScreenCoordinator.swift
//  Kamikaze War
//
//  Created by Hadrian Grille Negreira on 12/06/2020.
//  Copyright © 2020 Hadrian Grille Negreira. All rights reserved.
//

import UIKit

class InitScreenCoordinator: Coordinator {
    let presenter: UINavigationController
    var initScreenViewModel: InitScreenViewModel?
    let scoreDataManager: KamikazeWarDataManager
    
    init(presenter: UINavigationController, dataManager:KamikazeWarDataManager) {
        self.presenter = presenter
        self.scoreDataManager = dataManager
    }
    
    override func start() {
        let initScreenViewModel = InitScreenViewModel(maxScoreDataManager: scoreDataManager)
        initScreenViewModel.coordinatorDelegate = self
        let initScreenViewController = InitScreenViewController(viewModel: initScreenViewModel)
        initScreenViewModel.viewDelegate = initScreenViewController
        self.initScreenViewModel = initScreenViewModel
        presenter.pushViewController(initScreenViewController, animated: true)
        print("Parte final start InitScreenCoordinator")
    }
    
    override func finish() {}
}

extension InitScreenCoordinator: InitScreenCoordinatorDelegate {
    func startGameTapped() {
        let gameViewModel = GameViewModel(dataManager: scoreDataManager)
        let gameViewController = GameViewController(viewModel: gameViewModel)
        gameViewController.navigationController?.navigationBar.isHidden = true
        gameViewModel.viewDelegate = gameViewController
        gameViewModel.coordinatorDelegate = self
        presenter.pushViewController(gameViewController, animated: true)
    }
    
    func EndGameTapped() {
        initScreenViewModel?.viewWasLoaded()
    }
}

extension InitScreenCoordinator: GameCoordinatorDelegate {
    func gameExitButtonTapped() {
        // save score
        presenter.popViewController(animated: true)
        initScreenViewModel?.coordinatorDelegate?.EndGameTapped()
    }
    
    
}
