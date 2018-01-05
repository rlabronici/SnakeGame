//
//  MapView.swift
//  SnakeGame
//
//  Created by Rodrigo Labronici on 02/01/18.
//  Copyright © 2018 Rodrigo Labronici. All rights reserved.
//

import Foundation
import UIKit

class MapView: UIView{
    
    var squareSize: CGFloat!
    var snake: Snake!
    //var snakeDraw: CGRect!
    var snakeLayer = [CAShapeLayer]()

    var fruitLayer = CAShapeLayer()
    var fruit: CGRect!
    
    init(frame: CGRect, squareSize: CGFloat, snake: Snake){
        super.init(frame: frame)
        
        self.backgroundColor = .white
        self.squareSize = squareSize
        self.snake = snake
        
        drawSnake(snake)
    }
    
    func drawSnake(_ snake: Snake){
        
        //snakeLayer = CAShapeLayer()
        for snakes in snakeLayer{
            snakes.removeFromSuperlayer()
        }
        //snakeLayer.removeFromSuperlayer()
        var i = 0
        for location in snake.mapPositions{
            
            let snakeDraw = CGRect(origin: CGPoint(x: squareSize * CGFloat(location.x), y: squareSize * CGFloat(location.y)), size: CGSize(width: squareSize, height: squareSize))
            
            let sl = CAShapeLayer()
            sl.path = UIBezierPath(rect: snakeDraw).cgPath
            sl.strokeColor = UIColor.clear.cgColor
            sl.fillColor = UIColor.black.cgColor
            self.layer.addSublayer(sl)
            snakeLayer.append(sl)
            
//            snakeLayer.path = UIBezierPath(rect: snakeDraw).cgPath
//            snakeLayer.strokeColor = UIColor.clear.cgColor
//            snakeLayer.fillColor = UIColor.black.cgColor
//            self.layer.addSublayer(snakeLayer)
//            print("snake[\(i)] location \(location)")
            i += 1
        }
    }
    
    func drawFruit(x: Int, y: Int){
        
        
        fruit = CGRect(origin: CGPoint(x: squareSize * CGFloat(x), y: squareSize * CGFloat(y)), size: CGSize(width: squareSize, height: squareSize))
        
        fruitLayer.path = UIBezierPath(rect: fruit).cgPath
        fruitLayer.strokeColor = UIColor.clear.cgColor
        fruitLayer.fillColor = UIColor.red.cgColor
        self.layer.addSublayer(fruitLayer)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
