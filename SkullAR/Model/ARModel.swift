//
//  ARModel.swift
//  SkullAR
//
//  Created by ILB on 20/11/24.
//

import Foundation

struct ARModel: Identifiable {
    let id: Int
    let name: String
    let displayName: String
    let url: URL?
    
    init(id: Int, name: String, displayName: String) {
        self.id = id
        self.name = name
        self.displayName = displayName
        self.url = Bundle.main.url(forResource: name, withExtension: "usdz")
    }
}
