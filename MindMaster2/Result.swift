//
//  Result.swift
//  MindMaster2
//
//  Created by Julien Dargelos on 07/02/2017.
//  Copyright © 2017 Julien Dargelos. All rights reserved.
//

import UIKit

// Résultat d'une comparaison
class Result: NSObject {
	// Nombre de bien placés
	var wellPlaced: Int = 0
	// Nombre de mal placés
	var wrongPlaced: Int = 0
	
	// Ajout d'un bien placé
	func addWellPlaced() {
		self.wellPlaced += 1
	}
	
	// Ajout d'un mal placé
	func addWrongPlaced() {
		self.wrongPlaced += 1
	}
	
	// Création d'un caractère ° coloré selon la couleur indiquée
	static func dot(_ color: UIColor) -> NSAttributedString {
		return NSAttributedString(string: "° ", attributes: [
			NSForegroundColorAttributeName: color,
			NSFontAttributeName: UIFont(name: "Helvetica", size: 32.0)!
		])
	}
	
	// Création d'un caractère ° représentant un bien placé
	func wellPlacedDot() -> NSAttributedString {
		return type(of: self).dot(UIColor.red)
	}
	
	// Création d'un caractère ° représentant un mal placé
	func wrongPlacedDot() -> NSAttributedString {
		return type(of: self).dot(UIColor.white)
	}
	
	// Création d'un chaine de caractère représentant le résultat avec des caractères ° colorés
	func string() -> NSMutableAttributedString {
		let string = NSMutableAttributedString()
		
		// On ajoute autant de caractères ° rouges qu'il y a de bien placés
		for _ in 0..<wellPlaced {
			string.append(self.wellPlacedDot())
		}
		
		// On ajoute autant de caractères ° blancs qu'il y a de mal placés
		for _ in 0..<wrongPlaced {
			string.append(self.wrongPlacedDot())
		}
		
		return string
	}
	
	// Retourne vrai si le résultat est un succès (si le nombre de bien placés est égal au nombre de valeurs d'une combinaison)
	func success() -> Bool {
		return self.wellPlaced == Combination.length
	}
}
