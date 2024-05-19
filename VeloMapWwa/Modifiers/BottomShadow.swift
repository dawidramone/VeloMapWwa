//
//  BottomShadow.swift
//  VeloMapWwa
//
//  Created by Dawid Czmyr on 19/05/2024.
//

import Foundation

import SwiftUI

struct BottomShadow: ViewModifier {
    var color: Color = .black
    var radius: CGFloat = 5
    var x: CGFloat = 0
    var y: CGFloat = 5

    func body(content: Content) -> some View {
        content
            .shadow(color: color.opacity(0.1), radius: radius, x: x, y: y)
    }
}

extension View {
    func bottomShadow(color: Color = .black, radius: CGFloat = 5, x: CGFloat = 0, y: CGFloat = 5) -> some View {
        modifier(BottomShadow(color: color, radius: radius, x: x, y: y))
    }
}
