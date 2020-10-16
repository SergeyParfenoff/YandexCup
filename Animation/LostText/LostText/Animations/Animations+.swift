//
//  Animations+.swift
//  LostText
//
//  Created by Sergey on 10.10.2020.
//

import Foundation

extension FigureColor {
    
    var CGColor: CGColor {
        get {
            switch self {
            case .black:
                return .black
            case .red:
                return .init(red: 255, green: 0, blue: 0, alpha: 1)
            case .white:
                return .white
            case .yellow:
                return .init(red: 255, green: 255, blue: 0, alpha: 1)
            }
        }
    }
    
}
