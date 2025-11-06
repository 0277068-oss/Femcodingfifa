//
//  PikachuClassifierViewModel.swift
//  ImageClassifier
//
//  Created by iOS Lab UPMX on 04/11/25.
//

import Foundation
import CoreML
import Vision
import UIKit
import Combine

class PikachuClassifierViewModel: ObservableObject {
    @Published var classificationResult: String = "Selecciona una imagen para comenzar"
    
    func classifyImage(_ image: UIImage) {
        guard let cgImage = image.cgImage else {
            classificationResult = "No se pudo convertir la imagen en un CGImage"
            return
            
        }
        
        guard let model = try? VNCoreMLModel(for: MyImageClassifier().model) else {
            classificationResult = "No se pudo cargar el modelo de visión"
            return
        }
        
        let request = VNCoreMLRequest(model: model) {request, error in
            if let results = request.results as?
                [VNClassificationObservation],
               let topResult = results.first{
                
                DispatchQueue.main.async {
                    let confidence = Int(topResult.confidence * 100)
                    
                    self.classificationResult = "\(topResult.identifier): \(confidence)"
        }
    }
    else{
        
        DispatchQueue.main.async {
            self.classificationResult = "No se pudo clasificar la imagen"
        }
        
        
            
        }
    }
        
        let handler = VNImageRequestHandler(cgImage: cgImage)
        DispatchQueue.global(qos: .userInitiated).async {
            do {
                try handler.perform([request])
            }catch{
                DispatchQueue.main.async {
                    
                    self.classificationResult = "Error al procesar la imagen: \(error.localizedDescription)"
                }
            }
        }
}

}
