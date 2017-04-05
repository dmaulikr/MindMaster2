//
//  GameViewController.swift
//  MindMaster2
//
//  Created by Julien Dargelos on 07/02/2017.
//  Copyright © 2017 Julien Dargelos. All rights reserved.
//

import UIKit

class GameViewController: ViewController, UITableViewDataSource, UITableViewDelegate {

	// Déclaration des références des éléments d'interface
	@IBOutlet weak var gradientView: GradientView!
	@IBOutlet weak var header: HeaderView!
	@IBOutlet weak var selector: SelectorView!
	@IBOutlet var selectorButtons: Array<ColorButton>!
	@IBOutlet var paletteButtons: Array<ColorButton>!
	@IBOutlet var tableView: UITableView!
	@IBOutlet weak var counter: CounterTextView!
	
	// Hauteur de la barre de status
	let statusBarHeight: CGFloat = 20
	// Identifiant de la cellule prototype de la Table View
	let historyCellIdentifier = "historyCell"
	
	// Écran d'alerte
	var alert = AlertVisualEffectView()
	// Bouton actuellement sélectionné
	var selectingButton: ColorButton!
	// Combinaison secrète
	var secret = Combination()
	// Historique des tentatives
	var attempts = History()
	
	// État du header
	var headerSet = false
	
    override func viewDidLoad() {
        super.viewDidLoad()
		
		// Remplissage aléatoire de la combinaison secrète
		self.secret.rand()
		
		// Tri des boutons (afin que leur ordre dans le tableau corresponde à l'ordre dans l'interface)
		self.orderButtons()
		
		// Initialisation du compteur d'essai
		self.updateCounter()
		
		// Initialisation de l'arrière plan
		self.setBackground(gradientView)
		
		// Initialisation du header
		self.setHeader()
		
		// Initialisation de la palette de couleurs
		self.setPaletteButtonsEvents()
		
		// Initialisation des boutons de sélection des couleurs
		self.setPaletteButtonsColors()
		
		// Initialisation des évènements des boutons de sélection des couleurs
		self.setSelectorButtonsEvents()
		
		// Initialisation de la tableView en fonction de l'orientation du support
		self.setTableView(nil, for: self.orientation())
		
		// Initialisation de l'écran d'alerte
		self.setAlert()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
	
	// Ajustement de l'interface lors du changement d'orientation du support
	override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
		super.viewWillTransition(to: size, with: coordinator)
		// Calcul de la direction du changement de l'orientation (-1 passage en paysage, 1 passage en portait)
		let direction: CGFloat = size.width > self.view.frame.width ? -1 : 1
		
		// Animation de l'ajustement de l'interface
		coordinator.animate(alongsideTransition: { _ in
			// Ajustement de la hauteur du header selon la direction du changement d'orientation
			self.header.toggle(direction)
			
			// Ajustement automatique de l'écran d'alerte
			self.alert.fit()
		})
		
		// Ajustement du positionnement et de la taille de la Table View selon la direction du changement d'orientation
		self.setTableView(self.selector.direction, for: direction)
	}

	// Orientation courante du support (-1 paysage, 1 portait)
	func orientation() -> CGFloat {
		return self.view.frame.width > self.view.frame.height ? -1 : 1
	}
	
	// Nombre de sections de la Table View (toujours 1)
	func numberOfSectionsInTableView(tableView: UITableView) -> Int {
		return 1
	}
	
	// Nombre de données dans la Table View
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return self.attempts.count()
	}
	
	// Ajout d'une cellule à la Table View
	@available(iOS 2.0, *)
	public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: historyCellIdentifier, for: indexPath as IndexPath) as! HistoryTableViewCell
		cell.set(self.attempts.get(indexPath.row))
		
		return cell
		
	}
	
	// Ajout d'une celle à la Table View
	func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: historyCellIdentifier, for: indexPath as IndexPath) as! HistoryTableViewCell
		cell.set(self.attempts.get(indexPath.row))
		
		return cell
	}
	
	// Désactivation de la sélection des cellules du la Table View
	func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
		tableView.deselectRow(at: indexPath as IndexPath, animated: true)
	}
	
	// Évènement touch du bouton de validation
	@IBAction func validateButtonTouch(_ sender: Any) {
		// Création et remplissage d'une combinaison avec l'entrée utilisateur
		let combination = Combination()
		combination.set(buttons: self.selectorButtons)
		
		// Contrôle de la combinaison, elle ne doit pas comprendre d'entrée vide
		if combination.filled() {
			// Comparaison de la combinaison utilisateur avec la combinaison secrète
			let result = self.secret.control(combination)
			
			// Ajout de la combinaison à l'historique, mise à jour du compteur et de la Table View
			self.attempts.append(combination: combination, result: result)
			self.updateCounter()
			self.updateTableView()
			self.scrollToBottom()
			
			// Déselection du bouton couramment sélectionné, fermeture de la palette de couleur, ajustement de la Table View
			self.selectingButton.selected(false)
			self.selector.close(palette: self.paletteButtons)
			self.toggleTableView(1)
			
			// Réinitialisation de la valeur des boutons de sélection
			for (_, button) in self.selectorButtons.enumerated() {
				button.clear()
			}
			
			// Affichage d'un écran d'alert en cas de succès ou d'échec, ramenant à l'écran d'accueil
			if(self.attempts.success()) {
				self.alert.open("You win", handler: back)
			}
			else if(self.attempts.fail()) {
				self.alert.open("You lose", handler: back)
			}
		}
		else {
			// Si la combinaison n'est pas entièrement remplie, affichage d'un écran d'alerte
			self.alert.open("Fill all the colors")
		}
	}
	
	// Retour à l'écran d'accueil
	func back() -> Bool {
		self.performSegue(withIdentifier: "back", sender: nil)
		return false
	}
	
	// Mise à jour du compteur de vies (maximum moins nombre de tentatives)
	func updateCounter() {
		self.counter.set(History.max - self.attempts.count())
	}
	
	// Initialisation de la Table View
	func setTableView(_ direction: Int? = 1, for orientation: CGFloat? = nil) {
		// Calcul et attribution de la position et de la hauteur
		let top = direction == -1 ? self.selector.openHeight : self.selector.closedHeight
		let height = orientation != nil ? self.header.height(for: orientation!) : self.header.frame.height
		let tableViewEdgeInsets = UIEdgeInsetsMake(height, 0, top - 1, 0)
		tableView.contentInset = tableViewEdgeInsets
		tableView.scrollIndicatorInsets = tableViewEdgeInsets
	}
	
	// Ajustement de la Table View
	func toggleTableView(_ direction: CGFloat) {
		let edgeInsets = UIEdgeInsetsMake(self.header.frame.height, 0, direction == -1 ? self.selector.openHeight - 1 : self.selector.closedHeight - 1, 0)
		UIView.animate(withDuration: 0.2, animations: {
			self.tableView.contentInset = edgeInsets
			self.tableView.scrollIndicatorInsets = edgeInsets
		}, completion: { _ in
			self.scrollToBottom()
		})
	}
	
	// Mise à jour de la Table View (insertion de la dernière tentative dans la tableà
	func updateTableView() {
		tableView.beginUpdates()
		tableView.insertRows(at: [IndexPath(row: self.attempts.count()-1, section: 0)], with: .automatic)
		tableView.endUpdates()
	}
	
	// Initialisation du header selon l'orientation du support
	func setHeader() {
		self.header.toggle(self.orientation())
	}
	
	// Initialisation de la vue d'alerte (ajout dans la vue et initialisation de l'instance)
	func setAlert() {
		self.gradientView.addSubview(self.alert)
		self.alert.initialize()
	}
	
	// Scroll en bas de la Table View
	func scrollToBottom() {
		let count = self.attempts.count()
		if(count > 0) {
			let indexPath = NSIndexPath(row: count - 1, section: 0)
			
			self.tableView.scrollToRow(at: indexPath as IndexPath, at: UITableViewScrollPosition.bottom, animated: true)
		}
	}
	
	// Évènement touch sur un bouton de sélection
	func selectorButtonTouch(withSender sender: ColorButton) {
		// Déselection du bouton courament sélectionné
		if self.selectingButton != nil {
			self.selectingButton.selected(false)
		}
		// Mise à jour de bouton courament sélectionné
		self.selectingButton = sender
		// Sélection du bouton
		self.selectingButton.selected(true)
		// Ouverture de la palette de couleurs
		self.selector.open(palette: self.paletteButtons)
		// Ajustement de la Table View avec la palette de couleurs ouverte
		self.toggleTableView(-1)
	}
	
	// Évènement touch sur un bouton de la palette de couleurs
	func paletteButtonTouch(withSender sender: ColorButton) {
		// Modification de la couleur de bouton couramment sélectionné avec la couleur du bouton de la palette de couleurs touché
		self.selectingButton.palette(sender.color)
		
		// Sélection automatique du bouton suivant et ou fermeture de la palette de couleurs
		let index = selectingButton.index + 1
		if index >= selectorButtons.count {
			self.selector.close(palette: self.paletteButtons)
			self.toggleTableView(1)
			if selectingButton != nil {
				selectingButton.selected(false)
			}
		}
		else {
			selectorButtonTouch(withSender: self.selectorButtons[index])
		}
	}
	
	// Initialisation des évènements des boutons de sélection (touch)
	func setSelectorButtonsEvents() {
		for (_, button) in (selectorButtons?.enumerated())! {
			button.addTarget(self, action: #selector(self.selectorButtonTouch(withSender:)), for: UIControlEvents.touchUpInside)
		}
	}
	
	// Initialisation des évènements des boutons de la palette de couleurs (touch)
	func setPaletteButtonsEvents() {
		for (_, button) in (paletteButtons?.enumerated())! {
			button.addTarget(self, action: #selector(self.paletteButtonTouch(withSender:)), for: UIControlEvents.touchUpInside)
		}
	}
	
	// Initialisation des boutons de la palette de couleurs (définition automatique de la couleur des boutons)
	func setPaletteButtonsColors() {
		for (_, button) in (paletteButtons?.enumerated())! {
			button.inc()
		}
	}
	
	// Ordonancement des boutons dans le tableau selon l'ordre d'affichage dans l'interface
	func orderButtons() {
		self.selectorButtons = ColorButton.order(self.selectorButtons)
		self.paletteButtons = ColorButton.order(self.paletteButtons)
	}
}
