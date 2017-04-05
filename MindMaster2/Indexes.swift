//
//  Indexes.swift
//  MindMaster2
//
//  Created by Julien Dargelos on 07/02/2017.
//  Copyright © 2017 Julien Dargelos. All rights reserved.
//

import UIKit

// Indexes
class Indexes: NSObject {
	// Tableau d'indexes
	var indexes: Array<Int> = []
	
	// Indique si un index se trouve dans le tableau d'indexes
	func include(_ value: Int) -> Bool {
		for (_, index) in self.indexes.enumerated() {
			if value == index {
				return true
			}
		}
		
		return false
	}
	
	// Ajoute un index dans le tableau d'indexes
	func add(_ index: Int) {
		if !self.include(index) {
			self.indexes.append(index)
		}
	}
}
