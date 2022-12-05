//
//  Level1X.swift
//  Alien-Attack
//
//  Created by Alex Resnik on 10/18/22.
//
            
import SpriteKit
import GameplayKit


extension GameScene {
    
    // Grid
    func wave0001() {
        
        var x = 400
        var y = 1700
            
        for i in 0...17 {
            
            enemy.append(SKSpriteNode(imageNamed: "enemyShip"))
            
            enemy[i].position = CGPoint(x: 750, y: 2200)
            enemy[i].setScale(0.35)
            enemy[i].zPosition = 2
            enemy[i].physicsBody = SKPhysicsBody(circleOfRadius: enemy[i].size.width / 2)
            enemy[i].physicsBody?.affectedByGravity = false
            enemy[i].physicsBody?.categoryBitMask = PhysicsCategories.Enemy
            enemy[i].physicsBody?.collisionBitMask = PhysicsCategories.None
            enemy[i].physicsBody?.contactTestBitMask = PhysicsCategories.Player | PhysicsCategories.Bullet
            
            addChild(enemy[i])
            
            let moveEnemy = SKAction.move(to: CGPoint(x: x, y: y), duration: 0.5)
            
            enemy[i].run(moveEnemy)
            
            x += 150
            
            if i == 5 { x = 400; y = 1550 }
            if i == 11 { x = 400; y = 1400 }
            
        }
        
    }
    
    
    // Circle to grid
    func wave0002() {
    
        let enemyPath = UIBezierPath()
        
        enemyPath.move(to: CGPoint(x: 2200, y: 2200))
        
        for _ in 1...5 {
            
            enemyPath.addArc(withCenter: CGPoint(x: 750, y: 1200), radius: 400, startAngle: 0, endAngle: .pi, clockwise: false)
            enemyPath.addArc(withCenter: CGPoint(x: 750, y: 1200), radius: 400, startAngle: .pi, endAngle: 2 * .pi, clockwise: false)
            
        }
        
        for i in 0...17 {
            
            let moveEnemy = SKAction.follow(enemyPath.cgPath, asOffset: false, orientToPath: false, duration: 20)
            
            moveEnemy.timingFunction = {
                
                time in
                
                return min(time - 0.01 * Float(i), 1)
                
            }
            
            enemy.append(SKSpriteNode(imageNamed: "enemyShip"))

            enemy[i].setScale(0.35)
            enemy[i].zPosition = 2
            enemy[i].physicsBody = SKPhysicsBody(circleOfRadius: enemy[i].size.width / 2)
            enemy[i].physicsBody?.affectedByGravity = false
            enemy[i].physicsBody?.categoryBitMask = PhysicsCategories.Enemy
            enemy[i].physicsBody?.collisionBitMask = PhysicsCategories.None
            enemy[i].physicsBody?.contactTestBitMask = PhysicsCategories.Player | PhysicsCategories.Bullet
            
            addChild(enemy[i])
            
            enemy[i].run(moveEnemy)
            
        }
        
        var x = 400
        var y = 1700
            
        for i in 0...17 {
            
            let moveEnemy = SKAction.move(to: CGPoint(x: x, y: y), duration: 0.5)
            let wait = SKAction.wait(forDuration: 10 + (Double(i) * 0.3))
            let removeActions = SKAction.run {self.enemy[i].removeAllActions() }
            let sequence = SKAction.sequence([wait, moveEnemy, removeActions])
            
            enemy[i].run(sequence)
            
            x += 150
            
            if i == 5 { x = 400; y = 1550 }
            if i == 11 { x = 400; y = 1400 }
            
        }
        
    }

    
    // Three cirles to grid
    func wave0003 (){

        let enemyPathLeft = UIBezierPath()
        let enemyPathRight = UIBezierPath()
        let enemyPathMiddle = UIBezierPath()
        var enemyLeft = [SKSpriteNode]()
        var enemyRight = [SKSpriteNode]()
        var enemyMiddle = [SKSpriteNode]()
        
        enemy.removeAll()
        
        enemyPathLeft.move(to: CGPoint(x: -100, y: 1000))
        
        for _ in 1...5 {
            
            enemyPathLeft.addArc(withCenter: CGPoint(x: 400, y: 1400), radius: 150, startAngle: .pi, endAngle: 2 * .pi, clockwise: false)
            enemyPathLeft.addArc(withCenter: CGPoint(x: 400, y: 1400), radius: 150, startAngle: 0, endAngle: .pi, clockwise: false)
            
        }
        
        for i in 0...5 {
            
            let moveEnemy = SKAction.follow(enemyPathLeft.cgPath, asOffset: false, orientToPath: false, duration: 10)
            
            moveEnemy.timingFunction = {
                
                time in
                
                return min(time - 0.03 * Float(i), 1)
                
            }
            
            enemyLeft.append(SKSpriteNode(imageNamed: "enemyShip"))

            enemyLeft[i].setScale(0.35)
            enemyLeft[i].zPosition = 2
            enemyLeft[i].physicsBody = SKPhysicsBody(circleOfRadius: enemyLeft[i].size.width / 2)
            enemyLeft[i].physicsBody?.affectedByGravity = false
            enemyLeft[i].physicsBody?.categoryBitMask = PhysicsCategories.Enemy
            enemyLeft[i].physicsBody?.collisionBitMask = PhysicsCategories.None
            enemyLeft[i].physicsBody?.contactTestBitMask = PhysicsCategories.Player | PhysicsCategories.Bullet
            
            addChild(enemyLeft[i])
            
            enemyLeft[i].run(moveEnemy)
            
        }

        
        enemyPathRight.move(to: CGPoint(x: 1600, y: 1400))
        
        for _ in 1...5 {
            
            enemyPathRight.addArc(withCenter: CGPoint(x: 1100, y: 1400), radius: 150, startAngle: 0, endAngle: .pi, clockwise: false)
            enemyPathRight.addArc(withCenter: CGPoint(x: 1100, y: 1400), radius: 150, startAngle: .pi, endAngle: 2 * .pi, clockwise: false)
            
        }
        
        for i in 0...5 {
            
            let moveEnemy = SKAction.follow(enemyPathRight.cgPath, asOffset: false, orientToPath: false, duration: 10)
            
            moveEnemy.timingFunction = {
                
                time in
                
                return min(time - 0.03 * Float(i), 1)
                
            }
            
            enemyRight.append(SKSpriteNode(imageNamed: "enemyShip"))

            enemyRight[i].setScale(0.35)
            enemyRight[i].zPosition = 2
            enemyRight[i].physicsBody = SKPhysicsBody(circleOfRadius: enemyRight[i].size.width / 2)
            enemyRight[i].physicsBody?.affectedByGravity = false
            enemyRight[i].physicsBody?.categoryBitMask = PhysicsCategories.Enemy
            enemyRight[i].physicsBody?.collisionBitMask = PhysicsCategories.None
            enemyRight[i].physicsBody?.contactTestBitMask = PhysicsCategories.Player | PhysicsCategories.Bullet
            
            addChild(enemyRight[i])
            
            enemyRight[i].run(moveEnemy)
            
        }
        
        enemyPathMiddle.move(to: CGPoint(x: -100, y: 500))
        
        for _ in 1...5 {
            
            enemyPathMiddle.addArc(withCenter: CGPoint(x: 750, y: 1000), radius: 150, startAngle: .pi, endAngle: 2 * .pi, clockwise: false)
            enemyPathMiddle.addArc(withCenter: CGPoint(x: 750, y: 1000), radius: 150, startAngle: 0, endAngle: .pi, clockwise: false)
            
        }
        
        for i in 0...5 {
            
            let moveEnemy = SKAction.follow(enemyPathMiddle.cgPath, asOffset: false, orientToPath: false, duration: 10)
            
            moveEnemy.timingFunction = {
                
                time in
                
                return min(time - 0.028 * Float(i), 1)
                
            }
            
            enemyMiddle.append(SKSpriteNode(imageNamed: "enemyShip"))

            enemyMiddle[i].setScale(0.35)
            enemyMiddle[i].zPosition = 2
            enemyMiddle[i].physicsBody = SKPhysicsBody(circleOfRadius: enemyMiddle[i].size.width / 2)
            enemyMiddle[i].physicsBody?.affectedByGravity = false
            enemyMiddle[i].physicsBody?.categoryBitMask = PhysicsCategories.Enemy
            enemyMiddle[i].physicsBody?.collisionBitMask = PhysicsCategories.None
            enemyMiddle[i].physicsBody?.contactTestBitMask = PhysicsCategories.Player | PhysicsCategories.Bullet
            
            addChild(enemyMiddle[i])
            
            enemyMiddle[i].run(moveEnemy)
            
        }
        
        
        
        var x = 400
        var y = 1800
            
        for i in 0...17 {
            
            if i <= 5 { self.enemy.append(enemyLeft[i]) }
            else if i <= 11 { self.enemy.append(enemyRight[i - 6]) }
            else { self.enemy.append(enemyMiddle[i - 12]) }
            
            let moveEnemy = SKAction.move(to: CGPoint(x: x, y: y), duration: 0.5)
            let wait = SKAction.wait(forDuration: 5 + (Double(i) * 0.3))
            let removeActions = SKAction.run { self.enemy[i].removeAllActions() }
            let sequence = SKAction.sequence([wait, moveEnemy, removeActions])
            
            self.enemy[i].run(sequence)
            
            x += 150
            
            if i == 5 { x = 400; y = 1650 }
            if i == 11 { x = 400; y = 1500 }
            
        }
        
    }
     
    
    // Dual curve
    func wave0004(){

        let enemyPath = UIBezierPath()
        
        enemyPath.move(to: CGPoint(x: -100, y: 1200))
        
        for _ in 1...30 {
            
            enemyPath.addCurve(to: CGPoint(x: -100, y: 1200), controlPoint1: CGPoint(x: 1100, y: 0), controlPoint2: CGPoint(x: 1100, y: 1200))
            enemyPath.addCurve(to: CGPoint(x: 2000, y: 1500), controlPoint1: CGPoint(x: 400, y: 2000), controlPoint2: CGPoint(x: 400, y: 1200))
            
        }
        
        for i in 0...17 {
            
            let moveEnemy = SKAction.follow(enemyPath.cgPath, asOffset: false, orientToPath: false, speed: 600)
            
            moveEnemy.timingFunction = {
                
                time in
                
                return min(time - 0.001 * Float(i), 1)
                
            }
            
            enemy.append(SKSpriteNode(imageNamed: "enemyShip"))
            
            enemy[i].setScale(0.35)
            enemy[i].zPosition = 2
            enemy[i].physicsBody = SKPhysicsBody(circleOfRadius: enemy[i].size.width / 2)
            enemy[i].physicsBody?.affectedByGravity = false
            enemy[i].physicsBody?.categoryBitMask = PhysicsCategories.Enemy
            enemy[i].physicsBody?.collisionBitMask = PhysicsCategories.None
            enemy[i].physicsBody?.contactTestBitMask = PhysicsCategories.Player | PhysicsCategories.Bullet
            
            addChild(enemy[i])
            
            enemy[i].run(moveEnemy)
            
        }
        
    }
    
    
    // Random motion
    func wave0005(){
        
        enemy.removeAll()
        
        let enemyPath = UIBezierPath()
        
        enemyPath.move(to: CGPoint(x: 400, y: 2200))
            
        enemyPath.addLine(to: CGPoint(x: 1200, y: 2200))
            
        for i in 0...17 {
            
            let moveEnemy = SKAction.follow(enemyPath.cgPath, asOffset: false, orientToPath: false, duration: 1)
            
            moveEnemy.timingFunction = {
                
                time in
                
                return min(time - 0.2 * Float(i), 1)
                
            }
            
            enemy.append(SKSpriteNode(imageNamed: "enemyShip"))

            enemy[i].setScale(0.35)
            enemy[i].zPosition = 2
            enemy[i].physicsBody = SKPhysicsBody(circleOfRadius: enemy[i].size.width / 2)
            enemy[i].physicsBody?.affectedByGravity = false
            enemy[i].physicsBody?.categoryBitMask = PhysicsCategories.Enemy
            enemy[i].physicsBody?.collisionBitMask = PhysicsCategories.None
            enemy[i].physicsBody?.contactTestBitMask = PhysicsCategories.Player | PhysicsCategories.Bullet
            
            addChild(enemy[i])
            
            enemy[i].run(moveEnemy)
            
        }
        
        var x = 400
        var y = 1800
        
        for i in 0...17 {
            
            let moveEnemy = SKAction.move(to: CGPoint(x: x, y: y), duration: 0.4)
            let wait = SKAction.wait(forDuration: 1 + (Double(i) * 0.3))
            let removeActions = SKAction.run { self.enemy[i].removeAllActions() }
            let sequence = SKAction.sequence([wait, moveEnemy, removeActions])
            
            self.enemy[i].run(sequence)
            
            x += 150
            
            if i == 5 { x = 400; y = 1650 }
            if i == 11 { x = 400; y = 1500 }
            
        }
        
        let waitRunAction = SKAction.run {
            
            let runAcion = SKAction.run { [self] in
                
                for i in 0...17 {
                    
                    let rndX = CGFloat.random(in: -100...100)
                    let rndY = CGFloat.random(in: -100...100)
                    
                    if enemy[i].position.x < gameArea.minX + 200 { enemy[i].position.x = gameArea.minX + 200 }
                    if enemy[i].position.x > gameArea.maxX - 200 { enemy[i].position.x = gameArea.maxX - 200 }
                    if enemy[i].position.y < gameArea.minY + 200 { enemy[i].position.y = gameArea.minY + 200 }
                    if enemy[i].position.y > gameArea.maxY - 200 { enemy[i].position.y = gameArea.maxY - 200 }

                    let moveEnemy = SKAction.moveBy(x: rndX, y: rndY, duration: 5)
                    let removeActions = SKAction.run { self.enemy[i].removeAllActions() }
                    let sequence = SKAction.sequence([moveEnemy, removeActions])
                    
                    self.enemy[i].run(sequence)
                    
                }
            }
            
            let wait = SKAction.wait(forDuration: 0.01)
            let sequence = SKAction.sequence([wait, runAcion])
            let repeatMove = SKAction.repeatForever(sequence)
            
            self.run(repeatMove)
            
        }
        
        let waitAction = SKAction.wait(forDuration: 10)
        let waitSequence = SKAction.sequence([waitAction, waitRunAction])
        
        self.run(waitSequence)
        
        
    }
    
    
    // Expanding circle
    func wave0006() {
        
        let enemyPathLine = UIBezierPath()
        let enemyPathCircle = UIBezierPath()
        
        enemyPathLine.move(to: CGPoint(x: 2200, y: 2200))
        
        enemyPathLine.addLine(to: CGPoint(x: 750, y: 1300))

        for i in 0...17 {
            
            let moveEnemy = SKAction.follow(enemyPathLine.cgPath, asOffset: false, orientToPath: false, duration: 0.5)
            
            enemy.append(SKSpriteNode(imageNamed: "enemyShip"))

            enemy[i].setScale(0.35)
            enemy[i].zPosition = 2
            enemy[i].physicsBody = SKPhysicsBody(circleOfRadius: enemy[i].size.width / 2)
            enemy[i].physicsBody?.affectedByGravity = false
            enemy[i].physicsBody?.categoryBitMask = PhysicsCategories.Enemy
            enemy[i].physicsBody?.collisionBitMask = PhysicsCategories.None
            enemy[i].physicsBody?.contactTestBitMask = PhysicsCategories.Player | PhysicsCategories.Bullet
            
            addChild(enemy[i])
            
            enemy[i].run(moveEnemy)
            
        }
        
        enemyPathCircle.move(to: CGPoint(x: 750, y: 1300))
        
        for i in 1...10 {
            
            enemyPathCircle.addArc(withCenter: CGPoint(x: 750, y: 1300), radius: CGFloat(40 * i), startAngle: 0, endAngle: .pi, clockwise: false)
            enemyPathCircle.addArc(withCenter: CGPoint(x: 750, y: 1300), radius: CGFloat(40 * i), startAngle: .pi, endAngle: 2 * .pi, clockwise: false)
            
        }

        for i in 0...17 {
            
            let moveEnemy = SKAction.follow(enemyPathCircle.cgPath, asOffset: false, orientToPath: false, duration: 0.5)
            
            moveEnemy.timingFunction = {
                
                time in
                
                return min(time - 0.0104 * Float(i), 1)
                
            }
            
            let waitCircle = SKAction.wait(forDuration: 1)
            let sequenceAction = SKAction.sequence([waitCircle, moveEnemy])
            
            enemy[i].run(sequenceAction)
            
        }
        
    }
   
    
    // Diagonal lines
    func wave0007() {
        
        var x = 400
        var y = 1800
            
        for i in 0...17 {
            
            enemy.append(SKSpriteNode(imageNamed: "enemyShip"))
            
            enemy[i].position = CGPoint(x: 750, y: 2200)
            enemy[i].setScale(0.35)
            enemy[i].zPosition = 2
            enemy[i].physicsBody = SKPhysicsBody(circleOfRadius: enemy[i].size.width / 2)
            enemy[i].physicsBody?.affectedByGravity = false
            enemy[i].physicsBody?.categoryBitMask = PhysicsCategories.Enemy
            enemy[i].physicsBody?.collisionBitMask = PhysicsCategories.None
            enemy[i].physicsBody?.contactTestBitMask = PhysicsCategories.Player | PhysicsCategories.Bullet
            
            addChild(enemy[i])
            
            let moveEnemy = SKAction.move(to: CGPoint(x: x, y: y), duration: 2)
            let moveEnemyDown = SKAction.move(to: CGPoint(x: x, y: y - 800), duration: 2)
            let moveSequence = SKAction.sequence([moveEnemy, moveEnemyDown, moveEnemy])

            enemy[i].run(moveSequence)
            
            x += 150
            
            if i == 5 { x = 400; y = 1650 }
            if i == 11 { x = 400; y = 1500 }
            
        }
        
    }
    
    
    // Single
    func wave0008() {

        var i = 0
 
        let runAction = SKAction.run {
            
            let x = CGFloat.random(in: 200...1300)
            
            self.enemy.append(SKSpriteNode(imageNamed: "enemyShip"))
            
            self.addChild(self.enemy[i])
            
            self.enemy[i].position = CGPoint(x: x, y: 2200)
            self.enemy[i].setScale(0.35)
            self.enemy[i].zPosition = 2
            self.enemy[i].physicsBody = SKPhysicsBody(circleOfRadius: self.enemy[i].size.width / 2)
            self.enemy[i].physicsBody?.affectedByGravity = false
            self.enemy[i].physicsBody?.categoryBitMask = PhysicsCategories.Enemy
            self.enemy[i].physicsBody?.collisionBitMask = PhysicsCategories.None
            self.enemy[i].physicsBody?.contactTestBitMask = PhysicsCategories.Player | PhysicsCategories.Bullet
            
            let moveEnemy = SKAction.move(to: CGPoint(x: x, y: -200), duration: 3)
            
            self.enemy[i].run(moveEnemy)
            
            i += 1
            
        }
    
        let wait = SKAction.wait(forDuration: 3)
        let sequence = SKAction.sequence([runAction, wait])
        let repeatAction = SKAction.repeat(sequence, count: 18)
        
        self.run(repeatAction)
        
    }
    
    
    // Circles in Circle
    func wave0009() {
        
        let enemyPathCircleOuter = UIBezierPath()
        let enemyPathCircleMiddle = UIBezierPath()
        let enemyPathCircleInner = UIBezierPath()
        
        enemyPathCircleOuter.move(to: CGPoint(x: 2200, y: 2200))
        enemyPathCircleMiddle.move(to: CGPoint(x: 2200, y: 2200))
        enemyPathCircleInner.move(to: CGPoint(x: 2200, y: 2200))
        
        for _ in 1...5 {
            
            enemyPathCircleOuter.addArc(withCenter: CGPoint(x: 750, y: 1300), radius: 400, startAngle: 0, endAngle: .pi, clockwise: false)
            enemyPathCircleOuter.addArc(withCenter: CGPoint(x: 750, y: 1300), radius: 400, startAngle: .pi, endAngle: 2 * .pi, clockwise: false)
            
            enemyPathCircleMiddle.addArc(withCenter: CGPoint(x: 750, y: 1300), radius: 250, startAngle: 0, endAngle: .pi, clockwise: false)
            enemyPathCircleMiddle.addArc(withCenter: CGPoint(x: 750, y: 1300), radius: 250, startAngle: .pi, endAngle: 2 * .pi, clockwise: false)
            
            enemyPathCircleInner.addArc(withCenter: CGPoint(x: 750, y: 1300), radius: 100, startAngle: 0, endAngle: .pi, clockwise: false)
            enemyPathCircleInner.addArc(withCenter: CGPoint(x: 750, y: 1300), radius: 100, startAngle: .pi, endAngle: 2 * .pi, clockwise: false)
            
        }
        
        for i in 0...17 {
            
            let moveEnemy = SKAction.follow(enemyPathCircleOuter.cgPath, asOffset: false, orientToPath: false, duration: 20)
            
            moveEnemy.timingFunction = {
                
                time in
                
                return min(time - 0.01 * Float(i), 1)
                
            }
            
            enemy.append(SKSpriteNode(imageNamed: "enemyShip"))

            enemy[i].setScale(0.35)
            enemy[i].zPosition = 2
            enemy[i].physicsBody = SKPhysicsBody(circleOfRadius: enemy[i].size.width / 2)
            enemy[i].physicsBody?.affectedByGravity = false
            enemy[i].physicsBody?.categoryBitMask = PhysicsCategories.Enemy
            enemy[i].physicsBody?.collisionBitMask = PhysicsCategories.None
            enemy[i].physicsBody?.contactTestBitMask = PhysicsCategories.Player | PhysicsCategories.Bullet
            
            addChild(enemy[i])
            
            
            enemy[i].run(moveEnemy)
            
        }
        
        for i in 18...28 {
            
            let moveEnemy = SKAction.follow(enemyPathCircleMiddle.cgPath, asOffset: false, orientToPath: false, duration: 20)
            
            moveEnemy.timingFunction = {
                
                time in
                
                return min(time - 0.0155 * Float(i - 18), 1)
                
            }
            
            enemy.append(SKSpriteNode(imageNamed: "enemyShip"))

            enemy[i].setScale(0.35)
            enemy[i].zPosition = 2
            enemy[i].physicsBody = SKPhysicsBody(circleOfRadius: enemy[i].size.width / 2)
            enemy[i].physicsBody?.affectedByGravity = false
            enemy[i].physicsBody?.categoryBitMask = PhysicsCategories.Enemy
            enemy[i].physicsBody?.collisionBitMask = PhysicsCategories.None
            enemy[i].physicsBody?.contactTestBitMask = PhysicsCategories.Player | PhysicsCategories.Bullet
            
            addChild(enemy[i])
            
            enemy[i].run(moveEnemy)
            
        }
        
        for i in 29...32 {
            
            let moveEnemy = SKAction.follow(enemyPathCircleInner.cgPath, asOffset: false, orientToPath: false, duration: 20)
            
            moveEnemy.timingFunction = {
                
                time in
                
                return min(time - 0.033 * Float(i - 29), 1)
                
            }
            
            enemy.append(SKSpriteNode(imageNamed: "enemyShip"))
            
            enemy[i].setScale(0.35)
            enemy[i].zPosition = 2
            enemy[i].physicsBody = SKPhysicsBody(circleOfRadius: enemy[i].size.width / 2)
            enemy[i].physicsBody?.affectedByGravity = false
            enemy[i].physicsBody?.categoryBitMask = PhysicsCategories.Enemy
            enemy[i].physicsBody?.collisionBitMask = PhysicsCategories.None
            enemy[i].physicsBody?.contactTestBitMask = PhysicsCategories.Player | PhysicsCategories.Bullet
            
            addChild(enemy[i])
            
            enemy[i].run(moveEnemy)
            
        }
        
    }
    
    
    
    func wave0010() {
        
            let enemyPath = UIBezierPath()
            
            enemyPath.move(to: CGPoint(x: 2200, y: 2200))
            
            for _ in 1...5 {
                
                enemyPath.addArc(withCenter: CGPoint(x: 750, y: 1200), radius: 400, startAngle: 0, endAngle: .pi, clockwise: false)
                enemyPath.addArc(withCenter: CGPoint(x: 750, y: 1200), radius: 400, startAngle: .pi, endAngle: 2 * .pi, clockwise: false)
                
            }
            
            for i in 0...17 {
                
                let moveEnemy = SKAction.follow(enemyPath.cgPath, asOffset: false, orientToPath: false, duration: 20)
                
                moveEnemy.timingFunction = {
                    
                    time in
                    
                    return min(time - 0.01 * Float(i), 1)
                    
                }
                
                enemy.append(SKSpriteNode(imageNamed: "enemyShip"))

                enemy[i].setScale(0.35)
                enemy[i].zPosition = 2
                enemy[i].physicsBody = SKPhysicsBody(circleOfRadius: enemy[i].size.width / 2)
                enemy[i].physicsBody?.affectedByGravity = false
                enemy[i].physicsBody?.categoryBitMask = PhysicsCategories.Enemy
                enemy[i].physicsBody?.collisionBitMask = PhysicsCategories.None
                enemy[i].physicsBody?.contactTestBitMask = PhysicsCategories.Player | PhysicsCategories.Bullet
                
                addChild(enemy[i])
                
                enemy[i].run(moveEnemy)
                
            }

        
    }
    
    
    
    func wave0011() {}
    
    
    
    func wave0012() {}
    
    
    
    func wave0013() {}
    
    
    
    func wave0014() {}
    
    
    
    func wave0015() {}
    
    
    
    func wave0016() {}
    
    
    
    func wave0017() {}
    
    
    
    func wave0018() {}
    
    
    
    func wave0019() {}
    
    
    
    func wave0020() {}
    
    
    
    func wave0021() {}
    
    
    
    func wave0022() {}
    
    
    
    func wave0023() {}
    
    
    
    func wave0024() {}
    
    
    
    func wave0025() {}
    
    
    
    func wave0026() {}
    
    
    
    func wave0027() {}
    
    
    
    func wave0028() {}
    
    
    
    func wave0029() {}
    
    
    
    func wave0030() {}
}
