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
        VStack(alignment: .leading, spacing: 10) {
            if let title = lookupResult.def.first?.text.capitalized {
                HStack(alignment: .bottom, spacing: 10) {
                    Text(title)
                        .font(FontsProvider.garamond(58, relativeTo: .largeTitle, weight: .bold))
                        .lineLimit(2)
                        .minimumScaleFactor(0.5)
                        .frame(maxWidth: proxy.size.width / 2, alignment: .leading)
                }
            }
        }
    }
}

//#Preview {
//    DictionaryEntryView(lookupResult: .fromMockFile())
//}
