//
//  main.swift
//  Clock
//
//  Created by Sergey on 07.11.2020.
//

import Foundation

var startHH: Int?
var startMM: Int?

var endHH: Int?
var endMM: Int?

if let input = readLine() {
    let parts = input.split(separator: " ")
    if parts.count == 2 {
        let startParts = parts[0].split(separator: ":")
        startHH = Int(startParts[0])
        startMM = Int(startParts[1])
        let endParts = parts[1].split(separator: ":")
        endHH = Int(endParts[0])
        endMM = Int(endParts[1])
    }
}

if let startHH = startHH,
   let startMM = startMM,
   let endHH = endHH,
   let endMM = endMM {
 
    let startAngle = angle(startHH, startMM)
    let endAngle = angle(endHH, endMM)
    let startAngleTrunc = startAngle.truncatingRemainder(dividingBy: 360)
   
    var swipeAngle = (endAngle - startAngle).truncatingRemainder(dividingBy: 360)
    if swipeAngle == 0 {
        swipeAngle = 0
    } else if swipeAngle < 0 {
        swipeAngle += 360
    }
    
    var more12hours = 0
    if endAngle >= startAngle {
        more12hours = (endAngle - startAngle) >= 360 ? 1 : 0
    } else {
        more12hours = ((720 - startAngle) + endAngle) >= 360 ? 1 : 0
    }
    
    print("\(startAngleTrunc) \(swipeAngle) \(more12hours)")
}

func angle(_ HH: Int, _ MM: Int) -> Double {
    return Double(HH) * 30 + Double(MM) * 0.5
}

