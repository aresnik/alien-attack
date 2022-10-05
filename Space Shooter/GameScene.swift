//
//  GameScene.swift
//  Space Shooter
//
//  Created by Alex Resnik on 9/5/22.
//

import SpriteKit
import GameplayKit

var gameScore = 0

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    var gamePaused:Bool
    
    var livesNumber:Int
    var levelNumber:Int
    
    var pauseLabel:SKLabelNode
    var tapToStartLabel:SKLabelNode
    var scoreLabel:SKLabelNode
    var livesLabel:SKLabelNode
   
    var player:SKSpriteNode
    
    let bulletSound:SKAction
    let explosionSound:SKAction

    
    enum gameState{
        case preGame //when the game state is before the game
        case inGame //when the game state is during the game
        case afterGame //when the game state is after the game
    }
    
    var currentGameState = gameState.preGame
    
    // Compute game area before init.
    var gameArea: CGRect {
        let maxAspectRatio: CGFloat = 16.0 / 9.0
        let playableWidth = size.height / maxAspectRatio
        let margin = (size.width - playableWidth) / 2
        return CGRect(x: margin, y: 0, width: playableWidth, height: size.height)
    }
    
    
    struct PhysicsCategories{
        static let None : UInt32 = 0
        static let Player : UInt32 = 0b1 //1
        static let Bullet : UInt32 = 0b10 //2
        static let Enemy : UInt32 = 0b100 //4
    }
    
    override init(size: CGSize) {
        
        gamePaused = UserDefaults().bool(forKey: "gamePaused")
        
        livesNumber = 3
        levelNumber = 0
        
        player = SKSpriteNode(imageNamed: "playerShip")
        
        pauseLabel = SKLabelNode(fontNamed: "The Bold Font")
        tapToStartLabel = SKLabelNode(fontNamed: "The Bold Font")
        scoreLabel = SKLabelNode(fontNamed: "The Bold Font")
        livesLabel = SKLabelNode(fontNamed: "The Bold Font")
        
        bulletSound = SKAction.playSoundFileNamed("BulletSoundEffect.wav", waitForCompletion: false)
        explosionSound = SKAction.playSoundFileNamed("ExplosionSoundEffect.wav", waitForCompletion: false)
        
        super.init(size: size)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func random() -> CGFloat{
        return CGFloat(Double(arc4random()) / 0xFFFFFFFF)
    }
    func random(min: CGFloat,max: CGFloat) -> CGFloat {
        return random() * (max - min) + min
    }
    
    override func didMove(to view: SKView) {
        
        gameScore = 0
        
        self.physicsWorld.contactDelegate = self

        
        for i in 0...1{
        
            var background = SKSpriteNode(imageNamed: "background")
            background.size = self.size
            background.anchorPoint = CGPoint(x: 0.5, y: 0)
            background.position = CGPoint(x: self.size.width/2, y: self.size.height*CGFloat(i))
            background.zPosition = 0
            background.name = "Background"
            self.addChild(background)
            
        }
        
        let starfield:SKEmitterNode!

        starfield = SKEmitterNode(fileNamed: "Starfield")
        starfield.position = CGPoint(x: 0, y: 1472)
        starfield.advanceSimulationTime(10)
        self.addChild(starfield)
        
        starfield.zPosition = 0
        
        player.setScale(1)
        player.position = CGPoint(x: self.size.width/2, y: 0 - self.size.height)
        player.zPosition = 2
        player.physicsBody = SKPhysicsBody(rectangleOf: player.size)
        player.physicsBody!.affectedByGravity = false
        player.physicsBody!.categoryBitMask = PhysicsCategories.Player
        player.physicsBody!.collisionBitMask = PhysicsCategories.None
        player.physicsBody!.contactTestBitMask = PhysicsCategories.Enemy
        self.addChild(player)
        
        scoreLabel.text = "Score: 0"
        scoreLabel.fontSize = 70
        scoreLabel.fontColor = SKColor.white
        scoreLabel.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.left
        scoreLabel.position = CGPoint(x: self.size.width*0.15, y: self.size.height + scoreLabel.frame.size.height)
        scoreLabel.zPosition = 100
        self.addChild(scoreLabel)
        
        let moveOnToScreenAction = SKAction.moveTo(y: self.size.height*0.9, duration: 0.3)
        scoreLabel.run(moveOnToScreenAction)
        livesLabel.run(moveOnToScreenAction)
        
        
        livesLabel.text = "Lives: 3"
        livesLabel.fontSize = 70
        livesLabel.fontColor = SKColor.white
        livesLabel.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.right
        livesLabel.position = CGPoint(x: self.size.width*0.85, y: self.size.height + livesLabel.frame.size.height)
        livesLabel.zPosition = 100
        self.addChild(livesLabel)
        
        
        tapToStartLabel.text = "Tap To Begin"
        tapToStartLabel.fontSize = 100
        tapToStartLabel.fontColor = SKColor.white
        tapToStartLabel.zPosition = 1
        tapToStartLabel.position = CGPoint(x: self.size.width/2, y: self.size.height/2)
        tapToStartLabel.alpha = 0
        self.addChild(tapToStartLabel)
        
        let fadInAction = SKAction.fadeIn(withDuration: 0.3)
        tapToStartLabel.run(fadInAction)
        
        
    }
    
    var lastUpdateTime: TimeInterval = 0
    var deltaFrameTime: TimeInterval = 0
    var amountToMovePerSecond: CGFloat = 600.0
    
    
    override func update(_ currentTime: TimeInterval) {
        
        if lastUpdateTime == 0 {
            lastUpdateTime = currentTime
        }
        else {
            deltaFrameTime = currentTime - lastUpdateTime
            lastUpdateTime = currentTime
        }
        
        let amountToMoveBackground = amountToMovePerSecond * CGFloat(deltaFrameTime)
        
        self.enumerateChildNodes(withName: "Background") {
            (background, stop) in
            
            if self.currentGameState == gameState.inGame {
                background.position.y -= amountToMoveBackground
            }
        
            if background.position.y < -self.size.height {
                background.position.y += self.size.height*2
            }
        }
    }
    
    func startGame(){
        
        currentGameState = gameState.inGame
        
        let fadOutAction = SKAction.fadeOut(withDuration: 0.5)
        let deleteActioon = SKAction.removeFromParent()
        let deleteSequence = SKAction.sequence([fadOutAction, deleteActioon])
        tapToStartLabel.run(deleteSequence)
        
        let moveShipOnToScreenAction = SKAction.moveTo(y: self.size.height*0.2, duration: 0.5)
        let startLevelAction = SKAction.run(startNewLevel)
        let startGameSquence = SKAction.sequence([moveShipOnToScreenAction, startLevelAction])
        player.run(startGameSquence)
        
        let spawnBullet = SKAction.run(fireBullet)
        let waitToSpawnBullet = SKAction.wait(forDuration: 0.2)
        let spawnBulletSequence = SKAction.sequence([waitToSpawnBullet, spawnBullet])
        let spawnBulletForever = SKAction.repeatForever(spawnBulletSequence)
        self.run(spawnBulletForever)
        
        pauseLabel.text = "Pause"
        pauseLabel.fontSize = 50
        pauseLabel.fontColor = SKColor.white
        pauseLabel.zPosition = 100
        pauseLabel.position = CGPoint(x: self.size.width/2, y: self.size.height*0.9)
        self.addChild(pauseLabel)
        
    }
    
    
    func loseLife(){
        
        livesNumber -= 1
        livesLabel.text = "Lives: \(livesNumber)"
        
        let scaleUp = SKAction.scale(to: 1.5, duration: 0.2)
        let scaleDown = SKAction.scale(to: 1, duration: 0.2)
        let scaleSequence = SKAction.sequence([scaleUp, scaleDown])
        livesLabel.run(scaleSequence)
        
        if livesNumber == 0{
            runGameOver()
        }
    }
    
    
    func addScore(){
        
        gameScore += 1
        scoreLabel.text = "Score: \(gameScore)"
        
        if (gameScore == 10 || gameScore == 25 || gameScore == 50 || gameScore == 75 || gameScore == 100) {
            startNewLevel()
        }
        
    }
    
    
    func runGameOver(){
        
        currentGameState = gameState.afterGame
        
        self.removeAllActions()
        
        self.enumerateChildNodes(withName: "Bullet"){
            bullet,stop in
            bullet.removeAllActions()
        }
        
        self.enumerateChildNodes(withName: "Enemy"){
            enemy,stop in
            enemy.removeAllActions()
        }
        
        let changeSceneAction = SKAction.run(changeScene)
        let waitToChangeScene = SKAction.wait(forDuration: 1)
        let changeSequence = SKAction.sequence([waitToChangeScene, changeSceneAction])
        self.run(changeSequence)
        
    }
    
    
    func changeScene() {
        let sceneToMoveTo = GameOverScene(size: self.size)
        sceneToMoveTo.scaleMode = self.scaleMode
        let myTransition = SKTransition.fade(withDuration: 0.5)
        self.view!.presentScene(sceneToMoveTo, transition: myTransition)
    }
    
    
    func didBegin(_ contact: SKPhysicsContact) {
        
        var body1 = SKPhysicsBody()
        var body2 = SKPhysicsBody()
        
        if contact.bodyA.categoryBitMask < contact.bodyB.categoryBitMask{
            body1 = contact.bodyA
            body2 = contact.bodyB
        }
        else{
            body1 = contact.bodyB
            body2 = contact.bodyA
        }
        
        if body1.categoryBitMask == PhysicsCategories.Player && body2.categoryBitMask == PhysicsCategories.Enemy{
            //if the player has hit the enemy
            
            if body1.node != nil {
            spawnExplosion(spawnPosition: body1.node!.position)
            }
            
            if body2.node != nil {
            spawnExplosion(spawnPosition: body2.node!.position)
            }
            
            body1.node?.removeFromParent()
            body2.node?.removeFromParent()
            
            runGameOver()
            
        }
        
        if body1.categoryBitMask == PhysicsCategories.Bullet && body2.categoryBitMask == PhysicsCategories.Enemy && (body2.node?.position.y)! < self.size.height {
            //if the bullet has hit the enemy
            
            addScore()
            
            if body2.node != nil {
            spawnExplosion(spawnPosition: body2.node!.position)
            }
            
            body1.node?.removeFromParent()
            body2.node?.removeFromParent()
            
        }
        
    }
    
    func spawnExplosion(spawnPosition: CGPoint){
    
        let explosion = SKEmitterNode(fileNamed: "Explosion")!
        explosion.position = spawnPosition
        explosion.zPosition = 3
        explosion.setScale(0)
        self.addChild(explosion)
        
        let scaleIn = SKAction.scale(to: 2, duration: 1)
        let fadeOut = SKAction.fadeOut(withDuration: 1)
        let delete = SKAction.removeFromParent()
        
        let exlosionSequence = SKAction.sequence([explosionSound, scaleIn, fadeOut, delete])
        
        explosion.run(exlosionSequence)
        
    }
    
    
    func startNewLevel(){
        
        levelNumber += 1
        
        if self.action(forKey: "spawningEnemies") != nil{
            self.removeAction(forKey: "spawningEnemies")
        }
        
        var levelDuration = NSTimeIntervalSince1970
        
        switch levelNumber {
        case 1: levelDuration = 2
        case 2: levelDuration = 1
        case 3: levelDuration = 0.8
        case 4: levelDuration = 0.5
        case 5: levelDuration = 0.4
        default:
            levelDuration = 0.4
            print("Cannot find level info")
        }
        
        let spawnEnemy = SKAction.run(spawnEnemy)
        let waitToSpawnEnemy = SKAction.wait(forDuration: levelDuration)
        let spawnEnemySequence = SKAction.sequence([waitToSpawnEnemy, spawnEnemy])
        let spawnEnemyForever = SKAction.repeatForever(spawnEnemySequence)
        self.run(spawnEnemyForever, withKey: "spawningEnemies")
        
    }
    
    func fireBullet(){
        
        pauseLabel.text = "Pause"
        
        let bullet:SKSpriteNode!
        
        bullet = SKSpriteNode(imageNamed: "bullet")
        bullet.name = "Bullet"
        bullet.setScale(1)
        bullet.position = player.position
        bullet.zPosition = 1
        bullet.physicsBody = SKPhysicsBody(rectangleOf: bullet.size)
        bullet.physicsBody!.affectedByGravity = false
        bullet.physicsBody!.categoryBitMask = PhysicsCategories.Bullet
        bullet.physicsBody!.collisionBitMask = PhysicsCategories.None
        bullet.physicsBody!.contactTestBitMask = PhysicsCategories.Enemy
        self.addChild(bullet)
        
        let moveBullet = SKAction.moveTo(y: self.size.height + bullet.size.height, duration: 1)
        let deleteBullet = SKAction.removeFromParent()
        let bulletSquence = SKAction.sequence([bulletSound, moveBullet, deleteBullet])
        bullet.run(bulletSquence)
        
    }
    
    func spawnEnemy(){
        
        let randomXStart = random(min: gameArea.minX, max: gameArea.maxX)
        let randomXEnd = random(min: gameArea.minX, max: gameArea.maxX)
        
        let startPoint = CGPoint(x: randomXStart, y: self.size.height * 1.2)
        let endPoint = CGPoint(x: randomXEnd, y: -self.size.height * 0.2)
        
        let enemy = SKSpriteNode(imageNamed: "enemyShip")
        
        enemy.name = "Enemy"
        enemy.setScale(0.5)
        enemy.position = startPoint
        enemy.zPosition = 2
        enemy.physicsBody = SKPhysicsBody(rectangleOf: enemy.size)
        enemy.physicsBody!.affectedByGravity = false
        enemy.physicsBody!.categoryBitMask = PhysicsCategories.Enemy
        enemy.physicsBody!.collisionBitMask = PhysicsCategories.None
        enemy.physicsBody!.contactTestBitMask = PhysicsCategories.Player | PhysicsCategories.Bullet
        self.addChild(enemy)
        
        let moveEnemy = SKAction.move(to: endPoint, duration: 5)
        let deleteEnemy = SKAction.removeFromParent()
        let loseALifeAction = SKAction.run(loseLife)
        let enemySquence = SKAction.sequence([moveEnemy, deleteEnemy, loseALifeAction])
        
        if currentGameState == gameState.inGame{
        enemy.run(enemySquence)
        }
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        
        if currentGameState == gameState.preGame{
            startGame()
        }
        
        for touch in touches {
            
            let pointOfTouch = touch.location(in: self)
            
            if pauseLabel.contains(pointOfTouch){

                if currentGameState == gameState.inGame && scene?.isPaused == false{

                    scene?.isPaused = true
                    pauseLabel.text = "Resume"
                    UserDefaults().set(true, forKey: "gamePaused")
                    
                }
                else if currentGameState == gameState.inGame && scene?.isPaused == true{
                    
                    scene?.isPaused = false
                    pauseLabel.text = "Pause"
                    UserDefaults().set(false, forKey: "gamePaused")
                }
                
                
            }
        }
        
        
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        if scene?.isPaused == false{
            
            for touch in touches {
                
                let pointOfTouch = touch.location(in: self)
                let previousPointOfTouch = touch.previousLocation(in: self)
                
                let amountDragged = pointOfTouch.x - previousPointOfTouch.x
                
                if currentGameState == gameState.inGame{
                    player.position.x += amountDragged
                }
                
                if player.position.x > gameArea.maxX {
                    player.position.x = gameArea.maxX
                }
                
                if player.position.x < gameArea.minX{
                    player.position.x = gameArea.minX
                }
                
            }
        }
    }

}

