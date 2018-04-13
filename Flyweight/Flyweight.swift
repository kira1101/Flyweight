//
//  Flyweight.swift
//  Flyweight
//
//  Created by p14822 on 2018/4/12.
//  Copyright © 2018年 p14822. All rights reserved.
//

import Foundation

protocol Flyweight {
    subscript(index:Coordinate) -> Int?{ get set };
    var total:Int { get }
    var count:Int { get }
}

extension Dictionary{
    init(setupFunc:(() -> [(Key, Value)])) {
        self.init()
        for item in setupFunc(){
            self[item.0] = item.1
        }
    }
}

class FlyweightFactory {
    class func createFlyweight() -> Flyweight{
        return FlyweightImplementation(extrinsic: extrinsicData)
    }
    
    private class var extrinsicData:[Coordinate: Cell]{
        get {
            struct singletonWrapper {
                static let singletonData = Dictionary<Coordinate, Cell>(
                    setupFunc: {() in
                        var result = [(Coordinate,Cell)]()
                        let letters:String = "ABCDEFGHIJKLMNOPQRSTUVWXYZ"
                        var stringIndex = letters.startIndex
                        let rows = 50
                        
                        repeat{
                            let colLetter = letters[stringIndex]
                            stringIndex = letters.index(stringIndex, offsetBy: 1)
                            for rowIndex in 1 ... rows{
                                let cell = Cell(col: colLetter, row: rowIndex, val: 0)
                                result.append((cell.coordinate, cell))
                            }
                        }while( stringIndex != letters.endIndex)
                        return result
                    }
                );
            }
            return singletonWrapper.singletonData
        }
    }
}
class FlyweightImplementation: Flyweight {
    
    private let extrinsicData:[Coordinate:Cell]
    private var intrinsicData:[Coordinate:Cell]
    private let queue:DispatchQueue
    
    init(extrinsic:[Coordinate: Cell]){
        self.extrinsicData = extrinsic
        self.intrinsicData = Dictionary<Coordinate, Cell>()
        self.queue = DispatchQueue(label: "dataQ", attributes: .concurrent)
    }
    
    subscript(key: Coordinate) -> Int? {
        get {
            var result:Int?
            queue.sync {
                if let cell = intrinsicData[key]{
                    result = cell.value
                }else{
                    result = extrinsicData[key]?.value
                }
            }
            return result
        }
        set(value) {
            if value != nil{
                queue.sync(flags: .barrier) {
                    intrinsicData[key] = Cell(col: key.col, row: key.row, val: value!)
                }
            }

        }
    }
    
    var total: Int{
        var result = 0
        
        queue.sync {
            result = extrinsicData.values.reduce(0, { total, cell in
                if let intrinsicCell = self.intrinsicData[cell.coordinate]{
                    return total + intrinsicCell.value
                }else{
                    return total + cell.value
                }
            })
        }
        return result
    }
    
    var count: Int{
        var result = 0
        queue.sync {
            result = intrinsicData.count
        }
        return result
    }
}
