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
    var snakeDraw: CGRect!
    var snakeLayer = CAShapeLayer()
    var fruitLayer = CAShapeLayer()
    var fruit: CGRect!
    
    init(frame: CGRect, squareSize: CGFloat, snake: Snake){
        super.init(frame: frame)
        
        self.backgroundColor = .white
        self.squareSize = squareSize
        self.snake = snake
        
        drawSnake()
    }
    
    func drawSnake(){
       snakeDraw = CGRect(origin: CGPoint(x: squareSize * CGFloat(snake.mapPositions[0].x), y: squareSize * CGFloat(snake.mapPositions[0].y)), size: CGSize(width: squareSize, height: squareSize))
        
        snakeLayer.path = UIBezierPath(rect: snakeDraw).cgPath
        snakeLayer.strokeColor = UIColor.clear.cgColor
        snakeLayer.fillColor = UIColor.black.cgColor
        self.layer.addSublayer(snakeLayer)
    }
    
    func drawFruit(x: Int, y: Int){
        
        fruit = CGRect(origin: CGPoint(x: squareSize * CGFloat(x), y: squareSize * CGFloat(y)), size: CGSize(width: squareSize, height: squareSize))
        
        fruitLayer.path = UIBezierPath(rect: fruit).cgPath
        fruitLayer.strokeColor = UIColor.clear.cgColor
        fruitLayer.fillColor = UIColor.black.cgColor
        self.layer.addSublayer(fruitLayer)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
