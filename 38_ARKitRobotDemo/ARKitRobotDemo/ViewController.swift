//
//  ViewController.swift
//  ARKitRobotDemo
//
//  Created by wyn on 2020/6/11.
//  Copyright © 2020 Wyn. All rights reserved.
//

import UIKit
import SceneKit
import ARKit

class ViewController: UIViewController {
    
    @IBOutlet var sceneView: ARSCNView!

    private var planes: [ UUID: PlaneNode] = [:]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        // Display the fps and time infomations
        sceneView.showsStatistics = true
        
        // Create a new scene
        let scene = SCNScene()
        
        // Set up the scene and the view
        sceneView.scene = scene
        
        sceneView.delegate = self
        sceneView.debugOptions = [ ARSCNDebugOptions.showFeaturePoints]
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(add3D(recognizer:)))
        sceneView.addGestureRecognizer(tapGestureRecognizer)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Create a session setting
        let configuration = ARWorldTrackingConfiguration()
        
        configuration.planeDetection = .horizontal
        
        // Execute view session
        sceneView.session.run(configuration)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Pause the view session
        sceneView.session.pause()
    }
    
    @objc func add3D(recognizer: UITapGestureRecognizer) {
        let tapLocation = recognizer.location(in: sceneView)
        let hitResults = sceneView.hitTest(tapLocation, types: .existingPlaneUsingExtent)
        
        guard let hitResult = hitResults.first else {
            return
        }
        
        guard let scene = SCNScene(named: "art.scnassets/robot.dae") else {
            return
        }
        
        let node = SCNNode()
        for childNode in scene.rootNode.childNodes {
            node.addChildNode(childNode)
        }
        
        node.position = SCNVector3(hitResult.worldTransform.columns.3.x, hitResult.worldTransform.columns.3.y + 0.35, hitResult.worldTransform.columns.3.z)
        node.scale = SCNVector3(0.1, 0.1, 0.1)
        node.rotation = SCNVector4(0, 1, 0, Float.pi)
        sceneView.scene.rootNode.addChildNode(node)
    }


}

extension ViewController: ARSCNViewDelegate {
    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {

        if let planeAnchor = anchor as? ARPlaneAnchor {

            let planeNode = PlaneNode(anchor: planeAnchor)
            
            planes[anchor.identifier] = planeNode
            node.addChildNode(planeNode)
        }
    }
    
    func renderer(_ renderer: SCNSceneRenderer, didUpdate node: SCNNode, for anchor: ARAnchor) {
        guard let planeAnchor = anchor as? ARPlaneAnchor, let plane = planes[planeAnchor.identifier] else {
            return
        }
        
        plane.update(anchor: planeAnchor)
    }
}

