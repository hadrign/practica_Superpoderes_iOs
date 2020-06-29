//
//  GameViewController.swift
//  Kamikaze War
//
//  Created by Hadrian Grille Negreira on 12/06/2020.
//  Copyright © 2020 Hadrian Grille Negreira. All rights reserved.
//

import UIKit
import ARKit

class GameViewController: UIViewController {
    
    @IBOutlet weak var sceneView: ARSCNView!
    @IBOutlet weak var btnExit: UIButton!
    @IBOutlet weak var currentScore: UILabel!
    @IBOutlet weak var btnSuperbullet: UIButton!
    @IBOutlet weak var btnBullet: UIButton!
    
    let viewModel: GameViewModel
    var score: Int = 0
    var plane: [Plane] = []
    var boxes: [Box] = []
    var healthBar: [HealthBar] = []
    var superBulletNumber = 0
    var idPlane: Int = 0
    var showBox: Bool = false
    var superBulletSelected: Bool = false
    var planeHealth: Int = 0
    var damage: Int = 0
    var shot: Bool = false
    fileprivate let velocity: Float = 1
    
    init(viewModel: GameViewModel) {
        self.viewModel = viewModel
        super.init(nibName: "Game", bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        btnBullet.layer.borderWidth = 4
        btnBullet.layer.borderColor = UIColor.blue.cgColor
        setupComponents()
        setupNotifications()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        sceneView.session.pause()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        addNewPlane(quantity: 1)
        addNewBox()
    }
    
    fileprivate func setupComponents() {
        let configuration = ARWorldTrackingConfiguration()
        sceneView.session.run(configuration)
        sceneView.session.delegate = self
        
        //tenemos que indicar que se nos avise cuando haya el contacto
        sceneView.scene.physicsWorld.contactDelegate = self
    }
    
    func setupNotifications() {
        let noteName = Notification.Name(rawValue: "PlaneCollitionWithUser")
               NotificationCenter.default.addObserver(self, selector: #selector(self.planeCollitionWithUser), name: noteName, object: nil)
    }
    
    @objc func planeCollitionWithUser() {
        self.viewModel.exitButtonTapped(CurrentScore: self.score)
    }
    
    private func addNewPlane(quantity: Int) {

        let plane = Plane(withId: self.idPlane)
        let x = CGFloat.random(in: -1...1)
        let y = CGFloat.random(in: -1...1)
        let z = CGFloat.random(in: -2 ... -1)
        self.idPlane += 1
        plane.position = SCNVector3(x, y, z)
        self.plane.append(plane)
        
        self.sceneView.prepare([plane]) {_ in
            self.sceneView.scene.rootNode.addChildNode(plane)
            
        }
        self.planeHealth = Int.random(in: 1 ... 10)
        print("******** self.planeHealth: \(self.planeHealth)")
        addHealthBar(in: plane.position)
    }
    
    private func addHealthBar (in position: SCNVector3) {
        let healthBar = HealthBar(health: self.planeHealth)
        healthBar.position = SCNVector3(position.x, position.y + 0.15, position.z)
        self.healthBar.append(healthBar)
        
        self.sceneView.prepare([healthBar]) {_ in
            self.sceneView.scene.rootNode.addChildNode(healthBar)
            
        }
        
    }
    
    private func addNewBox() {
        let box = Box()
        let x = CGFloat.random(in: -1...1)
        let y = CGFloat.random(in: -1...1)
        let z = CGFloat.random(in: -2 ... -1)
        box.position = SCNVector3(x, y, z)
        self.boxes.append(box)
        
        self.sceneView.prepare([box]) {_ in
            self.sceneView.scene.rootNode.addChildNode(box)
        }

    }
    
    
    @IBAction func bulletx1Selected(_ sender: Any) {
        btnBullet.layer.borderWidth = 4
        btnBullet.layer.borderColor = UIColor.blue.cgColor
        btnSuperbullet.layer.borderWidth = 0
        self.superBulletSelected = false
    }
    @IBAction func bulletx2Selected(_ sender: Any) {
        if superBulletNumber > 0 {
            btnSuperbullet.layer.borderWidth = 4
            btnSuperbullet.layer.borderColor = UIColor.red.cgColor
            self.superBulletSelected = true
            btnBullet.layer.borderWidth = 0
        }
    }
    
    
    
    @IBAction func tapScreen(_ sender: Any) {
        guard let camera = self.sceneView.session.currentFrame?.camera else { return }
        //aqui comprobar que bala tiene seleccionda, si tiene munición y lanzarla.
        // si no dispone de munición cambiar de bala y lanzar de la que si hay
        if self.superBulletSelected && self.superBulletNumber > 0 {
            let superBullet = Superbullet(camera)
            sceneView.scene.rootNode.addChildNode(superBullet)
            self.superBulletNumber -= 1
            self.shot = true
            DispatchQueue.main.async {
                self.btnSuperbullet.setTitle("Bullet x2: \(self.superBulletNumber)", for: .normal)
            }
        } else {
            let bullet = Bullet(camera)
            sceneView.scene.rootNode.addChildNode(bullet)
            btnBullet.layer.borderWidth = 2
            btnBullet.layer.borderColor = UIColor.blue.cgColor
            btnSuperbullet.layer.borderWidth = 0
            self.superBulletSelected = false
            self.shot = true
        }
        

    }
    
    
    @IBAction func exitButtonTapped(_ sender: Any) {
        let alert = UIAlertController(title: "Seguro que quiere salir?", message: "Pulsa Si para salir y No para continuar con la partida", preferredStyle: .alert)

        alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { action in
            self.viewModel.exitButtonTapped(CurrentScore: self.score)
        }))
        alert.addAction(UIAlertAction(title: "No", style: .cancel, handler: nil))

        self.present(alert, animated: true)
    }
}


//MARK: - Contact delegate
extension GameViewController: SCNPhysicsContactDelegate {
    
    func physicsWorld(_ world: SCNPhysicsWorld, didBegin contact: SCNPhysicsContact) {
        //Si algo choca con el avión
        if contact.nodeA.physicsBody?.categoryBitMask == Collisions.plane.rawValue || contact.nodeB.physicsBody?.categoryBitMask == Collisions.plane.rawValue {
            var idPlane = 0
            var node: SCNNode!
            if contact.nodeA is Plane {
                node = contact.nodeA
                let plane = contact.nodeA as! Plane
                idPlane = plane.id
                if contact.nodeB is Bullet {
                    self.damage = 1
                } else if contact.nodeB is Superbullet {
                    self.damage = 2
                }
            }
            if contact.nodeB is Plane {
                node = contact.nodeB
                let plane = contact.nodeB as! Plane
                idPlane = plane.id
                if contact.nodeA is Bullet {
                    self.damage = 1
                } else if contact.nodeA is Superbullet {
                    self.damage = 2
                }
            }
            
            if shot {
                self.planeHealth -= self.damage
                self.shot = false
                if self.planeHealth <= 0 {
                    //Explossion
                    Explossion.show(with: node, in: sceneView.scene)
                    
                    self.sceneView.scene.rootNode.childNodes.forEach {
                        if $0 is Plane {
                            let plane = $0 as! Plane
                            if plane.id == idPlane {
                                $0.removeFromParentNode()
                                self.plane.removeAll()
                                self.score += 5
                                DispatchQueue.main.async {
                                    self.currentScore.text = "Score: \(self.score)"
                                }
                                
                            }
                        } else if $0 is HealthBar {
                            $0.removeFromParentNode()
                            healthBar.removeAll()
                            self.damage = 0
                        }
                    }
                    //cargamos un nuevo avión
                    self.addNewPlane(quantity: 1)
                    //Cargamos una nueva Box si no existe ninguna
                    if self.showBox && boxes.count == 0 {
                        self.addNewBox()
                    } else {
                        self.showBox = true
                    }
                } else {
                    self.sceneView.scene.rootNode.childNodes.forEach {
                        if $0 is HealthBar {
                            $0.removeFromParentNode()
                            healthBar.removeAll()
                            DispatchQueue.main.async {
                                self.addHealthBar(in: self.plane[0].position)
                            }
                        }
                    }
                }
            } else {
                
            }
            
            
        } else if contact.nodeA.physicsBody?.categoryBitMask == Collisions.box.rawValue || contact.nodeB.physicsBody?.categoryBitMask == Collisions.box.rawValue {
            
            var node: SCNNode!
            if contact.nodeA is Box {
                node = contact.nodeA
                //let box = contact.nodeA as! Box
            }
            if contact.nodeB is Box {
                node = contact.nodeB
                //let box = contact.nodeB as! Box
            }
            
            //Explossion
            Explossion.show(with: node, in: sceneView.scene)
            
            self.sceneView.scene.rootNode.childNodes.forEach {
                if $0 is Box {
                    //let box = $0 as! Box
                    $0.removeFromParentNode()
                    self.superBulletNumber += 2
                    self.showBox = false
                    self.boxes.removeAll()
                    DispatchQueue.main.async {
                        self.btnSuperbullet.setTitle("Bullet x2: \(self.superBulletNumber)", for: .normal)
                    }
                }
            }
            
        }
    }
    
}

//MARK: - ARSCNViewDelegate
extension GameViewController: ARSessionDelegate {
    func session(_ session: ARSession, didUpdate frame: ARFrame) {
        if let cameraOrientation = session.currentFrame?.camera.transform {
            self.plane.forEach { $0.face(to: cameraOrientation) }
            self.healthBar.forEach { $0.face(to: cameraOrientation) }
        }
    }
}

extension GameViewController: GameViewDelegate {
    
}
