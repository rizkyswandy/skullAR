//
//  ARModelManager.swift
//  SkullAR
//
//  Created by ILB on 20/11/24.
//

import Foundation

class ARModelManager {
    static let shared = ARModelManager()
    
    private let models: [ARModel] = [
        ARModel(id: 0, name: "blackBear", displayName: "Bear"),
        ARModel(id: 1, name: "brownHyena", displayName: "Hyena"),
        ARModel(id: 2, name: "leopard", displayName: "Leopard"),
        ARModel(id: 3, name: "twoToedSloth", displayName: "Sloth")
    ]
    
    func getAllModels() -> [ARModel] {
        return models
    }
    
    func findModel(byVoiceInput input: String) -> ARModel? {
        // Simplify matching logic
        let inputLower = input.lowercased()
        return models.first { model in
            inputLower.contains(model.displayName.lowercased())
        }
    }
}

