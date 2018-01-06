//
//  Snake.swift
//  SnakeGame
//
//  Created by Rodrigo Labronici on 02/01/18.
//  Copyright © 2018 Rodrigo Labronici. All rights reserved.
//

import Foundation

struct MapPosition {
    var x: Int
    var y: Int
    
    init(){
        self.x = 0
        self.y = 0
    }
    
    init(x: Int, y: Int){
        self.x = x
        self.y = y
    }
}

class Snake {
    var direction: Directions = .down
    var length: Int = 3
    var mapPositions = [MapPosition]()
    var lastPosition: MapPosition!
    
    init() {
        
        mapPositions.append(MapPosition(x: 5, y: 5))
        mapPositions.append(MapPosition(x: 5, y: 4))
        mapPositions.append(MapPosition(x: 5, y: 3))
        
        lastPosition = mapPositions.last
    }
    
    func move(){
        changeTailPosition()
        switch direction {
        case .up:
            mapPositions[0].y -= 1
        case .down:
            mapPositions[0].y += 1
        case .right:
            mapPositions[0].x += 1
        case .left:
            mapPositions[0].x -= 1
        default:
            assert(false, "parou pq?")
        }
    }
    
    func increaseSnakeLength(){
        mapPositions.append(MapPosition(x: lastPosition.x, y: lastPosition.y))
        length += 1
    }
    
    func changeTailPosition(){
        var i = length - 1
        while i >= 1{
            self.mapPositions[i].x = self.mapPositions[i-1].x
            self.mapPositions[i].y = self.mapPositions[i-1].y
            i -= 1
        }
    }

}


