//
//  WhackSlot.swift
//  Whack-A-Penguin
//
//  Created by Trevor MacGregor on 2017-06-16.
//  Copyright © 2017 TeevoCo. All rights reserved.
//

import SpriteKit
import UIKit


class WhackSlot: SKNode {
    
    var isVisible = false
    var isHit = false
    
    var charNode: SKSpriteNode!
    
    func configure(at position: CGPoint) {
        self.position = position
        
        let sprite = SKSpriteNode(imageNamed: "whackHole")
        addChild(sprite)
        
        let cropNode = SKCropNode()
        cropNode.position = CGPoint(x: 0, y: 15)
        cropNode.zPosition = 1
        cropNode.maskNode = SKSpriteNode(imageNamed: "whackMask")
        
        charNode = SKSpriteNode(imageNamed: "penguinGood")
        charNode.position = CGPoint(x: 0, y: -90)
        charNode.name = "character"
        cropNode.addChild(charNode)
        
        addChild(cropNode)
    }
    
    func show(hideTime: Double) {
        if isVisible {return}
        
        charNode.run(SKAction.moveBy(x: 0, y: 80, duration: 0.05))
        isVisible = true
        isHit = false
        
        if RandomInt(min: 0, max: 2) == 0 {
            charNode.texture = SKTexture(imageNamed: "penguinGood")
            charNode.name = "charFriend"
        }else{
            charNode.texture = SKTexture(imageNamed: "penguinEvil")
            charNode.name = "charEnemy"
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + (hideTime * 3.5)) {[unowned self] in self.hide()
        }
    }
    
    
    //undoes the results of show(): the penguin moves back down the screen into its hole, then its isVisible property is set to false.
    func hide() {
        if !isVisible {return}
        
        charNode.run(SKAction.moveBy(x: 0, y: -80, duration: 0.05))
        isVisible = false
    }
    
    //this method will handle hiding the penguin. This needs to wait for a moment (so the player still sees what they tapped), move the penguin back down again, then set the penguin to be invisible again.
    func hit() {
        isHit = true
        
        let delay = SKAction.wait(forDuration: 0.25)
        let hide = SKAction.moveBy(x: 0, y: -80, duration: 0.25)
        let notVisible = SKAction.run { [unowned self] in
            self.isVisible = false}
        charNode.run(SKAction.sequence([delay,hide,notVisible]))
    }

}
