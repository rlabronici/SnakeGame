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
    
    var snakeLayer = [CAShapeLayer]()
    let fruitLayer = CAShapeLayer()
    
    var viewControllerDelegate: MapViewDelegate?
    
    init(frame: CGRect, squareSize: CGFloat){
        super.init(frame: frame)
        
        
        self.backgroundColor = UIColor.init(red: 216/255, green: 207/255, blue: 178/255, alpha: 1)
        self.squareSize = squareSize
        
    }
    
    func drawSnake(){
        
        for snakes in snakeLayer{
            snakes.removeFromSuperlayer()
        }
        if let snake = viewControllerDelegate?.getSnake(){
            for i in 0..<snake.mapPositions.count{
                
                let snakeDraw = CGRect(origin: CGPoint(x: squareSize * CGFloat(snake.mapPositions[i].x), y: squareSize * CGFloat(snake.mapPositions[i].y)), size: CGSize(width: squareSize, height: squareSize))
                
                let sl = CAShapeLayer()
                sl.path = UIBezierPath(rect: snakeDraw).cgPath
                sl.strokeColor = UIColor.clear.cgColor
        
                var b = 107+(i * 10)
                sl.fillColor = UIColor.init(red: 0/255, green: 65/255, blue: CGFloat(b) / 255 , alpha: 1).cgColor
                
                
                self.layer.addSublayer(sl)
                snakeLayer.append(sl)
            }
        }
    }
    
    func drawFruit(x: Int, y: Int){
        
        
        let fruit = CGRect(origin: CGPoint(x: squareSize * CGFloat(x), y: squareSize * CGFloat(y)), size: CGSize(width: squareSize, height: squareSize))
        
        fruitLayer.path = UIBezierPath(ovalIn: fruit).cgPath
        fruitLayer.strokeColor = UIColor.clear.cgColor
        fruitLayer.fillColor = UIColor.red.cgColor
        self.layer.addSublayer(fruitLayer)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    
}
