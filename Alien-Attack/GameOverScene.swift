//
//  GameOverScene.swift
//  Space Shooter
//
//  Created by Alex Resnik on 9/10/22.
//

import Foundation
import SpriteKit
import GameplayKit


class GameOverScene: SKScene {

    let restartLabel = SKLabelNode(fontNamed: "The Bold Font")
    
    var backColor: UIColor

    
    override init(size: CGSize) {
        
        backColor = UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.0)

        super.init(size: size)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        
        fatalError("init(coder:) has not been implemented")
        
    }
    
    override func didMove(to view: SKView) {
        
        backgroundColor = backColor
        
        let background = SKSpriteNode(imageNamed: "background")
        
        background.size = self.size
        background.position = CGPoint(x: self.size.width/2, y: self.size.height/2)
        background.zPosition = 0
        
        self.addChild(background)
        
        let gameOverLabel = SKLabelNode(fontNamed: "The Bold Font")
        
        gameOverLabel.text = "Game Over"
        gameOverLabel.fontSize = 200
        gameOverLabel.fontColor = SKColor.white
        gameOverLabel.position = CGPoint(x: self.size.width*0.5, y: self.size.height*0.7)
        gameOverLabel.zPosition = 1
        
        self.addChild(gameOverLabel)
        
        let scoreLabel = SKLabelNode(fontNamed: "The Bold Font")
        
        scoreLabel.text = "Score: \(gameScore)"
        scoreLabel.fontSize = 125
        scoreLabel.fontColor = SKColor.white
        scoreLabel.position = CGPoint(x: self.size.width/2, y: self.size.height*0.55)
        scoreLabel.zPosition = 1
        
        self.addChild(scoreLabel)
        
        let waveLabel = SKLabelNode(fontNamed: "The Bold Font")
        
        waveLabel.text = "Wave: \(waveNumber)"
        waveLabel.fontSize = 125
        waveLabel.fontColor = SKColor.white
        waveLabel.zPosition = 1
        waveLabel.position = CGPoint(x: self.size.width/2, y: self.size.height*0.45)
        
        self.addChild(waveLabel)
            
        restartLabel.text = "Restart"
        restartLabel.fontSize = 90
        restartLabel.fontColor = SKColor.white
        restartLabel.zPosition = 1
        restartLabel.position = CGPoint(x: self.size.width/2, y: self.size.height*0.3)
        
        self.addChild(restartLabel)
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        for touch in touches {
            
            let pointOfTouch = touch.location(in: self)
            
            if restartLabel.contains(pointOfTouch){
                
                let sceneTOMoveTo = GameScene(size: size)
                let myTransition = SKTransition.fade(withDuration: 0.5)
                
                sceneTOMoveTo.scaleMode = self.scaleMode
                
                self.view!.presentScene(sceneTOMoveTo, transition: myTransition)
            }
        }
        
    }
    
}
