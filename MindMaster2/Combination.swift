//
//  Combination.swift
//  MindMaster2
//
//  Created by Julien Dargelos on 07/02/2017.
//  Copyright © 2017 Julien Dargelos. All rights reserved.
//

import UIKit

// Combinaison de couleurs
class Combination: NSObject {
	// Nombre de valeurs dans une combinaison
	static let length = 4
	// Nombre total de valeurs
	static let max = 8
	
	// Valeurs de la combinaison (par défaut à -1)
	var values: Array<Int> = Array(repeating: -1, count: length)
	
	// Définition des valeurs de la combinaison avec un tableau de Color Button
	func set(buttons: Array<ColorButton>) {
		let length = self.values.count
		
		// Attribution des valeurs
		// S'il n'y en a pas assez, seules celles fournies seront utilisées et les autres resteront à leur valeur précédente
		// S'il il y en a trop, seules les length premières couleurs seront utilisées
		for (i, button) in buttons.enumerated() {
			if i < length {
				self.values[i] = button.color
			}
			else {
				break
			}
		}
	}
	
	// Indique si la combinaison est entièrement remplie (s'il n'y a pas de valeurs à -1)
	func filled() -> Bool {
		for (_, value) in self.values.enumerated() {
			if value < 0 {
				return false
			}
		}
		
		return true
	}
	
	// Randomise la combinaison
	func rand() {
		// Nombre maximal qu'une valeur peut prendre (le minimum est 0, -1 indique qu'elle est vide)
		let max = type(of: self).max - 1
		
		// Pour chaque valeur de la combinaison, on attribue un entier aléatoire entre 0 et max
		for (i, _) in self.values.enumerated() {
			self.values[i] = Int(arc4random_uniform(UInt32(max)))
		}
	}
	
	// Valeur de la combinaison à l'index fournis
	func at(_ index: Int) -> Int {
		return self.values[index];
	}
	
	// Comparaison de la combinaison avec une autre combinaison
	func control(_ combination: Combination) -> Result {
		// Indexes déjà comparés
		let indexes = Indexes()
		// Résultat de la comparaison
		let result = Result()
		// Histogramme de valeurs
		let amounts = Amounts()
		
		// Pour chaque valeur de la combinaison courante
		for (i, value) in self.values.enumerated() {
			if value == combination.at(i) {
				// Si la valeur est égale à celle au même index dans la combinaison comparée, on ajoute un bien placé, et on ajoute l'index dans le tableau des index comparés
				result.addWellPlaced()
				indexes.add(i)
			}
			else {
				// Sinon, on ajoute la valeur à l'histogramme
				amounts.increase(value)
			}
		}
		
		// Pour chaque valeur de la combinaison comparée
		for (i, value) in combination.values.enumerated() {
			if !indexes.include(i) && amounts.present(value) {
				// Si l'index n'est pas parmi les index déjà comparé, et que la valeur est dans l'histogramme au moins une fois, on ajoute un mal placé, et on retire une fois la valeur dans l'histogramme
				result.addWrongPlaced()
				amounts.decrease(value)
			}
		}
		
		return result
	}
	
	// Comparaison de la combinaison directement avec un tableau de bouton
	func control(buttons: Array<ColorButton>) -> Result {
		// Création d'une nouvelle combinaison avec les boutons indiqués, puis comparaison avec la combinaison courante
		let combination = Combination()
		combination.set(buttons: buttons)
		return self.control(combination)
	}
	
	// Transformation de la combinaison en chaîne de caractère colorée selon ses valeurs
	func string() -> NSMutableAttributedString {
		// Création d'une chaîne avec des attributs de style
		let string = NSMutableAttributedString()
		
		// Pour chaque valeur de la combinaison
		for (_, value) in self.values.enumerated() {
			// On ajoute un caractère • de la couleur correspondante
			string.append(NSAttributedString(string: "• ", attributes: [
				NSForegroundColorAttributeName: ColorButton.at(value),
				NSFontAttributeName: UIFont(name: "Helvetica", size: 50.0)!
			]))
		}
		
		return string
	}
}
