//
//  ReadResponse.swift
//  HackathonTractian
//
//  Created by Ricardo de Agostini Neto on 08/08/24.
//

import Foundation

class ReadData: ObservableObject  {

    func readData(gptResponse: String) -> Machine? {
        
        if let jsonData = gptResponse.data(using: .utf8) {
            
            do {
                let decoder = JSONDecoder()
                let machineInfo = try decoder.decode(Machine.self, from: jsonData)
                return machineInfo
            }
            catch {
                print("erro ao decodar")
            }
            
        } else {
            print("Erro ao converter")
        }
        
        return nil
        
    }
    
    func extractJSONContent(from jsonString: String) -> String {
        guard let startIndex = jsonString.firstIndex(of: "{"),
              let endIndex = jsonString.lastIndex(of: "}") else {
            return ""
        }
        
        let range = startIndex...endIndex
        let extractedString = jsonString[range]
        
        return String(extractedString)
    }
    
    
    
}
