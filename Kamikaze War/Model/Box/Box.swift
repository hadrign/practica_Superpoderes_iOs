//
//  Box.swift
//  Kamikaze War
//
//  Created by Hadrian Grille Negreira on 20/06/2020.
//  Copyright © 2020 Hadrian Grille Negreira. All rights reserved.
//

import ARKit

class Box: SCNNode {
    
    override init() {
        super.init()
        
        //No usaremos la bala suministrada, crearemos una esfera
        let box = SCNBox(width: 0.1, height: 0.1, length: 0.1, chamferRadius: 0)
        let material = SCNMaterial()
        material.diffuse.contents = UIColor.green
        box.materials = [material]
        self.geometry = box
        
        //Añadimos las físicas
        let shape = SCNPhysicsShape(geometry: box, options: nil)
        self.physicsBody = SCNPhysicsBody(type: .dynamic, shape: shape)
        self.physicsBody?.isAffectedByGravity = false
        
        //identificador de nuestro objeto para las colisiones
        self.physicsBody?.categoryBitMask = Collisions.box.rawValue
        
        //Especificamos los objectos contra los que puede colisionar
        self.physicsBody?.contactTestBitMask = Collisions.bullet.rawValue
        
        //Animar la caja un pquito
        let hoverUp = SCNAction.moveBy(x: 0, y: 0.2, z: 0, duration: 2.5)
        let hoverDown = SCNAction.moveBy(x: 0, y: -0.2, z: 0, duration: 2.5)
        let hoverSequence = SCNAction.sequence([hoverUp, hoverDown])
        let hoverForever = SCNAction.repeatForever(hoverSequence)
        self.runAction(hoverForever)

    }
    
    required init?(coder aDecoder: NSCoder) {fatalError()}
    
    
}



