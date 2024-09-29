//
//  TrailingIconLabelStyle.swift
//  Scrumdinger
//
//  Created by 이태호 on 2024/09/25.
//

import SwiftUI

struct TrailingIconLableStyle: LabelStyle {
    func makeBody(configuration: Configuration) -> some View {
        HStack {
            configuration.title
            configuration.icon
        }
    }
}

extension LabelStyle where Self == TrailingIconLableStyle {
    static var trailingIcon: Self { Self() }
}
