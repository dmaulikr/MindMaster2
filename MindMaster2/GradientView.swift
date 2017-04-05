//
//  GradientView.swift
//  MindMaster2
//
//  Created by Julien Dargelos on 06/02/2017.
//  Copyright © 2017 Julien Dargelos. All rights reserved.
//

import UIKit

// Vue avec dégradé animé
class GradientView: UIView {
	// Index de la dernière couleur courantes
	var lastElementIndex: Int = 0
	
	// Couleurs du dégradé
	var colors: Array<UIColor> = [] {
		didSet {
			lastElementIndex = colors.count - 1
		}
	}
	// Index de la couleur courante
	var index: Int = 0
	// Progression de l'animation entre deux couleurs (varie entre 0 et 1)
	var factor: CGFloat = 1
	
	// Dessin du dégradé
	override func draw(_ rect: CGRect) {
		// S'il n'y a que deux couleurs ou moins, impossible d'animer le dégradé
		if colors.count < 2 {
			return;
		}
		
		// Contexte graphique
		let context = UIGraphicsGetCurrentContext();
		context!.saveGState();
		
		// Composants du dégradé selon la couleur courante et la progression de l'animation
		var colorComponents: Array<CGFloat> = self.gradientColorComponents(at: index, factor: factor)

		// Dégradé construit avec les composants précédemment calculés
		let gradient = CGGradient(
			colorSpace: CGColorSpaceCreateDeviceRGB(),
			colorComponents: &colorComponents,
			locations: [0.0, 1.0],
			count: 2
		)

		// Ajout du dégradé sur la vue
		context!.drawLinearGradient(
			gradient!,
			start: CGPoint(x: 0.0, y: 0.0),
			end: CGPoint(x: rect.size.width, y: rect.size.height),
			options: CGGradientDrawingOptions.drawsAfterEndLocation
		)
		
		// Mise à jour du contexte graphique
		context!.restoreGState();
	}
	
	// Calcul des composants du dégradé selon un index de couleur et la progression de l'animation
	func gradientColorComponents(at: Int, factor: CGFloat) -> Array<CGFloat> {
		// Couleurs du dégradé
		let c: Array<Array<CGFloat>> = [
			self.colors[at == 0 ? (self.colors.count - 1) : at - 1].cgColor.components!,
			self.colors[at].cgColor.components!,
			self.colors[at == (self.colors.count - 1) ? 0 : at + 1].cgColor.components!,
		]
		
		// Composants du dégradé
		return [
			c[0][0] * (1 - factor) + c[1][0] * factor,
			c[0][1] * (1 - factor) + c[1][1] * factor,
			c[0][2] * (1 - factor) + c[1][2] * factor,
			c[0][3] * (1 - factor) + c[1][3] * factor,
			c[1][0] * (1 - factor) + c[2][0] * factor,
			c[1][1] * (1 - factor) + c[2][1] * factor,
			c[1][2] * (1 - factor) + c[2][2] * factor,
			c[1][3] * (1 - factor) + c[2][3] * factor
		]
	}
	
	// Instance de CADisplayLink permettant de synchroniser l'animation avec la fréquence de rafraichissement de l'écran
	lazy var displayLink: CADisplayLink = {
		let displayLink: CADisplayLink = CADisplayLink(target: self, selector: #selector(self.screenUpdated))
		displayLink.add(to: RunLoop.main, forMode: RunLoopMode.commonModes)
		displayLink.isPaused = true
		return displayLink
	}()
	
	// Méthode appelée lorsque l'écran a été rafraichi
	func screenUpdated(displayLink: CADisplayLink) {
		// Mise à jour de la progression de l'animation
		self.factor += CGFloat(displayLink.duration)
		
		// Si la progression est supérieure à 1, elle revient à 0 et la couleur courante passe à la suivante
		if(self.factor > 1) {
			index = index+1 >= colors.count ? 0 : index+1
			factor = 0
		}
		
		// Indique que la vue doit être redessinée
		self.setNeedsDisplay()
	}
	
	// Activation de l'animation
	func play() {
		self.displayLink.isPaused = false
	}
	
	// Désactivation de l'animation
	func pause() {
		self.displayLink.isPaused = true
	}
}
