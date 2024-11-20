//
//  MicrophoneButton.swift
//  SkullAR
//
//  Created by ILB on 20/11/24.
//

import SwiftUI

struct MicrophoneButton: View {
    let isRecording: Bool
    let action: () -> Void
    
    var body: some View {
        VStack {
            Button(action: action) {
                ZStack {
                    Circle()
                        .fill(Color.white.opacity(0.2))
                        .frame(width: 80, height: 80)
                        .shadow(radius: 5)
                    
                    if isRecording {
                        Image(systemName: "waveform")  
                            .resizable()
                            .scaledToFit()
                            .foregroundColor(.white)
                            .frame(width: 30, height: 30)
                    } else {
                        Image(systemName: "mic.fill")
                            .resizable()
                            .scaledToFit()
                            .foregroundColor(.white)
                            .frame(width: 30, height: 30)
                    }
                }
            }
            
            if isRecording {
                Text("Listening...")
                    .foregroundColor(.white)
                    .font(.subheadline)
                    .padding(.top, 8)
                    .shadow(radius: 2)
            }
        }
    }
}
