//
//  HealthBar.swift
//  Kamikaze War
//
//  Created by Hadrian Grille Negreira on 28/06/2020.
//  Copyright © 2020 Hadrian Grille Negreira. All rights reserved.
//

import ARKit
import UIKit

class HealthBar: SCNNode {
    
    var width: Int = 0
    
    init(health width: Int) {
        super.init()
        
        self.width = width
        let healthBar = SCNPlane(width: CGFloat(width)/10, height: 0.01)
        let material = SCNMaterial()
        material.diffuse.contents = UIColor.green
        healthBar.materials = [material]
        self.geometry = healthBar
        
        //Añadimos las físicas
        let shape = SCNPhysicsShape(geometry: healthBar, options: nil)
        self.physicsBody = SCNPhysicsBody(type: .dynamic, shape: shape)
        self.physicsBody?.isAffectedByGravity = false
        
        let moveForward = SCNAction.moveBy(x: 0, y: 0, z: 0.3, duration: 2)
        let moveSequence = SCNAction.sequence([moveForward])
        let moveTime = SCNAction.repeat(moveSequence, count: 5)
        self.runAction(moveTime)
    }
    
    required init?(coder aDecoder: NSCoder) {fatalError()}
    
    func face(to objectOrientation: simd_float4x4) {
        var transform = objectOrientation
        transform.columns.3.x = self.position.x
        transform.columns.3.y = self.position.y
        transform.columns.3.z = self.position.z
        self.transform = SCNMatrix4(transform)
    }
    
    func modifywidth(to currentWidth: Int) {
        
    }
    
}
