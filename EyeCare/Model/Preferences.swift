//
//  Preferences.swift
//  TestProject
//
//  Created by Edward Webb on 15/12/19.
//  Copyright © 2019 Outki. All rights reserved.
//

import Foundation

struct Preferences {

  // 1
  var selectedTime: TimeInterval {
    get {
      // 2
      let savedTime = UserDefaults.standard.double(forKey: "selectedTime")
      if savedTime > 0 {
        return savedTime
      }
      // 3
      return 1200
    }
    set {
      // 4
      UserDefaults.standard.set(newValue, forKey: "selectedTime")
    }
  }

}   
