//
//  AttachmentControlsApp.swift
//  AttachmentControls
//
//  Created by Drew Olbrich on 9/9/23.
//

import SwiftUI
import RealityKit

@main
struct AttachmentControlsApp: App {
    
    @Environment(\.openWindow) private var openWindow
    @Environment(\.dismissWindow) private var dismissWindow

    let volumeGroupID = "volumeGroupID"

    let attachmentID = "attachmentID"

    let volumeSize: Float = 0.5

    var body: some SwiftUI.Scene {
        // Main app window
        WindowGroup() {
            VStack(spacing: 20) {
                Button {
                    openWindow(id: volumeGroupID)
                } label: {
                    Text("Open Volume")
                }
                Button {
                    dismissWindow(id: volumeGroupID)
                } label: {
                    Text("Dismiss Volume")
                }
            }
        }
        
        // Volume
        WindowGroup(id: volumeGroupID, for: UUID.self) { id in
            RealityView { content, attachments in
                content.addSphere(with: .orange, radius: volumeSize/2 - 0.02)
                
                if let sceneAttachment = attachments.entity(for: attachmentID) {
                    sceneAttachment.position = [0, 0, volumeSize/2 - 0.01]
                    content.add(sceneAttachment)
                } else {
                    assertionFailure("sceneAttachment is undefined")
                }
            } attachments: {
                Attachment(id: "attachmentID") {
                    Text("Attachment")
                        .font(.extraLargeTitle)
                }
            }
        }
        .windowStyle(.volumetric)
        .defaultSize(Size3D(width: volumeSize, height: volumeSize, depth: volumeSize), in: .meters)
    }

}

extension RealityViewContent {
    
    /// Adds a sphere to a `RealityViewContent` struct.
    func addSphere(with color: UIColor, radius: Float) {
        let meshResource = MeshResource.generateSphere(radius: radius)
        var material = PhysicallyBasedMaterial()
        material.baseColor = .init(tint: color, texture: nil)
        let modelEntity = ModelEntity(mesh: meshResource, materials: [material])
        let shapeResource = ShapeResource.generateSphere(radius: radius)
        modelEntity.components.set(CollisionComponent(shapes: [shapeResource]))
        modelEntity.components.set(InputTargetComponent())
        self.add(modelEntity)
    }
    
}
