//
//  HeaderView.swift
//  MindMaster2
//
//  Created by Julien Dargelos on 10/02/2017.
//  Copyright © 2017 Julien Dargelos. All rights reserved.
//

import UIKit

// Vue d'entête
class HeaderView: UIVisualEffectView {
	// Hauteur de la barre de status
	let statusBarHeight: CGFloat = 16
	// Hauteur de la vue en portait
	let portraitHeight: CGFloat = 64
	// Hauteur de la vue en paysage
	let landscapeHeight: CGFloat = 44
	
	// Mise à jour de la hauteur de la vue selon l'orientation du support
	func toggle(_ direction: CGFloat) {
		self.frame = CGRect(
			x: 0,
			y: 0,
			width: self.frame.width,
			height: self.height(for: direction)
		)
	}
	
	// Retourne la hauteur de la vue selon l'orientation indiquée
	func height(for direction: CGFloat) -> CGFloat {
		return direction == -1 ? self.landscapeHeight : self.portraitHeight
	}
}
