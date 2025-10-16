//
//  FontBook.swift
//  Slovar
//
//  Created by Алексей Козачук on 07.09.2025.
//
import SwiftUI

enum FontsProvider {
    private static let garamond = "EBGaramond-Regular"
    private static let garamondItalic = "EBGaramond-Italic"
    
    static func garamond(_ size: CGFloat, relativeTo: Font.TextStyle, weight: Font.Weight = .regular, italic: Bool = false) -> Font {
        Font.custom(italic ? garamondItalic : garamond, size: size, relativeTo: relativeTo).weight(weight)
    }
}
