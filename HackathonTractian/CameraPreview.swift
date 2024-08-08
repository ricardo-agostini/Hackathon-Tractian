//
//  CameraPreview.swift
//  HackathonTractian
//
//  Created by Ricardo de Agostini Neto on 08/08/24.
//

import Foundation
import SwiftUI
import AVFoundation

struct CameraPreview: UIViewRepresentable {
    
    @ObservedObject var camera: CameraModel
    let frame: CGRect
    
    func makeUIView(context: Context) -> UIView {
        
//        let view = UIView(frame: UIScreen.main.bounds)
        let view = UIViewType(frame: frame)
        
        
        camera.preview = AVCaptureVideoPreviewLayer(session: camera.session)
        camera.preview.frame = frame
        // Your Own Properties...
        camera.preview.videoGravity = .resizeAspectFill
        view.layer.addSublayer (camera.preview)
        
        
         //DispatchQueue.global(qos: .background).async {
             camera.session.startRunning()
         //}
        
        
        return view
    }
    
    
    
    
    func updateUIView(_ uiView: UIView, context: Context) {
        
    }
    
}
