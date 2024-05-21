//
//  PageLayout.swift
//  VeloMapWwa
//
//  Created by Dawid Czmyr on 19/05/2024.
//

import SwiftUI

struct PageLayout<Content: View>: View {
    var showBackButton: Bool
    var onBackClick: (() -> Void)?
    var content: () -> Content
    @State private var topSafeAreaInset: CGFloat = 0.0

    init(showBackButton: Bool, onBackClick: (() -> Void)? = nil, @ViewBuilder content: @escaping () -> Content) {
        self.showBackButton = showBackButton
        self.onBackClick = onBackClick
        self.content = content
    }

    var body: some View {
        VStack(spacing: 0) {
            ZStack {
                Color.customNavyBlue
                    .edgesIgnoringSafeArea(.top)
                if showBackButton {
                    HStack {
                        Button(action: {
                            onBackClick?()
                        }) {
                            Image(systemName: "arrow.left")
                                .foregroundColor(.white)
                                .padding(.leading, 16)
                        }
                        Spacer()
                    }
                    .frame(height: 44)
                    .padding(.top, topSafeAreaInset)
                }
            }
            .frame(height: 40 + topSafeAreaInset)
            .background(Color.customNavyBlue)

            content()
                .edgesIgnoringSafeArea(.bottom)

            Spacer(minLength: 0)
        }
        .navigationBarBackButtonHidden(true)
        .onAppear {
            updateSafeAreaInsets()
        }
        .edgesIgnoringSafeArea(.top)
    }

    private func updateSafeAreaInsets() {
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
            if let window = windowScene.windows.first {
                topSafeAreaInset = window.safeAreaInsets.top
            }
        }
    }
}

#Preview {
    PageLayout(showBackButton: false, onBackClick: {}, content: {
        VStack {
            Text("Hello, World!")
        }

    })
}
