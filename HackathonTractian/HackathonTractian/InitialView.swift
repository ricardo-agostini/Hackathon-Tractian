//
//  ContentView.swift
//  HackathonTractian
//
//  Created by Ricardo de Agostini Neto on 08/08/24.
//

import SwiftUI

struct InitialView: View {
    
    @State var classifierManager: ClassifierManager = ClassifierManager()
    
    var body: some View {
        NavigationStack {
            List {
                
                Section {
                    NavigationLink(destination: CameraView(classifierManager: classifierManager)) {
                        Text("Tirar Foto")
                            .foregroundColor(.white)
                            .bold()
                            .padding()
                            .frame(width: 250)
                            .background(Color.blue)
                            .cornerRadius(10)
                    }
                }
                
//                Section {
//                NavigationLink(destination: CameraView(classifierManager: classifierManager)) {
//                    Text("Selecionar Foto da Galeria")
//                        .foregroundColor(.white)
//                        .bold()
//                        .padding()
//                        .frame(width: 250)
//                        .background(Color.blue)
//                        .cornerRadius(10)
//                }
//            }
            

            
            
            
        }.scrollContentBackground(.hidden) // Oculta o fundo padrão da lista
                .background(Color.white) // Define o fundo branco
        .padding()
        .navigationTitle("Cadastrar Máquinas")
        .navigationBarBackButtonHidden(true)
    }
        
        
    }
}

#Preview {
    InitialView()
}
