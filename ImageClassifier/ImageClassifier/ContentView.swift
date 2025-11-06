//
//  ContentView.swift
//  ImageClassifier
//
//  Created by iOS Lab UPMX on 04/11/25.
//

import SwiftUI

struct ContentView: View {
    
    @StateObject private var viewModel = PikachuClassifierViewModel()
    @State private var selectedImage: UIImage?
    @State private var showImagePicker = false
    
    var body: some View {
        NavigationView {
            VStack {
                Text("Detector de Pikachu")
                    .font(.largeTitle)
                    .bold()
                
                if let image = selectedImage {
                    Image(uiImage: image)
                        .resizable()
                        .scaledToFit()
                        .frame(height: 280)
                        .cornerRadius(15)
                }
                
                Button("Seleccionar Imagen") {
                    showImagePicker = true
                }
                .font(.title2)
                .padding()
                .background(Color.blue)
                .foregroundColor(.white)
                .cornerRadius(15)
                
                Text(viewModel.classificationResult)
                    .font(.title3)
                    .padding()
                    .multilineTextAlignment(.center)
            }
            .padding(20)
        }
        .sheet(isPresented: $showImagePicker) {
            ImagePicker(image: $selectedImage) { img in
                viewModel.classifyImage(img)
            }
        }
    }
}

#Preview {
    ContentView()
}
