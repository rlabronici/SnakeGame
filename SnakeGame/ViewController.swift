//
//  ViewController.swift
//  SnakeGame
//
//  Created by Rodrigo Labronici on 02/01/18.
//  Copyright © 2018 Rodrigo Labronici. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    let heightSquaresNumbers: CGFloat = 20
    var widthSquaresNumbers: CGFloat!
    let gap: CGFloat = 20
    
    var mapView: MapView!
    
    var snake: Snake!
    
    var squareSize: CGFloat!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.blue
        
        
        let height = self.view.frame.size.height - gap
        let width = self.view.frame.size.width - gap
        
        let proportion =  width / height
        
        squareSize = height / CGFloat(heightSquaresNumbers)
        widthSquaresNumbers = CGFloat(heightSquaresNumbers) * proportion
        
        snake = Snake()
        
        let rect = CGRect(origin: CGPoint(x: gap / 2, y: gap / 2), size: CGSize(width: widthSquaresNumbers * squareSize, height: heightSquaresNumbers * squareSize))
        mapView = MapView(frame: rect, squareSize: squareSize, snake: snake)
        self.view.addSubview(mapView)
        
        let loopGame = Timer.scheduledTimer(timeInterval: 0.3, target: self, selector: #selector(ViewController.loopTimer), userInfo: nil, repeats: true)
        
        addSwipeGesture()
        
        
    }

    func addSwipeGesture(){
        let swipes: [UISwipeGestureRecognizerDirection] = [.up, .down, .right, .left]

        for swipe in swipes{
            let gestureRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(self.handleSwipe(_:)))
            gestureRecognizer.direction = swipe
            self.view.addGestureRecognizer(gestureRecognizer)
        }
    }
    
    @objc func handleSwipe(_ sender: UISwipeGestureRecognizer){
        let direction = sender.direction
        switch direction {
        case  UISwipeGestureRecognizerDirection.up:
            snake.direction = .up
        case  UISwipeGestureRecognizerDirection.down:
            snake.direction = .down
        case  UISwipeGestureRecognizerDirection.right:
            snake.direction = .right
        case  UISwipeGestureRecognizerDirection.left:
            snake.direction = .left
        default:
            assert(false, "movimento incorreto")
        }
    }

    @objc func loopTimer(){
        self.snake.move()
        mapView.drawSnake()
        
    }
    
    func willDrawFruit(){
        var positionX: Int
        var positionY: Int
        repeat{
            positionX = Int(arc4random_uniform(UInt32(widthSquaresNumbers)))
            positionY = Int(arc4random_uniform(UInt32(heightSquaresNumbers)))
        } while(!canCreateFruit(positionX, positionY))
        mapView.drawFruit(x: positionX, y: positionY)
    }
    
    func canCreateFruit(_ positionX: Int,_ positionY: Int) -> Bool{
        for position in snake.mapPositions{
            if positionX == position.x && positionY == position.y{
                return false
            }
        }
        return true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }

}

