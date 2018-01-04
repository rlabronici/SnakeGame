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
    
    var fruitPosition: MapPosition!
    
    var loopGame: Timer!
    
    var easyButton: UIButton!
    var mediumButton: UIButton!
    var hardButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.blue
        
        fruitPosition = MapPosition(x: 0, y: 0)
        
        let height = self.view.frame.size.height - gap
        let width = self.view.frame.size.width - gap
        
        
        
        let proportion =  width / height
        
        squareSize = height / CGFloat(heightSquaresNumbers)
        widthSquaresNumbers = CGFloat(heightSquaresNumbers) * proportion
        
        snake = Snake()
        
        let rect = CGRect(origin: CGPoint(x: gap / 2, y: gap / 2), size: CGSize(width: widthSquaresNumbers * squareSize, height: heightSquaresNumbers * squareSize))
        mapView = MapView(frame: rect, squareSize: squareSize, snake: snake)
        
        easyButton = createButtonMenu(width: width/2, height: height * 0.3, labelName: "Easy")
        mediumButton = createButtonMenu(width: width/2, height: height * 0.5, labelName: "Medium")
        hardButton = createButtonMenu(width: width/2, height: height * 0.7, labelName: "Hard")
        
        self.view.addSubview(mapView)
        
        addSwipeGesture()
        
        
    }

    func createButtonMenu(width: CGFloat, height: CGFloat, labelName: String) -> UIButton{
        let button = UIButton(frame: CGRect(origin: CGPoint(x: 0, y: 0), size: CGSize(width: 70, height: 40)))
        button.addTarget(self, action: #selector(pressLevelButton(_:)), for: .touchUpInside)
        button.setTitle(labelName, for: .normal)
        button.setTitleColor(.blue, for: .normal)
        button.center.x = width
        button.center.y = height
        mapView.addSubview(button)
        
        return button
        
    }
    
    @objc func pressLevelButton(_ sender: UIButton) {
        easyButton.isHidden = true
        mediumButton.isHidden = true
        hardButton.isHidden = true
        
        var difficulty: Double! = 0
        switch (sender.titleLabel?.text)!{
        case "Easy":
            difficulty = 0.3
        case "Medium":
            difficulty = 0.2
        case "Hard":
            difficulty = 0.1
        default:
            assert(false)
        }
        startGameWith(difficulty)
    }
    
    func startGameWith(_ difficulty: Double){
        
        createFruit()
        loopGame = Timer.scheduledTimer(timeInterval: difficulty, target: self, selector: #selector(ViewController.loopTimer), userInfo: nil, repeats: true)

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
            if snake.direction != Directions.down{
                snake.direction = .up
            }
        case  UISwipeGestureRecognizerDirection.down:
            if snake.direction != Directions.up{
                snake.direction = .down
            }
        case  UISwipeGestureRecognizerDirection.right:
            if snake.direction != Directions.left{
                snake.direction = .right
            }
        case  UISwipeGestureRecognizerDirection.left:
            if snake.direction != Directions.right{
                snake.direction = .left
            }
        default:
            assert(false, "movimento incorreto")
        }
    }

    @objc func loopTimer(){
        
        self.snake.move()
        snake.lastPosition = snake.mapPositions.last
        if hasEatenFruit(){
            snake.increaseSnakeLength()
            createFruit()
        }
        if hasHitSomething(){
            loopGame.invalidate()
            return
        }
        mapView.drawSnake(snake)
        mapView.drawFruit(x: fruitPosition.x, y: fruitPosition.y)
    }
    
    func hasEatenFruit() -> Bool{
        if fruitPosition.x == snake.mapPositions[0].x && fruitPosition.y == snake.mapPositions[0].y{
            return true
        }
        return false
    }
    
    func createFruit(){
        repeat{
            fruitPosition.x = Int(arc4random_uniform(UInt32(widthSquaresNumbers)))
            fruitPosition.y = Int(arc4random_uniform(UInt32(heightSquaresNumbers)))
        } while(!canCreateFruit(fruitPosition.x, fruitPosition.y))
       
        
    }
    
    func canCreateFruit(_ positionX: Int,_ positionY: Int) -> Bool{
        for position in snake.mapPositions{
            if positionX == position.x && positionY == position.y{
                return false
            }
        }
        return true
    }
    
    func hasHitSomething() -> Bool{
        let snakeHead = snake.mapPositions.first
        for i in 1..<snake.length{
            if snakeHead?.x == snake.mapPositions[i].x && snakeHead?.y == snake.mapPositions[i].y{
                return true
            }
        }
        if (snakeHead?.x)! < 0 || (snakeHead?.x)! >= Int(widthSquaresNumbers) || (snakeHead?.y)! < 0 || (snakeHead?.y)! >= Int(heightSquaresNumbers){
            return true
        }
        return false
    }
    
    func getSnake() -> Snake{
        return snake
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }

}

