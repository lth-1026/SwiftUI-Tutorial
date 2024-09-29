//
//  Theme.swift
//  Scrumdinger
//
//  Created by 이태호 on 2024/09/24.

import SwiftUI


enum Theme: String, CaseIterable, Identifiable, Codable {
    case yellow
    case orange
    case poppy
    case bubblegum
    case buttercup
    case indigo
    case lavender
    case magenta
    case navy
    case oxblood
    case periwinkle
    case purple
    case seafoam
    case sky
    case tan
    case teal

    var accentColor: Color {
        switch self {
        case .bubblegum, .buttercup, .lavender, .orange, .periwinkle, .poppy, .seafoam, .sky, .tan, .teal, .yellow: return .black
        case .indigo, .magenta, .navy, .oxblood, .purple: return .white
        }
    }
    var mainColor: Color {
        Color(rawValue)
    }
    var name: String {
        rawValue.capitalized
    }
    var id: String {
        name
    }
}
