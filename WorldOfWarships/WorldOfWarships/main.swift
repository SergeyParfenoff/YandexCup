import Foundation

var n: Int? //field size
var m: Int? //command count

if let input = readLine() {
    let parts = input.split(separator: " ")
    if parts.count == 2 {
        n = Int(parts[0])
        m = Int(parts[1])
    }
}

struct MineField {
    let x1: Int
    let y1: Int
    let x2: Int
    let y2: Int
    
    func minesCount() -> Int {
        Int((x2 - x1 + 1) * (y2 - y1 + 1))
    }
    
    func isPointInside(_ x: Int, _ y: Int) -> Bool {
        x >= x1
            && x <= x2
            && y >= y1
            && y <= y2
    }
    
    func isFieldOverlapped(_ field: MineField) -> Bool {
        isPointInside(field.x1, field.y1) ||
            isPointInside(field.x1, field.y2) ||
            isPointInside(field.x2, field.y1) ||
            isPointInside(field.x2, field.y2) ||
            field.isPointInside(x1, y1) ||
            field.isPointInside(x1, y2) ||
            field.isPointInside(x2, y1) ||
            field.isPointInside(x2, y2) ||
            (field.x1 >= x1 && field.x2 <= x2 && y1 >= field.y1 && y2 <= field.y2) ||
            (x1 >= field.x1 && x2 <= field.x2 && field.y1 >= y1 && field.y2 <= y2)
    }
    
    init(_ x1: Int, _ y1: Int, _ x2: Int, _ y2: Int) {
        self.x1 = x1
        self.y1 = y1
        self.x2 = x2
        self.y2 = y2
    }
}

var mineFields = [[MineField]](repeating: [], count: 100)
var exploded = [MineField]()

func explode(at startDepth: Int) {
    var depthIdx = startDepth - 1
    
    while depthIdx >= 0 {
        var toRemove = [Int]()
        
        for i in 0..<mineFields[depthIdx].count {
            let field = mineFields[depthIdx][i]
            
            for explodedField in exploded {
                if field.isFieldOverlapped(explodedField) {
                    exploded.append(field)
                    toRemove.append(i)
                    break
                }
            }
        }
        
        while toRemove.count > 0 {
            mineFields[depthIdx].remove(at: toRemove.removeLast())
        }
        depthIdx -= 1
    }
}

func dropTrawlAt(_ x: Int, _ y: Int) -> Int {
   
    depthCycle: for depthIdx in 0...99 {
        for i in 0..<mineFields[depthIdx].count {
            let field = mineFields[depthIdx][i]
            
            if field.isPointInside(x, y) {
                exploded.append(field)
                mineFields[depthIdx].remove(at: i)
                explode(at: depthIdx)
                break depthCycle
            }
        }
    }
     
    let result = exploded.reduce(0) { $0 + $1.minesCount() }
    exploded = [MineField]()
    
    return result
}

if var commandCounter = m {
    while commandCounter > 0 {
        if let input = readLine() {
            let parts = input.split(separator: " ")
            if !parts.isEmpty {
                if parts[0] == "AMUR",
                   let x1 = Int(parts[1]),
                   let y1 = Int(parts[2]),
                   let x2 = Int(parts[3]),
                   let y2 = Int(parts[4]),
                   let depth = Int(parts[5]) {
                    mineFields[depth - 1] += [MineField(x1, y1, x2, y2)]
                } else if parts[0] == "TUMAN",
                          let x = Int(parts[1]),
                          let y = Int(parts[2]) {
                    print("\(dropTrawlAt(x, y))")
                }
                
            }
        }
        commandCounter -= 1
    }
}
