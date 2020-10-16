//
//  Animations.swift
//  LostText
//
//  Created by Sergey on 08.10.2020.
//

import Foundation

enum FigureColor: String {
    case black
    case red
    case white
    case yellow
}

enum AnimationType {
    case move(x: Double, y: Double)
    case rotate(Double)
    case scale(Double)
}

struct Animation {
    let type: AnimationType
    let time: Int
    let cycle: Bool
}

protocol Figure {
    var center: (x: Double, y: Double) { get }
    var color: FigureColor { get }
    var animations: [Animation] { get set }
}

struct Rectangle: Figure {
    let width: Double
    let height: Double
    let angle: Double
    let center: (x: Double, y: Double)
    let color: FigureColor
    var animations: [Animation]
}

struct Circle: Figure {
    let radius: Double
    let center: (x: Double, y: Double)
    let color: FigureColor
    var animations: [Animation]
}
