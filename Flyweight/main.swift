//
//  main.swift
//  Flyweight
//
//  Created by p14822 on 2018/4/12.
//  Copyright © 2018年 p14822. All rights reserved.
//

import Foundation

print("Hello, World!")

let ss1 = Spreadsheet()
ss1.setValue(coord: Coordinate(col: "A", row: 1), value: 100)
ss1.setValue(coord: Coordinate(col: "J", row: 20), value: 200)

print("SS1 Total: \(ss1.total)")

let ss2 = Spreadsheet()
ss2.setValue(coord: Coordinate(col: "F", row: 10), value: 200)
ss2.setValue(coord: Coordinate(col: "G", row: 23), value: 250)

print("SS2 Total: \(ss2.total)")

print("Cells created: \(1300 + ss1.grid.count + ss2.grid.count)")
