//
//  GameOverScene.swift
//  Space Shooter
//
//  Created by Alex Resnik on 9/10/22.
//

import Foundation
import SpriteKit

class MainMenuScene: SKScene {
    
    override init(size: CGSize) {
        
        super.init(size: size)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        
        fatalError("init(coder:) has not been implemented")
        
    }
    
    override func didMove(to view: SKView) {
        
        // Set background size.
        let background = SKSpriteNode(imageNamed: "background")
        
        background.size = self.size
        background.position = CGPoint(x: self.size.width/2, y: self.size.height/2)
        
        self.addChild(background)
        
        // Set up labels.
        let gameBy = makeLabel(text: "Nova Games Studio, LLC", fontSize: 50,fontColor: SKColor.white,
        position: CGPoint(x: self.size.width*0.5, y: self.size.height*0.78))
        
        self.addChild(gameBy)
        
        let gameName1 = makeLabel(text: "Space Shooter:", fontSize: 120,fontColor: SKColor.white,
        position: CGPoint(x: self.size.width*0.5, y: self.size.height*0.7))
        
        self.addChild(gameName1)
        
        let gameName2 = makeLabel(text: "Tomatoes Invation", fontSize: 120,fontColor: SKColor.white,
        position: CGPoint(x: self.size.width*0.5, y: self.size.height*0.625))
        
        self.addChild(gameName2)
        
        let startGame = makeLabel(text: "Start Game", fontSize: 150,fontColor: SKColor.white,
        position: CGPoint(x: self.size.width*0.5, y: self.size.height*0.4))
        startGame.name = "startButton"
        
        self.addChild(startGame)
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        for touch: AnyObject in touches {
            
            let pointOfTouch = touch.location(in: self)
            let nodeITouched = atPoint(pointOfTouch)
            
            if nodeITouched.name == "startButton" {
                
                let sceneToMoveTo = GameScene(size: size)
                let myTransition = SKTransition.fade(withDuration: 0.5)
                
                sceneToMoveTo.scaleMode = self.scaleMode
                
                self.view!.presentScene(sceneToMoveTo, transition: myTransition)
            }
            
        }
        
    }
    
    func makeLabel(text: String, fontSize: CGFloat, fontColor: SKColor, position: CGPoint) -> SKLabelNode {
        
        let labelNode = SKLabelNode(fontNamed: "The Bold Font")
        
        labelNode.text = text
        labelNode.fontSize = fontSize
        labelNode.fontColor = fontColor
        labelNode.position = position
        labelNode.zPosition = 1
        
        return labelNode
    }
}
