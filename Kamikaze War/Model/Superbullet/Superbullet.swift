//
//  Superbullet.swift
//  Kamikaze War
//
//  Created by Hadrian Grille Negreira on 20/06/2020.
//  Copyright © 2020 Hadrian Grille Negreira. All rights reserved.
//

import ARKit

class Superbullet: SCNNode {
    fileprivate let velocity: Float = 9
    
    init(_ camera: ARCamera) {
        super.init()
        
        //No usaremos la bala suministrada, crearemos una esfera
        let superbullet = SCNSphere(radius: 0.02)
        let material = SCNMaterial()
        material.diffuse.contents = UIColor.red
        superbullet.materials = [material]
        self.geometry = superbullet
        
        //Añadimos las físicas
        let shape = SCNPhysicsShape(geometry: superbullet, options: nil)
        self.physicsBody = SCNPhysicsBody(type: .dynamic, shape: shape)
        self.physicsBody?.isAffectedByGravity = false
        
        self.physicsBody?.categoryBitMask = Collisions.bullet.rawValue
        
        self.physicsBody?.contactTestBitMask = Collisions.plane.rawValue
        self.physicsBody?.contactTestBitMask = Collisions.box.rawValue
        
        // Aplicamos impulso a la bala
        let matrix = SCNMatrix4(camera.transform)
        //Vector de direccion (También lleva incluida la velocidad)
        let v = -self.velocity
        let dir = SCNVector3(v * matrix.m31, v * matrix.m32, v * matrix.m33)
        //Necesitamos un punto de origen
        let pos = SCNVector3(matrix.m41, matrix.m42, matrix.m43)
        
        self.physicsBody?.applyForce(dir, asImpulse: true)
        self.position = pos

    }
    
    required init?(coder aDecoder: NSCoder) {fatalError()}
    
}

