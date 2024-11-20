//
//  ContentView.swift
//  SkullAR
//
//  Created by ILB on 20/11/24.
//

import SwiftUI
import QuickLook

struct ContentView: View {
    @StateObject private var viewModel = ContentViewModel()
    
    let columns = [
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    
    var body: some View {
        NavigationView {
            ZStack {
                Image("background")
                    .resizable()
                    .scaledToFill()
                    .edgesIgnoringSafeArea(.all)
                
                VStack(spacing: 30) {
                    Text("AR Content - Voice Search")
                        .font(.title)
                        .bold()
                        .padding(.top, 120)
                    
                    Text("What skull would you like to see?      Say one of these word")
                        .font(.title2)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal)
                    
                    // Grid of available options
                    LazyVGrid(columns: columns, spacing: 20) {
                        ForEach(["Bear", "Hyena", "Leopard", "Sloth"], id: \.self) { option in
                            Text(option)
                                .font(.headline)
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color.white.opacity(0.2))
                                .cornerRadius(10)
                        }
                    }
                    .padding(.horizontal)
                    
                    if let errorMessage = viewModel.errorMessage {
                        Text(errorMessage)
                            .foregroundColor(.red)
                            .padding()
                    }
                    
                    Text(viewModel.transcript)
                        .font(.body)
                        .foregroundColor(.white)
                        .padding()
                        .animation(.default, value: viewModel.transcript)
                    
                    Spacer()
                    
                    MicrophoneButton(isRecording: viewModel.isRecording) {
                        viewModel.toggleRecording()
                    }
                    .padding(.bottom, 100)
                }
                .foregroundColor(.white)
            }
        }
        .quickLookPreview($viewModel.selectedModelURL)
    }
}


struct OptionItemView: View {
    let text: String
    
    var body: some View {
        Text(text)
            .font(.headline)
            .foregroundColor(.white)
            .frame(maxWidth: .infinity)
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 10)
                    .fill(Color.white.opacity(0.2))
                    .shadow(color: .black.opacity(0.2), radius: 5, x: 0, y: 2)
            )
    }
}


#Preview {
    ContentView()
}
