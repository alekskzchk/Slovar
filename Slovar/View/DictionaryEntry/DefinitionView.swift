//
//  DefinitionView.swift
//  Slovar
//
//  Created by Алексей Козачук on 07.09.2025.
//

import SwiftUI

struct DefinitionView: View {
    var lookupResult: LookupResult
    var proxy: GeometryProxy
    var body: some View {
            if let title = lookupResult.def.first?.text.capitalized {
                    Text(title)
                        .font(FontsProvider.garamond(58, relativeTo: .largeTitle, weight: .bold))
                        .minimumScaleFactor(0.3)
                        .lineLimit(1)
                        .fixedSize(horizontal: true, vertical: false)
            }
    }
}

#Preview {
    DictionaryEntryView(lookupResult: .fromMockFile())
}
