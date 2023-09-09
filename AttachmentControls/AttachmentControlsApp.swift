//
//  AttachmentControlsApp.swift
//  AttachmentControls
//
//  Created by Drew Olbrich on 9/9/23.
//

import SwiftUI
import RealityKit

/// This app demonstrates that in visionOS 1.0 beta (Xcode 15 beta 8), if a
/// `RealityView` in a volume has an attachment with controls, often the
/// attachment's controls will not respond to user input.
///
/// Repro steps:
///
/// 1. Launch the app.
/// 2. Move the app's window to the left side of the simulator screen.
/// 3. Select the window's Open Volume button.
/// 4. In the volume that appears, select the New Color button.
///
/// Expected behavior: The color of the sphere in the volume changes to a random color.
///
/// Observed behavior: The Open Volume button doesn't work, and the sphere does not
/// change color. Furthermore, the Open Volume's hover effect does not appear.
///
/// The observed behavior described above only happens about 1/4 of the time.
/// If the sphere does change color, follow these steps:
///
/// 1. Select the window's Close Volume button
/// 2. Select the window's Open Volume button again.
/// 3. Select the New Color button again.
///
/// It may be necessary to repeat these steps several times before the observed behavior occurs.
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

