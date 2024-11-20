//
//  MicrophoneButton.swift
//  SkullAR
//
//  Created by ILB on 20/11/24.
//

import SwiftUI

struct MicrophoneButton: View {
    let isRecording: Bool
    let geometry: GeometryProxy
    let action: () -> Void
    
    private var buttonSize: CGFloat {
        min(geometry.size.width * 0.2, geometry.size.height * 0.1)
    }
    
    private var iconSize: CGFloat {
        buttonSize * 0.4
    }
    
    var body: some View {
        VStack {
            Button(action: action) {
                ZStack {
                    Circle()
                        .fill(Color.white.opacity(0.2))
                        .frame(width: buttonSize, height: buttonSize)
                        .shadow(radius: 5)
                    
                    if isRecording {
                        Image(systemName: "waveform")
                            .resizable()
                            .scaledToFit()
                            .foregroundColor(.white)
                            .frame(width: iconSize, height: iconSize)
                    } else {
                        Image(systemName: "mic.fill")
                            .resizable()
                            .scaledToFit()
                            .foregroundColor(.white)
                            .frame(width: iconSize, height: iconSize)
                    }
                }
            }
            
            if isRecording {
                Text("Listening...")
                    .foregroundColor(.white)
                    .font(.system(size: geometry.size.height * 0.018))
                    .padding(.top, 8)
                    .shadow(radius: 2)
            }
        }
    }
}
