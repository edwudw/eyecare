//
//  AppDelegate.swift
//  TestProject
//
//  Created by Edward Webb on 15/12/19.
//  Copyright © 2019 Outki. All rights reserved.
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {



    @IBOutlet weak var startTimerMenuItem: NSMenuItem!
    @IBOutlet weak var resetTimerMenuItem: NSMenuItem!
    @IBOutlet weak var stopTimerMenuItem: NSMenuItem!
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        // Insert code here to initialize your application
        enableMenus(start: true, stop: false, reset: false)
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }
    
    func enableMenus(start: Bool, stop: Bool, reset: Bool) {
       startTimerMenuItem.isEnabled = start
       stopTimerMenuItem.isEnabled = stop
       resetTimerMenuItem.isEnabled = reset
     }


}

