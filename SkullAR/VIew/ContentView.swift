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
    @Environment(\.horizontalSizeClass) private var horizontalSizeClass
    @Environment(\.verticalSizeClass) private var verticalSizeClass
    
    // Dynamic grid columns based on size class
    var columns: [GridItem] {
        horizontalSizeClass == .compact ?
            [GridItem(.flexible()), GridItem(.flexible())] :
            [GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())]
    }
    
    var body: some View {
        NavigationView {
            GeometryReader { geometry in
                ZStack {
                    GeometryReader { geo in
                        Image("background")
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: geo.size.width, height: geo.size.height)
                            .clipped()
                            .ignoresSafeArea(.all)
                    }
                    .ignoresSafeArea(.all)
                    
                    ScrollView {
                        VStack(spacing: geometry.size.height * 0.03) {
                            Text("AR Content - Voice Search")
                                .font(.system(size: geometry.size.height * 0.04))
                                .bold()
                                .padding(.top, geometry.size.height * 0.08)
                                .minimumScaleFactor(0.5)
                            
                            Text("What skull would you like to see? Say one of these word")
                                .font(.system(size: geometry.size.height * 0.025))
                                .multilineTextAlignment(.center)
                                .padding(.horizontal)
                                .minimumScaleFactor(0.5)
                            
                            // Grid of available options
                            LazyVGrid(columns: columns, spacing: geometry.size.width * 0.05) {
                                ForEach(["Bear", "Hyena", "Leopard", "Sloth"], id: \.self) { option in
                                    OptionItemView(text: option, geometry: geometry)
                                }
                            }
                            .padding(.horizontal)
                            
                            if let errorMessage = viewModel.errorMessage {
                                Text(errorMessage)
                                    .foregroundColor(.red)
                                    .font(.system(size: geometry.size.height * 0.02))
                                    .padding()
                            }
                            
                            Text(viewModel.transcript)
                                .font(.system(size: geometry.size.height * 0.02))
                                .foregroundColor(.white)
                                .padding()
                                .animation(.default, value: viewModel.transcript)
                            
                            Spacer(minLength: geometry.size.height * 0.25)
                            
                            MicrophoneButton(
                                isRecording: viewModel.isRecording,
                                geometry: geometry,
                                action: viewModel.toggleRecording
                            )
                            .padding(.bottom, geometry.size.height * 0.08)
                        }
                        .foregroundColor(.white)
                    }
                }
            }
        }
        .quickLookPreview($viewModel.selectedModelURL)
    }
}

struct OptionItemView: View {
    let text: String
    let geometry: GeometryProxy
    
    var body: some View {
        Text(text)
            .font(.system(size: geometry.size.height * 0.022))
            .foregroundColor(.white)
            .frame(maxWidth: .infinity)
            .padding(geometry.size.width * 0.03)
            .background(
                RoundedRectangle(cornerRadius: 10)
                    .fill(Color.white.opacity(0.2))
                    .shadow(color: .black.opacity(0.2), radius: 5, x: 0, y: 2)
            )
            .frame(height: geometry.size.height * 0.06)
    }
}


#Preview {
    ContentView()
}
