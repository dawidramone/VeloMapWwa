//
//  View+Extension.swift
//  VeloMapWwa
//
//  Created by Dawid Czmyr on 21/05/2024.
//

import SwiftUI

extension View {
    func bottomShadow(color: Color = .black, radius: CGFloat = 5, x: CGFloat = 0, y: CGFloat = 5) -> some View {
        modifier(BottomShadow(color: color, radius: radius, x: x, y: y))
    }
}
