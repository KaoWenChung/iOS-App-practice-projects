//
//  ViewController.swift
//  ARKitDemo
//
//  Created by wyn on 2020/6/9.
//  Copyright © 2020 Wyn. All rights reserved.
//

import UIKit
import SpriteKit
import ARKit

enum BirdType: Int {
    case yellow
    case blue
    case green
    case grey
    
    var prefix: String{
        switch self {
        case .yellow: return "Yellow"
        case .blue: return "Blue"
        case .green: return "green"
        case .grey: return "Grey"
        }
    }
    
    private static let count: Int = {
        var max: Int = 0
        while let _ = BirdType(rawValue: max) {max += 1}
        return max
    }()
    
    static func random() -> BirdType{
        let randomNumber = Int.random(in: 0..<BirdType.count)
        return BirdType(rawValue: randomNumber)!
    }
    
    func keyFrames() -> [SKTexture] {
        var texture: [SKTexture] = []
        for index in 1...8 {
            texture.append(SKTexture(imageNamed: "\(self.prefix)-\(index)"))
        }
        return texture
    }
}

class ViewController: UIViewController, ARSKViewDelegate {
    
    @IBOutlet var sceneView: ARSKView!
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set the view's delegate
        sceneView.delegate = self
        
        // Show statistics such as fps and node count
        sceneView.showsFPS = true
        sceneView.showsNodeCount = true
        
        // Load the SKScene from 'Scene.sks'
        if let scene = SKScene(fileNamed: "Scene") {
            sceneView.presentScene(scene)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Create a session configuration
        let configuration = ARWorldTrackingConfiguration()

        // Run the view's session
        sceneView.session.run(configuration)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Pause the view's session
        sceneView.session.pause()
    }
    
    // MARK: - ARSKViewDelegate
    
    func view(_ view: ARSKView, nodeFor anchor: ARAnchor) -> SKNode? {
        // Create and configure a node for the anchor added to the view's session.
        let birdType = BirdType.random()
        let birdFrames = birdType.keyFrames()
        
        let birdNode = SKSpriteNode(texture: birdFrames[0])
        birdNode.position = CGPoint(x: view.center.x ,y: view.center.y)
        birdNode.size = CGSize(width: birdNode.size.width * 0.1, height: birdNode.size.height * 0.1)
        
        birdNode.run(SKAction.repeatForever(SKAction.animate(with: birdFrames, timePerFrame: 0.1)))
        return birdNode
    }
    
    func session(_ session: ARSession, didFailWithError error: Error) {
        // Present an error message to the user
        
    }
    
    func sessionWasInterrupted(_ session: ARSession) {
        // Inform the user that the session has been interrupted, for example, by presenting an overlay
        
    }
    
    func sessionInterruptionEnded(_ session: ARSession) {
        // Reset tracking and/or remove existing anchors if consistent tracking is required
        
    }
}
