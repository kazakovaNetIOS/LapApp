//
//  Extensions.swift
//  LapApp
//
//  Created by Natalia Kazakova on 14/08/2019.
//  Copyright © 2019 Natalia Kazakova. All rights reserved.
//

import Foundation

//MARK: - TimeInterval extension
/***************************************************************/

extension TimeInterval {
    public var hourMinuteSecondMS: String {
        return String(format:"%02d:%02d:%02d.%03d", hour, minute, second, millisecond)
    }
    var hour: Int {
        return Int((self / 60 / 60).truncatingRemainder(dividingBy: 60))
    }
    var minute: Int {
        return Int((self / 60).truncatingRemainder(dividingBy: 60))
    }
    var second: Int {
        return Int(truncatingRemainder(dividingBy: 60))
    }
    var millisecond: Int {
        return Int((self * 1000).truncatingRemainder(dividingBy: 1000))
    }
}
