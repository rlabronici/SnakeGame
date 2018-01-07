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
    
    var snakeLayers = [CAShapeLayer]()
    var fruitLayer = CAShapeLayer()
    
    var viewControllerDelegate: MapViewDelegate?
    
    init(frame: CGRect, squareSize: CGFloat){
        super.init(frame: frame)
        
        
        self.backgroundColor = UIColor.init(red: 216/255, green: 207/255, blue: 178/255, alpha: 1)
        self.squareSize = squareSize
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func updateSnakeLayer(){
        self.snakeLayers.append(CAShapeLayer())
        if let snake = viewControllerDelegate?.getSnake(){
            let snakeDraw = CGRect(origin: CGPoint(x: squareSize * CGFloat((snake.mapPositions.last?.x)!), y: squareSize * CGFloat((snake.mapPositions.last?.y)!)), size: CGSize(width: squareSize, height: squareSize))
            snakeLayers.last?.path = UIBezierPath(rect: snakeDraw).cgPath
            let b = 107+((snakeLayers.count - 1) * 10)
            snakeLayers.last?.fillColor = UIColor.init(red: 0/255, green: 65/255, blue: CGFloat(b) / 255 , alpha: 1).cgColor
            self.layer.addSublayer(snakeLayers.last!)
        }
    }
    
    func drawSnake(){
        print(snakeLayers.count)
        if let snake = viewControllerDelegate?.getSnake(){
            for i in 0..<snake.mapPositions.count{
                let snakeDraw = CGRect(origin: CGPoint(x: squareSize * CGFloat(snake.mapPositions[i].x), y: squareSize * CGFloat(snake.mapPositions[i].y)), size: CGSize(width: squareSize, height: squareSize))
                snakeLayers[i].path = UIBezierPath(rect: snakeDraw).cgPath
                
            }
        }
    }

    func drawFruit(){
        
        if let fruitPosition = viewControllerDelegate?.getFruitPosition(){
            let fruit = CGRect(origin: CGPoint(x: squareSize * CGFloat(fruitPosition.x), y: squareSize * CGFloat(fruitPosition.y)), size: CGSize(width: squareSize, height: squareSize))
            
            fruitLayer.path = UIBezierPath(ovalIn: fruit).cgPath
            fruitLayer.strokeColor = UIColor.clear.cgColor
            fruitLayer.fillColor = UIColor.init(red: 255/255, green: 105/255, blue: 35 / 255 , alpha: 1).cgColor
            self.layer.addSublayer(fruitLayer)
        }
    }

    func restart() {
        for snakes in snakeLayers{
            snakes.removeFromSuperlayer()
        }
        fruitLayer.removeFromSuperlayer()
        snakeLayers = [CAShapeLayer]()
        fruitLayer = CAShapeLayer()
    }
    
}
