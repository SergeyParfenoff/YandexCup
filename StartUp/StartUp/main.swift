//
//  main.swift
//  StartUp
//
//  Created by Sergey on 07.11.2020.
//

import Foundation

var s: Int?//sum
var m: Int?//
var n: Int?//
var k: Int?//

var mCoins: Set<Int> = []
var nCoins: Set<Int> = []
var kCoins: Set<Int> = []

var result: [Int] = []

if let input = readLine() {
    s = Int(input)
}

if let input = readLine() {
    let parts = input.split(separator: " ")
    if parts.count == 3 {
        m = Int(parts[0])
        n = Int(parts[1])
        k = Int(parts[2])
    }
}

if m != nil, let input = readLine() {
    let parts = input.split(separator: " ")
    if parts.count == m! {
        mCoins = Set(parts.compactMap { Int($0) })
    }
}

if n != nil, let input = readLine() {
    let parts = input.split(separator: " ")
    if parts.count == n! {
        nCoins = Set(parts.compactMap { Int($0) })
    }
}

if k != nil, let input = readLine() {
    let parts = input.split(separator: " ")
    if parts.count == k! {
        kCoins = Set(parts.compactMap { Int($0) })
    }
}

if let s = s,
   let m = m,
   let n = n,
   let k = k {
    
    var biggestWallet: Set<Int> = []
    var smallestWallet: Set<Int> = []
    var mediumWallet: Set<Int> = []
    
    let maxCoins = max(m, n, k)
    var big_order = 0
    var med_order = 0
    var sml_order = 0
    
    if m == maxCoins {
        biggestWallet = mCoins
        big_order = 0
        if n > k {
            smallestWallet = kCoins
            mediumWallet = nCoins
            med_order = 1
            sml_order = 2
        } else {
            smallestWallet = nCoins
            mediumWallet = kCoins
            med_order = 2
            sml_order = 1
        }
    } else if n == maxCoins {
        biggestWallet = nCoins
        big_order = 1
        if k > m {
            smallestWallet = mCoins
            mediumWallet = kCoins
            med_order = 2
            sml_order = 0
        } else {
            smallestWallet = kCoins
            mediumWallet = mCoins
            med_order = 0
            sml_order = 2
        }
    } else {
        biggestWallet = kCoins
        big_order = 2
        if m > n {
            smallestWallet = nCoins
            mediumWallet = mCoins
            med_order = 0
            sml_order = 1
        } else {
            smallestWallet = mCoins
            mediumWallet = nCoins
            med_order = 1
            sml_order = 0
        }
    }
    
    mainLoop: for smallCoin in smallestWallet {
        for mediumCoin in mediumWallet {
            let lastCoin = s - smallCoin - mediumCoin
            if biggestWallet.contains(lastCoin) {
                if big_order == 0 {
                    result.append(lastCoin)
                } else if med_order == 0 {
                    result.append(mediumCoin)
                } else {
                    result.append(smallCoin)
                }
                if big_order == 1 {
                    result.append(lastCoin)
                } else if med_order == 1 {
                    result.append(mediumCoin)
                } else {
                    result.append(smallCoin)
                }
                if big_order == 2 {
                    result.append(lastCoin)
                } else if med_order == 2 {
                    result.append(mediumCoin)
                } else {
                    result.append(smallCoin)
                }
                break mainLoop
            }
        }
    }
}

if result.isEmpty {
    print("NO")
} else {
    print("YES")
    print("\(result[0]) \(result[1]) \(result[2])")
}
