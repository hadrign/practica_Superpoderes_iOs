//
//  Coordinator.swift
//  CreateMVVM
//  Kamikaze War
//
//  Created by Hadrian Grille Negreira on 12/06/2020.
//  Copyright © 2020 Hadrian Grille Negreira. All rights reserved.

import Foundation

/// Clase base de todo cooridnator. Los hijos deben implementar obligatoriamente start() y finish()
class Coordinator {
    fileprivate var childCoordinators: [Coordinator] = []

    func start() {
        preconditionFailure("This method needs to be overriden by concrete subclass.")
    }

    func finish() {
        preconditionFailure("This method needs to be overriden by concrete subclass.")
    }

    func addChildCoordinator(_ coordinator: Coordinator) {
        childCoordinators.append(coordinator)
    }

    func removeChildCoordinator(_ coordinator: Coordinator) {
        if let index = childCoordinators.firstIndex(of: coordinator) {
            childCoordinators.remove(at: index)
        } else {
            print("Couldn't remove coordinator: \(coordinator). It's not a child coordinator.")
        }
    }

    func removeAllChildCoordinatorsWith<T>(type: T.Type) {
        childCoordinators = childCoordinators.filter { $0 is T  == false }
    }

    func removeAllChildCoordinators() {
        childCoordinators.removeAll()
    }
}

extension Coordinator: Equatable {

    static func == (lhs: Coordinator, rhs: Coordinator) -> Bool {
        return lhs === rhs
    }

}
