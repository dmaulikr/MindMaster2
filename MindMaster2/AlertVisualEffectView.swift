//
//  AlertVisualEffectView.swift
//  MindMaster2
//
//  Created by Julien Dargelos on 10/02/2017.
//  Copyright © 2017 Julien Dargelos. All rights reserved.
//

import UIKit
import AudioToolbox

// Vue d'alerte
class AlertVisualEffectView: UIVisualEffectView, UIGestureRecognizerDelegate {
	
	// Text View utilisée pour afficher le message, définition des styles
	var messageTextView: UITextView = {
		let messageTextView = UITextView(frame: CGRect(x: 0, y: 0, width: 300, height: 50))
		messageTextView.backgroundColor = UIColor(displayP3Red: 0, green: 0, blue: 0, alpha: 0)
		messageTextView.textAlignment = NSTextAlignment.center
		messageTextView.font = UIFont(name: "Helvetica", size: 40)
		messageTextView.textColor = UIColor.white
		messageTextView.isScrollEnabled = false
		messageTextView.isEditable = false
		messageTextView.isSelectable = false
		
		return messageTextView
	}()
	// Méthode appelée lorsque l'alerte est fermée par l'utilisateur
	var handler: (() -> Bool)? = nil
	// Indique les évènements de la vue ont déjà été définis
	var eventSet = false
	
	// Initialisation de la vue
	func initialize() {
		// Par défaut l'alerte n'est pas affichée
		self.isHidden = true
		// Son opacité est nulle
		self.alpha = 0
		// Elle est placée devant toutes les autres vues
		self.layer.zPosition = 100
		
		// Application d'un effet de flou sur la vue
		self.effect = UIBlurEffect(style: UIBlurEffectStyle.dark)
		self.frame = (self.superview?.bounds)!
		self.autoresizingMask = [.flexibleWidth, .flexibleHeight]
		
		// Ajout de la Text View dans la vue d'alerte
		self.addSubview(self.messageTextView)
	}
	
	// Ouverture de la vue d'alerte avec un message à afficher et une méthode à exécuter lors de la réponse utilisateur (optionnelle)
	func open(_ message: String, handler: (() -> Bool)? = nil) {
		// Mise à jour du texte de la Text View avec le message indiqué
		self.messageTextView.text = message
		
		// Ajout de l'évènement touch sur la vue pour que l'utilisateur puisse la fermer
		self.setEvent()
		
		// Ajustement automatique de la vue
		self.fit()
		
		// Enregistrement du callback s'il a été indiqué
		if handler != nil {
			self.handler = handler
		}
		
		// Ouverture de la vue
		self.open()
	}
	
	// Ouverture de la vue d'alerte
	func open() {
		// La vue n'est plus masquée
		self.isHidden = false
		
		// Animation du changement d'opacité de la vue
		UIView.animate(withDuration: 0.2, animations: {
			self.alpha = 1
		})
		
		// Vibration du support
		self.vibrate()
	}
	
	// Ajustement automatique de la vue d'alerte
	func fit() {
		// Ajustement de la taille et de la position du texte
		self.messageTextView.sizeToFit()
		self.messageTextView.center = (self.superview?.center)!
	}
	
	// Fermeture de la vue
	func close(withSender sender: UIVisualEffectView? = nil) {
		// Exécution du callback s'il avait été indiqué et uniquement si la fermeture de la vue provient d'une intéraction utilisateur
		// La variable keep permet de déterminer si la vue doit être fermée en fonction du retour du callback (la vue ne se ferme pas s'il est à false)
		var keep = false
		if sender != nil && self.handler != nil {
			keep = !(handler!())
		}
		
		// Fermeture de la vue en fonction du retour éventuel du callback
		self.close(keep: keep)
	}
	
	// Fermeture de la vue uniquement si keep est à false
	func close(keep: Bool = false) {
		if !keep {
			// Animation du changement d'opacité vers 0
			UIView.animate(withDuration: 0.2, animations: {
				self.alpha = 0
			}, completion: { _ in
				// La vue est masquée à la fin de l'animation
				self.isHidden = true
			})
		}
	}
	
	// Initialisation de l'évènement tap sur la vue uniquement s'il n'a pas déjà été défini
	func setEvent() {
		if !self.eventSet {
			// Désormais les évènements sont définis donc eventSet passe à true pour qu'il ne soit pas redéfinis par la suite
			self.eventSet = true
			
			// Ajout d'un évènement tap sur la vue qui appelle la fonction de fermeture de la vue
			let tap = UITapGestureRecognizer(target: self, action: #selector(self.close(withSender:)))
			tap.delegate = self as UIGestureRecognizerDelegate
			self.addGestureRecognizer(tap)
		}
	}
	
	// Viration du support
	func vibrate() {
		AudioServicesPlayAlertSound(SystemSoundID(kSystemSoundID_Vibrate))
	}
}
