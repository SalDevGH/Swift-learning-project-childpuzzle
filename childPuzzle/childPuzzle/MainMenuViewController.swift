//
//  MainMenuViewController.swift
//  childPuzzle
//
//  Copyright © 2016 gsaliga. All rights reserved.
//

import UIKit


// Main Menu Screen handler
class MainMenuViewController: UIViewController {
	internal var disableStartAutoPlay:Bool = true

	// this struct holds the image names for the difficulty level settings' buttons
	private struct levelButtonImages {
		static let easyOn    = "btnLevel1On"
		static let easyOff   = "btnLevel1Off"
		static let mediumOn  = "btnLevel2On"
		static let mediumOff = "btnLevel2Off"
		static let hardOn    = "btnLevel3On"
		static let hardOff   = "btnLevel3Off"
	}

	// image names for all the switch buttons (checkboxes)
	private struct switchButtonImages {
		static let music                = "music"
		static let musicDisabled        = "musicDisabled"
		static let tone                 = "tone"
		static let toneDisabled         = "toneDisabled"
		static let miracleItemsDisabled = "miracleItemsCheckboxOff"
		static let miracleItems         = "miracleItemsCheckboxOn"
		static let autoPlayDisabled     = "autoPlayCheckboxOff"
		static let autoPlay             = "autoPlayCheckboxOn"
	}

	// this struct stores all the configuration of the settings button
	private struct settingsButtonConfig {
		static let animDuration          = 0.3
		static let animMaxRepeatCount    = 2
		static let topConstraintModifier = -5
		static let openingSoundEffect    = "settingsPanelOpen"
		struct imageName {
			static let base  = "settings"
			static let alter = "settingsAlter"
		}
	}

	// this struct describes the configuration of the settings panel
	private struct settingsPanelConfig {
		static let minTrailingConstraint = 30
		static let rowHeightDivisor      = 24
		static let topDivisor            = 12
	}

	private var isSettingsPanelOpen                    = false
	private var settingsPanelTop:CGFloat               = 0.0
	private var expectedSettingsButtonTrailing:CGFloat = 0.0

	private let animImagesForSettingsButton            = [
		UIImage(named: settingsButtonConfig.imageName.base)!,
		UIImage(named: settingsButtonConfig.imageName.alter)!
	]
	private var musicSwitchButtonController: UISwitchButtonController!
	private var soundSwitchButtonController: UISwitchButtonController!
	private var miracleSwitchButtonController: UISwitchButtonController!
	private var autoPlaySwitchButtonController: UISwitchButtonController!
	private var difficultyLevelRadioGroup: UIRadioButtonController!

	@IBOutlet private weak var settingsPanel: UIView!
	@IBOutlet private weak var settingsButton: UIButton!
	@IBOutlet private weak var buttonLevelEasy: UIButton!
	@IBOutlet private weak var buttonLevelMedium: UIButton!
	@IBOutlet private weak var buttonLevelHard: UIButton!
	@IBOutlet private weak var musicSwitchButton: UIButton!
	@IBOutlet private weak var soundSwitchButton: UIButton!
	@IBOutlet private weak var miracleItemsSwitchButton: UIButton!
	@IBOutlet private weak var autoPlaySwitchButton: UIButton!
	@IBOutlet private weak var settingsPanelTrailingConstraint: NSLayoutConstraint!
	@IBOutlet private weak var settingsPanelTopContstraint: NSLayoutConstraint!
	@IBOutlet private weak var musicSwitchTopConstraint: NSLayoutConstraint!
	@IBOutlet private weak var miracleSwitchTopConstraint: NSLayoutConstraint!
	@IBOutlet private weak var autoPlaySwitchTopConstraint: NSLayoutConstraint!
	@IBOutlet private weak var settingsButtonTopConstraint: NSLayoutConstraint!
	@IBOutlet private weak var settingsButtonTrailingConstraint: NSLayoutConstraint!
	@IBOutlet private weak var difficultyLabelTopConstraint: NSLayoutConstraint!
	@IBOutlet private weak var levelEasyButtonTrailingConstraint: NSLayoutConstraint!
	@IBOutlet private weak var levelMediumButtonTrailingConstraint: NSLayoutConstraint!


	// overriden event handler for viewDidLoad
	internal override func viewDidLoad() {
		super.viewDidLoad()

		// kickstarting Application singleton
		app.start()
		app.setGameState(.initApplication)

		// store self as main menu ViewController
		app.getTransitionController().setMainMenuVC(self)

		// setup auto-play if needed
		if app.getAutoPlayEnabled() {
			self.disableStartAutoPlaying(false)
		}

		// loading sound effect for panel opening
		app.getSoundControllerOfMenu().loadEffect(settingsButtonConfig.openingSoundEffect)

		// set-up this specific scene
		self.setupUI()
	}

	// overriden viewDidAppear() This starts the application
	internal override func viewDidAppear(animated: Bool) {
		super.viewDidAppear(animated)

		if self.disableStartAutoPlay == false {
			app.setGameState(.playingAutoBaby)
		} else {
			self.playSettingsButtonAnimation()

			if app.getGameState() != .mainMenu {
				app.setGameState(.mainMenu)
			}
		}
	}

	// setter for disabling the automatic start of the auto-play mode
	internal func disableStartAutoPlaying(disable: Bool) {
		self.disableStartAutoPlay = disable
	}

	// enable unwinding
	internal override func canPerformUnwindSegueAction(action: Selector, fromViewController: UIViewController,
	                                                   withSender sender: AnyObject) -> Bool {

		if self.respondsToSelector(action) {
			return true
		}
		
		return false
	}

	// configures the user interface
	private func setupUI() {
		self.setupConstraints()

		// create switches
		self.musicSwitchButtonController = UISwitchButtonController(
			normal: switchButtonImages.musicDisabled,
			selected: switchButtonImages.music
		)
		self.soundSwitchButtonController = UISwitchButtonController(
			normal: switchButtonImages.toneDisabled,
			selected: switchButtonImages.tone
		)
		self.miracleSwitchButtonController = UISwitchButtonController(
			normal: switchButtonImages.miracleItemsDisabled,
			selected: switchButtonImages.miracleItems
		)
		self.autoPlaySwitchButtonController = UISwitchButtonController(
			normal: switchButtonImages.autoPlayDisabled,
			selected: switchButtonImages.autoPlay
		)

		// create difficulty level radiogroup
		self.difficultyLevelRadioGroup = UIRadioButtonController()
		self.difficultyLevelRadioGroup.addElement(
			self.buttonLevelEasy,
			normal:   MainMenuViewController.levelButtonImages.easyOff,
			selected: MainMenuViewController.levelButtonImages.easyOn
		)
		self.difficultyLevelRadioGroup.addElement(
			self.buttonLevelMedium,
			normal:   MainMenuViewController.levelButtonImages.mediumOff,
			selected: MainMenuViewController.levelButtonImages.mediumOn
		)
		self.difficultyLevelRadioGroup.addElement(
			self.buttonLevelHard,
			normal:   MainMenuViewController.levelButtonImages.hardOff,
			selected: MainMenuViewController.levelButtonImages.hardOn
		)

		// init default values by current configuration settings
		self.musicSwitchButtonController.setupSwitchButton(
			self.musicSwitchButton,
			defaultValue: app.getMusicEnabled()
		)
		self.soundSwitchButtonController.setupSwitchButton(
			self.soundSwitchButton,
			defaultValue: app.getSoundEffectsEnabled()
		)
		self.miracleSwitchButtonController.setupSwitchButton(
			self.miracleItemsSwitchButton,
			defaultValue: app.getMiracleItemsEnabled()
		)
		self.autoPlaySwitchButtonController.setupSwitchButton(
			self.autoPlaySwitchButton,
			defaultValue: app.getAutoPlayEnabled()
		)
		self.difficultyLevelRadioGroup.setSelectedElement(app.getCurrentDifficultyLevel())

		// setup and start animation of the Settings Button
		self.settingsButton.setImage(
			UIImage(named: settingsButtonConfig.imageName.base),
			forState: UIControlState.Normal
		)
		self.settingsButton.imageView!.animationImages   = self.animImagesForSettingsButton
		self.settingsButton.imageView!.animationDuration = settingsButtonConfig.animDuration
	}

	// sets up all the constraints for the ui
	private func setupConstraints() {
		let panelRowHeight      = self.view.frame.height / CGFloat(settingsPanelConfig.rowHeightDivisor)
		let levelButtonTrailing = self.buttonLevelEasy.frame.width / 2

		// calculations for placing menu UI elements
		self.settingsPanelTop               = self.view.frame.height / CGFloat(settingsPanelConfig.topDivisor)
		self.expectedSettingsButtonTrailing = -1 * settingsPanelTop + (self.settingsButton.frame.width / 3)

		// set up constraints
		self.settingsPanelTopContstraint.constant         = settingsPanelTop
		self.musicSwitchTopConstraint.constant            = panelRowHeight
		self.miracleSwitchTopConstraint.constant          = panelRowHeight
		self.autoPlaySwitchTopConstraint.constant         = panelRowHeight
		self.difficultyLabelTopConstraint.constant        = panelRowHeight
		self.settingsButtonTrailingConstraint.constant    = self.expectedSettingsButtonTrailing
		self.settingsButtonTopConstraint.constant         = 0
		self.levelEasyButtonTrailingConstraint.constant   = -1 * levelButtonTrailing;
		self.levelMediumButtonTrailingConstraint.constant = -1 * levelButtonTrailing;
	}

	// opens or closes the settings panel, regarding to its current state
	private func toggleSettingsPanel() {
		// toggle panel
		if !self.isSettingsPanelOpen {
			self.startOpenSettingsPanel()
		} else {
			self.startCloseSettingsPanel()
		}

		self.isSettingsPanelOpen = !self.isSettingsPanelOpen
	}

	// overriden event handler for memory warning event
	internal override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()

		// disposing of any resources that can be recreated
		app.handleMemoryWarning()

		// custom re-configuration of the UI, because its possible that the music is turned off
		self.musicSwitchButtonController.setupSwitchButton(
			self.musicSwitchButton,
			defaultValue: app.getMusicEnabled()
		)
	}

	// opens the settings panel
	private func startOpenSettingsPanel() {
		// playing sound
		if app.getSoundEffectsEnabled() {
			app.getSoundControllerOfMenu().playEffect(settingsButtonConfig.openingSoundEffect)
		}

		// start animation of the Settings Panel
		UIView.animateWithDuration(
			Defines.TIMING.settingsPanelOpen,
			delay: 0.0,
			options: [.CurveEaseInOut],
			animations: {
				self.settingsPanelTrailingConstraint.constant = -1.0 * self.settingsPanel.frame.width +
																CGFloat(settingsPanelConfig.minTrailingConstraint)
				self.view.layoutIfNeeded()
			},
			completion: nil
		)

		// start animation of the Settings Button
		UIView.animateWithDuration(
			Defines.TIMING.settingsButtonMoveOut,
			delay: 0.0,
			options: [.CurveEaseInOut],
			animations: {
				self.settingsButtonTrailingConstraint.constant = -1 * (self.settingsPanelTrailingConstraint.constant +
																 self.settingsButton.frame.width)
				self.settingsButtonTopConstraint.constant -= self.settingsButton.frame.height +
															 CGFloat(settingsButtonConfig.topConstraintModifier)

				self.view.layoutIfNeeded()
			},
			completion: { finished in
				self.playSettingsButtonAnimation()
			}
		)
	}

	// closes the settings panel
	private func startCloseSettingsPanel() {
		// start animation of the Settings Panel
		UIView.animateWithDuration(
			Defines.TIMING.settingsPanelClose,
			delay: 0.0,
			options: [.CurveEaseInOut],
			animations: {
				self.settingsPanelTrailingConstraint.constant = 0.0
				self.view.layoutIfNeeded()
			},
			completion: nil
		)

		// start animation of the Settings Button
		UIView.animateWithDuration(
			Defines.TIMING.settingsButtonMoveIn,
			delay: 0.0,
			options: [.CurveEaseInOut],
			animations: {
				self.settingsButtonTrailingConstraint.constant = self.expectedSettingsButtonTrailing
				self.settingsButtonTopConstraint.constant      = 0
				self.view.layoutIfNeeded()
			},
			completion: { finished in
				self.playSettingsButtonAnimation()
			}
		)
	}

	// playing button animation using random repeat count
	private func playSettingsButtonAnimation() {
		self.settingsButton.imageView!.animationRepeatCount = app.randInt(settingsButtonConfig.animMaxRepeatCount) + 1
		self.settingsButton.imageView!.startAnimating()
	}

	// event handler of tapping the music switch icon
	@IBAction private func musicSwitchButtonTapped(sender: AnyObject) {
		// calling general event handler for the switch-button
		self.musicSwitchButtonController.buttonHasPressed(self.musicSwitchButton)

		app.setMusicEnabled(self.musicSwitchButtonController.isSwitchOn(self.musicSwitchButton))
	}

	// event handler of tapping the sound effects switch icon
	@IBAction private func soundSwitchButtonTapped(sender: AnyObject) {
		// calling general event handler for the switch-button
		self.soundSwitchButtonController.buttonHasPressed(self.soundSwitchButton)

		let isSoundOn = self.soundSwitchButtonController.isSwitchOn(self.soundSwitchButton)
		app.setSoundEffectsEnabled(isSoundOn)

		// loading general sound effects because there is a possibility that they were not loaded during startup
		if isSoundOn {
			app.getStageController().loadGeneralSoundEffects()
		}

	}

	// event handler of tapping the miracle items switch icon
	@IBAction private func miracleItemsButtonTapped(sender: AnyObject) {
		// calling general event handler for the switch-button
		self.miracleSwitchButtonController.buttonHasPressed(self.miracleItemsSwitchButton)
		app.setMiracleItemsEnabled(self.miracleSwitchButtonController.isSwitchOn(self.miracleItemsSwitchButton))
	}

	// event handler of tapping the auto play switch icon
	@IBAction private func autoPlayButtonTapped(sender: AnyObject) {
		// calling general event handler for the switch-button
		self.autoPlaySwitchButtonController.buttonHasPressed(self.autoPlaySwitchButton)
		app.setAutoPlayEnabled(self.autoPlaySwitchButtonController.isSwitchOn(self.autoPlaySwitchButton))
	}

	// event handler of tapping the gear icon
	@IBAction private func gearIconTouched(sender: AnyObject) {
		self.toggleSettingsPanel()
	}

	// action for unwind seque | This must be exists here with an empty body in order to get the unwind working
	@IBAction private func prepareForUnwindToMainMenu(segue: UIStoryboardSegue) {
		if self.isSettingsPanelOpen {
			self.toggleSettingsPanel()
		}
	}

	// event handler of tapping button level easy
	@IBAction private func buttonLevelEasyTapped(sender: AnyObject) {
		self.difficultyLevelRadioGroup.buttonHasPressed(self.buttonLevelEasy)
		app.setCurrentDifficultyLevel(Defines.DIFFICULTY_LEVEL.easy.rawValue)
	}

	// event handler of tapping button level medium
	@IBAction private func buttonLevelMediumTapped(sender: AnyObject) {
		self.difficultyLevelRadioGroup.buttonHasPressed(self.buttonLevelMedium)
		app.setCurrentDifficultyLevel(Defines.DIFFICULTY_LEVEL.medium.rawValue)
	}

	// event handler of tapping button level hard
	@IBAction private func buttonLevelHardTapped(sender: AnyObject) {
		self.difficultyLevelRadioGroup.buttonHasPressed(self.buttonLevelHard)
		app.setCurrentDifficultyLevel(Defines.DIFFICULTY_LEVEL.hard.rawValue)
	}

	// event handler of tapping the background
	// its only purpose is to close the settings panel if it is open
	@IBAction private func backgroundTapped(sender: AnyObject) {
		if self.isSettingsPanelOpen {
			self.startCloseSettingsPanel()
			self.isSettingsPanelOpen = false
		}
	}

}
