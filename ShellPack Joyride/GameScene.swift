//
//  GameScene.swift
//  ShellPack Joyride
//
//  Created by Nicos Fabro on 25/4/18.
//  Copyright © 2018 Nicos Fabro. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    var timer = Timer()
    
    var koopa = SKSpriteNode()
    var bg = SKSpriteNode()
    var coin = SKSpriteNode()
    let lblScore = SKLabelNode(fontNamed: "AvenirNext-Bold")
    
    let texturesKoopaFly = [
        SKTexture(imageNamed: "koopa-fly1.png"),
        SKTexture(imageNamed: "koopa-fly2.png"),
        SKTexture(imageNamed: "koopa-fly3.png"),
        SKTexture(imageNamed: "koopa-fly4.png"),
        SKTexture(imageNamed: "koopa-fly5.png"),
        SKTexture(imageNamed: "koopa-fly6.png"),
        SKTexture(imageNamed: "koopa-fly7.png"),
        SKTexture(imageNamed: "koopa-fly8.png"),
        SKTexture(imageNamed: "koopa-fly9.png")
    ]
    
    let texturesKoopaWalk = [
        SKTexture(imageNamed: "koopa-walk1.png"),
        SKTexture(imageNamed: "koopa-walk2.png"),
        SKTexture(imageNamed: "koopa-walk3.png"),
        SKTexture(imageNamed: "koopa-walk4.png"),
        SKTexture(imageNamed: "koopa-walk5.png"),
        SKTexture(imageNamed: "koopa-walk6.png"),
        SKTexture(imageNamed: "koopa-walk7.png"),
        SKTexture(imageNamed: "koopa-walk8.png")
    ]
    
    let texturasKoopaNaked = [
        SKTexture(imageNamed: "koopa-naked1.png"),
        SKTexture(imageNamed: "koopa-naked2.png"),
        SKTexture(imageNamed: "koopa-naked3.png"),
        SKTexture(imageNamed: "koopa-naked4.png"),
        SKTexture(imageNamed: "koopa-naked5.png"),
        SKTexture(imageNamed: "koopa-naked6.png"),
        SKTexture(imageNamed: "koopa-naked7.png"),
        SKTexture(imageNamed: "koopa-naked8.png")
    ]
    
    let texturasCoin = [
        SKTexture(imageNamed: "coin1.png"),
        SKTexture(imageNamed: "coin2.png"),
        SKTexture(imageNamed: "coin3.png"),
        SKTexture(imageNamed: "coin4.png"),
        SKTexture(imageNamed: "coin5.png"),
        SKTexture(imageNamed: "coin6.png"),
        SKTexture(imageNamed: "coin7.png"),
        SKTexture(imageNamed: "coin8.png"),
        SKTexture(imageNamed: "coin9.png"),
        SKTexture(imageNamed: "coin10.png"),
        SKTexture(imageNamed: "coin11.png"),
        SKTexture(imageNamed: "coin12.png"),
        SKTexture(imageNamed: "coin13.png"),
        SKTexture(imageNamed: "coin14.png"),
        SKTexture(imageNamed: "coin15.png"),
        SKTexture(imageNamed: "coin16.png"),
        SKTexture(imageNamed: "coin17.png"),
        SKTexture(imageNamed: "coin18.png"),
        SKTexture(imageNamed: "coin19.png"),
        SKTexture(imageNamed: "coin20.png"),
        SKTexture(imageNamed: "coin21.png")
    ]
    
    // Enumeración de los nodos que pueden colisionar
    // se les debe representar con números potencia de 2
    enum tipoNodo: UInt32 {
        case koopa = 1      // Koopa colisiona
        case limits = 2     // Si choca con el suelo o el techo
        case coin = 0       // Si toca una moneda
    }
    
    var score = 0
    
    override func didMove(to view: SKView) {
        self.physicsWorld.contactDelegate = self
        timer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(self.createCoin), userInfo: nil, repeats: true)
        
        crearKoopa()
        crearBgAnimado()
        createLimits()
        createScoreLabel()
        scene?.scaleMode = SKSceneScaleMode.resizeFill
        
        print("Max Y = \(self.frame.maxY)")
        print("Min Y = \(self.frame.minY)")
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        /*if let label = self.label {
         label.run(SKAction.init(named: "Pulse")!, withKey: "fadeInOut")
         }
         
         for t in touches { self.touchDown(atPoint: t.location(in: self)) }*/
        animateFly()
    }
    
    /*
     override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
     for t in touches { self.touchMoved(toPoint: t.location(in: self)) }
     }
     
     override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
     for t in touches { self.touchUp(atPoint: t.location(in: self)) }
     }
     
     override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
     for t in touches { self.touchUp(atPoint: t.location(in: self)) }
     }
     */
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
//        self.coin.position.x -= 10
        lblScore.text = "Score: \(score)"
        lblScore.position = CGPoint(x: self.frame.maxX - lblScore.frame.width / 2, y: self.frame.maxY - lblScore.frame.height)
    }
    
    // Función para tratar las colisiones o contactos de los nodos
    func didBegin(_ contact: SKPhysicsContact) {
        // en contact tenemos bodyA y bodyB que son los cuerpos que hicieron contacto
        let cuerpoA = contact.bodyA
        let cuerpoB = contact.bodyB
        // Miramos si el koopa toca la moneda
        if (cuerpoA.categoryBitMask == tipoNodo.koopa.rawValue && cuerpoB.categoryBitMask == tipoNodo.coin.rawValue) || (cuerpoA.categoryBitMask == tipoNodo.coin.rawValue && cuerpoB.categoryBitMask == tipoNodo.koopa.rawValue) {
            self.score += 1
            lblScore.text = "Score: \(score)"
            
            if cuerpoA.categoryBitMask == tipoNodo.coin.rawValue {
                cuerpoA.node?.removeFromParent()
            } else {
                cuerpoB.node?.removeFromParent()
            }
        }
    }
    
    func crearKoopa() {
//        Le añadimos una textura inicial al koopa
        self.koopa = SKSpriteNode(texture: texturesKoopaFly[0])
//        Le añadimos cuerpo físico al koopa
        self.koopa.physicsBody = SKPhysicsBody(circleOfRadius: texturesKoopaFly[0].size().height / 2)
        self.koopa.zPosition = 8
        
//        Tendrá gravedad
        self.koopa.physicsBody?.isDynamic = true
        
//        Lo creamos en una posición inicial
        self.koopa.position = CGPoint(x: self.frame.minX - self.frame.minX * 0.1, y: self.frame.midY)
        
//        Le añadimos su categoría
        self.koopa.physicsBody?.categoryBitMask = tipoNodo.koopa.rawValue
        
//        Colisiona con:
        self.koopa.physicsBody?.collisionBitMask = tipoNodo.limits.rawValue
        
//        Hace contacto con:
        self.koopa.physicsBody?.contactTestBitMask = tipoNodo.coin.rawValue
        
        self.addChild(koopa)
    }
    
    func crearBgAnimado() {
        
        bg.position = CGPoint(x: 0.0, y: 0.0)
        bg.zPosition = -1
        
        // Textura para el fondo
        let textureBg = SKTexture(imageNamed: "bg.png")
        
        // Acciones del fondo (para hacer ilusión de movimiento)
        // Desplazamos en el eje de las x cada 0.3s
        let movimientoFondo = SKAction.move(by: CGVector(dx: -textureBg.size().width, dy: 0), duration: 4)
        
        let originalBgMovement = SKAction.move(by: CGVector(dx: textureBg.size().width, dy: 0), duration: 0)
        
        // repetimos hasta el infinito
        let infiniteBgMovement = SKAction.repeatForever(SKAction.sequence([movimientoFondo, originalBgMovement]))
        
        // Necesitamos más de un fondo para que no se vea la pantalla en negro
        // contador de fondos
        var i: CGFloat = 0
        
        while i < 2 {
            // Le ponemos la textura al fondo
            self.bg = SKSpriteNode(texture: textureBg)
            
            // Indicamos la posición inicial del fondo
            self.bg.position = CGPoint(x: textureBg.size().width * i, y: self.frame.midY)
            
            // Estiramos la altura de la imagen para que se adapte al alto de la pantalla
            // bg.size.height = self.frame.height
            
            // Indicamos zPosition para que quede detrás de todo
            self.bg.zPosition = -1
            
            // Aplicamos la acción
            self.bg.run(infiniteBgMovement)
            // Ponemos el fondo en la escena
            self.addChild(bg)
            
            // Incrementamos contador
            i += 1
        }
    }
    
    func createScoreLabel() {
        lblScore.text = "Score: \(score)"
        lblScore.fontSize = 24
        lblScore.fontColor = SKColor.green
        lblScore.zPosition = 10
        self.addChild(lblScore)
    }
    
    @objc func createCoin(position: CGPoint) {
        
        self.coin = SKSpriteNode(texture: texturasCoin[0])
        
        self.coin.physicsBody = SKPhysicsBody(circleOfRadius: texturasCoin[0].size().height / 2)
        let maxY = Int(self.frame.maxY)
        let randY = CGFloat(arc4random_uniform(UInt32(maxY * 2))) + CGFloat(maxY * -1)
        self.coin.position = CGPoint(x: self.frame.maxX, y: randY)
        self.coin.zPosition = 0
        self.coin.setScale(0.5)
        
        self.coin.physicsBody?.isDynamic = false
        
        let coinAnimation = SKAction.animate(with: texturasCoin, timePerFrame: 0.02)
        let coinAnimationForever = SKAction.repeatForever(coinAnimation)
        self.coin.run(coinAnimationForever)
        
        self.coin.physicsBody?.collisionBitMask = 0
        self.coin.physicsBody?.categoryBitMask = tipoNodo.coin.rawValue
        self.coin.physicsBody?.contactTestBitMask = tipoNodo.koopa.rawValue
        
        let moverCoin = SKAction.move(by: CGVector(dx: -3 * self.frame.width, dy: 0), duration: TimeInterval(self.frame.width / 80))
        let borrarCoin = SKAction.removeFromParent()
        let moverBorrarCoin = SKAction.sequence([moverCoin, borrarCoin])
        
        self.coin.run(moverBorrarCoin)
        
        self.addChild(coin)
    }
    
    func createLimits() {
        let ground = SKNode()
        ground.position = CGPoint(x: -self.frame.midX, y: -self.frame.height / 2)
        ground.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: self.frame.width, height: 1))
        // el suelo se tiene que estar quieto
        ground.physicsBody!.isDynamic = false
        
        // Categoría para collision
        ground.physicsBody!.categoryBitMask = tipoNodo.limits.rawValue
        // Colisiona con el koopa
        ground.physicsBody!.collisionBitMask = tipoNodo.koopa.rawValue
        // contacto con el suelo
        ground.physicsBody!.contactTestBitMask = tipoNodo.koopa.rawValue
        
        let roof = SKNode()
        roof.position = CGPoint(x: -self.frame.midX, y: self.frame.height / 2)
        roof.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: self.frame.width, height: 1))
        // el techo se tiene que estar quieto
        roof.physicsBody!.isDynamic = false
        
        // Categoría para collision
        roof.physicsBody!.categoryBitMask = tipoNodo.limits.rawValue
        // Colisiona con el koopa
        roof.physicsBody!.collisionBitMask = tipoNodo.koopa.rawValue
        // contacto con el suelo
        roof.physicsBody!.contactTestBitMask = tipoNodo.koopa.rawValue
        
        self.addChild(ground)
        self.addChild(roof)
    }
    
    func animateFly() {
        self.koopa.physicsBody?.velocity = CGVector(dx: 0, dy: 0)
        self.koopa.physicsBody?.applyImpulse(CGVector(dx: 0, dy: 50))
        let animationFly = SKAction.animate(with: texturesKoopaFly, timePerFrame: 0.05)
        koopa.run(animationFly)
    }
}
