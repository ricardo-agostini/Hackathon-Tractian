//
//  PutInfosView.swift
//  HackathonTractian
//
//  Created by Ricardo de Agostini Neto on 08/08/24.
//
import SwiftUI

struct PutInfosView: View {
    
    var image1: CGImage
    var image2: CGImage
    var image3: CGImage
    var classifierManager: ClassifierManager
    
    @State private var isNavigationAnalysing = false
    
    
    @State private var nome: String = ""
    @State private var modelo: String = ""
    @State private var fabricante: String = ""
    @State private var jsonOutput: String = ""
    
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                // Campo para o usuário inserir o nome
                TextField("Nome", text: $nome)
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(8)
                
                // Campo para o usuário inserir o modelo de uma máquina
                TextField("Modelo", text: $modelo)
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(8)
                
                // Campo para o usuário inserir o Fabricante
                TextField("Fabricante", text: $fabricante)
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(8)
                
                // Botão para submeter as informações
                Button(action: {
                    // Criação do JSON a partir das variáveis
                    let machineInfo: [String: String] = [
                        "name": nome,
                        "manufacturer": fabricante,
                        "model": modelo
                    ]
                    
                    // Conversão do dicionário para JSON
                    if let jsonData = try? JSONSerialization.data(withJSONObject: machineInfo, options: .prettyPrinted),
                       let jsonString = String(data: jsonData, encoding: .utf8) {
                        jsonOutput = jsonString
                        print(jsonOutput)
                    }
                    
                    isNavigationAnalysing = true
                    
                }) {
                    Text("Salvar Informações e Analisar")
                        .foregroundColor(.white)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.blue)
                        .cornerRadius(8)
                }
                .padding(.top, 20)
                .background(
                    NavigationLink(destination: AnalysingView(image1: image1, image2: image2, image3: image3, jsonUser: jsonOutput, model: modelo, name: nome, manufacturer: fabricante, classifierManager: classifierManager), isActive: $isNavigationAnalysing) {
                        EmptyView()
                    }
                        .hidden()
                )
                .padding(.leading, 25)
                
                // Exibir o JSON gerado
//                if !jsonOutput.isEmpty {
//                    Text("JSON Gerado:")
//                        .font(.headline)
//                        .padding(.top, 20)
//                    ScrollView {
//                        Text(jsonOutput)
//                            .padding()
//                            .background(Color(.systemGray6))
//                            .cornerRadius(8)
//                            .font(.system(.body, design: .monospaced))
//                    }
//                }
                
                Spacer()
            }
            .padding()
            .navigationTitle("Inserir Informações")
            .navigationBarBackButtonHidden(true)
            
        }.navigationBarBackButtonHidden(true)
    }
}


