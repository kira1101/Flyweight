//
//  spreadsheet.swift
//  Flyweight
//
//  Created by p14822 on 2018/4/12.
//  Copyright © 2018年 p14822. All rights reserved.
//

import Foundation

func == (lhs: Coordinate,rhs: Coordinate) -> Bool{
    return lhs.col == rhs.col && lhs.row == rhs.row
}

class Coordinate: Hashable,CustomStringConvertible {
    let col:Character
    let row:Int
    
    init(col:Character,row:Int) {
        self.col = col
        self.row = row
    }
    var hashValue: Int{
        return description.hashValue
    }
    
    var description: String{
        return "\(col)\(row)"
    }
}


class Cell {
    var coordinate:Coordinate
    var value:Int
    
    init(col:Character,row:Int,val:Int) {
        self.coordinate = Coordinate(col:col,row:row)
        self.value = val
    }
}

class Spreadsheet {
    var grid:Flyweight
    
    init() {
        grid = FlyweightFactory.createFlyweight()
    }
    
    func setValue(coord: Coordinate, value: Int){
        grid[coord] = value
    }
    
    var total:Int{
        return grid.total
    }
    
}
