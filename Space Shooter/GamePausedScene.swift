//
//  GamePausedScene.swift
//  Space Shooter
//
//  Created by Alex Resnik on 10/3/22.
//

import Foundation
import SpriteKit

class GamePauseScene: SKScene {
    
    //IMages
    let background: SKSpriteNode
    
    // Text.
    let gameFont: String

    var resumeGame = SKLabelNode()
    
    
    override init(size: CGSize) {
        // Images.
        background = SKSpriteNode(imageNamed: "background")
        background.zPosition = 0
        
        
        //Text.
        gameFont = "The Bold Font"
        
        super.init(size: size)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func didMove(to view: SKView) {
        
        // Set background size.
        background.size = self.size
        background.position = CGPoint(x: self.size.width/2, y: self.size.height/2)
        self.addChild(background)
        
        // Set up labels.
        resumeGame = makeLabel(text: "Resume Game", fontSize: 100,fontColor: SKColor.white,
        position: CGPoint(x: self.size.width*0.5, y: self.size.height*0.4))
        resumeGame.name = "resumeButton"
        self.addChild(resumeGame)
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch: AnyObject in touches {
            
            let pointOfTouch = touch.location(in: self)
            let nodeITouched = atPoint(pointOfTouch)
            
            if nodeITouched.name == "resumeButton" {
                let sceneToMoveTo = GameScene(size: size)
                sceneToMoveTo.scaleMode = self.scaleMode
                let myTransition = SKTransition.fade(withDuration: 0.5)
                self.view!.presentScene(sceneToMoveTo, transition: myTransition)
            }
            
        }
        
    }
    func makeLabel(text: String, fontSize: CGFloat, fontColor: SKColor, position: CGPoint) -> SKLabelNode {
        let labelNode = SKLabelNode(fontNamed: gameFont)
        labelNode.text = text
        labelNode.fontSize = fontSize
        labelNode.fontColor = fontColor
        labelNode.position = position
        labelNode.zPosition = 1
        return labelNode
    }
}

    

