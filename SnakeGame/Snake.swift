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
}

class Snake {
    var direction: Directions = .down
    var length: Int = 1
    var mapPositions = [MapPosition]()
    
    
    init() {
        
        mapPositions.append(MapPosition(x: 0, y: 0))
    }
    
    func move(){
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

}


