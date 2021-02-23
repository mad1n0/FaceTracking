//
//  transformvisualization2.swift
//  DeepSight
//
//  Created by Marc Valdivieso Merino on 02/12/2020.
//

import ARKit
import SceneKit

class TransformVisualization: NSObject, VirtualContentController {
    
    var contentNode: SCNNode?
    
    // Load multiple copies of the axis origin visualization for the transforms this class visualizes.
    var rightEyeNode = SCNReferenceNode()
    lazy var leftEyeNode = SCNReferenceNode()
    lazy var lookAt = SCNReferenceNode()
    
    /// - Tag: ARNodeTracking
    func renderer(_ renderer: SCNSceneRenderer, nodeFor anchor: ARAnchor) -> SCNNode? {
        // This class adds AR content only for face anchors.
        guard anchor is ARFaceAnchor else { return nil }
        
        // Load an asset from the app bundle to provide visual content for the anchor.
        contentNode = SCNReferenceNode()
        
        // Add content for eye tracking in iOS 12.
        self.addEyeTransformNodes()
        
        // Provide the qnode to ARKit for keeping in sync with the face anchor.
        return contentNode
    }

    func renderer(_ renderer: SCNSceneRenderer, didUpdate node: SCNNode, for anchor: ARAnchor) {
        guard #available(iOS 12.0, *), let faceAnchor = anchor as? ARFaceAnchor
            else { return }
        
        rightEyeNode.simdTransform = faceAnchor.rightEyeTransform
        leftEyeNode.simdTransform = faceAnchor.leftEyeTransform
        lookAt.simdPosition = faceAnchor.lookAtPoint
        print(faceAnchor.rightEyeTransform)
        print(faceAnchor.lookAtPoint)
        
    }
    
    func addEyeTransformNodes() {
        guard #available(iOS 12.0, *), let anchorNode = contentNode else { return }
        
        // Scale down the coordinate axis visualizations for eyes.
        rightEyeNode.simdPivot = float4x4(diagonal: float4(3, 3, 3, 1))
        leftEyeNode.simdPivot = float4x4(diagonal: float4(3, 3, 3, 1))
        //lookAt.simdWorldPosition =  float3()
        //print(rightEyeNode.simdPivot)
        anchorNode.addChildNode(rightEyeNode)
        anchorNode.addChildNode(leftEyeNode)
        //anchorNode.addChildNode(lookAt)
    }

}
