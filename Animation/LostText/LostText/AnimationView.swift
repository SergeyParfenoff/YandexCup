//
//  AnimationView.swift
//  LostText
//
//  Created by Sergey on 12.10.2020.
//

import Cocoa

class AnimationView: NSView {

    var animationReader: AnimationReader?
    
    override func layout() {
        if animationReader?.wasRead ?? true {
            return
        }
        
        self.layer?.isGeometryFlipped = false
        self.layer?.backgroundColor = .white
        self.layer?.removeAllAnimations()
        self.layer?.sublayers?.removeAll()
        
        for figure in animationReader!.figures {
            
            let shapeLayer = CAShapeLayer()
            shapeLayer.fillColor = figure.color.CGColor
            
            if let rectangle = figure as? Rectangle {
                let rect = CGRect.init(x: 0,
                                       y: 0,
                                       width: rectangle.width,
                                       height: rectangle.height)
                shapeLayer.path = CGPath(rect: rect, transform: nil)
                shapeLayer.position = CGPoint(x: rectangle.center.x, y: rectangle.center.y)
                shapeLayer.bounds = CGRect(x: 0, y: 0, width: rectangle.width, height: rectangle.height)
                shapeLayer.setAffineTransform(.init(rotationAngle: CGFloat(rectangle.angle)))
            } else if let circle = figure as? Circle {
                let rect = CGRect(x: circle.center.x, y: circle.center.y,
                                  width: circle.radius * 2,
                                  height: circle.radius * 2)
                shapeLayer.path = CGPath(ellipseIn: rect, transform: nil)
                shapeLayer.bounds = CGRect(x: 0, y: 0, width: circle.radius * 2, height: circle.radius * 2)
            } else {
                continue
            }
            
            for animation in figure.animations {
                switch animation.type {
                case .move(let destX, let destY):
                    let moving = CABasicAnimation(keyPath: "position")
                    moving.fromValue = shapeLayer.position
                    moving.toValue = CGPoint(x: destX, y: destY)
                    moving.duration = Double(animation.time / 1000)
                    if animation.cycle {
                        moving.autoreverses = true
                        moving.repeatCount = .infinity
                    } else {
                        shapeLayer.position = CGPoint(x: destX, y: destY)
                    }
                    shapeLayer.add(moving, forKey: "position")
                case .rotate(let angle):
                    let rotation = CABasicAnimation(keyPath: "transform.rotation")
                    let fromAngle = ((figure as? Rectangle)?.angle ?? 0)
                    rotation.fromValue = fromAngle
                    rotation.toValue = fromAngle + angle
                    rotation.duration = Double(animation.time / 1000)
                    if animation.cycle {
                        rotation.autoreverses = true
                        rotation.repeatCount = .infinity
                    } else {
                        CATransaction.setDisableActions(true)
                        let transform = shapeLayer.affineTransform().rotated(by: CGFloat(fromAngle + angle))
                        shapeLayer.setAffineTransform(transform)
                        CATransaction.setDisableActions(false)
                    }
                    shapeLayer.add(rotation, forKey: "rotation")
                case .scale(let multiplier):
                    let scaling = CABasicAnimation(keyPath: "transform.scale")
                    scaling.fromValue = 1
                    scaling.toValue = multiplier
                    scaling.duration = Double(animation.time / 1000)
                    if animation.cycle {
                        scaling.autoreverses = true
                        scaling.repeatCount = .infinity
                    } else {
                        CATransaction.setDisableActions(true)
                        let transform = shapeLayer.affineTransform().scaledBy(x: CGFloat(multiplier), y: CGFloat(multiplier))
                        shapeLayer.setAffineTransform(transform)
                        CATransaction.setDisableActions(false)
                    }
                    shapeLayer.add(scaling, forKey: "scaling")
                }
            }
            self.layer?.addSublayer(shapeLayer)
        }
        animationReader?.wasRead = true
    }
    
}

