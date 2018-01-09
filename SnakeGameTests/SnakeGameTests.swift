//
//  SnakeGameTests.swift
//  SnakeGameTests
//
//  Created by Rodrigo Labronici on 02/01/18.
//  Copyright © 2018 Rodrigo Labronici. All rights reserved.
//

import XCTest
@testable import SnakeGame

class SnakeGameTests: XCTestCase {
    
    var viewController: ViewController!
    
    override func setUp() {
        super.setUp()
        
        viewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "view") as! ViewController
        
        _ = viewController.view
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
        viewController = nil
    }
    
    func testDrawPerformance() {
        viewController.startGameWith(0.3)
        self.measure {
            viewController.loopTimer()
        }
    }
    
    func testCreateSnake(){
        viewController.snake = Snake()
        XCTAssertEqual(viewController.snake?.length, 3, "Tamanho inicial da cobra deve ser 3")
    }
    
    func testCreateSnakeAndLayer(){
        viewController.startGameWith(0.3)
        XCTAssertTrue(viewController.snake?.length == viewController.mapView.snakeLayers.count)
    }
    
    func testIncreaseSnakeAndLayer() {
        viewController.startGameWith(0.3)
        viewController.snake?.increaseSnakeLength()
        viewController.mapView.updateSnakeLayer()
        XCTAssertTrue(viewController.snake?.length == viewController.mapView.snakeLayers.count)
    }
    
    
}
