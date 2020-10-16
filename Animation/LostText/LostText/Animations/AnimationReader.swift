//
//  AnimationParser.swift
//  LostText
//
//  Created by Sergey on 28.09.2020.
//

import Foundation

class AnimationReader {
    let canvasWidth: Int
    let canvasHeight: Int
    var wasRead: Bool
    private (set) var figures: [Figure]

    init?(text: String) {
        var width: Int?
        var hight: Int?

        let reader = StringReader(text)

        if let firstLine = reader.readLine() {
            let lineParts = firstLine.split(separator: " ")
            if lineParts.count != 2 {
                return nil
            }
            width = Int(lineParts[0])
            hight = Int(lineParts[1])
        } else {
            return nil
        }

        if width == nil || hight == nil {
            return nil
        }
        
        canvasWidth = width!
        canvasHeight = hight!
        figures = []

        var figuresCount = 0
        if let secondLine = reader.readLine() {
            figuresCount = Int(secondLine) ?? 0
        }

        while figuresCount > 0 {
            if let figureLine = reader.readLine() {
                let lineParts = figureLine.split(separator: " ")
                if lineParts.count < 4 {
                    return nil
                }
                var figure: Figure?

                switch lineParts[0] {
                case "rectangle":
                    figure = readRect(lineParts, reader)
                case "circle":
                    figure = readCircle(lineParts, reader)
                default:
                    return nil
                }
                if figure == nil {
                    return nil
                }
                figures.append(figure!)
                figuresCount -= 1
            } else {
                return nil
            }
            
        }
        wasRead = false
    }
}

func deg2rad(_ number: Double) -> Double {
    return number * .pi / 180
}

func readMoveAnimation(_ lineParts: [String.SubSequence]) -> Animation? {
    guard lineParts.count >= 4 else {
        return nil
    }
    guard let destX = Double(lineParts[1]),
          let destY = Double(lineParts[2]),
          let time = Int(lineParts[3])
    else { return nil }
    
    if lineParts.count >= 5, lineParts[4] == "cycle" {
        return Animation(type: .move(x: destX, y: destY), time: time, cycle: true)
    } else {
        return Animation(type: .move(x: destX, y: destY), time: time, cycle: false)
    }
}

func readRotateAnimation(_ lineParts: [String.SubSequence]) -> Animation? {
    guard lineParts.count >= 3 else {
        return nil
    }
    guard let angle = Double(lineParts[1]),
          let time = Int(lineParts[2])
    else { return nil }
    
    if lineParts.count >= 4, lineParts[3] == "cycle" {
        return Animation(type: .rotate(deg2rad(angle)), time: time, cycle: true)
    } else {
        return Animation(type: .rotate(deg2rad(angle)), time: time, cycle: false)
    }
}

func readScaleAnimation(_ lineParts: [String.SubSequence]) -> Animation? {
    guard lineParts.count >= 3 else {
        return nil
    }
    guard let destScale = Double(lineParts[1]),
          let time = Int(lineParts[2])
    else { return nil }
    
    if lineParts.count >= 4, lineParts[3] == "cycle" {
        return Animation(type: .scale(destScale), time: time, cycle: true)
    } else {
        return Animation(type: .scale(destScale), time: time, cycle: false)
    }
}

func readAnimation(_ lineParts: [String.SubSequence]) -> Animation? {
    if lineParts.count == 0 {
        return nil
    }
    
    switch lineParts[0] {
    case "move":
        return readMoveAnimation(lineParts)
    case "rotate":
        return readRotateAnimation(lineParts)
    case "scale":
        return readScaleAnimation(lineParts)
    default:
        return nil
    }
}

func readAnimations(count: Int, reader: StringReader) -> [Animation]? {
    var count = count
    var animations: [Animation] = []
    
    while count > 0 {
        guard let animationLine = reader.readLine(),
              let animation = readAnimation(animationLine.split(separator: " ")) else {
            return nil
        }
        animations.append(animation)
        count -= 1
    }
    
    return animations
}

func readRect(_ lineParts: [String.SubSequence], _ reader: StringReader) -> Rectangle? {
    guard lineParts.count >= 7 else {
        return nil
    }
    guard let centerX = Double(lineParts[1]),
          let centerY = Double(lineParts[2]),
          let width = Double(lineParts[3]),
          let height = Double(lineParts[4]),
          let angle = Double(lineParts[5]),
          let color = FigureColor(rawValue: String(lineParts[6]))
    else { return nil }
    
    guard let animationsCountLine = reader.readLine(),
          let figureAnimationsCount = Int(animationsCountLine)
          else { return nil }
    
    guard let animations = readAnimations(count: figureAnimationsCount, reader: reader) else {
        return nil
    }
    
    return Rectangle(width: width,
                     height: height,
                     angle: deg2rad(angle),
                     center: (x: centerX, y: centerY),
                     color: color,
                     animations: animations)
}

func readCircle(_ lineParts: [String.SubSequence], _ reader: StringReader) -> Circle? {
    guard lineParts.count >= 5 else {
        return nil
    }
    guard let centerX = Double(lineParts[1]),
          let centerY = Double(lineParts[2]),
          let radius = Double(lineParts[3]),
          let color = FigureColor(rawValue: String(lineParts[4]))
    else { return nil }
    
    guard let animationsCountLine = reader.readLine(),
          let figureAnimationsCount = Int(animationsCountLine)
          else { return nil }
    
    guard let animations = readAnimations(count: figureAnimationsCount, reader: reader) else {
        return nil
    }
    
    return Circle(radius: radius,
                  center: (x: centerX, y: centerY),
                  color: color,
                  animations: animations)
}
