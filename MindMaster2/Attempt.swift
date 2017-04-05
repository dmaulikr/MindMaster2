//
//  Attempt.swift
//  MindMaster2
//
//  Created by Julien Dargelos on 10/02/2017.
//  Copyright © 2017 Julien Dargelos. All rights reserved.
//

import UIKit

// Tentative
class Attempt: NSObject {
	// Combinaison de la tentative
	var combination: Combination
	// Résultat de la tentative
	var result: Result
	
	// Initialisation de la tentative avec une combinaison et un résultat, puis allocation aux attributs de l'instance
	init(combination: Combination, result: Result) {
		self.combination = combination
		self.result = result
	}
	
	// Retourne true si la tentative est un succès
	func success() -> Bool {
		return self.result.success()
	}
}
