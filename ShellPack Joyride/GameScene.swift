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
    
//    Timers para las monedas y enemigos
    var timerCoins = Timer()
    var timerEnemies = Timer()
    
//    Nodo Koopa
    var koopa = SKSpriteNode()
//    Nodo Background
    var bg = SKSpriteNode()
    
//    Nodos para los labels de "Game Over" y "Score"
    let lblGameOver = SKLabelNode(fontNamed: "AvenirNext-Bold")
    let lblScore = SKLabelNode(fontNamed: "AvenirNext-Bold")
    
//    Nodos de los corazones
    var heart1 = SKSpriteNode()
    var heart2 = SKSpriteNode()
    var heart3 = SKSpriteNode()
    
//    Diferentes tipos de texturas del Koopa
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
    
    let texturesKoopaNaked = [
        SKTexture(imageNamed: "koopa-naked1.png"),
        SKTexture(imageNamed: "koopa-naked2.png"),
        SKTexture(imageNamed: "koopa-naked3.png"),
        SKTexture(imageNamed: "koopa-naked4.png"),
        SKTexture(imageNamed: "koopa-naked5.png"),
        SKTexture(imageNamed: "koopa-naked6.png"),
        SKTexture(imageNamed: "koopa-naked7.png"),
        SKTexture(imageNamed: "koopa-naked8.png")
    ]
    
//    Texturas de la moneda
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
    
//    Texturas de Luigi
    let texturasLuigi = [
        SKTexture(imageNamed: "luigi1.png"),
        SKTexture(imageNamed: "luigi2.png"),
        SKTexture(imageNamed: "luigi3.png"),
        SKTexture(imageNamed: "luigi2.png")
    ]
    
//    Texturas de los corazones
    let texturasHeart = [
        SKTexture(imageNamed: "heart1.png"),    // ON
        SKTexture(imageNamed: "heart2.png")     // OFF
    ]
    
//    Enumeración de los nodos que pueden colisionar
//    se les debe representar con números potencia de 2
    enum tipoNodo: UInt32 {
        case koopa = 1      // Koopa colisiona
        case limits = 2     // Si choca con el suelo o el techo
        case coin = 0       // Si toca una moneda
        case enemy = 4      // Si toca un enemigo
    }
    
//    Variables del juego
    var score = 0
    var hearts = 3
    var gameOver = false
    var enemySpeed = 1.0 // Variable que se usa para aumentar la velocidad de los enemigos
    var isGround = false
    var numJumps = 0
    
//    Se llama al iniciar la aplicación
    override func didMove(to view: SKView) {
        self.physicsWorld.contactDelegate = self // Le decimos que el GameScene se encargará de las físicas
        restart()
    }
    
//    Función para reiniciar (iniciar si es la primera vez) el juego
    func restart() {
//        Inicialización de los timers
        self.timerCoins = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.createCoin), userInfo: nil, repeats: true)
        self.timerEnemies = Timer.scheduledTimer(timeInterval: 3, target: self, selector: #selector(self.createLuigi), userInfo: nil, repeats: true)
        
//        Creación de los nodos
        createKoopa()
        crearBgAnimado()
        createLimits()
        createScoreLabel()
        createHearts()
        
//        Inicialización de las variables del juego
        self.gameOver = false
        self.score = 0
        self.speed = 1
        self.hearts = 3
        self.removeChildren(in: [lblGameOver])
    }
    
//    Se ejecuta cada vez que se toca la pantalla
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if !gameOver { // Si el juego no ha acabado
            if self.hearts == 3 {
                fly()
            } else {
                jump()
            }
        } else { // Si el juego ha acabado
            self.removeAllChildren() // Se eliminan los nodos child del parent
            restart()
        }
    }
    
//    Función que se llama por cada frame
    override func update(_ currentTime: TimeInterval) {
        
        if self.hearts == 0 && self.speed == 1 {
            createGameOverLabel()
            self.gameOver = true
            self.timerCoins.invalidate()
            self.timerEnemies.invalidate()
        }
    }
    
    func createGameOverLabel() {
        self.lblGameOver.text = "Game Over"
        self.lblGameOver.fontSize = 30
        self.lblGameOver.fontColor = SKColor.red
        self.lblGameOver.zPosition = 10
        self.lblGameOver.position = CGPoint(x: self.frame.midX, y: self.frame.midY)
        self.addChild(lblGameOver)
        self.speed = 0
    }
    
//    Función para tratar las colisiones o contactos de los nodos
//    Se llama cada vez que un nodo hace contacto con otro
    func didBegin(_ contact: SKPhysicsContact) {
//        En contact tenemos bodyA y bodyB que son los cuerpos que hicieron contacto
        let cuerpoA = contact.bodyA
        let cuerpoB = contact.bodyB
        
//        Miramos si el koopa toca la moneda
        if (cuerpoA.categoryBitMask == tipoNodo.koopa.rawValue && cuerpoB.categoryBitMask == tipoNodo.coin.rawValue) ||
            (cuerpoA.categoryBitMask == tipoNodo.coin.rawValue && cuerpoB.categoryBitMask == tipoNodo.koopa.rawValue) {
            self.score += 1
            
//            Actualizamos el label Score
            self.lblScore.text = "Score: \(score)"
            self.lblScore.position = CGPoint(x: self.frame.maxX - lblScore.frame.width / 2, y: self.frame.maxY - lblScore.frame.height) // Hacemos que el label se posicione sin que se salga de la pantalla al aumentar un dígito
            
//            Eliminamos el nodo moneda
            if cuerpoA.categoryBitMask == tipoNodo.coin.rawValue {
                cuerpoA.node?.removeFromParent()
            } else {
                cuerpoB.node?.removeFromParent()
            }
        } else if (cuerpoA.categoryBitMask == tipoNodo.koopa.rawValue && cuerpoB.categoryBitMask == tipoNodo.enemy.rawValue) ||
            (cuerpoA.categoryBitMask == tipoNodo.enemy.rawValue && cuerpoB.categoryBitMask == tipoNodo.koopa.rawValue) { // Miramos si el koopa toca un enemigo
            self.hearts -= 1
            
            switch hearts {
            case 2:
                self.heart1.texture = texturasHeart[1]
                koopa2Hearts()
            case 1:
                self.heart2.texture = texturasHeart[1]
                koopa1Heart()
            case 0:
                self.heart3.texture = texturasHeart[1]
            default:
                self.heart1.texture = texturasHeart[1]
                self.heart2.texture = texturasHeart[1]
                self.heart3.texture = texturasHeart[1]
            }
        } else if (cuerpoA.categoryBitMask == tipoNodo.koopa.rawValue && cuerpoB.categoryBitMask == tipoNodo.limits.rawValue) ||
            (cuerpoA.categoryBitMask == tipoNodo.limits.rawValue && cuerpoB.categoryBitMask == tipoNodo.koopa.rawValue) { // Miramos si el koopa toca los límites
//            Reiniciamos el número de saltos y si está en el suelo
            self.isGround = true
            self.numJumps = 0
        }
    }
    
    func createKoopa() {
//        Le añadimos una textura inicial al koopa
        self.koopa = SKSpriteNode(texture: texturesKoopaFly[0])
//        Le añadimos cuerpo físico al koopa
        self.koopa.physicsBody = SKPhysicsBody(circleOfRadius: texturesKoopaFly[0].size().height / 2)
//        Posicionamos el koopa en z=8
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
        self.koopa.physicsBody?.contactTestBitMask = tipoNodo.enemy.rawValue
        
//        Añadimos al Koopa al parent
        self.addChild(koopa)
    }
    
//    Función que se llama cuando el Koopa tiene 2 vidas
//    Le asigna la animación de caminar (con el caparazón)
    func koopa2Hearts() {
        let animationWalk = SKAction.animate(with: texturesKoopaWalk, timePerFrame: 0.05)
        let animationWalkForever = SKAction.repeatForever(animationWalk)
        self.koopa.run(animationWalkForever)
    }
    
//    Función que se llama cuando el Koopa tiene 1 vida
//    Le asigna la animación de caminar (desnudo)
    func koopa1Heart() {
        let animationNaked = SKAction.animate(with: texturesKoopaNaked, timePerFrame: 0.05)
        let animationNakedForever = SKAction.repeatForever(animationNaked)
        self.koopa.run(animationNakedForever)
    }
    
    func crearBgAnimado() {
        
        bg.position = CGPoint(x: 0.0, y: 0.0)
        bg.zPosition = -1
        
//        Textura para el fondo
        let textureBg = SKTexture(imageNamed: "bg.png")
        
//        Movimiento del fondo
//        Desplazamos en el eje de las x cada 4
        let movimientoFondo = SKAction.move(by: CGVector(dx: -textureBg.size().width, dy: 0), duration: 4)
        
        let originalBgMovement = SKAction.move(by: CGVector(dx: textureBg.size().width, dy: 0), duration: 0)
        
//        Repetimos la animación para siempre
        let infiniteBgMovement = SKAction.repeatForever(SKAction.sequence([movimientoFondo, originalBgMovement]))
        
//        Necesitamos más de un fondo para que no se vea la pantalla en negro
//        Contador de fondos
        var i: CGFloat = 0
        
        while i < 2 {
//            Le ponemos la textura al fondo
            self.bg = SKSpriteNode(texture: textureBg)
            
//          Indicamos la posición inicial del fondo
            self.bg.position = CGPoint(x: textureBg.size().width * i, y: self.frame.midY)
            
//            Estiramos la altura de la imagen para que se adapte al alto de la pantalla
//            bg.size.height = self.frame.height
            
//            Indicamos zPosition para que quede detrás de todo
            self.bg.zPosition = -1
            
//            Aplicamos la acción
            self.bg.run(infiniteBgMovement)
//            Ponemos el fondo en la escena
            self.addChild(bg)
            
//            Incrementamos contador
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
    
    func createHearts() {
        self.heart1 = SKSpriteNode(texture: texturasHeart[0])
        self.heart1.zPosition = 2
        self.heart1.physicsBody?.isDynamic = false
        self.heart1.position = CGPoint(x: self.frame.maxX - texturasHeart[0].size().width / 2, y: self.frame.maxY - lblScore.frame.height - texturasHeart[0].size().height)
        self.addChild(heart1)
        
        self.heart2 = SKSpriteNode(texture: texturasHeart[0])
        self.heart2.zPosition = 2
        self.heart2.physicsBody?.isDynamic = false
        self.heart2.position = CGPoint(x: self.frame.maxX - texturasHeart[0].size().width * 1.5, y: self.frame.maxY - lblScore.frame.height - texturasHeart[0].size().height)
        self.addChild(heart2)
        
        self.heart3 = SKSpriteNode(texture: texturasHeart[0])
        self.heart3.zPosition = 2
        self.heart3.physicsBody?.isDynamic = false
        self.heart3.position = CGPoint(x: self.frame.maxX - texturasHeart[0].size().width * 2.5, y: self.frame.maxY - lblScore.frame.height - texturasHeart[0].size().height)
        self.addChild(heart3)
    }
    
//    Función que se llama cada tic del timer de monedas
//    La hacemos una función de Objective-C para poder asignarla al selector del Timer
    @objc func createCoin() {
        
        let coin = SKSpriteNode(texture: texturasCoin[0])
        
        coin.physicsBody = SKPhysicsBody(circleOfRadius: texturasCoin[0].size().height / 2)
        
//        Posicionamos las monedas a la derecha del todo y en una Y aleatoria
        let maxY = Int(self.frame.maxY)
        let randY = CGFloat(arc4random_uniform(UInt32(maxY * 2))) + CGFloat(maxY * -1)
        coin.position = CGPoint(x: self.frame.maxX, y: randY)
        
        coin.zPosition = 0
        coin.setScale(0.5)
        
//        No tendrán gravedad
        coin.physicsBody?.isDynamic = false
        
        let coinAnimation = SKAction.animate(with: texturasCoin, timePerFrame: 0.02)
        let coinAnimationForever = SKAction.repeatForever(coinAnimation)
        coin.run(coinAnimationForever)
        
        coin.physicsBody?.collisionBitMask = 0
        coin.physicsBody?.categoryBitMask = tipoNodo.coin.rawValue
        coin.physicsBody?.contactTestBitMask = tipoNodo.koopa.rawValue
        
        let moverCoin = SKAction.move(by: CGVector(dx: -3 * self.frame.width, dy: 0), duration: TimeInterval(self.frame.width / 80))
        let borrarCoin = SKAction.removeFromParent()
        let moverBorrarCoin = SKAction.sequence([moverCoin, borrarCoin]) // Movemos la moneda y la borramos cuando llega al final
        
        coin.run(moverBorrarCoin)
        
        self.addChild(coin)
    }
    
//    Lo mismo que la función anterior pero para los enemigos
    @objc func createLuigi() {
        
        let luigi = SKSpriteNode(texture: texturasLuigi[0])
        luigi.size = CGSize(width: 100.0, height: 145.0)
        
        luigi.physicsBody = SKPhysicsBody(circleOfRadius: 72.5)
        let maxY = Int(self.frame.maxY)
        let randY = CGFloat(arc4random_uniform(UInt32(maxY * 2))) + CGFloat(maxY * -1)
        luigi.position = CGPoint(x: self.frame.maxX, y: randY)
        luigi.zPosition = 0
        luigi.setScale(0.5)
        
        luigi.physicsBody?.isDynamic = false
        
        let coinAnimation = SKAction.animate(with: texturasLuigi, timePerFrame: 0.02)
        let coinAnimationForever = SKAction.repeatForever(coinAnimation)
        luigi.run(coinAnimationForever)
        
        luigi.physicsBody?.collisionBitMask = 0
        luigi.physicsBody?.categoryBitMask = tipoNodo.enemy.rawValue
        luigi.physicsBody?.contactTestBitMask = tipoNodo.koopa.rawValue
        
        let moverLuigi = SKAction.move(by: CGVector(dx: -3 * self.frame.width, dy: 0), duration: TimeInterval(self.frame.width / CGFloat(100 * self.enemySpeed)))
        let borrarLuigi = SKAction.removeFromParent()
        let moverBorrarLuigi = SKAction.sequence([moverLuigi, borrarLuigi])
        
        luigi.run(moverBorrarLuigi)
        
        self.addChild(luigi)
        
        self.enemySpeed += 0.1 // Aumentamos la velocidad por cada enemigo que salga por pantalla
    }
    
//    Creamos los límites del fondo para que el Koopa no se salga de la escena
    func createLimits() {
        let ground = SKNode()
        ground.position = CGPoint(x: -self.frame.midX, y: -self.frame.height / 2)
        ground.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: self.frame.width, height: 1))
//        El suelo no tendrá gravedad
        ground.physicsBody!.isDynamic = false
        
//        Categoría para collision
        ground.physicsBody!.categoryBitMask = tipoNodo.limits.rawValue
//        Colisiona con el koopa
        ground.physicsBody!.collisionBitMask = tipoNodo.koopa.rawValue
//        Contacto con el suelo
        ground.physicsBody!.contactTestBitMask = tipoNodo.koopa.rawValue
        
        let roof = SKNode()
        roof.position = CGPoint(x: -self.frame.midX, y: self.frame.height / 2)
        roof.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: self.frame.width, height: 1))
        // el techo se tiene que estar quieto
        roof.physicsBody!.isDynamic = false
        
//        Categoría para collision
        roof.physicsBody!.categoryBitMask = tipoNodo.limits.rawValue
//        Colisiona con el koopa
        roof.physicsBody!.collisionBitMask = tipoNodo.koopa.rawValue
//        Contacto con el suelo
        roof.physicsBody!.contactTestBitMask = tipoNodo.koopa.rawValue
        
        self.addChild(ground)
        self.addChild(roof)
    }
    
//    Animación y movimiento para volar
    func fly() {
        self.koopa.physicsBody?.velocity = CGVector(dx: 0, dy: 0)
        self.koopa.physicsBody?.applyImpulse(CGVector(dx: 0, dy: 50))
        let animationFly = SKAction.animate(with: texturesKoopaFly, timePerFrame: 0.05)
        koopa.run(animationFly)
    }
    
//    Salto
    func jump() {
        if self.isGround || (self.numJumps == 1 && self.hearts == 2) { // Si está en el suelo saltará. También si tiene dos vidas y 1 salto (Hará doble salto si tiene 2 vidas)
            self.koopa.physicsBody?.applyImpulse(CGVector(dx: 0, dy: 50))
        }
        
//        Al saltar le decimos que no está en el suelo
        self.isGround = false
        self.numJumps += 1
    }
}
