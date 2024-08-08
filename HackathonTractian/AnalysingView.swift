//
//  AnalysingView.swift
//  HackathonTractian
//
//  Created by Ricardo de Agostini Neto on 08/08/24.
//

import SwiftUI

struct AnalysingView: View {
    
    var image1: CGImage
    var image2: CGImage
    var image3: CGImage
    var jsonUser: String
    var model: String
    var name: String
    var manufacturer: String
    var classifierManager: ClassifierManager
    
    let readData = ReadData()
    
//    @State var machine = Machine(Power: "", Voltage: "", Frequency: "", Rotation: "", Protection: "", Efficiency: "", Status: "", Additional: "")

    @State var machine = Machine(/*name: "", manufacturer: "", model: "", */Power: "", Voltage: "", Frequency: "", Rotation: "", Protection: "", Efficiency: "", Status: "", Additional: "")
    
    @State private var isNavigationActive = false
    
    var body: some View {
        
        //Converti dentro da view só para mostrar as imagens, mas elas estão como CGImage certinho
        let uiImage1 = UIImage(cgImage: image1)
        let uiImage2 = UIImage(cgImage: image2)
        let uiImage3 = UIImage(cgImage: image3)

        
        //NavigationView {
//            Text("Visualização analizando")
//            
//            Image(uiImage: uiImage1)
//                .resizable()
//                .cornerRadius(20)
//                .rotationEffect(Angle(degrees: 90))
//                .scaledToFit()
//                .frame(width: 150, height: 150)
//                .listRowSeparator(.hidden)
//            
//            
//            Image(uiImage: uiImage2)
//                .resizable()
//                .cornerRadius(20)
//                .rotationEffect(Angle(degrees: 90))
//                .scaledToFit()
//                .frame(width: 150, height: 150)
//                .listRowSeparator(.hidden)
//            
//            
//            Image(uiImage: uiImage3)
//                .resizable()
//                .cornerRadius(20)
//                .rotationEffect(Angle(degrees: 90))
//                .scaledToFit()
//                .frame(width: 150, height: 150)
//                .listRowSeparator(.hidden)
            
            
            List {
                Section(header: Text("Especificações Técnicas")) {
                    HStack {
                        Text("Potência:")
                            .fontWeight(.semibold)
                        Spacer()
                        Text(machine.Power)
                    }
                    HStack {
                        Text("Tensão:")
                            .fontWeight(.semibold)
                        Spacer()
                        Text(machine.Voltage)
                    }
                    HStack {
                        Text("Frequência:")
                            .fontWeight(.semibold)
                        Spacer()
                        Text(machine.Frequency)
                    }
                    HStack {
                        Text("Rotação:")
                            .fontWeight(.semibold)
                        Spacer()
                        Text(machine.Rotation)
                    }
                    HStack {
                        Text("Proteção:")
                            .fontWeight(.semibold)
                        Spacer()
                        Text(machine.Protection)
                    }
                    HStack {
                        Text("Eficiência:")
                            .fontWeight(.semibold)
                        Spacer()
                        Text(machine.Efficiency)
                    }
                    HStack {
                        Text("Status:")
                            .fontWeight(.semibold)
                        Spacer()
                        Text(machine.Status)
                    }
                }
                
                Section(header: Text("Informações Adicionais")) {
                    Text(machine.Additional)
                }
                
                
                Section(header: Text("Dados do Funcionário")) {
                    HStack {
                        Text("Localização:")
                            .fontWeight(.semibold)
                        Spacer()
                        Text("Campinas")
                    }
                    HStack {
                        Text("Número de Identificação:")
                            .fontWeight(.semibold)
                        Spacer()
                        Text("100009204")
                    }
                }
                
                
                
            }
            .navigationTitle("Informações")
            .navigationBarBackButtonHidden(true)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    
                    Button(action: {
                        
                        isNavigationActive = true
                    }) {Text("Go to Menu")}
                        .background(
                            NavigationLink(destination: InitialView(), isActive: $isNavigationActive) {
                                EmptyView()
                            }
                                .hidden()
                        )
                }
            }
            
            
            
            
        //}
        .task {
//            classifierManager.identify(image)
            classifierManager.identify(image1, imageInput2: image2, imageInput3: image3)
        }
        .onChange(of: classifierManager.finalInfos) { newValue in
            if let value = newValue {
                
                let json = readData.extractJSONContent(from: value)
                print("-------------------------------------")
                print(json)
                print("-------------------------------------")
                machine = readData.readData(gptResponse: json) ?? Machine(/*name: "", manufacturer: "", model: "", */Power: "", Voltage: "", Frequency: "", Rotation: "", Protection: "", Efficiency: "", Status: "", Additional: "")
                print(machine)
                //exibir.toggle()
            }
        }
    }
}

