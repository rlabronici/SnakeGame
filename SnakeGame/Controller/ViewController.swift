//
//  ViewController.swift
//  SnakeGame
//
//  Created by Rodrigo Labronici on 02/01/18.
//  Copyright © 2018 Rodrigo Labronici. All rights reserved.
//

import UIKit

class ViewController: UIViewController, MapViewDelegate {
    
    var height: CGFloat!
    var width: CGFloat!
    var heightSquaresNumbers: CGFloat = 0
    let widthSquaresNumbers: CGFloat = 17
    let widthGap: CGFloat = 20
    var heightGap: CGFloat = 20
    
    var mapView: MapView!
    
    var snake: Snake?
    
    var squareSize: CGFloat!
    
    var fruitPosition = MapPosition()
    
    var loopGame: Timer!
    
    var scoreLabel: UILabel!
    var score: Int = 0
    
    var easyButton: UIButton!
    var mediumButton: UIButton!
    var hardButton: UIButton!
    
    var gameOverLabel: UILabel!
    
    var scoreView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.init(red: 101/255, green: 150/255, blue: 154/255, alpha: 1)
        
        createMapView()
        createMenu()
        self.view.addSubview(mapView)
        
        scoreLabel = createLabel(x: mapView.frame.width / 2, y: mapView.frame.height, labelName: "Score: \(score)", fontSize: 20)
        
        addSwipeGesture()
        
        
    }
    
    func createMapView(){
        height = self.view.frame.size.height - heightGap
        width = self.view.frame.size.width - heightGap
        
        let proportion =  width / height
        squareSize = width / widthSquaresNumbers
        heightSquaresNumbers = widthSquaresNumbers / proportion
        
        heightGap = heightSquaresNumbers - CGFloat(Int(heightSquaresNumbers))
        heightSquaresNumbers -= heightGap
        heightGap = widthGap + heightGap * squareSize
        
        let rect = CGRect(origin: CGPoint(x: widthGap / 2, y: heightGap / 2), size: CGSize(width: CGFloat(widthSquaresNumbers) * squareSize, height: heightSquaresNumbers * squareSize))
        mapView = MapView(frame: rect, squareSize: squareSize)
        mapView.viewControllerDelegate = self
    }
    
    func createMenu(){
        easyButton = createButton(x: width/2, y: height * 0.3, labelName: "Easy", selector: #selector(pressLevelButton(_:)))
        mediumButton = createButton(x: width/2, y: height * 0.5, labelName: "Medium", selector: #selector(pressLevelButton(_:)))
        hardButton = createButton(x: width/2, y: height * 0.7, labelName: "Hard", selector: #selector(pressLevelButton(_:)))
    }

    func createLabel(x:CGFloat, y:CGFloat, labelName: String, fontSize: CGFloat) -> UILabel{
        
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: 0.9 * mapView.frame.width, height: fontSize + 20))
        label.text = labelName
        label.center.x = x
        label.center.y = y
        label.numberOfLines = 1
        label.minimumScaleFactor = 0.5
        label.baselineAdjustment = .alignCenters
        label.textAlignment  = .center
        label.font = UIFont(name:"Futura-Bold", size: fontSize)
        label.adjustsFontSizeToFitWidth = true
        
        return label
    }
    
    func createButton(x: CGFloat, y: CGFloat, labelName: String, selector: Selector) -> UIButton{
        let button = UIButton(frame: CGRect(origin: CGPoint(x: 0, y: 0), size: CGSize(width: 0.9 * mapView.frame.width, height: 40)))
        button.addTarget(self, action: selector, for: .touchUpInside)
        button.setTitle(labelName, for: .normal)
        button.setTitleColor(UIColor.init(red: 101/255, green: 150/255, blue: 154/255, alpha: 1), for: .normal)
        button.center.x = x
        button.center.y = y
        button.titleLabel?.textAlignment = .center
        button.titleLabel?.baselineAdjustment = .alignCenters
        button.titleLabel?.minimumScaleFactor = 0.5
        button.titleLabel?.adjustsFontSizeToFitWidth = true
        button.titleLabel?.font = UIFont(name:"Futura-Bold", size: 30.0)
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
        
        snake = Snake()
        for _ in 0..<3{
            mapView.updateSnakeLayer()
        }
        
        createFruit()
        
        score = 0
        
        scoreView = UIView(frame: CGRect(origin: CGPoint(x: 0, y: 0), size: mapView.frame.size))
        mapView.addSubview(scoreView)
        
        scoreView.addSubview(scoreLabel)
        scoreLabel.isHidden = false
        
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
        if let snake = snake{
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
    }

    @objc func loopTimer(){
        self.snake?.move()
        snake?.lastPosition = snake?.mapPositions.last
        if hasEatenFruit(){
            snake?.increaseSnakeLength()
            mapView.updateSnakeLayer()
            score += 1
            scoreLabel.text = "Score: \(score)"
            createFruit()
            mapView.bringSubview(toFront: scoreView)
        }
        if hasHitSomething(){
            gameOver()
            return
        }
        mapView.drawSnake()
        mapView.drawFruit()
    }
    
    func hasEatenFruit() -> Bool{
        if fruitPosition.x == snake?.mapPositions[0].x && fruitPosition.y == snake?.mapPositions[0].y{
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
        for position in (snake?.mapPositions)!{
            if positionX == position.x && positionY == position.y{
                return false
            }
        }
        return true
    }
    
    func hasHitSomething() -> Bool{
        let snakeHead = snake?.mapPositions.first
        for i in 1..<(snake?.length)!{
            if snakeHead?.x == snake?.mapPositions[i].x && snakeHead?.y == snake?.mapPositions[i].y{
                return true
            }
        }
        if (snakeHead?.x)! < 0 || (snakeHead?.x)! >= Int(widthSquaresNumbers) || (snakeHead?.y)! < 0 || (snakeHead?.y)! >= Int(heightSquaresNumbers){
            return true
        }
        return false
    }
    
    func gameOver(){
        loopGame.invalidate()
        gameOverLabel = createLabel(x: mapView.frame.width / 2, y: mapView.frame.height * 0.3, labelName: "Game Over", fontSize: 80)
        mapView.addSubview(gameOverLabel)
        
        _ = createButton(x: mapView.frame.width / 2,
                         y: gameOverLabel.frame.height + gameOverLabel.frame.origin.y + 0.2 * mapView.frame.height,
                         labelName: "Retry",
                         selector: #selector(retry(_:)))
    }
    
    @objc func retry(_ sender: UIButton){
        sender.removeFromSuperview()
        gameOverLabel.removeFromSuperview()
        snake?.mapPositions = [MapPosition]()
        mapView.restart()
        score = 0
        scoreLabel.text = "Score: \(score)"
        scoreLabel.isHidden = true
        
        easyButton.isHidden = false
        mediumButton.isHidden = false
        hardButton.isHidden = false
    }
    
    func getSnake() -> Snake?{
        return snake
    }
    
    func getFruitPosition() -> MapPosition?{
        return fruitPosition
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }

}

