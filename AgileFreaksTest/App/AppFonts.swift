import SwiftUI
import UIKit

extension Font {
    /// Optical-size static Merriweather (36pt) — PostScript names match bundled `Merriweather_36pt-*.ttf` faces.
    enum MerriweatherWeight {
        case regular
        case medium
        case semibold
        case bold

        var postScriptName: String {
            switch self {
            case .regular: "Merriweather36pt-Regular"
            case .medium: "Merriweather36pt-Medium"
            case .semibold: "Merriweather36pt-SemiBold"
            case .bold: "Merriweather36pt-Bold"
            }
        }
    }

    static func merriweather(_ style: Font.TextStyle, weight: MerriweatherWeight = .regular) -> Font {
        let uiStyle = style.uiTextStyle
        let traits = UITraitCollection(preferredContentSizeCategory: .large)
        let ui = UIFont.preferredFont(forTextStyle: uiStyle, compatibleWith: traits)
        return Font.custom(weight.postScriptName, size: ui.pointSize, relativeTo: style)
    }
}

extension Font.TextStyle {
    var uiTextStyle: UIFont.TextStyle {
        switch self {
        case .largeTitle: .largeTitle
        case .title: .title1
        case .title2: .title2
        case .title3: .title3
        case .headline: .headline
        case .body: .body
        case .callout: .callout
        case .subheadline: .subheadline
        case .footnote: .footnote
        case .caption: .caption1
        case .caption2: .caption2
        @unknown default: .body
        }
    }
}
