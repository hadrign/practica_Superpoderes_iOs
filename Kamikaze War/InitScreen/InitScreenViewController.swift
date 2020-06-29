//
//  InitScreenViewController.swift
//  Kamikaze War
//
//  Created by Hadrian Grille Negreira on 12/06/2020.
//  Copyright © 2020 Hadrian Grille Negreira. All rights reserved.
//

import UIKit

class InitScreenViewController: UIViewController {
    
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var startBtn: UIButton!
    
    let viewModel: InitScreenViewModel
    
    init(viewModel: InitScreenViewModel) {
        self.viewModel = viewModel
        super.init(nibName: "InitScreen", bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        startBtn.layer.cornerRadius = 10
        viewModel.viewWasLoaded()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        //viewModel.viewWasLoaded()
    }
    
    @IBAction func fireStartGame(_ sender: Any) {
        viewModel.startGame()
    }
    
}

extension InitScreenViewController: InitScreenViewDelegate {
    func ScoreFetched(score: String?) {
        scoreLabel.text = "\(score ?? "00")"
    }
    
    
}
