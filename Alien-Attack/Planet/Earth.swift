//
//  Level1X.swift
//  Alien-Attack
//  Earth
//
//  Created by Alex Resnik on 10/18/22.
//
            
import SpriteKit
import GameplayKit


extension GameScene {
    
    
    func enemyPhysics(i: Int) {
        
        enemy[i].setScale(0.35)
        enemy[i].zPosition = 2
        enemy[i].physicsBody = SKPhysicsBody(circleOfRadius: enemy[i].size.width / 2)
        enemy[i].physicsBody?.affectedByGravity = false
        enemy[i].physicsBody?.categoryBitMask = PhysicsCategories.Enemy
        enemy[i].physicsBody?.collisionBitMask = PhysicsCategories.None
        enemy[i].physicsBody?.contactTestBitMask = PhysicsCategories.Player | PhysicsCategories.Bullet
        
    }
    
    
    // ------------- Level 1-1 -------------------
    
    // Grid
    func wave0001() {
        
        var rect = CGRect()
        
        rect.size.width = 800
        rect.size.height = 800
        rect.origin.x = (size.width / 2) - (rect.width / 2)
        rect.origin.y = rect.height / 2
        
        var x = rect.minX
        var y = rect.maxY
            
        for i in 0...17 {
            
            enemy.append(SKSpriteNode(imageNamed: "enemyShip"))
            
            enemy[i].position.x = 750
            enemy[i].position.y = 2200
            
            let moveEnemy = SKAction.move(to: CGPoint(x: x, y: y), duration: 2)
            let wait = SKAction.wait(forDuration: 1)
            let sequence = SKAction.sequence([wait, moveEnemy])
            
            addChild(enemy[i])
            
            enemyPhysics(i: i)
            
            enemy[i].run(sequence)
            
            x += rect.width/5
            
            if i == 5 { x = rect.minX; y = rect.maxY - rect.height/6 }
            if i == 11 { x = rect.minX; y = rect.maxY - rect.height/3 }
            
        }
        
    }
    
    
    // Circle to grid
    func wave0002() {
    
        let enemyPath = UIBezierPath()
        
        var rect = CGRect()
        
        rect.size.width = 800
        rect.size.height = 800
        rect.origin.x = (size.width / 2) - (rect.size.width / 2)
        
        let arc1 = CGPoint(x: rect.midX, y: rect.midY)
        let arc2 = CGPoint(x: rect.midX, y: rect.midY)
        
        rect.origin.y = rect.height / 2
        
        enemyPath.move(to: CGPoint(x: 2200, y: 2200))
        
        for _ in 1...5 {
            
            enemyPath.addArc(withCenter: arc1, radius: rect.width / 2, startAngle:   0, endAngle:     .pi, clockwise: false)
            enemyPath.addArc(withCenter: arc2, radius: rect.width / 2, startAngle: .pi, endAngle: 2 * .pi, clockwise: false)
        }
        
        for i in 0...17 {
            
            let moveEnemy = SKAction.follow(enemyPath.cgPath, asOffset: false, orientToPath: false, speed: 600)
            
            moveEnemy.timingFunction = {
                
                time in
                
                return min(time - 0.01 * Float(i), 1)
                
            }
            
            enemy.append(SKSpriteNode(imageNamed: "enemyShip"))

            enemyPhysics(i: i)
            
            addChild(enemy[i])
            
            enemy[i].run(moveEnemy)
            
        }

        
        var x = rect.minX
        var y = rect.maxY
            
        for i in 0...17 {
            
            let moveEnemy = SKAction.move(to: CGPoint(x: x, y: y), duration: 0.5)
            let wait = SKAction.wait(forDuration: 10 + (Double(i) * 0.3))
            let removeActions = SKAction.run {self.enemy[i].removeAllActions() }
            let sequence = SKAction.sequence([wait, moveEnemy, removeActions])
            
            enemy[i].run(sequence)
            
            x += rect.width/5
            
            if i == 5 { x = rect.minX; y = rect.maxY - rect.height/6 }
            if i == 11 { x = rect.minX; y = rect.maxY - rect.height/3 }
            
        }
        
    }

    
    // Three cirles to grid
    func wave0003 (){
        
        var rect = CGRect()
        
        let radius = 200.0
        
        rect.size.width = 800
        rect.size.height = 800
        rect.origin.x = (size.width / 2) - (rect.width / 2)
        rect.origin.y = 900
        
        let left   = CGPoint(x: rect.minX + rect.width * 1/4, y: rect.maxY - rect.height * 1/4)
        let right  = CGPoint(x: rect.minX + rect.width * 3/4, y: rect.maxY - rect.height * 1/4)
        let middle = CGPoint(x: rect.midX,                    y: rect.maxY - rect.height * 3/4)

        var enemyPath = [UIBezierPath]()
        
        for _ in 1...3 { enemyPath.append(UIBezierPath()) }
        
        enemyPath[0].move(to: CGPoint(x:    0, y: 500)) //Left
        enemyPath[1].move(to: CGPoint(x: 1000, y: 500)) //Right
        enemyPath[2].move(to: CGPoint(x:    0, y: 200)) //Middle
        
        for _ in 1...5 {
            
            // Left
            enemyPath[0].addArc(withCenter: left, radius: radius, startAngle: .pi, endAngle: 2 * .pi, clockwise: false)
            enemyPath[0].addArc(withCenter: left, radius: radius, startAngle:   0, endAngle:     .pi, clockwise: false)
            // Right
            enemyPath[1].addArc(withCenter: right, radius: radius, startAngle:   0, endAngle:     .pi, clockwise: false)
            enemyPath[1].addArc(withCenter: right, radius: radius, startAngle: .pi, endAngle: 2 * .pi, clockwise: false)
            // Middle
            enemyPath[2].addArc(withCenter: middle, radius: radius, startAngle: .pi, endAngle: 2 * .pi, clockwise: false)
            enemyPath[2].addArc(withCenter: middle, radius: radius, startAngle:   0, endAngle:     .pi, clockwise: false)
            
        }
        
        for j in 0...2 {
            
            for i in 0...5 {
                
                let k = i + j*6
                
                let moveEnemy = SKAction.follow(enemyPath[j].cgPath, asOffset: false, orientToPath: false, speed: 400)
                
                moveEnemy.timingFunction = {
                    
                    time in
                    
                    return min(time - 0.03 * Float(i), 1)
                    
                }
                
                enemy.append(SKSpriteNode(imageNamed: "enemyShip"))
                
                enemyPhysics(i: k)
                
                addChild(enemy[k])
                
                enemy[k].run(moveEnemy)
                
            }
            
        }
        
        
        var x = rect.minX
        var y = rect.maxY
            
        for i in 0...17 {
            
            let moveEnemy = SKAction.move(to: CGPoint(x: x, y: y), duration: 0.5)
            let wait = SKAction.wait(forDuration: 5 + (Double(i) * 0.3))
            let removeActions = SKAction.run { self.enemy[i].removeAllActions() }
            let sequence = SKAction.sequence([wait, moveEnemy, removeActions])
            
            self.enemy[i].run(sequence)
            
            x += rect.width/5
            
            if i == 5 { x = rect.minX; y = rect.maxY - rect.height/6 }
            if i == 11 { x = rect.minX; y = rect.maxY - rect.height/3 }
            
        }
        
    }
     
    
    // Ovals
    func wave0004(){
        
        var rect = CGRect()
        
        rect.size.width = 1200
        rect.size.height = 600
        rect.origin.x = size.width / 2 - rect.width / 2
        rect.origin.y = 900
        
        let curveToA    = CGPoint(x: rect.midX + rect.width * 1/4, y: rect.minY + rect.height * 1/4)
        let curveCntrlA = CGPoint(x: rect.midX,                    y: rect.minY + rect.height * 1/8)
        
        let curveToB    = CGPoint(x: rect.midX + rect.width * 1/4, y: rect.minY + rect.height * 3/4)
        let curveCntrlB = CGPoint(x: rect.maxX,                    y: rect.midY)
        
        let curveToC    = CGPoint(x: rect.minX + rect.width * 1/4, y: rect.maxY - rect.height * 1/4)
        let curveCntrlC = CGPoint(x: rect.midX,                    y: rect.maxY - rect.height * 1/8)
        
        let curveToD    = CGPoint(x: rect.minX + rect.width * 1/4, y: rect.midY - rect.height * 1/4)
        let curveCntrlD = CGPoint(x: rect.minX,                    y: rect.midY)
        
        var enemyPath = [UIBezierPath]()
        
        for _ in 1...2 { enemyPath.append(UIBezierPath()) }
        
        enemyPath[0].move(to: CGPoint(x: 0, y: 1200)) // horizontal
        enemyPath[1].move(to: CGPoint(x: 0, y: 0)) // Vertical
        
        for _ in 1...30 {
            
            // Horizontal
            enemyPath[0].addQuadCurve(to: curveToA, controlPoint: curveCntrlA)
            enemyPath[0].addQuadCurve(to: curveToB, controlPoint: curveCntrlB)
            enemyPath[0].addQuadCurve(to: curveToC, controlPoint: curveCntrlC)
            enemyPath[0].addQuadCurve(to: curveToD, controlPoint: curveCntrlD)
            // Vertical
            enemyPath[1].addQuadCurve(to: curveToA, controlPoint: curveCntrlA)
            enemyPath[1].addQuadCurve(to: curveToB, controlPoint: curveCntrlB)
            enemyPath[1].addQuadCurve(to: curveToC, controlPoint: curveCntrlC)
            enemyPath[1].addQuadCurve(to: curveToD, controlPoint: curveCntrlD)
            
        }
        
        let x = rect.midX
        let y = rect.midY
        let transform = CGAffineTransform(translationX: x, y: y).rotated(by: .pi / 2).translatedBy(x: -x, y: -y)
        
        enemyPath[1].apply(transform)
        
        for j in 0...1 {
            
            for i in 0...15 {
                
                let k = i + j*16
                
                let moveEnemy = SKAction.follow(enemyPath[j].cgPath, asOffset: false, orientToPath: false, speed: 600)
                
                moveEnemy.timingFunction = {
                    
                    time in
                    
                    return min(time - 0.00205 * Float(i), 1)
                    
                }
                
                enemy.append(SKSpriteNode(imageNamed: "enemyShip"))
                
                enemyPhysics(i: k)
                
                addChild(enemy[k])
                
                enemy[k].run(moveEnemy)
                
            }
            
        }
        
    }
    
    
    // Random motion
    func wave0005(){
        
        let enemyPath = UIBezierPath()
        
        var rect = CGRect()
        
        rect.size.width = 800
        rect.size.height = 800
        rect.origin.x = (size.width / 2) - (rect.width / 2)
        rect.origin.y = 900
        
        enemyPath.move(to: CGPoint(x: 400, y: 2200))
            
        for i in 0...17 {
            
            let moveEnemy = SKAction.follow(enemyPath.cgPath, asOffset: false, orientToPath: false, duration: 1)
            
            moveEnemy.timingFunction = {
                
                time in
                
                return min(time - 0.2 * Float(i), 1)
                
            }
            
            enemy.append(SKSpriteNode(imageNamed: "enemyShip"))

            enemyPhysics(i: i)
            
            addChild(enemy[i])
            
            enemy[i].run(moveEnemy)
            
        }
        
        var x = rect.minX
        var y = rect.maxY
        
        for i in 0...17 {
            
            let moveEnemy = SKAction.move(to: CGPoint(x: x, y: y), duration: 0.4)
            let wait = SKAction.wait(forDuration: 1 + (Double(i) * 0.3))
            let removeActions = SKAction.run { self.enemy[i].removeAllActions() }
            let sequence = SKAction.sequence([wait, moveEnemy, removeActions])
            
            self.enemy[i].run(sequence)
            
            x += rect.width/5
            
            if i == 5 { x = rect.minX; y = rect.maxY - rect.height/6 }
            if i == 11 { x = rect.minX; y = rect.maxY - rect.height/3 }
            
        }
        
        let waitRunAction = SKAction.run {
            
            let runAcion = SKAction.run { [self] in
                
                for i in 0...17 {
                    
                    let rndX = CGFloat.random(in: -10...10)
                    let rndY = CGFloat.random(in: -10...10)
                    
                    if enemy[i].position.x < rect.minX { enemy[i].position.x = rect.minX }
                    if enemy[i].position.x > rect.maxX { enemy[i].position.x = rect.maxX }
                    if enemy[i].position.y < rect.minY { enemy[i].position.y = rect.minY }
                    if enemy[i].position.y > rect.maxY { enemy[i].position.y = rect.maxY }

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
    
    // ------ Level 1-2 -------
    
    // Expanding circle
    func wave0006() {
        
        let enemyPathLine = UIBezierPath()
        let enemyPathCircle = UIBezierPath()
        
        var rect = CGRect()
        
        rect.size.width = 800
        rect.size.height = 800
        rect.origin.x = (size.width / 2) - (rect.width / 2)
        rect.origin.y = 900
        
        enemyPathLine.move(to: CGPoint(x: 2200, y: 2200))
        
        enemyPathLine.addLine(to: CGPoint(x: rect.midX, y: rect.midY))

        for i in 0...17 {
            
            let moveEnemy = SKAction.follow(enemyPathLine.cgPath, asOffset: false, orientToPath: false, duration: 0.5)
            
            enemy.append(SKSpriteNode(imageNamed: "enemyShip"))

            enemyPhysics(i: i)
            
            addChild(enemy[i])
            
            enemy[i].run(moveEnemy)
            
        }
        
        enemyPathCircle.move(to: CGPoint(x: rect.midX, y: rect.midY))
        
        for i in 1...10 {
            
            enemyPathCircle.addArc(withCenter: CGPoint(x: rect.midX, y: rect.midY), radius: CGFloat(40 * i), startAngle: 0, endAngle: .pi, clockwise: false)
            enemyPathCircle.addArc(withCenter: CGPoint(x: rect.midX, y: rect.midY), radius: CGFloat(40 * i), startAngle: .pi, endAngle: 2 * .pi, clockwise: false)
            
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
   
    
    // Grid Up and Down
    func wave0007() {
        
        var rect = CGRect()
        
        rect.size.width = 800
        rect.size.height = 800
        rect.origin.x = (size.width / 2) - (rect.width / 2)
        rect.origin.y = 900
        
        var x = rect.minX
        var y = rect.maxY
            
        for i in 0...17 {
            
            enemy.append(SKSpriteNode(imageNamed: "enemyShip"))
            
            enemy[i].position.x = 750
            enemy[i].position.y = 2200
            
            enemyPhysics(i: i)
            
            addChild(enemy[i])
            
            let moveEnemy = SKAction.move(to: CGPoint(x: x, y: y), duration: 2)
            let moveEnemyDown = SKAction.move(to: CGPoint(x: x, y: y - 800), duration: 2)
            let moveSequence = SKAction.sequence([moveEnemy, moveEnemyDown, moveEnemy])
            let repeatMove = SKAction.repeatForever(moveSequence)

            enemy[i].run(repeatMove)
            
            x += rect.width / 5
            
            if i == 5 { x = rect.minX; y = rect.maxY - rect.height / 6 }
            if i == 11 { x = rect.minX; y = rect.maxY - rect.height / 3 }
            
        }
        
    }
    
    
    // Single
    func wave0008() {

        var i = 0
        
        for _ in 0...17 { self.enemy.append(SKSpriteNode(imageNamed: "enemyShip")) }
 
        let runAction = SKAction.run {
            
            let x = CGFloat.random(in: 200...1300)
            
            self.addChild(self.enemy[i])
            
            self.enemy[i].position = CGPoint(x: x, y: 2200)
         
            self.enemyPhysics(i: i)
            
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
        
        var rect = CGRect()
        
        rect.size.width = 800
        rect.size.height = 800
        rect.origin.x = (size.width / 2) - (rect.width / 2)
        rect.origin.y = 900
        
        enemyPathCircleOuter.move(to: CGPoint(x: 2200, y: 2200))
        enemyPathCircleMiddle.move(to: CGPoint(x: 2200, y: 2200))
        enemyPathCircleInner.move(to: CGPoint(x: 2200, y: 2200))
        
        for _ in 1...5 {
            
            enemyPathCircleOuter.addArc(withCenter: CGPoint(x: rect.midX, y: rect.midY), radius: 400, startAngle: 0, endAngle: .pi, clockwise: false)
            enemyPathCircleOuter.addArc(withCenter: CGPoint(x: rect.midX, y: rect.midY), radius: 400, startAngle: .pi, endAngle: 2 * .pi, clockwise: false)
            
            enemyPathCircleMiddle.addArc(withCenter: CGPoint(x: rect.midX, y: rect.midY), radius: 250, startAngle: 0, endAngle: .pi, clockwise: false)
            enemyPathCircleMiddle.addArc(withCenter: CGPoint(x: rect.midX, y: rect.midY), radius: 250, startAngle: .pi, endAngle: 2 * .pi, clockwise: false)
            
            enemyPathCircleInner.addArc(withCenter: CGPoint(x: rect.midX, y: rect.midY), radius: 100, startAngle: 0, endAngle: .pi, clockwise: false)
            enemyPathCircleInner.addArc(withCenter: CGPoint(x: rect.midX, y: rect.midY), radius: 100, startAngle: .pi, endAngle: 2 * .pi, clockwise: false)
            
        }
        
        for i in 0...17 {
            
            let moveEnemy = SKAction.follow(enemyPathCircleOuter.cgPath, asOffset: false, orientToPath: false, speed: 400)
            
            moveEnemy.timingFunction = {
                
                time in
                
                return min(time - 0.01 * Float(i), 1)
                
            }
            
            enemy.append(SKSpriteNode(imageNamed: "enemyShip"))

            enemyPhysics(i: i)
            
            addChild(enemy[i])
            
            
            enemy[i].run(moveEnemy)
            
        }
        
        for i in 18...28 {
            
            let moveEnemy = SKAction.follow(enemyPathCircleMiddle.cgPath, asOffset: false, orientToPath: false, speed: 400)
            
            moveEnemy.timingFunction = {
                
                time in
                
                return min(time - 0.0155 * Float(i - 18), 1)
                
            }
            
            enemy.append(SKSpriteNode(imageNamed: "enemyShip"))

            enemyPhysics(i: i)
            
            addChild(enemy[i])
            
            enemy[i].run(moveEnemy)
            
        }
        
        for i in 29...32 {
            
            let moveEnemy = SKAction.follow(enemyPathCircleInner.cgPath, asOffset: false, orientToPath: false, speed: 400)
            
            moveEnemy.timingFunction = {
                
                time in
                
                return min(time - 0.033 * Float(i - 29), 1)
                
            }
            
            enemy.append(SKSpriteNode(imageNamed: "enemyShip"))
            
            enemyPhysics(i: i)
            
            addChild(enemy[i])
            
            enemy[i].run(moveEnemy)
            
        }
        
    }
    
    
    // Square
    func wave0010() {
        
        let enemyPath = UIBezierPath()
        
        var rect = CGRect()
        
        rect.size.width = 800
        rect.size.height = 800
        rect.origin.x = size.width / 2 - 400
        rect.origin.y = 900

        
        enemyPath.move(to: CGPoint(x: 0, y: 1200))
        
        for _ in 1...50 {

            enemyPath.addLine(to: CGPoint(x: rect.minX, y: rect.maxY))
            enemyPath.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY))
            enemyPath.addLine(to: CGPoint(x: rect.maxX, y: rect.minY))
            enemyPath.addLine(to: CGPoint(x: rect.minX, y: rect.minY))
            
        }
        
        for i in 0...17 {
            
            let moveEnemy = SKAction.follow(enemyPath.cgPath, asOffset: false, orientToPath: false, speed: 600)
            
            moveEnemy.timingFunction = {
                
                time in
                
                return min(time - 0.0011 * Float(i), 1)
                
            }
            
            enemy.append(SKSpriteNode(imageNamed: "enemyShip"))

            enemyPhysics(i: i)
            
            addChild(enemy[i])
            
            enemy[i].run(moveEnemy)
            
        }
    
    }
    
    // ------- Level 1-3 -------
    
    // Triangle
    func wave0011() {
        
        let enemyPath = UIBezierPath()
        
        var rect = CGRect()
        
        rect.size.width = 800
        rect.size.height = 800
        rect.origin.x = (size.width / 2) - (rect.size.width / 2)
        rect.origin.y = 900
        
        enemyPath.move(to: CGPoint(x: 2200, y: 2200))
        
        for _ in 1...50 {
            
            enemyPath.addLine(to: CGPoint(x: rect.midX, y: rect.minY))
            enemyPath.addLine(to: CGPoint(x: rect.minX, y: rect.maxY))
            enemyPath.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY))
         
        }
        
        for i in 0...17 {
            
            let moveEnemy = SKAction.follow(enemyPath.cgPath, asOffset: false, orientToPath: false, speed: 600)
            
            moveEnemy.timingFunction = {
                
                time in
                
                return min(time - 0.0011 * Float(i), 1)
                
            }
            
            enemy.append(SKSpriteNode(imageNamed: "enemyShip"))

            enemyPhysics(i: i)
            
            addChild(enemy[i])
            
            enemy[i].run(moveEnemy)
            
        }
    
    }
    
    
    // Downward Curve
    func wave0012() {
        
        let enemyPath = UIBezierPath()
        
        var rect = CGRect()
        
        rect.size.width = 800
        rect.size.height = 1200
        rect.origin.x = (size.width / 2) - (rect.size.width / 2)
        rect.origin.y = 500
        
        enemyPath.move(to: CGPoint(x: 0, y: 2200))
        enemyPath.addLine(to: CGPoint(x: rect.minX, y: rect.maxY))
        
        for _ in 1...50 {
            
            enemyPath.addQuadCurve(to: CGPoint(x: rect.maxX, y: rect.maxY),controlPoint: CGPoint(x: size.width / 2, y: rect.minY))
            enemyPath.addLine(to: CGPoint(x: rect.minX, y: rect.maxY))
         
        }
        
        for i in 0...17 {
            
            let moveEnemy = SKAction.follow(enemyPath.cgPath, asOffset: false, orientToPath: false, speed: 600)
            
            moveEnemy.timingFunction = {
                
                time in
                
                return min(time - 0.0011 * Float(i), 1)
                
            }
            
            enemy.append(SKSpriteNode(imageNamed: "enemyShip"))

            enemyPhysics(i: i)
            
            addChild(enemy[i])
            
            enemy[i].run(moveEnemy)
            
        }
        
    }
    
    
    // Infinty
    func wave0013() {
        
        let enemyPath = UIBezierPath()
        
        var rect = CGRect()
        
        rect.size.width = 800
        rect.size.height = 800
        rect.origin.x = (size.width / 2) - (rect.width / 2)
        rect.origin.y = rect.height / 2
        
        enemyPath.move   (to: CGPoint(x: 0, y: 2000))
        enemyPath.addLine(to: CGPoint(x: rect.minX, y: rect.midY))
        
        for _ in 1...50 {
            
            enemyPath.addQuadCurve(to: CGPoint(x: rect.midX, y: rect.midY), controlPoint: CGPoint(x: rect.midX * 2/4, y: rect.minY))
            enemyPath.addQuadCurve(to: CGPoint(x: rect.maxX, y: rect.midY), controlPoint: CGPoint(x: rect.maxX * 3/4, y: rect.maxY))
            enemyPath.addQuadCurve(to: CGPoint(x: rect.midX, y: rect.midY), controlPoint: CGPoint(x: rect.maxX * 3/4, y: rect.minY))
            enemyPath.addQuadCurve(to: CGPoint(x: rect.minX, y: rect.midY), controlPoint: CGPoint(x: rect.midX * 2/4, y: rect.maxY))
         
        }
        
        for i in 0...17 {
            
            let moveEnemy = SKAction.follow(enemyPath.cgPath, asOffset: true, orientToPath: true, speed: 600)
            
            moveEnemy.timingFunction = {
                
                time in
                
                return min(time - 0.0011 * Float(i), 1)
                
            }
            
            enemy.append(SKSpriteNode(imageNamed: "enemyShip"))

            enemyPhysics(i: i)
            
            addChild(enemy[i])
            
            enemy[i].run(moveEnemy)
            
        }
        
        
    }
    
    
    // Cross
    func wave0014() {
        
        let enemyPath = UIBezierPath()
        
        var rect = CGRect()
        
        rect.size.width = 800
        rect.size.height = 800
        rect.origin.x = size.width / 2 - 400
        rect.origin.y = 900
        
        enemyPath.move(to: CGPoint(x: 0, y: 1800))
        
        for _ in 1...50 {

            enemyPath.addLine(to: CGPoint(x: rect.minX + rect.width * 000, y: rect.minY + rect.height * 2/3))
            enemyPath.addLine(to: CGPoint(x: rect.minX + rect.width * 1/3, y: rect.minY + rect.height * 2/3))
            enemyPath.addLine(to: CGPoint(x: rect.minX + rect.width * 1/3, y: rect.maxY + rect.height * 000))
            enemyPath.addLine(to: CGPoint(x: rect.minX + rect.width * 2/3, y: rect.maxY + rect.height * 000))
            enemyPath.addLine(to: CGPoint(x: rect.minX + rect.width * 2/3, y: rect.minY + rect.height * 2/3))
            enemyPath.addLine(to: CGPoint(x: rect.maxX + rect.width * 000, y: rect.minY + rect.height * 2/3))
            enemyPath.addLine(to: CGPoint(x: rect.maxX + rect.width * 000, y: rect.minY + rect.height * 1/3))
            enemyPath.addLine(to: CGPoint(x: rect.minX + rect.width * 2/3, y: rect.minY + rect.height * 1/3))
            enemyPath.addLine(to: CGPoint(x: rect.minX + rect.width * 2/3, y: rect.minY + rect.height * 000))
            enemyPath.addLine(to: CGPoint(x: rect.minX + rect.width * 1/3, y: rect.minY + rect.height * 000))
            enemyPath.addLine(to: CGPoint(x: rect.minX + rect.width * 1/3, y: rect.minY + rect.height * 1/3))
            enemyPath.addLine(to: CGPoint(x: rect.minX + rect.width * 000, y: rect.minY + rect.height * 1/3))
            
        }
        
        for i in 0...22 {
            
            let moveEnemy = SKAction.follow(enemyPath.cgPath, asOffset: false, orientToPath: false, speed: 600)
            
            moveEnemy.timingFunction = {
                
                time in
                
                return min(time - 0.00087 * Float(i), 1)
                
            }
            
            enemy.append(SKSpriteNode(imageNamed: "enemyShip"))

            enemyPhysics(i: i)
            
            addChild(enemy[i])
            
            enemy[i].run(moveEnemy)
            
        }
    
    }
    
    
    // Star of David
    func wave0015() {
        
        let enemyPathDown = UIBezierPath()
        let enemyPathUp = UIBezierPath()
        
        var rect = CGRect()
        
        rect.size.width = 800
        rect.size.height = 800
        rect.origin.x = size.width / 2 - 400
        rect.origin.y = 700
        
        
        enemyPathDown.move(to: CGPoint(x: 0, y: 1800))
        enemyPathUp.move(to: CGPoint(x: 0, y: 1800))
        
        for _ in 1...50 {

            enemyPathDown.addLine(to: CGPoint(x: rect.minX, y: rect.maxY))
            enemyPathDown.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY))
            enemyPathDown.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY))
            enemyPathDown.addLine(to: CGPoint(x: rect.midX, y: rect.minY))
            
            enemyPathUp.addLine(to: CGPoint(x: rect.minX, y: rect.maxY))
            enemyPathUp.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY))
            enemyPathUp.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY))
            enemyPathUp.addLine(to: CGPoint(x: rect.midX, y: rect.minY))
    
        }
        
        enemyPathUp.apply(CGAffineTransform(scaleX: 1, y: -1))
        enemyPathUp.apply(CGAffineTransform(translationX: 0, y: 2450))
        
        for i in 0...25 {
            
            let moveEnemyDown = SKAction.follow(enemyPathDown.cgPath, asOffset: false, orientToPath: false, speed: 600)
            
            
            moveEnemyDown.timingFunction = {
                
                time in
                
                return min(time - 0.00077 * Float(i), 1)
                
            }
            
            enemy.append(SKSpriteNode(imageNamed: "enemyShip"))

            enemyPhysics(i: i)
            
            addChild(enemy[i])
            
            enemy[i].run(moveEnemyDown)
            
        }
        
        for i in 26...51 {
            
            let moveEnemyUp = SKAction.follow(enemyPathUp.cgPath, asOffset: false, orientToPath: false, speed: 600)
            
            
            moveEnemyUp.timingFunction = {
                
                time in
                
                return min(time - 0.00077 * Float(i), 1)
                
            }
            
            enemy.append(SKSpriteNode(imageNamed: "enemyShip"))

            enemyPhysics(i: i)
            
            addChild(enemy[i])
            
            enemy[i].run(moveEnemyUp)
            
        }
        
    }
    
    // ------ Level 1-4 ------
    
    // Cross at 45 Degrees
    func wave0016() {
        
        let enemyPath = UIBezierPath()
        
        var rect = CGRect()
        
        rect.size.width = 800
        rect.size.height = 800
        rect.origin.x = (size.width / 2) - (rect.width / 2)
        rect.origin.y = 900
        
        enemyPath.move(to: CGPoint(x: 0, y: 1800))
        
        for _ in 1...50 {

            enemyPath.addLine(to: CGPoint(x: rect.minX + rect.width * 000, y: rect.minY + rect.height * 2/3))
            enemyPath.addLine(to: CGPoint(x: rect.minX + rect.width * 1/3, y: rect.minY + rect.height * 2/3))
            enemyPath.addLine(to: CGPoint(x: rect.minX + rect.width * 1/3, y: rect.maxY + rect.height * 000))
            enemyPath.addLine(to: CGPoint(x: rect.minX + rect.width * 2/3, y: rect.maxY + rect.height * 000))
            enemyPath.addLine(to: CGPoint(x: rect.minX + rect.width * 2/3, y: rect.minY + rect.height * 2/3))
            enemyPath.addLine(to: CGPoint(x: rect.maxX + rect.width * 000, y: rect.minY + rect.height * 2/3))
            enemyPath.addLine(to: CGPoint(x: rect.maxX + rect.width * 000, y: rect.minY + rect.height * 1/3))
            enemyPath.addLine(to: CGPoint(x: rect.minX + rect.width * 2/3, y: rect.minY + rect.height * 1/3))
            enemyPath.addLine(to: CGPoint(x: rect.minX + rect.width * 2/3, y: rect.minY + rect.height * 000))
            enemyPath.addLine(to: CGPoint(x: rect.minX + rect.width * 1/3, y: rect.minY + rect.height * 000))
            enemyPath.addLine(to: CGPoint(x: rect.minX + rect.width * 1/3, y: rect.minY + rect.height * 1/3))
            enemyPath.addLine(to: CGPoint(x: rect.minX + rect.width * 000, y: rect.minY + rect.height * 1/3))
            
        }
        
        let x = rect.midX
        let y = rect.midY
        let transform = CGAffineTransform(translationX: x, y: y).rotated(by: .pi / 4).translatedBy(x: -x, y: -y)
        
        enemyPath.apply(transform)
        
        
        for i in 0...22 {
            
            let moveEnemy = SKAction.follow(enemyPath.cgPath, asOffset: false, orientToPath: false, speed: 600)
            
            moveEnemy.timingFunction = {
                
                time in
                
                return min(time - 0.00087 * Float(i), 1)
                
            }
            
            enemy.append(SKSpriteNode(imageNamed: "enemyShip"))

            enemyPhysics(i: i)
            
            addChild(enemy[i])
            
            enemy[i].run(moveEnemy)
            
        }
    
    }
    
    
    // Hart
    func wave0017() {
        
        let enemyPath = UIBezierPath()
        
        var rect = CGRect()
        
        rect.size.width = 800
        rect.size.height = 800
        rect.origin.x = (size.width / 2) - (rect.width / 2)
        rect.origin.y = 900
        
        let radiusA = rect.width * 1/4
        let radiusB = radiusA
        
        let moveToA  = CGPoint(x: rect.minX + rect.width *   0, y: rect.maxY - rect.height * 1/4)
        let centerA  = CGPoint(x: rect.minX + rect.width * 1/4, y: rect.maxY - rect.height * 1/4)
        let centerB  = CGPoint(x: rect.maxX - rect.width * 1/4, y: rect.maxY - rect.height * 1/4)
        let curveToC = CGPoint(x: rect.midX + rect.width *   0, y: rect.minY + rect.height *   0)
        let controlC = CGPoint(x: rect.maxX - rect.width * 1/8, y: rect.minY + rect.height * 1/8)
        let controlD = CGPoint(x: rect.minX + rect.width * 1/8, y: rect.minY + rect.height * 1/8)
        
        enemyPath.move(to: CGPoint(x: 0, y: 1800))
        enemyPath.addLine(to: moveToA)
        
        for _ in 1...50 {

            enemyPath.addArc(withCenter: centerA, radius: radiusA, startAngle: .pi, endAngle: 0, clockwise: false)
            enemyPath.addArc(withCenter: centerB, radius: radiusB, startAngle: .pi, endAngle: 0, clockwise: false)
            
            enemyPath.addQuadCurve(to: curveToC, controlPoint: controlC)
            enemyPath.addQuadCurve(to:  moveToA, controlPoint: controlD)
            
        }
        
        
        for i in 0...22 {
            
            let moveEnemy = SKAction.follow(enemyPath.cgPath, asOffset: false, orientToPath: false, speed: 600)
            
            moveEnemy.timingFunction = {
                
                time in
                
                return min(time - 0.00087 * Float(i), 1)
                
            }
            
            enemy.append(SKSpriteNode(imageNamed: "enemyShip"))

            enemyPhysics(i: i)
            
            addChild(enemy[i])
            
            enemy[i].run(moveEnemy)
            
        }
        
    }
    
    
    // Star
    func wave0018() {
        
        
        let enemyPath = UIBezierPath()
        
        var rect = CGRect()
        
        rect.size.width = 800
        rect.size.height = 800
        rect.origin.x = (size.width / 2) - (rect.width / 2)
        rect.origin.y = 900
        
        enemyPath.move(to: CGPoint(x: 0, y: 1800))
        enemyPath.addLine(to: CGPoint(x: rect.minX, y: rect.midY + rect.height * 1/8))
        
        for _ in 1...50 {

            enemyPath.addLine(to: CGPoint(x: rect.midX - rect.width *  1/8, y: rect.midY + rect.height * 1/8)) // Line A
            enemyPath.addLine(to: CGPoint(x: rect.midX                    , y: rect.maxY                    )) // Line B
            enemyPath.addLine(to: CGPoint(x: rect.midX + rect.width *  1/8, y: rect.midY + rect.height * 1/8)) // Line C
            enemyPath.addLine(to: CGPoint(x: rect.maxX                    , y: rect.midY + rect.height * 1/8)) // Line D
            enemyPath.addLine(to: CGPoint(x: rect.midX + rect.width * 3/16, y: rect.midY - rect.height * 1/8)) // Line E
            enemyPath.addLine(to: CGPoint(x: rect.maxX - rect.width * 3/16, y: rect.minY                    )) // Line F
            enemyPath.addLine(to: CGPoint(x: rect.midX                    , y: rect.minY + rect.height * 2/8)) // Line G
            enemyPath.addLine(to: CGPoint(x: rect.minX + rect.width * 3/16, y: rect.minY                    )) // Line H
            enemyPath.addLine(to: CGPoint(x: rect.minX + rect.width * 5/16, y: rect.midY - rect.height * 1/8)) // Line I
            enemyPath.addLine(to: CGPoint(x: rect.minX                    , y: rect.midY + rect.height * 1/8)) // Line J
            
        }
        
        
        for i in 0...22 {
            
            let moveEnemy = SKAction.follow(enemyPath.cgPath, asOffset: false, orientToPath: false, speed: 600)
            
            moveEnemy.timingFunction = {
                
                time in
                
                return min(time - 0.00087 * Float(i), 1)
                
            }
            
            enemy.append(SKSpriteNode(imageNamed: "enemyShip"))

            enemyPhysics(i: i)
            
            addChild(enemy[i])
            
            enemy[i].run(moveEnemy)
            
        }
        
    }
    
    
    // Hexagon
    func wave0019() {
        
        let enemyPath = UIBezierPath()
        
        var rect = CGRect()
        
        rect.size.width = 800
        rect.size.height = 800
        rect.origin.x = (size.width / 2) - (rect.width / 2)
        rect.origin.y = 900
        
        enemyPath.move(to: CGPoint(x: 0, y: 1800))
        enemyPath.addLine(to: CGPoint(x: rect.minX, y: rect.midY))
        
        for _ in 1...50 {

            enemyPath.addLine(to: CGPoint(x: rect.minX + rect.width * 2/8, y: rect.maxY                    )) // Line A
            enemyPath.addLine(to: CGPoint(x: rect.midX + rect.width * 2/8, y: rect.maxY                    )) // Line B
            enemyPath.addLine(to: CGPoint(x: rect.maxX + rect.width *   0, y: rect.midY + rect.height *   0)) // Line C
            enemyPath.addLine(to: CGPoint(x: rect.midX + rect.width * 2/8, y: rect.minY + rect.height *   0)) // Line D
            enemyPath.addLine(to: CGPoint(x: rect.minX + rect.width * 2/8, y: rect.minY - rect.height *   0)) // Line E
            enemyPath.addLine(to: CGPoint(x: rect.minX - rect.width *   0, y: rect.midY                    )) // Line F
            
        }
        
        
        for i in 0...22 {
            
            let moveEnemy = SKAction.follow(enemyPath.cgPath, asOffset: false, orientToPath: false, speed: 600)
            
            moveEnemy.timingFunction = {
                
                time in
                
                return min(time - 0.00087 * Float(i), 1)
                
            }
            
            enemy.append(SKSpriteNode(imageNamed: "enemyShip"))

            enemyPhysics(i: i)
            
            addChild(enemy[i])
            
            enemy[i].run(moveEnemy)
            
        }
        
    }
    
    
    // Arrow
    func wave0020() {
        
        let enemyPath = UIBezierPath()
        
        var rect = CGRect()
        
        rect.size.width = 800
        rect.size.height = 800
        rect.origin.x = (size.width / 2) - (rect.width / 2)
        rect.origin.y = 900
        
        enemyPath.move(to: CGPoint(x: 0, y: 1800))
        enemyPath.addLine(to: CGPoint(x: rect.minX, y: rect.midY + rect.height * 1/8))
        
        for _ in 1...50 {

            enemyPath.addLine(to: CGPoint(x: rect.midX - rect.width *  1/8, y: rect.midY + rect.height * 1/8)) // Line A
            enemyPath.addLine(to: CGPoint(x: rect.midX - rect.width *  1/8, y: rect.maxY + rect.height *   0)) // Line B
            enemyPath.addLine(to: CGPoint(x: rect.midX + rect.width *  1/8, y: rect.maxY + rect.height *   0)) // Line C
            enemyPath.addLine(to: CGPoint(x: rect.midX + rect.width *  1/8, y: rect.midY + rect.height * 1/8)) // Line D
            enemyPath.addLine(to: CGPoint(x: rect.maxX + rect.width *    0, y: rect.midY + rect.height * 1/8)) // Line E
            enemyPath.addLine(to: CGPoint(x: rect.midX - rect.width *    0, y: rect.minY + rect.height *   0)) // Line F
            enemyPath.addLine(to: CGPoint(x: rect.minX - rect.width *    0, y: rect.midY + rect.height * 1/8)) // Line G
            
        }
        
        
        for i in 0...22 {
            
            let moveEnemy = SKAction.follow(enemyPath.cgPath, asOffset: false, orientToPath: false, speed: 600)
            
            moveEnemy.timingFunction = {
                
                time in
                
                return min(time - 0.00087 * Float(i), 1)
                
            }
            
            enemy.append(SKSpriteNode(imageNamed: "enemyShip"))

            enemyPhysics(i: i)
            
            addChild(enemy[i])
            
            enemy[i].run(moveEnemy)
            
        }
        
        
    }
    
    // --------- Level 1-5 --------
    
    // Crescent
    func wave0021() {
        
        let enemyPath = UIBezierPath()
        
        var rect = CGRect()
        
        rect.size.width = 800
        rect.size.height = 800
        rect.origin.x = (size.width / 2) - (rect.width / 2)
        rect.origin.y = 900
        
        let curveToA = CGPoint(x: rect.maxX, y: rect.minY)
        let curveCnA = CGPoint(x: rect.minX - rect.width * 1/8, y: rect.minY - rect.height * 1/8)
        let curveToB = CGPoint(x: rect.minX, y: rect.maxY)
        let curveCnB = CGPoint(x: rect.minX + rect.width * 2/8, y: rect.minY + rect.height * 2/8)
        
        enemyPath.move   (to: CGPoint(x: 0, y: 2000))
        enemyPath.addLine(to: CGPoint(x: rect.minX, y: rect.maxY))
        
        for _ in 1...50 {
            
            enemyPath.addQuadCurve(to: curveToA, controlPoint: curveCnA)
            enemyPath.addQuadCurve(to: curveToB, controlPoint: curveCnB)
         
        }
        
        for i in 0...17 {
            
            let moveEnemy = SKAction.follow(enemyPath.cgPath, asOffset: true, orientToPath: true, speed: 600)
            
            moveEnemy.timingFunction = {
                
                time in
                
                return min(time - 0.0011 * Float(i), 1)
                
            }
            
            enemy.append(SKSpriteNode(imageNamed: "enemyShip"))

            enemyPhysics(i: i)
            
            addChild(enemy[i])
            
            enemy[i].run(moveEnemy)
            
        }
        
        
    }
    
    
    // Trefoil
    func wave0022() {
        
        var rect = CGRect()
        
        let radius = 200.0
        
        rect.size.width = 800
        rect.size.height = 800
        rect.origin.x = (size.width / 2) - (rect.width / 2)
        rect.origin.y = 900
        
        let left   = CGPoint(x: rect.minX + rect.width * 3/8, y: rect.maxY - rect.height * 1/4)
        let right  = CGPoint(x: rect.minX + rect.width * 5/8, y: rect.maxY - rect.height * 1/4)
        let middle = CGPoint(x: rect.midX,                    y: rect.maxY - rect.height * 4/8)

        var enemyPath = [UIBezierPath]()
        
        for _ in 1...3 { enemyPath.append(UIBezierPath()) }
        
        enemyPath[0].move(to: CGPoint(x:    0, y: 1200)) //Left
        enemyPath[1].move(to: CGPoint(x: 1500, y: 1600)) //Right
        enemyPath[2].move(to: CGPoint(x:    0, y: 1000)) //Middle
        
        for _ in 1...50 {
            
            // Left
            enemyPath[0].addArc(withCenter: left, radius: radius, startAngle: .pi, endAngle: 2 * .pi, clockwise: false)
            enemyPath[0].addArc(withCenter: left, radius: radius, startAngle:   0, endAngle:     .pi, clockwise: false)
            // Right
            enemyPath[1].addArc(withCenter: right, radius: radius, startAngle:   0, endAngle:     .pi, clockwise: false)
            enemyPath[1].addArc(withCenter: right, radius: radius, startAngle: .pi, endAngle: 2 * .pi, clockwise: false)
            // Middle
            enemyPath[2].addArc(withCenter: middle, radius: radius, startAngle: .pi, endAngle: 2 * .pi, clockwise: false)
            enemyPath[2].addArc(withCenter: middle, radius: radius, startAngle:   0, endAngle:     .pi, clockwise: false)
            
        }
        
        for j in 0...2 {
            
            for i in 0...10 {
                
                let k = i + j*11
                
                let moveEnemy = SKAction.follow(enemyPath[j].cgPath, asOffset: false, orientToPath: false, speed: 400)
                
                moveEnemy.timingFunction = {
                    
                    time in
                    
                    return min(time - 0.0018 * Float(i), 1)
                    
                }
                
                enemy.append(SKSpriteNode(imageNamed: "enemyShip"))
                
                enemyPhysics(i: k)
                
                addChild(enemy[k])
                
                enemy[k].run(moveEnemy)
                
            }
            
        }
        
    }
    
    
    // Diamond
    func wave0023() {
        
        let enemyPath = UIBezierPath()
        
        var rect = CGRect()
        
        rect.size.width = 700
        rect.size.height = 700
        rect.origin.x = size.width / 2 - 400
        rect.origin.y = 900

        
        enemyPath.move(to: CGPoint(x: 0, y: 1200))
        
        for _ in 1...50 {

            enemyPath.addLine(to: CGPoint(x: rect.minX, y: rect.maxY))
            enemyPath.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY))
            enemyPath.addLine(to: CGPoint(x: rect.maxX, y: rect.minY))
            enemyPath.addLine(to: CGPoint(x: rect.minX, y: rect.minY))
            
        }
        
        let x = rect.midX
        let y = rect.midY
        let transform = CGAffineTransform(translationX: x, y: y).rotated(by: .pi / 4).translatedBy(x: -x, y: -y)
        
        enemyPath.apply(transform)
        
        for i in 0...17 {
            
            let moveEnemy = SKAction.follow(enemyPath.cgPath, asOffset: false, orientToPath: false, speed: 600)
            
            moveEnemy.timingFunction = {
                
                time in
                
                return min(time - 0.0011 * Float(i), 1)
                
            }
            
            enemy.append(SKSpriteNode(imageNamed: "enemyShip"))

            enemyPhysics(i: i)
            
            addChild(enemy[i])
            
            enemy[i].run(moveEnemy)
            
        }
        
    }
    
    
    // Two Half Circle
    func wave0024() {
        
        let enemyPathDown = UIBezierPath()
        let enemyPathUp = UIBezierPath()
        
        var rect = CGRect()
        
        rect.size.width = 800
        rect.size.height = 800
        rect.origin.x = (size.width / 2) - (rect.size.width / 2)
        rect.origin.y = 700
        
        let arc1 = CGPoint(x: rect.midX, y: rect.midY)
        
        rect.origin.y = rect.height / 2
        
        enemyPathDown.move(to: CGPoint(x: 2200, y: 2200))
        enemyPathUp.move(to: CGPoint(x: 2200, y: 2200))
        
        for _ in 1...50 {
            
            enemyPathDown.addArc(withCenter: arc1, radius: rect.width / 2, startAngle:   0, endAngle:     .pi, clockwise: false)
            enemyPathUp.addArc(withCenter: arc1, radius: rect.width / 2, startAngle:   0, endAngle:     .pi, clockwise: false)
            
        }
        
        enemyPathUp.apply(CGAffineTransform(scaleX: 1, y: -1))
        enemyPathUp.apply(CGAffineTransform(translationX: 0, y: 2400))
        
        for i in 0...14 {
            
            let moveEnemyDown = SKAction.follow(enemyPathDown.cgPath, asOffset: false, orientToPath: false, speed: 600)
            
            moveEnemyDown.timingFunction = {
                
                time in
                
                return min(time - 0.00135 * Float(i), 1)
                
            }
            
            enemy.append(SKSpriteNode(imageNamed: "enemyShip"))

            enemyPhysics(i: i)
            
            addChild(enemy[i])
            
            enemy[i].run(moveEnemyDown)
            
        }

        for i in 15...29 {
            
            let moveEnemyUp = SKAction.follow(enemyPathUp.cgPath, asOffset: false, orientToPath: false, speed: 600)
            
            moveEnemyUp.timingFunction = {
                
                time in
                
                return min(time - 0.00135 * Float(i), 1)
                
            }
            
            enemy.append(SKSpriteNode(imageNamed: "enemyShip"))

            enemyPhysics(i: i)
            
            addChild(enemy[i])
            
            enemy[i].run(moveEnemyUp)
            
        }
        
    }
    
    
    // Four Quarter Circles
    func wave0025() {
        
        let enemyPathTopRight = UIBezierPath()
        let enemyPathTopLeft = UIBezierPath()
        let enemyPathBottomRight = UIBezierPath()
        let enemyPathBottomLeft = UIBezierPath()
        
        var rect = CGRect()
        
        let radius = 400.0
        let enemyTime: Float = 0.002
        
        rect.size.width = 800
        rect.size.height = 800
        rect.origin.x = (size.width / 2) - (rect.size.width / 2)
        rect.origin.y = 900
        
        let topRight    = CGPoint(x: rect.midX + rect.width * 1/16, y: rect.midY + rect.height * 1/16)
        let topLeft     = CGPoint(x: rect.midX - rect.width * 1/16, y: rect.midY + rect.height * 1/16)
        let bottomRight = CGPoint(x: rect.midX - rect.width * 1/16, y: rect.midY - rect.height * 1/16)
        let bottomLeft  = CGPoint(x: rect.midX + rect.width * 1/16, y: rect.midY - rect.height * 1/16)
        
        rect.origin.y = rect.height / 2
        
        enemyPathTopRight.move(to: CGPoint(x: 2200, y: 2200))
        enemyPathTopLeft.move(to: CGPoint(x: 2200, y: 2200))
        enemyPathBottomRight.move(to: CGPoint(x: 2200, y: 2200))
        enemyPathBottomLeft.move(to: CGPoint(x: 2200, y: 2200))
        
        for _ in 1...50 {
            
            // Top Right
            enemyPathTopRight.addLine(to: topRight)
            enemyPathTopRight.addArc(withCenter: topRight, radius: radius, startAngle: 0, endAngle: .pi / 2, clockwise: true)
            enemyPathTopRight.addLine(to: topRight)
            // Top Left
            enemyPathTopLeft.addLine(to: topLeft)
            enemyPathTopLeft.addArc(withCenter: topLeft, radius: radius, startAngle: .pi / 2, endAngle: .pi, clockwise: true)
            enemyPathTopLeft.addLine(to: topLeft)
            // Bottom Right
            enemyPathBottomRight.addLine(to: bottomRight)
            enemyPathBottomRight.addArc(withCenter: bottomRight, radius: radius, startAngle: .pi, endAngle: .pi * 3/2, clockwise: true)
            enemyPathBottomRight.addLine(to: bottomRight)
            // Bottom Left
            enemyPathBottomLeft.addLine(to: bottomLeft)
            enemyPathBottomLeft.addArc(withCenter: bottomLeft, radius: radius, startAngle: .pi * 3/2, endAngle: .pi * 2, clockwise: true)
            enemyPathBottomLeft.addLine(to: bottomLeft)
            
        }
        
        for i in 0...10 {
            
            let moveEnemyTopRight = SKAction.follow(enemyPathTopRight.cgPath, asOffset: false, orientToPath: false, speed: 600)
            
            moveEnemyTopRight.timingFunction = {
                
                time in
                
                return min(time - enemyTime * Float(i), 1)
                
            }
            
            enemy.append(SKSpriteNode(imageNamed: "enemyShip"))

            enemyPhysics(i: i)
            
            addChild(enemy[i])
            
            enemy[i].run(moveEnemyTopRight)
            
        }

        for i in 11...20 {
            
            let moveEnemyTopLeft = SKAction.follow(enemyPathTopLeft.cgPath, asOffset: false, orientToPath: false, speed: 600)
            
            moveEnemyTopLeft.timingFunction = {
                
                time in
                
                return min(time - enemyTime * Float(i), 1)
                
            }
            
            enemy.append(SKSpriteNode(imageNamed: "enemyShip"))

            enemyPhysics(i: i)
            
            addChild(enemy[i])
            
            enemy[i].run(moveEnemyTopLeft)
            
        }
        
        for i in 21...30 {
            
            let moveEnemyBottomRight = SKAction.follow(enemyPathBottomRight.cgPath, asOffset: false, orientToPath: false, speed: 600)
            
            moveEnemyBottomRight.timingFunction = {
                
                time in
                
                return min(time - enemyTime * Float(i), 1)
                
            }
            
            enemy.append(SKSpriteNode(imageNamed: "enemyShip"))

            enemyPhysics(i: i)
            
            addChild(enemy[i])
            
            enemy[i].run(moveEnemyBottomRight)
            
        }

        for i in 31...40 {
            
            let moveEnemyBottomLeft = SKAction.follow(enemyPathBottomLeft.cgPath, asOffset: false, orientToPath: false, speed: 600)
            
            moveEnemyBottomLeft.timingFunction = {
                
                time in
                
                return min(time - enemyTime * Float(i), 1)
                
            }
            
            enemy.append(SKSpriteNode(imageNamed: "enemyShip"))

            enemyPhysics(i: i)
            
            addChild(enemy[i])
            
            enemy[i].run(moveEnemyBottomLeft)
            
        }
        
    }
    
    
    // ---------------- Level 2-1 ---------------
    
    // Hour Glass
    func wave0026() {
        
        let enemyPath = UIBezierPath()
        
        var rect = CGRect()
        
        rect.size.width = 800
        rect.size.height = 800
        rect.origin.x = size.width / 2 - 400
        rect.origin.y = 900
        
        enemyPath.move(to: CGPoint(x: 0, y: 1800))
        
        enemyPath.addLine(to: CGPoint(x: rect.minX, y: rect.maxY))
        
        for _ in 1...50 {

            enemyPath.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY))
            enemyPath.addLine(to: CGPoint(x: rect.minX, y: rect.minY))
            enemyPath.addLine(to: CGPoint(x: rect.maxX, y: rect.minY))
            enemyPath.addLine(to: CGPoint(x: rect.minX, y: rect.maxY))
    
        }
        
        
        for i in 0...25 {
            
            let moveEnemy = SKAction.follow(enemyPath.cgPath, asOffset: false, orientToPath: false, speed: 600)
            
            
            moveEnemy.timingFunction = {
                
                time in
                
                return min(time - 0.00077 * Float(i), 1)
                
            }
            
            enemy.append(SKSpriteNode(imageNamed: "enemyShip"))

            enemyPhysics(i: i)
            
            addChild(enemy[i])
            
            enemy[i].run(moveEnemy)
            
        }
        
    }
    
    
    // Tear Drop
    func wave0027() {
        
        let enemyPath = UIBezierPath()
        
        var rect = CGRect()
        
        rect.size.width = 800
        rect.size.height = 800
        rect.origin.x = size.width / 2 - 400
        rect.origin.y = 900
        
        let pathToA = CGPoint(x: rect.maxX, y: rect.midY)
        let pathCnA = CGPoint(x: rect.midX, y: rect.midY)
        let pathToB = CGPoint(x: rect.midX, y: rect.minY)
        let pathCnB = CGPoint(x: rect.maxX, y: rect.minY)
        let pathToC = CGPoint(x: rect.minX, y: rect.midY)
        let pathCnC = CGPoint(x: rect.minX, y: rect.minY)
        let pathToD = CGPoint(x: rect.midX, y: rect.maxY)
        let pathCnD = CGPoint(x: rect.midX, y: rect.midY)
        
        enemyPath.move(to: CGPoint(x: 0, y: 1800))
        
        enemyPath.addLine(to: CGPoint(x: rect.midX, y: rect.maxY))
        
        for _ in 1...50 {

            enemyPath.addQuadCurve(to: pathToA, controlPoint: pathCnA)
            enemyPath.addQuadCurve(to: pathToB, controlPoint: pathCnB)
            enemyPath.addQuadCurve(to: pathToC, controlPoint: pathCnC)
            enemyPath.addQuadCurve(to: pathToD, controlPoint: pathCnD)
        }
        
        
        for i in 0...22 {
            
            let moveEnemy = SKAction.follow(enemyPath.cgPath, asOffset: false, orientToPath: false, speed: 600)
            
            
            moveEnemy.timingFunction = {
                
                time in
                
                return min(time - 0.0009 * Float(i), 1)
                
            }
            
            enemy.append(SKSpriteNode(imageNamed: "enemyShip"))

            enemyPhysics(i: i)
            
            addChild(enemy[i])
            
            enemy[i].run(moveEnemy)
            
        }
        
    }
    
    
    // Pyramid
    func wave0028() {
        
        let enemyPath = UIBezierPath()
        
        var rect = CGRect()
        
        rect.size.width = 800
        rect.size.height = 800
        rect.origin.x = size.width / 2 - 400
        rect.origin.y = 900
        
        enemyPath.move(to: CGPoint(x: 0, y: 1800))
        
        enemyPath.addLine(to: CGPoint(x: rect.midX, y: rect.maxY))
        
        for _ in 1...50 {

            enemyPath.addLine(to: CGPoint(x: rect.maxX, y: rect.minY + rect.height * 1/8))
            enemyPath.addLine(to: CGPoint(x: rect.midX, y: rect.minY                    ))
            enemyPath.addLine(to: CGPoint(x: rect.minX, y: rect.minY + rect.height * 1/8))
            enemyPath.addLine(to: CGPoint(x: rect.midX, y: rect.maxY                    ))
        }
        
        
        for i in 0...22 {
            
            let moveEnemy = SKAction.follow(enemyPath.cgPath, asOffset: false, orientToPath: false, speed: 600)
            
            
            moveEnemy.timingFunction = {
                
                time in
                
                return min(time - 0.0009 * Float(i), 1)
                
            }
            
            enemy.append(SKSpriteNode(imageNamed: "enemyShip"))

            enemyPhysics(i: i)
            
            addChild(enemy[i])
            
            enemy[i].run(moveEnemy)
            
        }
        
    }
    
    
    // Diamond
    func wave0029() {
        
        let enemyPath = UIBezierPath()
        
        var rect = CGRect()
        
        rect.size.width = 800
        rect.size.height = 800
        rect.origin.x = size.width / 2 - 400
        rect.origin.y = 900
        
        enemyPath.move(to: CGPoint(x: 0, y: 1800))
        
        enemyPath.addLine(to: CGPoint(x: rect.midX - rect.width * 1/8, y: rect.maxY))
        
        for _ in 1...50 {

            enemyPath.addLine(to: CGPoint(x: rect.midX + rect.width * 1/8, y: rect.maxY                    )) // Line A
            enemyPath.addLine(to: CGPoint(x: rect.maxX                   , y: rect.midY + rect.height * 2/8)) // Line B
            enemyPath.addLine(to: CGPoint(x: rect.midX                   , y: rect.minY                    )) // Line C
            enemyPath.addLine(to: CGPoint(x: rect.minX                   , y: rect.midY + rect.height * 2/8)) // Line D
            enemyPath.addLine(to: CGPoint(x: rect.midX - rect.width * 1/8, y: rect.maxY                    )) // Line E
        }
        
        
        for i in 0...22 {
            
            let moveEnemy = SKAction.follow(enemyPath.cgPath, asOffset: false, orientToPath: false, speed: 600)
            
            
            moveEnemy.timingFunction = {
                
                time in
                
                return min(time - 0.0009 * Float(i), 1)
                
            }
            
            enemy.append(SKSpriteNode(imageNamed: "enemyShip"))

            enemyPhysics(i: i)
            
            addChild(enemy[i])
            
            enemy[i].run(moveEnemy)
            
        }
        
    }
    
    
    // Logic Gate
    func wave0030() {
        
        let enemyPath = UIBezierPath()
        
        var rect = CGRect()
        
        rect.size.width = 800
        rect.size.height = 800
        rect.origin.x = size.width / 2 - 400
        rect.origin.y = 900
        
        let pathToA = CGPoint(x: rect.maxX, y: rect.maxY)
        let pathCnA = CGPoint(x: rect.midX, y: rect.maxY - rect.height * 3/8)
        let pathToB = CGPoint(x: rect.midX, y: rect.minY)
        let pathCnB = CGPoint(x: rect.maxX, y: rect.minY)
        let pathToC = CGPoint(x: rect.minX, y: rect.maxY)
        let pathCnC = CGPoint(x: rect.minX, y: rect.minY)
        
        enemyPath.move(to: CGPoint(x: 0, y: 1800))
        
        enemyPath.addLine(to: CGPoint(x: rect.minX, y: rect.maxY))
        
        for _ in 1...50 {

            enemyPath.addQuadCurve(to: pathToA, controlPoint: pathCnA)
            enemyPath.addQuadCurve(to: pathToB, controlPoint: pathCnB)
            enemyPath.addQuadCurve(to: pathToC, controlPoint: pathCnC)
        }
        
        
        for i in 0...22 {
            
            let moveEnemy = SKAction.follow(enemyPath.cgPath, asOffset: false, orientToPath: false, speed: 600)
            
            
            moveEnemy.timingFunction = {
                
                time in
                
                return min(time - 0.0009 * Float(i), 1)
                
            }
            
            enemy.append(SKSpriteNode(imageNamed: "enemyShip"))

            enemyPhysics(i: i)
            
            addChild(enemy[i])
            
            enemy[i].run(moveEnemy)
            
        }
        
    }
    
    // ------- Level 2-2 ---------
    
    // Square with Curved Corners
    func wave0031() {
        
        let enemyPath = UIBezierPath()
        
        var rect = CGRect()
        
        rect.size.width = 800
        rect.size.height = 800
        rect.origin.x = size.width / 2 - 400
        rect.origin.y = 900
        
        let curveToB = CGPoint(x: rect.maxX                   , y: rect.maxY - rect.height * 2/8)
        let curveCnB = CGPoint(x: rect.maxX - rect.width * 2/8, y: rect.maxY - rect.height * 2/8)
        let curveToD = CGPoint(x: rect.maxX - rect.width * 2/8, y: rect.minY)
        let curveCnD = CGPoint(x: rect.maxX - rect.width * 2/8, y: rect.minY + rect.height * 2/8)
        let curveToF = CGPoint(x: rect.minX                   , y: rect.minY + rect.height * 2/8)
        let curveCnF = CGPoint(x: rect.minX + rect.width * 2/8, y: rect.minY + rect.height * 2/8)
        let curveToH = CGPoint(x: rect.minX + rect.width * 2/8, y: rect.maxY)
        let curveCnH = CGPoint(x: rect.minX + rect.width * 2/8, y: rect.maxY - rect.height * 2/8)
        
        enemyPath.move(to: CGPoint(x: 0, y: 1800))
        
        enemyPath.addLine(to: CGPoint(x: rect.minX + rect.width * 2/8, y: rect.maxY))
        
        for _ in 1...50 {

            enemyPath.addLine(to: CGPoint(x: rect.midX + rect.width * 2/8, y: rect.maxY)) // Seg A
            enemyPath.addQuadCurve(to: curveToB, controlPoint: curveCnB)                      //Seg B
            enemyPath.addLine(to: CGPoint(x: rect.maxX, y: rect.minY + rect.height * 2/8)) // Seg C
            enemyPath.addQuadCurve(to: curveToD, controlPoint: curveCnD)                     //Seg D
            enemyPath.addLine(to: CGPoint(x: rect.minX + rect.width * 2/8, y: rect.minY)) // Seg E
            enemyPath.addQuadCurve(to: curveToF, controlPoint: curveCnF)                      // Seg F
            enemyPath.addLine(to: CGPoint(x: rect.minX, y: rect.maxY - rect.width * 2/8)) // Seg G
            enemyPath.addQuadCurve(to: curveToH, controlPoint: curveCnH)                     // Seg H
            
        }
        
        
        for i in 0...22 {
            
            let moveEnemy = SKAction.follow(enemyPath.cgPath, asOffset: false, orientToPath: false, speed: 600)
            
            
            moveEnemy.timingFunction = {
                
                time in
                
                return min(time - 0.0009 * Float(i), 1)
                
            }
            
            enemy.append(SKSpriteNode(imageNamed: "enemyShip"))

            enemyPhysics(i: i)
            
            addChild(enemy[i])
            
            enemy[i].run(moveEnemy)
            
        }
        
    }
    
    
    // Rectangle with Rounded Side
    func wave0032() {
        
        let enemyPath = UIBezierPath()
        
        var rect = CGRect()
        
        rect.size.width = 800
        rect.size.height = 800
        rect.origin.x = size.width / 2 - 400
        rect.origin.y = 900
        
        let curveToC = CGPoint(x: rect.minX                   , y: rect.minY + rect.height * 3/8)
        let curveCnC = CGPoint(x: rect.midX                   , y: rect.minY - rect.height * 3/8)
        
        enemyPath.move(to: CGPoint(x: 0, y: 1800))
        
        enemyPath.addLine(to: CGPoint(x: rect.minX, y: rect.maxY))
        
        for _ in 1...50 {

            enemyPath.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY)) // Seg A
            enemyPath.addLine(to: CGPoint(x: rect.maxX, y: rect.midY -  rect.height * 1/8)) // Seg B
            enemyPath.addQuadCurve(to: curveToC, controlPoint: curveCnC) // Seg C
            enemyPath.addLine(to: CGPoint(x: rect.minX, y: rect.maxY)) // Seg D
            
        }
        
        
        for i in 0...22 {
            
            let moveEnemy = SKAction.follow(enemyPath.cgPath, asOffset: false, orientToPath: false, speed: 600)
            
            
            moveEnemy.timingFunction = {
                
                time in
                
                return min(time - 0.0009 * Float(i), 1)
                
            }
            
            enemy.append(SKSpriteNode(imageNamed: "enemyShip"))

            enemyPhysics(i: i)
            
            addChild(enemy[i])
            
            enemy[i].run(moveEnemy)
            
        }
        
    }
    
    
    // 270 Degree Circle
    func wave0033() {
        
        let enemyPath = UIBezierPath()
        
        var rect = CGRect()
        
        rect.size.width = 800
        rect.size.height = 800
        rect.origin.x = size.width / 2 - 400
        rect.origin.y = 900
        
        let radius = rect.width / 2

        let curveToC = CGPoint(x: rect.midX, y: rect.midY)
        
        enemyPath.move(to: CGPoint(x: 1800, y: 1200))
        
        for _ in 1...50 {

            enemyPath.addArc(withCenter: curveToC, radius: radius, startAngle: 0, endAngle: .pi * 3/2, clockwise: true)
            enemyPath.addLine(to: CGPoint(x: rect.midX, y: rect.midY))
            
        }
        
        let x = rect.midX
        let y = rect.midY
        let transform = CGAffineTransform(translationX: x, y: y).rotated(by: .pi / 4).translatedBy(x: -x, y: -y)
        
        enemyPath.apply(transform)
        
        for i in 0...22 {
            
            let moveEnemy = SKAction.follow(enemyPath.cgPath, asOffset: false, orientToPath: false, speed: 600)
            
            
            moveEnemy.timingFunction = {
                
                time in
                
                return min(time - 0.0009 * Float(i), 1)
                
            }
            
            enemy.append(SKSpriteNode(imageNamed: "enemyShip"))

            enemyPhysics(i: i)
            
            addChild(enemy[i])
            
            enemy[i].run(moveEnemy)
            
        }
        
    }
    
    
    // Compass Arrow
    func wave0034() {
        
        let enemyPath = UIBezierPath()
        
        var rect = CGRect()
        
        rect.size.width = 800
        rect.size.height = 800
        rect.origin.x = size.width / 2 - 400
        rect.origin.y = 900
        
        enemyPath.move(to: CGPoint(x: 0, y: 600))
        
        enemyPath.addLine(to: CGPoint(x: rect.minX, y: rect.maxY))
        
        for _ in 1...50 {

            enemyPath.addLine(to: CGPoint(x: rect.midX, y: rect.midY + rect.height * 2/8)) // Seg A
            enemyPath.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY))                      // Seg B
            enemyPath.addLine(to: CGPoint(x: rect.midX, y: rect.minY))                      // Seg C
            enemyPath.addLine(to: CGPoint(x: rect.minX, y: rect.maxY))                       // Seg D
            
        }
        
        let x = rect.midX
        let y = rect.midY
        let transform = CGAffineTransform(translationX: x, y: y).rotated(by: .pi * 3/4).translatedBy(x: -x, y: -y)
        
        enemyPath.apply(transform)
        
        for i in 0...22 {
            
            let moveEnemy = SKAction.follow(enemyPath.cgPath, asOffset: false, orientToPath: false, speed: 600)
            
            
            moveEnemy.timingFunction = {
                
                time in
                
                return min(time - 0.0009 * Float(i), 1)
                
            }
            
            enemy.append(SKSpriteNode(imageNamed: "enemyShip"))

            enemyPhysics(i: i)
            
            addChild(enemy[i])
            
            enemy[i].run(moveEnemy)
            
        }
        
    }
    
    
    // Check Mark
    func wave0035() {
        
        let enemyPath = UIBezierPath()
        
        var rect = CGRect()
        
        rect.size.width = 800
        rect.size.height = 800
        rect.origin.x = size.width / 2 - 400
        rect.origin.y = 900
        
        enemyPath.move(to: CGPoint(x: 0, y: 600))
        
        enemyPath.addLine(to: CGPoint(x: rect.minX, y: rect.midY))
        
        for _ in 1...50 {

            enemyPath.addLine(to: CGPoint(x: rect.minX + rect.width * 2/8,  y: rect.midY))                        // Seg A
            enemyPath.addLine(to: CGPoint(x: rect.midX - rect.width * 1/16, y: rect.midY - rect.height * 3/16))   // Seg B
            enemyPath.addLine(to: CGPoint(x: rect.maxX - rect.width * 2/8 , y: rect.maxY))                        // Seg C
            enemyPath.addLine(to: CGPoint(x: rect.maxX                    , y: rect.maxY))                        // Seg D
            enemyPath.addLine(to: CGPoint(x: rect.midX                    , y: rect.minY))                        // Seg E
            enemyPath.addLine(to: CGPoint(x: rect.minX                    , y: rect.midY))                        // Seg F

        }
        
        for i in 0...22 {
            
            let moveEnemy = SKAction.follow(enemyPath.cgPath, asOffset: false, orientToPath: false, speed: 600)
            
            
            moveEnemy.timingFunction = {
                
                time in
                
                return min(time - 0.0009 * Float(i), 1)
                
            }
            
            enemy.append(SKSpriteNode(imageNamed: "enemyShip"))

            enemyPhysics(i: i)
            
            addChild(enemy[i])
            
            enemy[i].run(moveEnemy)
            
        }
        
    }
    
    // --------- Level 2-3 ------------
    
    // Rotating Compass Arrow
    func wave0036() {
        
        let enemyPath = UIBezierPath()
        
        var rect = CGRect()
        
        rect.size.width = 800
        rect.size.height = 800
        rect.origin.x = size.width / 2 - 400
        rect.origin.y = 900
        
        enemyPath.move(to: CGPoint(x: 0, y: 0))
        
        enemyPath.addLine(to: CGPoint(x: rect.minX, y: rect.maxY))
        
        for _ in 1...25 {
            
            for _ in 1...2 {
                
                enemyPath.addLine(to: CGPoint(x: rect.midX, y: rect.midY + rect.height * 2/8))  // Seg A
                enemyPath.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY))                      // Seg B
                enemyPath.addLine(to: CGPoint(x: rect.midX, y: rect.minY))                      // Seg C
                enemyPath.addLine(to: CGPoint(x: rect.minX, y: rect.maxY))                      // Seg D

            }
            
            let x = rect.midX
            let y = rect.midY
            let transform = CGAffineTransform(translationX: x, y: y).rotated(by: .pi / 2).translatedBy(x: -x, y: -y)
            
            enemyPath.apply(transform)
            
        }
        
        for i in 0...22 {
            
            let moveEnemy = SKAction.follow(enemyPath.cgPath, asOffset: false, orientToPath: false, speed: 600)
            
            
            moveEnemy.timingFunction = {
                
                time in
                
                return min(time - 0.0009 * Float(i), 1)
                
            }
            
            enemy.append(SKSpriteNode(imageNamed: "enemyShip"))

            enemyPhysics(i: i)
            
            addChild(enemy[i])
            
            enemy[i].run(moveEnemy)
            
        }
        
    }
    
    
    // Marker
    func wave0037() {
        
        let enemyPath = UIBezierPath()
        
        var rect = CGRect()
        
        rect.size.width = 800
        rect.size.height = 800
        rect.origin.x = size.width / 2 - 400
        rect.origin.y = 900
        
        enemyPath.move(to: CGPoint(x: 0, y: 600))
        
        enemyPath.addLine(to: CGPoint(x: rect.minX, y: rect.maxY))
        
        for _ in 1...50 {

            enemyPath.addLine(to: CGPoint(x: rect.midX, y: rect.midY + rect.height * 2/8)) // Seg A
            enemyPath.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY))                     // Seg B
            enemyPath.addLine(to: CGPoint(x: rect.maxX, y: rect.minY + rect.height * 2/8)) // Seg C
            enemyPath.addLine(to: CGPoint(x: rect.midX, y: rect.minY))                     // Seg D
            enemyPath.addLine(to: CGPoint(x: rect.minX, y: rect.minY + rect.height * 2/8)) // Seg E
            enemyPath.addLine(to: CGPoint(x: rect.minX, y: rect.maxY))                     // Seg F
        }
        
        for i in 0...22 {
            
            let moveEnemy = SKAction.follow(enemyPath.cgPath, asOffset: false, orientToPath: false, speed: 600)
            
            
            moveEnemy.timingFunction = {
                
                time in
                
                return min(time - 0.0009 * Float(i), 1)
                
            }
            
            enemy.append(SKSpriteNode(imageNamed: "enemyShip"))

            enemyPhysics(i: i)
            
            addChild(enemy[i])
            
            enemy[i].run(moveEnemy)
            
        }
        
    }
    
    
    // Square with Curved Sides
    func wave0038() {
        
        let enemyPath = UIBezierPath()
        
        var rect = CGRect()
        
        rect.size.width = 800
        rect.size.height = 800
        rect.origin.x = size.width / 2 - 400
        rect.origin.y = 900
        
        let pathToA = CGPoint(x: rect.maxX, y: rect.maxY)
        let pathCnA = CGPoint(x: rect.midX, y: rect.midY)
        let pathToB = CGPoint(x: rect.maxX, y: rect.minY)
        let pathCnB = CGPoint(x: rect.midX, y: rect.midY)
        let pathToC = CGPoint(x: rect.minX, y: rect.minY)
        let pathCnC = CGPoint(x: rect.midX, y: rect.midY)
        let pathToD = CGPoint(x: rect.minX, y: rect.maxY)
        let pathCnD = CGPoint(x: rect.midX, y: rect.midY)
        
        enemyPath.move(to: CGPoint(x: 0, y: 600))
        
        enemyPath.addLine(to: CGPoint(x: rect.minX, y: rect.maxY))
        
        for _ in 1...50 {

            enemyPath.addQuadCurve(to: pathToA, controlPoint: pathCnA)
            enemyPath.addQuadCurve(to: pathToB, controlPoint: pathCnB)
            enemyPath.addQuadCurve(to: pathToC, controlPoint: pathCnC)
            enemyPath.addQuadCurve(to: pathToD, controlPoint: pathCnD)
        }
        
        for i in 0...22 {
            
            let moveEnemy = SKAction.follow(enemyPath.cgPath, asOffset: false, orientToPath: false, speed: 600)
            
            
            moveEnemy.timingFunction = {
                
                time in
                
                return min(time - 0.0009 * Float(i), 1)
                
            }
            
            enemy.append(SKSpriteNode(imageNamed: "enemyShip"))

            enemyPhysics(i: i)
            
            addChild(enemy[i])
            
            enemy[i].run(moveEnemy)
            
        }
        
    }
    
    
    
    func wave0039() {
        
        
        
    }
    
    
    
    func wave0040() {}
    
    // -------- Level 2-4 --------
    
    
    func wave0041() {}
    
    
    
    func wave0042() {}
    
    
    
    func wave0043() {}
    
    
    
    func wave0044() {}
    
    
    
    func wave0045() {}
    
    // ---------- Level 2-5 ---------
    
    
    func wave0046() {}
    
    
    
    func wave0047() {}
    
    
    
    func wave0048() {}
    
    
    
    func wave0049() {}
    
    
    
    func wave0050() {}
    
    
    // ------------- Level 3-1 -------------------
    
    
    func wave0051() {}
    
    
    
    func wave0052() {}

    
    
    func wave0053 (){}
     
    
    
    func wave0054(){}
    
    
    
    func wave0055(){}
    
    // ------ Level 3-2 -------
    
    
    func wave0056() {}
   
    
    
    func wave0057() {}
    
    
    
    func wave0058() {}
    
    
    
    func wave0059() {}
    
    
    
    func wave0060() {}
    
    // ------- Level 3-3 -------
    
    
    func wave0061() {}
    
    
    
    func wave0062() {}
    
    
    
    func wave0063() {}
    
    
    // Cross
    func wave0064() {}
    
    
    
    func wave0065() {}
    
    // ------ Level 3-4 ------
    
    
    func wave0066() {}
    
    
    
    func wave0067() {}
    
    
    
    func wave0068() {}
    
    
    
    func wave0069() {}
    
    
    
    func wave0070() {}
    
    // --------- Level 3-5 --------
    
    
    func wave0071() {}
    
    
    
    func wave0072() {}
    
    
    
    func wave0073() {}
    
    
    
    func wave0074() {}
    
    
    
    func wave0075() {}
    
    
    // ---------------- Level 4-1 ---------------
    
    
    func wave0076() {}
    
    
    
    func wave0077() {}
    
    
    
    func wave0078() {}
    
    
    
    func wave0079() {}
    
    
    
    func wave0080() {}
    
    // ------- Level 4-2 ---------
    
    
    func wave0081() {}
    
    
    
    func wave0082() {}
    
    
    
    func wave0083() {}
    
    
    
    func wave0084() {}
    
    
    
    func wave0085() {}
    
    // --------- Level 4-3 ------------
    
    
    func wave0086() {}
    
    
    
    func wave0087() {}
    
    
    
    func wave0088() {}
    
    
    
    func wave0089() {}
    
    
    
    func wave0090() {}
    
    // -------- Level 4-4 --------
    
    
    func wave0091() {}
    
    
    
    func wave0092() {}
    
    
    
    func wave0093() {}
    
    
    
    func wave0094() {}
    
    
    
    func wave0095() {}
    
    // ---------- Level 4-5 ---------
    
    
    func wave0096() {}
    
    
    
    func wave0097() {}
    
    
    
    func wave0098() {}
    
    
    
    func wave0099() {}
    
    
    
    func wave0100() {}
    
    
    // ------------ Level 5-1-----------------
    
    
    func wave0101() {}
    
    
    
    func wave0102() {}
    
    
    
    func wave0103() {}
    
    
    
    func wave0104() {}
    
    
    
    func wave0105() {}
    
    // ------- Level 5-2 ---------
    
    
    func wave0106() {}
    
    
    
    func wave0107() {}
    
    
    
    func wave0108() {}
    
    
    
    func wave0109() {}
    
    
    
    func wave0110() {}
    
    // --------- Level 5-3 ------------
    
    
    func wave0111() {}
    
    
    
    func wave0112() {}
    
    
    
    func wave0113() {}
    
    
    
    func wave0114() {}
    
    
    
    func wave0115() {}
    
    // -------- Level 5-4 --------
    
    
    func wave0116() {}
    
    
    
    func wave0117() {}
    
    
    
    func wave0118() {}
    
    
    
    func wave0119() {}
    
    
    
    func wave0120() {}
    
    // ---------- Level 4-5 ---------
    
    
    func wave0121() {}
    
    
    
    func wave0122() {}
    
    
    
    func wave0123() {}
    
    
    
    func wave0124() {}
    
    
    
    func wave0125() {}
}


