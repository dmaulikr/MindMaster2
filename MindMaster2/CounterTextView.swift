//
//  CounterTextView.swift
//  MindMaster2
//
//  Created by Julien Dargelos on 10/02/2017.
//  Copyright © 2017 Julien Dargelos. All rights reserved.
//

import UIKit

// Vue avec un compteur
class CounterTextView: UITextView {
	
	// Mise à jour du compteur avec la valeur indiquée
	func set(_ count: Int) {
		self.text = "♥︎ "+String(count)
	}
}
