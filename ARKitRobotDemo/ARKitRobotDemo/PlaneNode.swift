//
//  PlaneNode.swift
//  ARKitRobotDemo
//
//  Created by wyn on 2020/6/12.
//  Copyright © 2020 Wyn. All rights reserved.
//

import Foundation
import SceneKit
import ARKit

class PlaneNode: SCNNode {
    private var anchor: ARPlaneAnchor!
    private var plane: SCNPlane!
    
    init(anchor: ARPlaneAnchor) {
        super.init()
        
        self.anchor = anchor
        
        // Create a virtual plane to visualize detected plane
        self.plane = SCNPlane(width: CGFloat(anchor.extent.x), height: CGFloat(anchor.extent.z))
        
        // Set up the virtual plane color
        self.plane.materials.first?.diffuse.contents = UIColor(red: 90/255, green: 200/255, blue: 250/255, alpha: 0.50)
        
        // Create the sceneKit geometry point
        self.geometry = plane
        self.position = SCNVector3(anchor.center.x, 0.0, anchor.center.z)
        
        // Because of SceneKit plane is vertical, we have to rotate it 90 degree
        self.eulerAngles.x = -Float.pi/2.0
    }
    
    required init?(coder aDecorder: NSCoder) {
        super.init(coder: aDecorder)
    }
    
    func update(anchor: ARPlaneAnchor) {
        self.anchor = anchor
        
        // Update size of the plane
        plane.width = CGFloat(anchor.extent.x)
        plane.height = CGFloat(anchor.extent.z)
        
        // Update position of the plane
        self.position = SCNVector3(anchor.center.x, 0.0, anchor.center.z)
    }
}
