//
//  ViewController.swift
//  MindMaster2
//
//  Created by Julien Dargelos on 06/02/2017.
//  Copyright © 2017 Julien Dargelos. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
	override func viewDidLoad() {
		super.viewDidLoad()
	}

	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}

	// Initialisation de l'arrière-plan animé en utilisant la classe GradientView
	func setBackground(_ view: GradientView) {
		// Définition des couleurs de l'arrière-plan
		view.colors = [
			UIColor(displayP3Red: 0, green: 0, blue: 255, alpha: 0.3),
			UIColor(displayP3Red: 0, green: 255, blue: 255, alpha: 0.3),
			UIColor(displayP3Red: 0, green: 255, blue: 0, alpha: 0.3),
			UIColor(displayP3Red: 255, green: 255, blue: 0, alpha: 0.3),
			UIColor(displayP3Red: 255, green: 0, blue: 0, alpha: 0.3),
			UIColor(displayP3Red: 128, green: 0, blue: 128, alpha: 0.3)
		]
		
		// Activation de l'animation
		view.play()
	}
}

