//
//  CameraModel.swift
//  HackathonTractian
//
//  Created by Ricardo de Agostini Neto on 08/08/24.
//

import Foundation
import AVFoundation
import SwiftUI


class CameraModel: NSObject, ObservableObject, AVCapturePhotoCaptureDelegate {
    
    @Published var isTaken = false
    
    @Published var session = AVCaptureSession()
    
    @Published var alert = false
    
    @Published var output = AVCapturePhotoOutput()
    
    @Published var preview: AVCaptureVideoPreviewLayer!
    
    @Published var picData = Data(count: 0)
    
    @Published var finalImage: CGImage?
    
    func Check() {
        
        switch AVCaptureDevice.authorizationStatus(for: .video) {
        case .authorized:
            setup()
            return
        case .notDetermined:
            AVCaptureDevice.requestAccess(for: .video) {(status) in
            
            if status {
                self.setup()
            }
        }
        case .denied:
            self.alert.toggle()
            return
    default:
        return
    }
    
}

func setup() {
    
    do {
        
        self.session.beginConfiguration()
        
        
        //Aqui passar um filto para pegra o tipo de câmera que o iphone do usuário possui
        let device = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .back)
        
        let input = try AVCaptureDeviceInput(device: device!)
        
        if self.session.canAddInput(input) {
            self.session.addInput(input)
        }
        
        session.sessionPreset = .photo
        if self.session.canAddOutput(self.output) {
            self.session.addOutput(self.output)
        }
        
        self.session.commitConfiguration()
        
    }
    catch {
        print(error.localizedDescription)
    }
}


    func takePic() {
        self.output.capturePhoto(with: AVCapturePhotoSettings(), delegate: self)
        //self.session.stopRunning()
        print("hello3")
        
        self.isTaken.toggle()
        
        //Perigoso, talvez remover isso -> Ontem, dia 02/07 no fim do dia, eu tive que comentar esse stoprunning pq nao estava funcionando
        //self.session.stopRunning()
    }
    
    func reTake() {
        DispatchQueue.global(qos: .background).async {
            self.session.startRunning()
            
            DispatchQueue.main.async {
                withAnimation {
                    self.isTaken.toggle()
                    self.finalImage = nil
                }
            }
        }
    }
    
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
        print("hello5")
        if error != nil {
            return
        }
        
        print("pic taken...")
        print(output)
        
        guard let imageData = photo.fileDataRepresentation() else{return}
        DispatchQueue.main.async {
            self.picData = imageData
            print("gello")
            self.savePic()
        }
        self.session.stopRunning()
    }
    
    func savePic() {
        
        let image = UIImage(data: self.picData)
        
        let newImage = convertUIImageToCGImage(input: image!)
        
        
        
        finalImage = newImage
        print("caiu aqui")
        
    }
    
    func convertUIImageToCGImage(input: UIImage) -> CGImage! {
        guard let ciImage = CIImage(image: input) else {
            return nil
        }
        
        let context = CIContext(options: nil)
        return context.createCGImage(ciImage, from: ciImage.extent)
    }
    
    
    

}



