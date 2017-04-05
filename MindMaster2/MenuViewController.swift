//
//  MenuViewController.swift
//  MindMaster2
//
//  Created by Julien Dargelos on 06/02/2017.
//  Copyright © 2017 Julien Dargelos. All rights reserved.
//

import UIKit

class MenuViewController: ViewController {

	// Déclaration des références des éléments d'interface
	@IBOutlet var gradientView: GradientView!
	@IBOutlet weak var playButtonView: UIVisualEffectView!
	
    override func viewDidLoad() {
        super.viewDidLoad()
		
		// Initialisation de l'arrière-plan
		setBackground(gradientView)
		
		// Initialisation du bouton play
		setPlayButton()		
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
	
	// Initialisation du bouton play (bords arrondis)
	func setPlayButton() {
		playButtonView.layer.cornerRadius = 10
		playButtonView.layer.masksToBounds = true
	}
}
