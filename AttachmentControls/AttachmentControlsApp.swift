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

    let volumeSize: Float = 0.7
    
    @State var volumeIsOpen = false
    
    @State var sphereEntity: ModelEntity?

    var body: some SwiftUI.Scene {
        // Main app window
        WindowGroup() {
            VStack(spacing: 20) {
                Button {
                    // Don't open more than one volume.
                    if !volumeIsOpen {
                        openWindow(id: volumeGroupID)
                        volumeIsOpen = true
                    }
                } label: {
                    Text("Open Volume")
                }
                Button {
                    if volumeIsOpen {
                        dismissWindow(id: volumeGroupID)
                        volumeIsOpen = false
                    }
                } label: {
                    Text("Dismiss Volume")
                }
            }
        }
        
        // Volume
        WindowGroup(id: volumeGroupID) {
            RealityView { content, attachments in
                let sphereEntity = createSphereEntity(withRadius: volumeSize/2 - 0.1)
                self.sphereEntity = sphereEntity
                content.add(sphereEntity)
                
                setRandomColor(for: sphereEntity)
                
                if let sceneAttachment = attachments.entity(for: attachmentID) {
                    sceneAttachment.position = [0, 0, volumeSize/2 - 0.05]
                    content.add(sceneAttachment)
                } else {
                    assertionFailure("sceneAttachment is undefined")
                }
            } attachments: {
                Attachment(id: "attachmentID") {
                    Button {
                        assert(sphereEntity != nil)
                        setRandomColor(for: sphereEntity ?? ModelEntity())
                    } label: {
                        Text("New Color")
                            .font(.extraLargeTitle)
                            .padding(40)
                    }
                }
            }
        }
        .windowStyle(.volumetric)
        .defaultSize(Size3D(width: volumeSize, height: volumeSize, depth: volumeSize), in: .meters)
    }

    func createSphereEntity(withRadius radius: Float) -> ModelEntity {
        let meshResource = MeshResource.generateSphere(radius: radius)
        return ModelEntity(mesh: meshResource, materials: [])
    }
    
    func setRandomColor(for modelEntity: ModelEntity) {
        guard var model = modelEntity.model else {
            assertionFailure("model is undefined")
            return
        }
        
        let color = UIColor.random()
        
        var material = PhysicallyBasedMaterial()
        material.baseColor = .init(tint: color, texture: nil)

        model.materials = [material]
        
        modelEntity.model = model
    }
    
}

extension UIColor {
    
    static func random() -> UIColor {
        func random() -> CGFloat {
            return CGFloat(arc4random())/CGFloat(UInt32.max)
        }
        
        return UIColor(hue: random(), saturation: 0.6, brightness: 0.9, alpha: 1)
    }
    
}

