//
//  ShakeEffect.swift
//  MultiplicationTable
//
//  Created by Алексей Козачук on 06.03.2025.
//

import SwiftUI

struct ShakeEffect: GeometryEffect {
    var animatableData: CGFloat
    
    func effectValue(size: CGSize) -> ProjectionTransform {
        let translation = sin(animatableData * .pi * 5) * 5
        return ProjectionTransform(CGAffineTransform(translationX: translation, y: 0))
    }
}
