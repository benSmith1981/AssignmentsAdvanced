//
//  Sizes.swift
//  OMDB
//
//  Created by Ivo  Nederlof on 31-01-17.
//  Copyright © 2017 Dutch Melon. All rights reserved.
//

import UIKit
import Foundation

struct Size {
    // Calculate percentage
    func percentage(of:CGFloat, percentage: CGFloat ) -> CGFloat {
        return percentage*of/100
    }
  
}
