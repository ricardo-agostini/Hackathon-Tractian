//
//  DataLoader.swift
//  CaloriesCounter
//
//  Created by Ricardo de Agostini Neto on 26/06/24.
//

import Foundation
import UIKit
import RegexBuilder
import SwiftOpenAI



let inicioDoPrompt: String = """
You are an expert in industrial machinery. Here is some context about the machines:

        Three-Phase Motors : Specifications
        ITEM    Specifications
        Standard    JIS C4210,4034, JEC2137 ect.
        Rating    Continuous [S1]
        Insulation Class
        2 Pole 4 Pole 6 Pole
        B Type    ～180 M
        F Type    180 L～
        Enclosures Type
        protection Iec standard
        Enclosures    Type    Protection
        Indoor    Fan cooled type
        Vertical Fan cooled type    TFO-K, KK
        VTFO-K, KK    IP44
        Outdoor    Fan cooled type
        Vertical Fan cooled type    TFO-K, KK
        VTFO-K, KK    IP55
        Voltage, Frequency    1/2 ～ 5 HP : 220/380 V 50 Hz
        7.5 ～30 HP : 380/415 V 50Hz
        40 HP～ : 200/380/415 V 50Hz
        Number of Cable    ～5 HP 6 WIRES(Direct starting 220 V or 380 V)
        7.5 HP ～ 6 WIRES(Star star-delta Delta Starting)
        2 pole 30 HP ～
        4 pole 40 HP ～
        6 pole 50 HP ～    12 Wires(Star star-deltaDelta Starting)
        Color    Alcron gray
        Transmission    2 pole 15 HP ～DIRECT CONPLING
        2 pole ～10 HP and 4 pole ～
        Rotation    CCW (VIEW FROM MOTOR DRIVE END)
        Environ ment    Temperature
        Humidity
        Altitude
        Establishment    -30 ～ 40°C
        Enclosed type MAX 95% RH
        MAX 1,000 m
        [IP44]IN DOOR, [IP44, IP55]OUT DOOR
        Atmosphere    NO CORROSIVE GAS, NO EXPLOSIVE GAS
        NO STEAM, NO DEW, LITTLE DUST

        Compressor - Screw (Atlas Copco GA Series):

        Specifications: The GA 37+ - 45+ models feature oil-injected rotary screw compressors with motor power ranging from 37kW to 45kW. They are highly energy-efficient with a Free Air Delivery (FAD) improved by 2.7% and energy efficiency enhanced by 3.2%. The compressors are equipped with the Elektronikon® Touch controller for advanced monitoring and control

        Pump - Centrifugal:

        Specifications: Centrifugal pumps are available in single or multi-stage configurations, often used for applications involving water, chemicals, and other fluids. They are characterized by their ability to handle large volumes at relatively low pressures. Specific models vary based on the manufacturer, but they generally include options for different materials of construction (stainless steel, cast iron) and seal types (mechanical seals, packing)

        Bearing - Rolling:

        Specifications: Rolling bearings are used to reduce friction and wear in rotating machinery. They come in several types, including ball bearings, cylindrical roller bearings, and tapered roller bearings. These bearings are specified by their load-carrying capacity, speed ratings, and material properties, which are designed to meet the demands of high-speed and high-load applications

        Reductor Gearbox (Parallel Shaft, Bevel Gear, Worm Gear):

        Specifications: Gearboxes are used to reduce speed and increase torque in various industrial machines. The parallel shaft and bevel gear designs are common in heavy-duty applications, offering high efficiency and reliability. Worm gearboxes are often used where compact size and low-speed operation are required. These gearboxes are specified by their gear ratios, output torque, and efficiency ratings

        You will be useful in the following way:
        From three photos (one of the technical plate and two of the machine itself) and a JSON file containing the name, manufacturer, and model of the machine, you must extract all the technical specifications of the machine that you can, as well as information about the condition of the machine (usage time, integrity, etc.).
        The essential information is Power, Voltage, Frequency, Rotation, Protection, Efficiency and Status (the condition of the machine).
        The other specifications must be a text inside an "Additional" key of the main json.
        If you can't find one of the essential information you must enter N/A on the field.
        Provide the response in JSON format.
        I will provide you with an example using three photos and a JSON file, and in the end, the real data for you to perform the requested task.
        
        Example Input 1:

        {
        "name": "10009204 - MOTOR ROLOS FIXO (LADO B) 40CV",
        "manufacturer": "WEG",
        "model": "electricMotor-threePhase"
        }
        
"""

let meioDoPrompt: String = """

Example Output 1:
                
                {
                "Power": "1.5 HP (1.1kW)",
                "Voltage": 230/460 (estimated),
                "Frequency": "50Hz",
                "Rotation": 1755 RPM (estimated),
                "Protection": "IP55",
                "Efficiency": "86.5% (NEMA)"
                "Status": "The machine shows visible dirt accumulation and worn paint, suggesting exposure to harsh environments, while external components appear acceptable but need a detailed check; preventive maintenance, including cleaning and electrical component inspection, is recommended.",
                "Additional":" This machine operates on a three-phase system and is built with a 143/5T frame. It has current ratings of 4.36A at 208V, 4.04A at 230V, and 2.42A at 380V. The insulation class is B, and it features a Totally Enclosed Fan-Cooled (TEFC) enclosure. The machine has a service factor of 1.25, with usable service factors of 2.52 at 208V and 1.15 at 380V. It operates with a power factor of 0.79 and has a temperature rise of ΔT 80."
                }

                Example Input 2:

                {
                "manufacturer": "Dodge",
                "name": "Fan Side Bearing",
                "model": "bearing-rolling"
                }


"""


let finalDoPrompt: String = """

                Example Output 2:
                    
                {
                    "Power": "1.5 HP",
                    "Voltage": "208-230/460 V",
                    "Frequency": "60 Hz",
                    "Rotation": "1760 RPM",
                    "Protection": "IP55",
                    "Efficiency": "88.5%",
                    "Status": "The machine shows significant signs of wear, with a considerable accumulation of dust and debris on and around the components. There is visible rust on the shaft and potential corrosion on other metal parts. The environment appears to be harsh, suggesting the need for immediate and thorough cleaning, followed by a detailed inspection to assess any further damage. Regular maintenance is strongly recommended to prevent operational failures.",
                    "Additional": "This is a three-phase motor designed for continuous duty. The motor features a Totally Enclosed Fan-Cooled (TEFC) enclosure with an insulation class of F. The NEMA nominal efficiency is 88.5% at rated load. The usable service factor is 1.15, and it has a frame size of 145JM. The machine is suitable for environments up to 40°C and a maximum altitude of 1000 m. Bearings are specified as DE 6206 and ODE 6203. The power factor is 76%."
                }

                Now I will provide you with the real data, that is, three images and a JSON file, so that you can generate the resulting JSON according to the example:
                
"""

let info: String = """

{
  "name": "10009204 - MOTOR ROLOS FIXO (LADO B) 40CV",
  "manufacturer": "WEG",
  "model": "electricMotor-threePhase"
}

"""

//Possíveis erros que podem dar
enum DataLoaderError: Error {
    case couldNotCreateImageURL
    case couldNotIdentifyPlant
}


/// Sends requests to OpenAI to classify plant images, and returns the result asynchronously
final actor DataLoader {

    /// Uses OpenAI to fetch a description of the image passed as argument
    /// - Parameter image: The image to describe
    /// - Returns: An OpenAI description of the image
    func identify(fromImage imageInput1: CGImage, imageInput2: CGImage, imageInput3: CGImage ) async throws -> String {
        
        //Nessa função, vamos encodar as imagens
        let exampleImage1 = UIImage(named: "ImagemExemplo1")!.cgImage
        let exampleImage2 = UIImage(named: "ImagemExemplo2")!.cgImage
        let exampleImage3 = UIImage(named: "ImagemExemplo3")!.cgImage
        
        let exampleImage4 = UIImage(named: "ImagemExemplo4")!.cgImage
        let exampleImage5 = UIImage(named: "ImagemExemplo5")!.cgImage
        let exampleImage6 = UIImage(named: "ImagemExemplo6")!.cgImage
        
        
        
        //Convertendo as 3 imagens de entrada para base64
        guard let localURL1 = imageInput1.openAILocalURLEncoding() else {
            throw DataLoaderError.couldNotCreateImageURL
        }
        
        guard let localURL2 = imageInput2.openAILocalURLEncoding() else {
            throw DataLoaderError.couldNotCreateImageURL
        }
        
        guard let localURL3 = imageInput3.openAILocalURLEncoding() else {
            throw DataLoaderError.couldNotCreateImageURL
        }
        
        
        
        
        //Abaixo, encodei as 3 imagens de exemplo para base64
        guard let localURLexample1 = exampleImage1!.openAILocalURLEncoding() else {
            throw DataLoaderError.couldNotCreateImageURL
        }
        guard let localURLexample2 = exampleImage2!.openAILocalURLEncoding() else {
            throw DataLoaderError.couldNotCreateImageURL
        }
        guard let localURLexample3 = exampleImage3!.openAILocalURLEncoding() else {
            throw DataLoaderError.couldNotCreateImageURL
        }
        
        //Abaixo, encodei as 3 imagens de exemplo para base64
        guard let localURLexample4 = exampleImage4!.openAILocalURLEncoding() else {
            throw DataLoaderError.couldNotCreateImageURL
        }
        guard let localURLexample5 = exampleImage5!.openAILocalURLEncoding() else {
            throw DataLoaderError.couldNotCreateImageURL
        }
        guard let localURLexample6 = exampleImage6!.openAILocalURLEncoding() else {
            throw DataLoaderError.couldNotCreateImageURL
        }
        
        
        
        
        let inicioDoPrompt = inicioDoPrompt
        let finalDoPrompt = finalDoPrompt
        
        let messageContent: [ChatCompletionParameters.Message.ContentType.MessageContent] = [
            
            .text(inicioDoPrompt), 
//            .imageUrl(.init(url: localURL))
            .imageUrl(.init(url: localURLexample1)),
            .imageUrl(.init(url: localURLexample2)),
            .imageUrl(.init(url: localURLexample3)),
            
            .text(meioDoPrompt),
            .imageUrl(.init(url: localURLexample4)),
            .imageUrl(.init(url: localURLexample5)),
            .imageUrl(.init(url: localURLexample6)),
            
            
            
            .text(finalDoPrompt),
            .imageUrl(.init(url: localURL1)),
            .imageUrl(.init(url: localURL2)),
            .imageUrl(.init(url: localURL3)),
            .text(info)
        
        ]
        
        
        
        
        
        
        let parameters = ChatCompletionParameters(messages: [.init(role: .user, content: .contentArray(messageContent))], model: .gpt4o)
        let response = try await AppConstants.openAI.startChat(parameters: parameters)

        let choices = response.choices
        
        //Essa poha é uma string caralhoooooo
        guard let text = choices.first?.message.content else {
            throw DataLoaderError.couldNotIdentifyPlant
        }

        return text
    }
}

extension UIImage {
    
    // Resizeing using CoreGraphics
    func resize(to size:CGSize) -> UIImage? {
        
        let cgImage = self.cgImage!
        let destWidth = Int(size.width)
        let destHeight = Int(size.height)
        let bitsPerComponent = 8
        let bytesPerPixel = cgImage.bitsPerPixel / bitsPerComponent
        let destBytesPerRow = destWidth * bytesPerPixel
        
        let context = CGContext(data: nil,
                                width: destWidth,
                                height: destHeight,
                                bitsPerComponent: bitsPerComponent,
                                bytesPerRow: destBytesPerRow,
                                space: cgImage.colorSpace!,
                                bitmapInfo: cgImage.bitmapInfo.rawValue)!
        context.interpolationQuality = .high
        context.draw(cgImage, in: CGRect(origin: CGPoint.zero, size: size))
        return context.makeImage().flatMap { UIImage(cgImage: $0) }
    }
}


//Função que encoda a CGImage para algo que a API da Open AI consegue ler
private extension CGImage {
    func openAILocalURLEncoding() -> URL? {
        if let data = UIImage(cgImage: self)
            .resize(to: CGSize(width: 200, height: 200))?
            .jpegData(compressionQuality: 0.4) {
        //if let data = UIImage(cgImage: self).jpegData(compressionQuality: 0.4) {
            let base64String = data.base64EncodedString()
            //print(base64String)
            if let url = URL(string: "data:image/jpeg;base64,\(base64String)") {
                print(url)
                return url
            }
        }
        return nil
    }
}
