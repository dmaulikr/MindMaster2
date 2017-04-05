//
//  HistoryTableViewCell.swift
//  MindMaster2
//
//  Created by Julien Dargelos on 10/02/2017.
//  Copyright © 2017 Julien Dargelos. All rights reserved.
//

import UIKit

// Cellule historique de Table View
class HistoryTableViewCell: UITableViewCell {
	
	// Déclaration des références des éléments d'interface (combinaison à gauche et résultat à droite)
	@IBOutlet weak var combination: UITextView!
	@IBOutlet weak var result: UITextView!
	
	override func awakeFromNib() {
		super.awakeFromNib()
	}
	
	override func setSelected(_ selected: Bool, animated: Bool) {
		super.setSelected(selected, animated: animated)
	}
	
	// Remplissage de la cellule avec une tentative
	func set(_ attempt: Attempt) {
		self.combination.attributedText = attempt.combination.string()
		self.result.attributedText = attempt.result.string()
	}
}
