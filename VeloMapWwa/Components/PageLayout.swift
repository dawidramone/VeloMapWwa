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
                    .padding(.top, UIApplication.shared.windows.first?.safeAreaInsets.top)
                }
            }
            .frame(height: 44 + (UIApplication.shared.windows.first?.safeAreaInsets.top ?? 0))
            .background(Color.customNavyBlue)

            content()
                .edgesIgnoringSafeArea(.bottom)

            Spacer(minLength: 0)
        }
        .edgesIgnoringSafeArea(.top)
    }
}

#Preview {
    PageLayout(showBackButton: false, onBackClick: {}, content: {
        VStack {
            Text("Hello, World!")
            Text("Hello, World!")
        }

    })
}
