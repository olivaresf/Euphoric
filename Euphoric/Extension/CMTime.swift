//
//  CMTime.swift
//  Euphoric
//
//  Created by Diego Oruna on 15/08/20.
//

import AVKit

extension CMTime{
    
    func toDisplayString() -> String{
        if CMTimeGetSeconds(self).isNaN {
            return "--:--"
        }
        
        let totalSeconds = Int(CMTimeGetSeconds(self))
        let seconds = totalSeconds % 60
        let minutes = totalSeconds % (60 * 60) / 60
        let hours = totalSeconds / 60 / 60
        let timeFormatString = String(format: "%02d:%02d:%02d", hours, minutes, seconds)
        return timeFormatString
    }
    
}
