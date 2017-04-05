//
//  History.swift
//  MindMaster2
//
//  Created by Julien Dargelos on 10/02/2017.
//  Copyright © 2017 Julien Dargelos. All rights reserved.
//

import UIKit

// Historique d'essais
class History: NSObject {
	// Nombre maximum d'essais
	static let max = 20
	// tableau de tentatives
	var attempts: Array<Attempt> = []
	
	// Ajout d'un essai dans l'historique avec une instance de Attempt
	func append(_ attempt: Attempt) {
		// Ajout de l'objet dans le tableau de tentatives
		attempts.append(attempt)
	}
	
	// Ajout d'un essai dans l'historique avec une instance de Combination et une autre de Result
	func append(combination: Combination, result: Result) {
		// Création d'une instance de Attempt avec les objets fournis, puis ajout dans le tableau de tentatives
		self.append(Attempt(combination: combination, result: result))
	}
	
	// Retourne vrai si l'historique est vide
	func empty() -> Bool {
		return self.attempts.count <= 0
	}
	
	// Retourne le nombre de tentatives dans l'historique
	func count() -> Int {
		return self.attempts.count
	}
	
	// Retourne la tentative à l'index indiqué
	func get(_ index: Int) -> Attempt {
		return self.attempts[index];
	}
	
	// Retourne la dernière tentative de l'historique s'il y en a une
	func last() -> Attempt? {
		if self.empty() {
			return nil
		}
		else {
			return self.attempts[self.attempts.count - 1]
		}
	}
	
	// Indique si la dernière tentative de l'historique est concluante
	func success() -> Bool {
		if self.empty() {
			return false
		}
		else {
			return self.last()!.success()
		}
	}
	
	// Indique si le nombre de tentatives de l'historique est supérieur ou égal au maximum
	func fail() -> Bool {
		return self.count() >= type(of: self).max
	}
}
