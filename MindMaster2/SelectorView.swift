//
//  SelectorView.swift
//  MindMaster2
//
//  Created by Julien Dargelos on 07/02/2017.
//  Copyright © 2017 Julien Dargelos. All rights reserved.
//

import UIKit

// Vue de sélection des couleurs
class SelectorView: UIVisualEffectView {
	// Hauteur de la vue lorsque la palette de couleurs est ouverte
	let openHeight: CGFloat = 105
	// Hauteur de la vue lorsque la palette de couleurs est fermée
	let closedHeight: CGFloat = 64
	// État de la vue (1 fermée, -1 ouverte)
	var direction: Int = 1
	
	// Retourne un rectangle en fonction de l'état de la vue (ouverte ou fermée)
	func frameTo(_ direction: CGFloat) -> CGRect {
		return CGRect(
			x: self.frame.origin.x,
			y: self.frame.origin.y+direction*(self.openHeight-self.closedHeight),
			width: self.frame.width,
			height: direction == -1 ? self.openHeight : self.closedHeight
		)
	}
	
	// Modification de l'état de la vue en fonction du tableau des boutons de la palette de couleurs (afin de les animer)
	func toggle(_ to: CGFloat, palette: Array<ColorButton>) {
		// Si l'état indiqué est égal à l'état actuel, rien n'est modifié
		if to != CGFloat(self.direction) {
			self.direction = Int(to)
			
			// Calcul du rectangle définissant la position et les dimensions de la vue
			let frame = self.frameTo(CGFloat(direction))
			// Calcul de l'opacité des boutons de la palette de couleurs (0 si la vue est fermée, 1 si elle est ouverte)
			let alpha: CGFloat = to == -1 ? 1 : 0
			// Interval en seconde de l'animation entre les boutons de la palette de couleurs
			let delta: TimeInterval = 0.03
			// Durée en seconde de l'animation d'un bouton de la palette de couleur (moins long lors de la fermeture)
			let duration: TimeInterval = to == -1 ? 0.4 : 0.1
			
			// Animation du changement de dimension de la vue
			UIView.animate(withDuration: 0.15, delay: to == -1 ? 0 : 0.1, options: UIViewAnimationOptions(), animations: {
				self.frame = frame
			})
			
			// Animation progressive de l'opcacité des boutons de la palette de couleurs
			for (i, button) in palette.enumerated() {
				UIView.animate(withDuration: duration, delay: delta*Double(i), options: UIViewAnimationOptions(), animations: {
					button.alpha = alpha
				})
			}
		}
	}
	
	// Ouverture de la vue
	func open(palette: Array<ColorButton>) {
		self.toggle(-1, palette: palette)
	}
	
	// Fermeture de la vue
	func close(palette: Array<ColorButton>) {
		self.toggle(1, palette: palette)
	}
}
