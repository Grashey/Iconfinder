import Foundation

let queue = DispatchQueue(label: "queue", attributes: .concurrent)
let group = DispatchGroup()
let lock = NSLock()

func makeMatrix(row: Int, column: Int) -> [[Int]] {
    var matrix: [[Int]] = []
    for _ in 1...row {
        group.enter()
        queue.async {
            var array: [Int] = []
            for _ in 1...column {
                let value = Int.random(in: 0...1)
                array.append(value)
            }
            lock.lock()
            matrix.append(array)
            lock.unlock()
            group.leave()
        }
        
    }
    group.wait()
    return matrix
}

func checkDistanceIn(_ matrix: [[Int]]) -> [[Int]] {
    let rowCount = matrix.count
    let columnCount = matrix[0].count

    var columnDistanceArray: [[Int]] = []
    var result = matrix
    
    // дистанции по столбцам
    for index in .zero..<columnCount {
        let line = matrix.compactMap { $0[index] }
        let distanceLine = makeDistanceFrom(line: line)
        columnDistanceArray.append(distanceLine)
    }
    
    for rowIndex in .zero..<rowCount {
        group.enter()
        queue.async {
            // оригинальные дистанции по строкам
            let distanceLine = makeDistanceFrom(line: matrix[rowIndex])
            
            // столбцы перевернуты в строки
            let secondDistanceLine = columnDistanceArray.compactMap { $0[rowIndex] }
            
            // сравнение значений, взятие меньшего
            var line: [Int] = []
            for index in .zero..<columnCount {
                let min = min(distanceLine[index], secondDistanceLine[index])
                line.append(min)
            }
            line = checkDistanceIn(line)
            result[rowIndex] = line
            group.leave()
        }
    }
    group.wait()
    return result
}

func makeDistanceFrom(line: [Int]) -> [Int] {
    let lineCount = line.count
    let target = 1
    
    // линия с проставленными 0 на местах таргета
    var distanceLine = line.map { $0 == target ? 0 : 99 }
    
    // поиск расстояния для ближайшего таргета
    for index in .zero..<lineCount {
        if distanceLine[index] != 0 {
            var prevDistance: Int?
            var nextDistance: Int?
            
            // поиск ближайшего таргета слева от индекса
            let prevArray = line[.zero...max(.zero, index - 1)]
            if let prevIndex = prevArray.lastIndex(where: {$0 == target}) {
                prevDistance = -(prevIndex - index)
            }
            
            // поиск ближайшего таргета справа от индекса
            let nextArray = line[min(index + 1, lineCount - 1)..<lineCount]
            if let nextIndex = nextArray.firstIndex(where: {$0 == target}) {
                nextDistance = nextIndex - index
            }
            
            distanceLine[index] = min(prevDistance ?? 99, nextDistance ?? 99)
            prevDistance = nil
            nextDistance = nil
        }
    }
    return distanceLine
}

// проверка соседний значений на условие, что дистанция увеличивается на 1 шаг
func checkDistanceIn(_ line: [Int]) -> [Int] {
    let group = DispatchGroup()
    var newLine: [Int] = line
    for index in .zero..<line.count {
        group.enter()
        queue.async {
            let value = line[index]
            let prev = line[max(index-1, .zero)]
            let next = line[min(index+1, line.count-1)]
            if value > min(prev,next) + 1 {
                newLine[index] = (min(prev,next) + 1)
            } 
            group.leave()
        }
    }
    group.wait()
    return newLine
}

let matrix = makeMatrix(row: 6, column: 6)

print("\nmatrix:")
for row in matrix {
    print(row)
}

let distanceMatrix = checkDistanceIn(matrix)

print("\ndistance:")
for row in distanceMatrix {
    print(row)
}



