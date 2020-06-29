//
//  Plane.swift
//  ARBillboad
//
//  Created by Oscar Izquierdo on 04/06/2020.
//  Copyright © 2020 Oscar Izquierdo. All rights reserved.
//

import ARKit

class Plane: SCNNode {
    
    var id: Int = 0
    
    init(withId: Int) {
        super.init()
        self.id = withId
        let plane = SCNScene(named: "ship.scn") ?? SCNScene()
        let node = plane.rootNode
        self.addChildNode(node)
        
        
        //Añadimos físicas al avión
        let shape = SCNPhysicsShape(node: node, options: nil)
        self.physicsBody = SCNPhysicsBody(type: .static, shape: shape)
        self.physicsBody?.isAffectedByGravity = false
        
        //identificador de nuestro objeto para las colisiones
        self.physicsBody?.categoryBitMask = Collisions.plane.rawValue
        
        //Especificamos los objectos contra los que puede colisionar
        self.physicsBody?.contactTestBitMask = Collisions.bullet.rawValue
        
        
        //Animar el avión un pquito
        
        let moveForward = SCNAction.moveBy(x: 0, y: 0, z: 0.3, duration: 2)
        //let hoverDown = SCNAction.moveBy(x: 0, y: -0.2, z: 0, duration: 2.5)
        let moveSequence = SCNAction.sequence([moveForward])
        let moveTime = SCNAction.repeat(moveSequence, count: 5)
        //self.runAction(hoverForever)
        self.runAction(moveTime) {
            DispatchQueue.main.async {
                 let noteName = Notification.Name(rawValue: "PlaneCollitionWithUser")
                                      NotificationCenter.default.post(name: noteName, object: nil)
            }
        }
        
    }
    
    required init?(coder aDecoder: NSCoder) { fatalError() }
    
    func face(to objectOrientation: simd_float4x4) {
        var transform = objectOrientation
        transform.columns.3.x = self.position.x
        transform.columns.3.y = self.position.y
        transform.columns.3.z = self.position.z
        self.transform = SCNMatrix4(transform)
        
    }
}
