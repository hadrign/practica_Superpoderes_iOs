//
//  AppCoordinator.swift
//  Kamikaze War
//
//  Created by Hadrian Grille Negreira on 12/06/2020.
//  Copyright © 2020 Hadrian Grille Negreira. All rights reserved.

import UIKit

/// Coordinator principal de la app. Encapsula todas las interacciones con la Window.
/// Tiene dos hijos, el topic list, y el categories list (uno por cada tab)
class AppCoordinator: Coordinator {

    lazy var scoreDataManager: KamikazeWarDataManager = {
        let scoreDataManager = KamikazeWarDataManager()
        return scoreDataManager
    }()

    let window: UIWindow
    init(window: UIWindow) {
        self.window = window
    }

    override func start() {
        //Revisar, seguramente tengamos que crear solo la vista inicio aqui y llamar al coodinator desde la otra pantalla para cambiar
        
        let rootNavigationController = UINavigationController()
        let initScreenCoordinator = InitScreenCoordinator(presenter: rootNavigationController, dataManager: scoreDataManager)
        addChildCoordinator(initScreenCoordinator)
        initScreenCoordinator.start()
        
        rootNavigationController.navigationBar.isHidden = true
        //window.rootViewController = initScreenNavigationController
        
        window.rootViewController = rootNavigationController
        window.makeKeyAndVisible()
        //window.isHidden = false
    }

    override func finish() {}
}
