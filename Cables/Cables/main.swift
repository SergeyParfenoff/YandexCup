//
//  main.swift
//  Cables
//
//  Created by Sergey on 22.09.2020.
//

import Foundation

var n: Int?//computer count
var k: Int?//already connected count
var m: Int?//price count

var result = -1

if let input = readLine() {
    let parts = input.split(separator: " ")
    if parts.count == 3 {
        n = Int(parts[0])
        k = Int(parts[1])
        m = Int(parts[2])
    }
}

struct Pair: Hashable {
    let comp1: Int
    let comp2: Int
    
    init(_ comp1: Int, _ comp2: Int) {
        self.comp1 = comp1 - 1
        self.comp2 = comp2 - 1
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(comp1 + comp2)
    }
}

class Net {
    var leaders: [Int]
    var ranks: [Int]
    var cost: Int?
    
    static let divider = Int(Int32.max)
    
    func findSegment(_ id: Int) -> Int {
        if leaders[id] == id {
            return id
        }
        leaders[id] = findSegment(leaders[id])
        return leaders[id]
    }
    
    func connect(_ comp1: Int, _ comp2: Int) {
        var leader1 = findSegment(comp1)
        var leader2 = findSegment(comp2)
        
        if leader1 != leader2 {
            if ranks[leader1] < ranks[leader2] {
                swap(&leader1, &leader2)
            }
            leaders[leader2] = leader1
            if ranks[leader1] == ranks[leader2] {
                ranks[leader1] += 1
            }
        }
    }
    
    func addCost(_ newCost: Int) {
        cost = (cost == nil) ? Int(newCost % Net.divider) : cost! * Int(newCost % Net.divider)
    }
    
    func connected() -> Bool {
        var leaderCounter = 0
        
        for i in 0..<leaders.count {
            if leaders[i] == i {
                leaderCounter += 1
                if leaderCounter > 1 {
                    return false
                }
            }
        }
        
        return true
    }
    
    init(_ size: Int) {
        leaders = []
        for counter in 0..<size {
            leaders.append(counter)
        }
        ranks = Array(repeating: 0, count: size)
    }
}

var paired: Set<Pair> = []

if k != nil {
    while k! > 0, let input = readLine() {
        let parts = input.split(separator: " ")
        if parts.count == 2, let comp1 = Int(parts[0]), let comp2 = Int(parts[1]) {
            paired.insert(Pair(comp1, comp2))
        }
        k! -= 1
    }
}

struct Price: Comparable {
    let pair: Pair
    let value: Int
    
    static func < (lhs: Price, rhs: Price) -> Bool {
        lhs.value < rhs.value
    }
    static func == (lhs: Price, rhs: Price) -> Bool {
        lhs.value == rhs.value
    }
}

var prices: [Price] = []

if m != nil {
    while m! > 0, let input = readLine() {
        let parts = input.split(separator: " ")
        if parts.count == 3,
           let comp1 = Int(parts[0]),
           let comp2 = Int(parts[1]),
           let price = Int(parts[2]) {
            let pair = Pair(comp1, comp2)
            prices.append(Price(pair: pair,
                                value: paired.contains(pair) ? -price : price))
        }
        m! -= 1
    }
    
    prices.sort()

    let net = Net(n!)

    for price in prices {
        if net.findSegment(price.pair.comp1) != net.findSegment(price.pair.comp2) {
            net.addCost(price.value)
            net.connect(price.pair.comp1, price.pair.comp2)
        }
    }
    
    result = net.connected() ? (net.cost ?? -1) : -1
}

print(result)
