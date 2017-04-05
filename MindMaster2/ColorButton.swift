//
//  ColorButton.swift
//  MindMaster2
//
//  Created by Julien Dargelos on 07/02/2017.
//  Copyright © 2017 Julien Dargelos. All rights reserved.
//

import UIKit

// Bouton de couleur
class ColorButton: UIButton {
	// Incrément permettant de définir automatiquement la couleur d'un bouton selon les couleurs déjà utilisées 
	static var incColor = 0
	// Index de la couleur du bouton
	var color: Int = -1
	// Index du bouton (permet d'ordonancer les boutons pour qu'ils soit dans le même ordre que dans l'interface)
	var index: Int = 0
	
	// Index des couleurs des boutons
	static let none = -1
	static let red = 0
	static let yellow = 1
	static let green = 2
	static let blue = 3
	static let orange = 4
	static let white = 5
	static let magenta = 6
	static let purple = 7
	
	// Couleurs des boutons
	static let colors: Array<UIColor> = [
		UIColor.red,
		UIColor.yellow,
		UIColor.green,
		UIColor.blue,
		UIColor.orange,
		UIColor.white,
		UIColor.magenta,
		UIColor.purple
	]
	
	// Retourne une couleur selon son index, et gris si elle n'existe pas (none == -1 par exemple qui n'est pas présent dans le tableau)
	static func at(_ color: Int) -> UIColor {
		if(color >= 0 && color < colors.count) {
			return colors[color];
		}
		else {
			return UIColor.gray
		}
	}
	
	// Définition de la couleur du bouton selon son index
	func palette(_ color: Int) {
		var colors = type(of: self).colors
		
		// Si la couleur existe, elle est utilisée pour colorer le bouton et l'index de la couleur du bouton est mis à jour
		if color >= 0 && color < colors.count {
			self.color = color
			self.setTitleColor(colors[color], for: UIControlState.normal)
		}
		else {
			// Si la couleur n'existe pas, l'index de none est aloué au bouton et il est coloré en gris
			self.color = -1
			self.setTitleColor(UIColor(displayP3Red: 0, green: 0, blue: 0, alpha: 0.3), for: UIControlState.normal)
		}
	}
	
	// Réinitialisation de la couleur du bouton (avec none)
	func clear() {
		self.palette(type(of: self).none)
	}
	
	// Définition automatique de la couleur d'un bouton en fonction des couleurs déjà utilisées (permet de définir automatiquement les couleurs de la palette)
	func inc() {
		var incColor = type(of: self).incColor
		let colors = type(of: self).colors
		
		self.palette(incColor)
		
		incColor += 1
		if incColor >= colors.count {
			incColor = 0
		}
		
		type(of: self).incColor = incColor
	}
	
	// Position du bouton sur l'axe horizontal
	func offset() -> Int {
		return Int(self.frame.origin.x)
	}
	
	// Sélectionne/déselectionne un bouton avec une animation
	func selected(_ selected: Bool) {
		let scale: CGFloat = selected ? 1.4 : 1
		
		UIView.animate(withDuration: 0.2, animations: {
			self.transform = CGAffineTransform(scaleX: scale, y: scale)
		})
	}
	
	// Ordonancement d'un tableau de boutons selon leur position sur l'axe horizontal. Permet de ranger les boutons dans le même ordre que dans l'interface
	static func order(_ buttons: Array<ColorButton>) -> Array<ColorButton> {
		let ordered: Array<ColorButton> = buttons.sorted(by: { $1.offset() > $0.offset() })
		
		for (index, button) in ordered.enumerated() {
			button.index = index
		}
		
		return ordered
	}
}
