//
//  ViewController.swift
//  TestProject
//
//  Created by Edward Webb on 15/12/19.
//  Copyright © 2019 Outki. All rights reserved.
//

import Cocoa

class ViewController: NSViewController {

    
    @IBOutlet weak var timeLeftField: NSTextField!
    @IBOutlet weak var startButton: NSButton!
    @IBOutlet weak var stopButton: NSButton!
    @IBOutlet weak var resetButton: NSButton!
    @IBAction func startButtonClicked(_ sender: Any) {
        if mainTimer.isPaused {
          mainTimer.resumeTimer()
        } else {
          mainTimer.duration = prefs.selectedTime
          mainTimer.startTimer()
        }
        configureButtonsAndMenus()
    
    }
    @IBAction func stopButtonClicked(_ sender: Any) {
        mainTimer.stopTimer()
        configureButtonsAndMenus()
    }
    @IBAction func resetButtonClicked(_ sender: Any) {
        mainTimer.resetTimer()
        updateDisplay(for: prefs.selectedTime)
        configureButtonsAndMenus()
    }
    
    @IBAction func startTimerMenuItemSelected(_ sender: Any) {
      startButtonClicked(sender)
    }

    @IBAction func stopTimerMenuItemSelected(_ sender: Any) {
      stopButtonClicked(sender)
    }

    @IBAction func resetTimerMenuItemSelected(_ sender: Any) {
      resetButtonClicked(sender)
    }
    
    var mainTimer = MainTimer()
    
    var prefs = Preferences()
    
    let notification = NSUserNotification()
    
    let notificationCenter = NSUserNotificationCenter.default
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mainTimer.delegate = self
        
        setupPrefs()
        
        notification.identifier = "unique-id"
        notification.title = "Eye Care"
        notification.subtitle = "Look away for 20 seconds"
        notification.informativeText = "Look away for 20 seconds at an object 20 feet away"
        notification.soundName = NSUserNotificationDefaultSoundName
        
        if mainTimer.isPaused {
          mainTimer.resumeTimer()
        } else {
          mainTimer.duration = prefs.selectedTime
          mainTimer.startTimer()
        }
        configureButtonsAndMenus()
        

        // Do any additional setup after loading the view.
    }

    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }
}

extension ViewController: MainTimerProtocol {

  func timeRemainingOnTimer(_ timer: MainTimer, timeRemaining: TimeInterval) {
    updateDisplay(for: timeRemaining)
  }

  func timerHasFinished(_ timer: MainTimer) {
    updateDisplay(for: 0)
    sendNotification()
    mainTimer.resetTimer()
    updateDisplay(for: prefs.selectedTime)
    mainTimer.resumeTimer()
    configureButtonsAndMenus()
  }
    
}

extension ViewController {

  // MARK: - Display
    
    func sendNotification() {
        notificationCenter.removeDeliveredNotification(notification)
        notificationCenter.deliver(notification)
    }

  func updateDisplay(for timeRemaining: TimeInterval) {
    timeLeftField.stringValue = textToDisplay(for: timeRemaining)
  }
    
    func configureButtonsAndMenus() {
      let enableStart: Bool
      let enableStop: Bool
      let enableReset: Bool

      if mainTimer.isStopped {
        enableStart = true
        enableStop = false
        enableReset = false
      } else if mainTimer.isPaused {
        enableStart = true
        enableStop = false
        enableReset = true
      } else {
        enableStart = false
        enableStop = true
        enableReset = false
      }

      startButton.isEnabled = enableStart
      stopButton.isEnabled = enableStop
      resetButton.isEnabled = enableReset

      if let appDel = NSApplication.shared.delegate as? AppDelegate {
        appDel.enableMenus(start: enableStart, stop: enableStop, reset: enableReset)
      }
    }

  private func textToDisplay(for timeRemaining: TimeInterval) -> String {
    if timeRemaining == 0 {
      return "Done!"
    }

    let minutesRemaining = floor(timeRemaining / 60)
    let secondsRemaining = timeRemaining - (minutesRemaining * 60)

    let secondsDisplay = String(format: "%02d", Int(secondsRemaining))
    let timeRemainingDisplay = "\(Int(minutesRemaining)):\(secondsDisplay)"

    return timeRemainingDisplay
  }

  private func imageToDisplay(for timeRemaining: TimeInterval) -> NSImage? {
    let percentageComplete = 100 - (timeRemaining / prefs.selectedTime * 100)

    if mainTimer.isStopped {
      let stoppedImageName = (timeRemaining == 0) ? "100" : "stopped"
      return NSImage(named: stoppedImageName)
    }

    let imageName: String
    switch percentageComplete {
    case 0 ..< 25:
      imageName = "0"
    case 25 ..< 50:
      imageName = "25"
    case 50 ..< 75:
      imageName = "50"
    case 75 ..< 100:
      imageName = "75"
    default:
      imageName = "100"
    }

    return NSImage(named: imageName)
  }

}

extension ViewController {

  // MARK: - Preferences

  func setupPrefs() {
    updateDisplay(for: prefs.selectedTime)

    let notificationName = Notification.Name(rawValue: "PrefsChanged")
    NotificationCenter.default.addObserver(forName: notificationName,
                                           object: nil, queue: nil) {
      (notification) in
      self.updateFromPrefs()
    }
  }

  func updateFromPrefs() {
    self.mainTimer.duration = self.prefs.selectedTime
    self.resetButtonClicked(self)
  }

}
