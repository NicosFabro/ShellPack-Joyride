//
//  GameScene.swift
//  ShellPack Joyride
//
//  Created by Nicos Fabro on 25/4/18.
//  Copyright © 2018 Nicos Fabro. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {
    
    var koopa = SKSpriteNode()
    var bg = SKSpriteNode()
    
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
    
    override func didMove(to view: SKView) {
        
        koopa.position = CGPoint(x: 0.0, y: 0.0)
        bg.position = CGPoint(x: 0.0, y: 0.0)
        
        koopa = SKSpriteNode(texture: texturesKoopaFly[0])
        bg.zPosition = -1
        
        let animacion = SKAction.animate(with: texturesKoopaFly, timePerFrame: 0.2)
        
        let animacionRepetida = SKAction.repeatForever(animacion)
        
        koopa.run(animacionRepetida)
        crearFondoConAnimacion()
        
        self.addChild(koopa)
    }
    
    func crearFondoConAnimacion() {
        // Textura para el fondo
        let texturaBg = SKTexture(imageNamed: "bg.png")
        
        // Acciones del fondo (para hacer ilusión de movimiento)
        // Desplazamos en el eje de las x cada 0.3s
        let movimientoFondo = SKAction.move(by: CGVector(dx: -texturaBg.size().width, dy: 0), duration: 4)
        
        let movimientoFondoOrigen = SKAction.move(by: CGVector(dx: texturaBg.size().width, dy: 0), duration: 0)
        
        // repetimos hasta el infinito
        let movimientoInfinitoFondo = SKAction.repeatForever(SKAction.sequence([movimientoFondo, movimientoFondoOrigen]))
        
        // Necesitamos más de un fondo para que no se vea la pantalla en negro
        // contador de fondos
        var i: CGFloat = 0
        
        while i < 2 {
            // Le ponemos la textura al fondo
            bg = SKSpriteNode(texture: texturaBg)
            
            // Indicamos la posición inicial del fondo
            bg.position = CGPoint(x: texturaBg.size().width * i, y: self.frame.midY)
            
            // Estiramos la altura de la imagen para que se adapte al alto de la pantalla
            // bg.size.height = self.frame.height
            
            // Indicamos zPosition para que quede detrás de todo
            bg.zPosition = -1
            
            // Aplicamos la acción
            bg.run(movimientoInfinitoFondo)
            // Ponemos el fondo en la escena
            self.addChild(bg)
            
            // Incrementamos contador
            i += 1
        }
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        /*if let label = self.label {
         label.run(SKAction.init(named: "Pulse")!, withKey: "fadeInOut")
         }
         
         for t in touches { self.touchDown(atPoint: t.location(in: self)) }*/
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
    }
}
