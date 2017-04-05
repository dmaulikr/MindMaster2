//
//  Amounts.swift
//  MindMaster2
//
//  Created by Julien Dargelos on 07/02/2017.
//  Copyright © 2017 Julien Dargelos. All rights reserved.
//

import UIKit

// Histogramme de valeurs
class Amounts: NSObject {
	// Tableau de valeurs
	var amounts: Array<Int> = Array(repeating: 0, count: Combination.max)
	
	// Incrémente une valeur dans l'histogramme
	func increase(_ color: Int) {
		if self.inRange(color) {
			amounts[color] += 1
		}
	}
	
	// Décrémente une valeur dans l'histogramme
	func decrease(_ color: Int) {
		if self.inRange(color) {
			amounts[color] -= 1
		}
	}
	
	// Indique si une valeur apparaît au moins une fois dans l'histogramme
	func present(_ color: Int) -> Bool {
		if self.inRange(color) {
			return self.amounts[color] > 0
		}
		else {
			return false
		}
	}
	
	// Indique si une valeur appartient à l'ensemble admis par l'histogramme
	func inRange(_ color: Int) -> Bool {
		return color >= 0 && color < self.amounts.count
	}
}
