 //
//  GameScene.swift
//  Space Shooter
//
//  Created by Alex Resnik on 9/5/22.
//

import SpriteKit
import GameplayKit
import SwiftUI


var gameScore = 0
var waveNumber = 35


class GameScene: SKScene, SKPhysicsContactDelegate {
    
    var livesNumberPlayer: Int
    var livesNumberEnemy: Int
    
    var player: SKSpriteNode
    var stopButton: SKSpriteNode
    var pauseButton: SKSpriteNode
    var enemy: [SKSpriteNode]
    
    var tapToStartLabel: SKLabelNode
    var scoreLabel: SKLabelNode
    
    var backColor: UIColor
    
    var lastUpdateTime: TimeInterval = 0
    var deltaFrameTime: TimeInterval = 0
    
    let amountToMovePerSecond: CGFloat = 100.0
    
    
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
        
        static let None: UInt32 = 0
        static let Player: UInt32 = 0b1 //1
        static let Bullet: UInt32 = 0b10 //2
        static let Enemy: UInt32 = 0b100 //4
        static let Bomb: UInt32 = 0b1000 //8
    }
    
    
    override init(size: CGSize) {
        
        UserDefaults().set(false, forKey: "gamePaused")
        
        backColor = UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.0)
        
        livesNumberPlayer = 3
        livesNumberEnemy = 3
        
        player = SKSpriteNode(imageNamed: "playerShip")
        stopButton = SKSpriteNode(imageNamed: "stopImage")
        pauseButton = SKSpriteNode(imageNamed: "pauseImage")
        enemy = [SKSpriteNode]()
            
        tapToStartLabel = SKLabelNode(fontNamed: "The Bold Font")
        scoreLabel = SKLabelNode(fontNamed: "The Bold Font")
        
        super.init(size: size)
        
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        
        fatalError("init(coder:) has not been implemented")
        
    }
    
    
    override func update(_ currentTime: TimeInterval) {
            
        scene?.isPaused = UserDefaults().bool(forKey: "gamePaused")
        
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
    
    
    override func didMove(to view: SKView) {
        
        gameScore = 0
        
        backgroundColor = backColor
        
        self.physicsWorld.contactDelegate = self
        
        for i in 0...1{
        
            let background = SKSpriteNode(imageNamed: "background")
            
            background.size = self.size
            background.anchorPoint = CGPoint(x: 0.5, y: 0)
            background.position = CGPoint(x: self.size.width / 2,
                                          y: self.size.height*CGFloat(i))
            background.zPosition = 0
            background.name = "Background"
            
            self.addChild(background)
            
        }
        
        let starfield:SKEmitterNode!

        starfield = SKEmitterNode(fileNamed: "Starfield")
        starfield.position = CGPoint(x: 0, y: 1472)
        starfield.advanceSimulationTime(10)
        starfield.zPosition = 0
        starfield.name = "Starfield"
        
        self.addChild(starfield)
        
        player.setScale(0.6)
        player.position = CGPoint(x: self.size.width/2, y: 0 - self.size.height)
        player.zPosition = 2
        
        if player.texture != nil {
            
            player.physicsBody = SKPhysicsBody(texture: player.texture!, size: player.texture!.size())
            
        }
            
        player.physicsBody?.affectedByGravity = false
        player.physicsBody?.categoryBitMask = PhysicsCategories.Player
        player.physicsBody?.collisionBitMask = PhysicsCategories.None
        player.physicsBody?.contactTestBitMask = PhysicsCategories.Enemy
        
        self.addChild(player)
        
        scoreLabel.text = "0"
        scoreLabel.fontSize = 70
        scoreLabel.fontColor = SKColor.white
        scoreLabel.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.left
        scoreLabel.position = CGPoint(x: self.size.width * 0.15, y: self.size.height + scoreLabel.frame.size.height)
        scoreLabel.zPosition = 100
        
        self.addChild(scoreLabel)
        
        let moveOnToScreenAction = SKAction.moveTo(y: self.size.height * 0.9, duration: 0.3)
        
        scoreLabel.run(moveOnToScreenAction)
        
        for n in 1 ... 3{
           
            addLives(numberOfLives: n)
            
        }
        
        tapToStartLabel.text = "Tap To Begin"
        tapToStartLabel.fontSize = 100
        tapToStartLabel.fontColor = SKColor.white
        tapToStartLabel.zPosition = 1
        tapToStartLabel.position = CGPoint(x: self.size.width / 2, y: self.size.height / 2)
        tapToStartLabel.alpha = 0
        
        self.addChild(tapToStartLabel)
        
        let fadInAction = SKAction.fadeIn(withDuration: 0.3)
        
        tapToStartLabel.run(fadInAction)

    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        if currentGameState == gameState.preGame{
            
            startGame()
            
        }
        
        for touch in touches {
            
            let pointOfTouch = touch.location(in: self)
            
            let touchedNode = self.atPoint(pointOfTouch)
            
            if touchedNode.name == "Stop"{
                
                if currentGameState == gameState.inGame && scene?.isPaused == false{
                    
                    runGameOver()
                    
                }
                
            }
            
            if touchedNode.name == "Pause"{

                if currentGameState == gameState.inGame && scene?.isPaused == false{

                    scene?.isPaused = true
                    pauseButton.texture = SKTexture(imageNamed: "playImage")
                    stopButton.texture = SKTexture(imageNamed: "stopDisabled")
                    UserDefaults().set(true, forKey: "gamePaused")
                    
                }
                
                else if currentGameState == gameState.inGame && scene?.isPaused == true{
                    
                    scene?.isPaused = false
                    pauseButton.texture = SKTexture(imageNamed: "pauseImage")
                    stopButton.texture = SKTexture(imageNamed: "stopImage")
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
                let amountDraggedX = pointOfTouch.x - previousPointOfTouch.x
                let amountDraggedY = pointOfTouch.y - previousPointOfTouch.y
                
                if currentGameState == gameState.inGame{
                    
                    player.position.x += amountDraggedX
                    player.position.y += amountDraggedY
                    
                }
                
                if player.position.x > gameArea.maxX{
                    
                    player.position.x = gameArea.maxX
                    
                }
                
                if player.position.x < gameArea.minX{
                    
                    player.position.x = gameArea.minX
                    
                }
                
                if player.position.y > gameArea.maxY{
                    
                    player.position.y = gameArea.maxY
                    
                }
                
                if player.position.y < gameArea.minY{
                    
                    player.position.y = gameArea.minY
                    
                }
                
            }
        }
    }
    
    
    func didBegin(_ contact: SKPhysicsContact) {
        
        var player = SKPhysicsBody()
        var enemy = SKPhysicsBody()
        
        if contact.bodyA.categoryBitMask < contact.bodyB.categoryBitMask{
            
            player = contact.bodyA
            enemy = contact.bodyB
        }
        
        else {
            
            player = contact.bodyB
            enemy = contact.bodyA
        }
        
        if player.categoryBitMask == PhysicsCategories.Player &&
            enemy.categoryBitMask == PhysicsCategories.Enemy {
            
            //if the player has hit the enemy
            redFlash()
            
            if enemy.node != nil {
                
                spawnExplosion(spawnPosition: enemy.node!.position)
                
            }
            
            enemy.node?.removeFromParent()
            player.node?.removeFromParent()
                
            let runOver = SKAction.run { self.runGameOver() }
                
            self.run(runOver)
            
        }
        
        if player.categoryBitMask == PhysicsCategories.Player &&
            enemy.categoryBitMask == PhysicsCategories.Bomb {
            
            //if the player has hit the bomb
            redFlash()
            
            loseLifePlayer()
            
            if enemy.node != nil {
                
                spawnExplosion(spawnPosition: enemy.node!.position)
                
            }
            
            enemy.node?.removeFromParent()
                        
            if livesNumberPlayer == 0 {
                
                if player.node != nil {
                    
                    spawnExplosion(spawnPosition: player.node!.position)
                    
                }
                
                player.node?.removeFromParent()
                
                let runOver = SKAction.run { self.runGameOver() }
                
                self.run(runOver)
                
            }
            
        }
        
        if enemy.node != nil {
            
            if player.categoryBitMask == PhysicsCategories.Bullet &&
                enemy.categoryBitMask == PhysicsCategories.Enemy &&
                (enemy.node?.position.y)! < self.size.height - 100 {
                
                //if the bullet has hit the enemy
                livesNumberEnemy -= 1
                
                player.node?.removeFromParent()
                
                if livesNumberEnemy == 0 {
                    
                    addScore()
                    
                    spawnExplosion(spawnPosition: enemy.node!.position)
                   
                    enemy.node?.removeFromParent()
                    
                    livesNumberEnemy = 4
                    
                }
                
            }
            
        }
        
    }
    
    
    func random() -> CGFloat{
        
        return CGFloat(Double(arc4random()) / 0xFFFFFFFF)
        
    }
    
    
    func random(min: CGFloat,max: CGFloat) -> CGFloat {
        
        return random() * (max - min) + min
    }
    
    
    func startGame(){
        
        currentGameState = gameState.inGame
                
        let fadOutAction = SKAction.fadeOut(withDuration: 0.5)
        let deleteActioon = SKAction.removeFromParent()
        let deleteSequence = SKAction.sequence([fadOutAction, deleteActioon])
        
        tapToStartLabel.run(deleteSequence)
               
        let repeatFire = SKAction.run {
            let spawnBullet = SKAction.run(self.fireBullet)
            let waitToSpawnBullet = SKAction.wait(forDuration: 0.3)
            let spawnBulletSequence = SKAction.sequence([waitToSpawnBullet, spawnBullet])
            let spawnBulletForever = SKAction.repeatForever(spawnBulletSequence)
            
            self.run(spawnBulletForever)
        }
        
        let repeatBombing = SKAction.run {
            
            let spawnBombs = SKAction.run(self.spawnBombs)
            let waitToSpawnBombs = SKAction.wait(forDuration: 0.5)
            let spawnBombsSequence = SKAction.sequence([waitToSpawnBombs, spawnBombs])
            let spawnBombsRepeat = SKAction.repeatForever(spawnBombsSequence)
            
            self.run(spawnBombsRepeat, withKey: "spawningBombs")
            
        }
        
        let moveShipOnToScreenAction = SKAction.moveTo(y: self.size.height * 0.2, duration: 0.5)
        let startLevelAction = SKAction.run(startNewWave)
        let waitToStart = SKAction.wait(forDuration: 1)
        let startGameSquence = SKAction.sequence([startLevelAction, waitToStart, moveShipOnToScreenAction])
        
        player.run(startGameSquence)

        stopButton.name = "Stop"
        stopButton.size = CGSize(width: 100, height: 100)
        stopButton.zPosition = 100
        stopButton.position = CGPoint(x: self.size.width/2 + 70, y: self.size.height*0.9)
        
        self.addChild(stopButton)
        
        pauseButton.name = "Pause"
        pauseButton.size = CGSize(width: 100, height: 100)
        pauseButton.zPosition = 100
        pauseButton.position = CGPoint(x: self.size.width/2 - 70, y: self.size.height*0.9)
        
        self.addChild(pauseButton)
        
    }
    
    
    func startNewWave(){
        
        if self.action(forKey: "spawningEnemies") != nil{
            
            self.removeAction(forKey: "spawningEnemies")
            
        }
        
        var waveName: ( () -> Void ) = wave0001
        
        switch waveNumber {
            
            
            // Level 1-1
            case 0001: waveName = wave0001
            case 0002: waveName = wave0002
            case 0003: waveName = wave0003
            case 0004: waveName = wave0004
            case 0005: waveName = wave0005
         
            // Level 1-2
            case 0006: waveName = wave0006
            case 0007: waveName = wave0007
            case 0008: waveName = wave0008
            case 0009: waveName = wave0009
            case 0010: waveName = wave0010
         
            // Leve 1-3
            case 0011: waveName = wave0011
            case 0012: waveName = wave0012
            case 0013: waveName = wave0013
            case 0014: waveName = wave0014
            case 0015: waveName = wave0015
         
            // Level 1-4
            case 0016: waveName = wave0016
            case 0017: waveName = wave0017
            case 0018: waveName = wave0018
            case 0019: waveName = wave0019
            case 0020: waveName = wave0020
                
            // Level 1-5
            case 0021: waveName = wave0021
            case 0022: waveName = wave0022
            case 0023: waveName = wave0023
            case 0024: waveName = wave0024
            case 0025: waveName = wave0025
            
         
            // Level 2-1
            case 0026: waveName = wave0026
            case 0027: waveName = wave0027
            case 0028: waveName = wave0028
            case 0029: waveName = wave0029
            case 0030: waveName = wave0030
         
            //Level 2-2
            case 0031: waveName = wave0031
            case 0032: waveName = wave0032
            case 0033: waveName = wave0033
            case 0034: waveName = wave0034
            case 0035: waveName = wave0035
         
            // Level 2-3
            case 0036: waveName = wave0036
            case 0037: waveName = wave0037
            case 0038: waveName = wave0038
            case 0039: waveName = wave0039
            case 0040: waveName = wave0040
         
            // Level 2-4
            case 0041: waveName = wave0041
            case 0042: waveName = wave0042
            case 0043: waveName = wave0043
            case 0044: waveName = wave0044
            case 0045: waveName = wave0045
                
            // Level 2-5
            case 0046: waveName = wave0046
            case 0047: waveName = wave0047
            case 0048: waveName = wave0048
            case 0049: waveName = wave0049
            case 0050: waveName = wave0050
         
         
            // Level 3-1
            case 0051: waveName = wave0051
            case 0052: waveName = wave0052
            case 0053: waveName = wave0053
            case 0054: waveName = wave0054
            case 0055: waveName = wave0055
         
            // Level 3-2
            case 0056: waveName = wave0056
            case 0057: waveName = wave0057
            case 0058: waveName = wave0058
            case 0059: waveName = wave0059
            case 0060: waveName = wave0060
         
            // Level 3-3
            case 0061: waveName = wave0061
            case 0062: waveName = wave0062
            case 0063: waveName = wave0063
            case 0064: waveName = wave0064
            case 0065: waveName = wave0065
         
            // Level 3-4
            case 0066: waveName = wave0066
            case 0067: waveName = wave0067
            case 0068: waveName = wave0068
            case 0069: waveName = wave0069
            case 0070: waveName = wave0070
         
            // Level 3-5
            case 0071: waveName = wave0071
            case 0072: waveName = wave0072
            case 0073: waveName = wave0073
            case 0074: waveName = wave0074
            case 0075: waveName = wave0075
         
         
            // Level 4-1
            case 0076: waveName = wave0076
            case 0077: waveName = wave0077
            case 0078: waveName = wave0078
            case 0079: waveName = wave0079
            case 0080: waveName = wave0080
         
            // Level 4-2
            case 0081: waveName = wave0081
            case 0082: waveName = wave0082
            case 0083: waveName = wave0083
            case 0084: waveName = wave0084
            case 0085: waveName = wave0085
         
            // Level 4-3
            case 0086: waveName = wave0086
            case 0087: waveName = wave0087
            case 0088: waveName = wave0088
            case 0089: waveName = wave0089
            case 0090: waveName = wave0090
         
            // Level 4-4
            case 0091: waveName = wave0091
            case 0092: waveName = wave0092
            case 0093: waveName = wave0093
            case 0094: waveName = wave0094
            case 0095: waveName = wave0095
         
            // Level 4-5
            case 0096: waveName = wave0096
            case 0097: waveName = wave0097
            case 0098: waveName = wave0098
            case 0099: waveName = wave0099
            case 0100: waveName = wave0100
         
         
            // Level 5-1
            case 0101: waveName = wave0101
            case 0102: waveName = wave0102
            case 0103: waveName = wave0103
            case 0104: waveName = wave0104
            case 0105: waveName = wave0105
            
            // Level 5-2
            case 0106: waveName = wave0106
            case 0107: waveName = wave0107
            case 0108: waveName = wave0108
            case 0109: waveName = wave0109
            case 0110: waveName = wave0110
         
            // Level 5-3
            case 0111: waveName = wave0111
            case 0112: waveName = wave0112
            case 0113: waveName = wave0113
            case 0114: waveName = wave0114
            case 0115: waveName = wave0115
         
            // Level 5-4
            case 0116: waveName = wave0116
            case 0117: waveName = wave0117
            case 0118: waveName = wave0118
            case 0119: waveName = wave0119
            case 0120: waveName = wave0120
         
            // Level 5-5
            case 0121: waveName = wave0121
            case 0122: waveName = wave0122
            case 0123: waveName = wave0123
            case 0124: waveName = wave0124
            case 0125: waveName = wave0125


        default: waveName = wave0035
            
            
            print("Cannot find level info")
            
        }
        
        let spawnEnemy = SKAction.run(waveName)
        let waitToSpawnEnemy = SKAction.wait(forDuration: 1)
        let spawnEnemySequence = SKAction.sequence([waitToSpawnEnemy, spawnEnemy])
        let spawnEnemyRepeat = SKAction.repeat(spawnEnemySequence, count: 1)
        
        self.run(spawnEnemyRepeat, withKey: "spawningEnemies")
        
    }
    
    
    func addLives(numberOfLives: Int) {
        
        var space: CGFloat = 0.0
        
        if numberOfLives == 2{
            
            space = 100
        }
        
        else if numberOfLives == 3{
           
           space = 200
            
        }

        let lives = SKSpriteNode(imageNamed: "playerShip")
        
        lives.name = "Lives\(numberOfLives)"
        lives.setScale(0.3)
        lives.zPosition = 100
        lives.position = CGPoint(x: self.size.width * 0.7 + space, y: self.size.height * 0.9)
        
        addChild(lives)
        
        let moveOnToScreenAction = SKAction.moveTo(y: self.size.height*0.9, duration: 0.3)
        
        lives.run(moveOnToScreenAction)
        
    }
 
    
    func loseLifePlayer(){
        
        self.enumerateChildNodes(withName: "Lives\(livesNumberPlayer)"){
            
            lives,remove in
            lives.removeFromParent()
            
            let scaleUp = SKAction.scale(to: 1.5, duration: 0.2)
            let scaleDown = SKAction.scale(to: 1, duration: 0.2)
            let scaleSequence = SKAction.sequence([scaleUp, scaleDown])
            
            lives.run(scaleSequence)
        }
        
        livesNumberPlayer -= 1
 
    }

    
    func addScore(){
        
        gameScore += 1
        
        scoreLabel.text = String(gameScore)

        if gameScore == 18 {
            
            let defaults = UserDefaults()
            
            waveNumber = defaults.integer(forKey: "waveNumberSaved")
            
            waveNumber += 1
            
            defaults.set(waveNumber, forKey: "waveNumberSaved")
            
            runGameOver()
        }
        
    }
    
    
    func shake(){
        
        let moveUpAction = SKAction.moveBy(x: 10, y: 10, duration: 0.05)
        let moveDownAction = SKAction.moveBy(x: -10, y: -10, duration: 0.05)
        let shakeSquence = SKAction.sequence([moveUpAction, moveDownAction])
        let repeatShake = SKAction.repeat(shakeSquence, count: 3)
        
        self.enumerateChildNodes(withName: "Enemy"){
            
            enemy, shake in
            enemy.run(repeatShake)
            
        }
        
        self.enumerateChildNodes(withName: "Bomb"){
            
            bomb, shake in
            bomb.run(repeatShake)
            
        }
        
        self.enumerateChildNodes(withName: "Bullet"){
            
            bullet, shake in
            bullet.run(repeatShake)
            
        }
        
        self.enumerateChildNodes(withName: "Starfield"){
            
            starfield, shake in
            starfield.run(repeatShake)
            
        }
        
        self.enumerateChildNodes(withName: "Explosion"){
            
            explosion, shake in
            explosion.run(repeatShake)
            
        }
        
        self.enumerateChildNodes(withName: "Background"){
            
            background, shake in
            background.run(repeatShake)
            
        }
        
        player.run(repeatShake)
        
    }
    
   
    func redFlash(){
        
        let changeToRed = SKAction.run{

            self.scene?.backgroundColor = UIColor(red: 0.8, green: 0.0, blue: 0.0, alpha: 0.5)
            
        }

        let wait = SKAction.wait(forDuration: 0.3)
        let changeBack = SKAction.run { self.scene?.backgroundColor = self.backColor }
        let colorSquence = SKAction.sequence([changeToRed, wait, changeBack])

        self.run(colorSquence)

    }
    
    
    func spawnExplosion(spawnPosition: CGPoint){
    
        if SKEmitterNode(fileNamed: "Explosion") != nil{
            
            let explosion = SKEmitterNode(fileNamed: "Explosion")!
                
            explosion.position = spawnPosition
            explosion.zPosition = 3
            explosion.setScale(1)
            explosion.name = "Explosion"
        
            self.addChild(explosion)
        
            let explosionSound = SKAction.playSoundFileNamed("ExplosionSoundEffect.wav", waitForCompletion: false)
            let scaleIn = SKAction.scale(to: 2, duration: 1)
            let fadeOut = SKAction.fadeOut(withDuration: 1)
            let delete = SKAction.removeFromParent()
            let exlosionSequence = SKAction.sequence([explosionSound, scaleIn, fadeOut, delete])
                
            explosion.run(exlosionSequence)
            
        }
        
    //  shake()
        
    }
    
    
    func fireBullet(){
        
        let bullet = SKSpriteNode(imageNamed: "bullet")
        
        bullet.name = "Bullet"
        bullet.setScale(0.5)
        bullet.position.x = player.position.x
        bullet.position.y = player.position.y + player.size.height
        bullet.zPosition = 1
        bullet.physicsBody = SKPhysicsBody(rectangleOf: bullet.size)
        bullet.physicsBody?.affectedByGravity = false
        bullet.physicsBody?.categoryBitMask = PhysicsCategories.Bullet
        bullet.physicsBody?.collisionBitMask = PhysicsCategories.None
        bullet.physicsBody?.contactTestBitMask = PhysicsCategories.None
            
        self.addChild(bullet)
            
        let bulletSound = SKAction.playSoundFileNamed("BulletSoundEffect.wav", waitForCompletion: false)
        let moveBullet = SKAction.moveTo(y: self.size.height + bullet.size.height, duration: 1)
        let deleteBullet = SKAction.removeFromParent()
        let bulletSquence = SKAction.sequence([bulletSound, moveBullet, deleteBullet])
            
        bullet.run(bulletSquence)

    }

    
    func spawnBombs(){

        let rndI = Int.random(in: 0...17)

        for i in 0...17 {
            
            if i == rndI && enemy[i].inParentHierarchy(self) {
                
                let bomb = SKSpriteNode(imageNamed: "enemyShip")
                
                bomb.name = "Bomb"
                bomb.size = CGSize(width: 50, height: 50)
                bomb.position = enemy[i].position
                bomb.zPosition = 2
                bomb.physicsBody = SKPhysicsBody(circleOfRadius: bomb.size.width / 2)
                bomb.physicsBody?.affectedByGravity = false
                bomb.physicsBody?.categoryBitMask = PhysicsCategories.Bomb
                bomb.physicsBody?.collisionBitMask = PhysicsCategories.None
                bomb.physicsBody?.contactTestBitMask = PhysicsCategories.Player
                
                self.addChild(bomb)
                
                let moveBomb = SKAction.moveTo(y: -self.size.height - bomb.size.height, duration: 10)
                let deleteBomb = SKAction.removeFromParent()
                let bombSquence = SKAction.sequence([moveBomb, deleteBomb])
                let repeatSquence = SKAction.repeatForever(bombSquence)
                
                bomb.run(repeatSquence)
                
            }
            
        }
        
    }
    
    
    func changeScene() {
        
        let sceneToMoveTo = GameOverScene(size: self.size)
        let myTransition = SKTransition.fade(withDuration: 0.5)
        
        sceneToMoveTo.scaleMode = self.scaleMode
        
        self.view?.presentScene(sceneToMoveTo, transition: myTransition)
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

    
    
    
    
   
    
    

    
    
   
    
    

    
    


}

