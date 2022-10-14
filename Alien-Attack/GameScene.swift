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
    
    var livesNumber: Int
    var levelNumber: Int
    
    var player: SKSpriteNode
    var stopButton: SKSpriteNode
    var pauseButton: SKSpriteNode
    
    var tapToStartLabel: SKLabelNode
    var scoreLabel: SKLabelNode
    
    var backColor: UIColor

    
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
    }
    
    override init(size: CGSize) {
        
        UserDefaults().set(false, forKey: "gamePaused")
        
        backColor = UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.0)
        
        livesNumber = 3
        levelNumber = 0
        
        player = SKSpriteNode(imageNamed: "playerShip")
        stopButton = SKSpriteNode(imageNamed: "stopImage")
        pauseButton = SKSpriteNode(imageNamed: "pauseImage")
            
        tapToStartLabel = SKLabelNode(fontNamed: "The Bold Font")
        scoreLabel = SKLabelNode(fontNamed: "The Bold Font")
        
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
        
        backgroundColor = backColor
        
        self.physicsWorld.contactDelegate = self
        
        for i in 0...1{
        
            let background = SKSpriteNode(imageNamed: "background")
            
            background.size = self.size
            background.anchorPoint = CGPoint(x: 0.5, y: 0)
            background.position = CGPoint(x: self.size.width/2,
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
        
        player.setScale(1)
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
        scoreLabel.position = CGPoint(x: self.size.width*0.1, y: self.size.height + scoreLabel.frame.size.height)
        scoreLabel.zPosition = 100
        
        self.addChild(scoreLabel)
        
        let moveOnToScreenAction = SKAction.moveTo(y: self.size.height*0.9, duration: 0.3)
        
        scoreLabel.run(moveOnToScreenAction)
        
        for n in 1 ... 3{
           
            addLives(numberOfLives: n)
            
        }

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
        lives.size = CGSize(width: 100, height: 100)
        lives.zPosition = 100
        lives.position = CGPoint(x: self.size.width * 0.75 + space, y: self.size.height * 0.9)
        
        addChild(lives)
        
        let moveOnToScreenAction = SKAction.moveTo(y: self.size.height*0.9, duration: 0.3)
        
        lives.run(moveOnToScreenAction)
        
    }
    
    
    var lastUpdateTime: TimeInterval = 0
    var deltaFrameTime: TimeInterval = 0
    let amountToMovePerSecond: CGFloat = 100.0
    
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
 
    
    func shake(){
        
        let moveUpAction = SKAction.moveBy(x: 30, y: 30, duration: 0.05)
        let moveDownAction = SKAction.moveBy(x: -30, y: -30, duration: 0.05)
        let shakeSquence = SKAction.sequence([moveUpAction, moveDownAction])
        let repeatShake = SKAction.repeat(shakeSquence, count: 5)
        
        self.enumerateChildNodes(withName: "Enemy"){
            
            enemy, repearShake in
            enemy.run(repeatShake)
            
        }
        
        self.enumerateChildNodes(withName: "Bullet"){
            
            bullet, repearShake in
            bullet.run(repeatShake)
            
        }
        
        self.enumerateChildNodes(withName: "Starfield"){
            
            starfield, repearShake in
            starfield.run(repeatShake)
            
        }
        
        self.enumerateChildNodes(withName: "Explosion"){
            
            explosion, repearShake in
            explosion.run(repeatShake)
            
        }
        
        self.enumerateChildNodes(withName: "Background"){
            
            background, repearShake in
            background.run(repeatShake)
            
        }
        
        player.run(repeatShake)
        
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
    
    
    func loseLife(){
        
        self.enumerateChildNodes(withName: "Lives\(livesNumber)"){
            
            lives,remove in
            lives.removeFromParent()
            
            let scaleUp = SKAction.scale(to: 1.5, duration: 0.2)
            let scaleDown = SKAction.scale(to: 1, duration: 0.2)
            let scaleSequence = SKAction.sequence([scaleUp, scaleDown])
            
            lives.run(scaleSequence)
        }
        
        livesNumber -= 1
 
    }
    
    
    func addScore(){
        
        gameScore += 1
        scoreLabel.text = String(gameScore)
        
        if gameScore == 10 ||
            gameScore == 25 ||
            gameScore == 50 ||
            gameScore == 75 ||
            gameScore == 100 {
            
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
        let myTransition = SKTransition.fade(withDuration: 0.5)
        
        sceneToMoveTo.scaleMode = self.scaleMode
        
        self.view?.presentScene(sceneToMoveTo, transition: myTransition)
    }
    
    
    func didBegin(_ contact: SKPhysicsContact) {
        
        var player = SKPhysicsBody()
        var enemy = SKPhysicsBody()
        
        if contact.bodyA.categoryBitMask < contact.bodyB.categoryBitMask{
            
            player = contact.bodyA
            enemy = contact.bodyB
        }
        
        else{
            
            player = contact.bodyB
            enemy = contact.bodyA
        }
        
        if player.categoryBitMask == PhysicsCategories.Player &&
            enemy.categoryBitMask == PhysicsCategories.Enemy{
            
            //if the player has hit the enemy
            redFlash()
            
            loseLife()
            
            if enemy.node != nil {
                
                spawnExplosion(spawnPosition: enemy.node!.position)
                
            }
            
            enemy.node?.removeFromParent()
                        
            if livesNumber == 0 {
                
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
                (enemy.node?.position.y)! < self.size.height - 200 {
                
                //if the bullet has hit the enemy
                addScore()
                
                spawnExplosion(spawnPosition: enemy.node!.position)
                
                player.node?.removeFromParent()
                enemy.node?.removeFromParent()
                
            }
            
        }
        
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
        
        shake()
        
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
        bullet.physicsBody?.contactTestBitMask = PhysicsCategories.Enemy
            
        self.addChild(bullet)
            
        let bulletSound = SKAction.playSoundFileNamed("BulletSoundEffect.wav", waitForCompletion: false)
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
        enemy.physicsBody = SKPhysicsBody(circleOfRadius: enemy.size.width / 2)
        enemy.physicsBody?.affectedByGravity = false
        enemy.physicsBody?.categoryBitMask = PhysicsCategories.Enemy
        enemy.physicsBody?.collisionBitMask = PhysicsCategories.None
        enemy.physicsBody?.contactTestBitMask = PhysicsCategories.Player | PhysicsCategories.Bullet
        
        self.addChild(enemy)
        
        let moveEnemy = SKAction.move(to: endPoint, duration: 5)
        let deleteEnemy = SKAction.removeFromParent()
        let enemySquence = SKAction.sequence([moveEnemy, deleteEnemy])
        
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

