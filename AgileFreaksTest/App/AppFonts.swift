import SwiftUI
import UIKit

extension Font {
    /// Optical-size static Merriweather (36pt) — PostScript names match bundled `Merriweather_36pt-*.ttf` faces.
    enum MerriweatherWeight {
        case regular
        case medium
        case semibold
        case bold
        case black

        var postScriptName: String {
            switch self {
            case .regular: "Merriweather36pt-Regular"
            case .medium: "Merriweather36pt-Medium"
            case .semibold: "Merriweather36pt-SemiBold"
            case .bold: "Merriweather36pt-Bold"
            case .black: "Merriweather36pt-Black"
            }
        }
    }

    static func merriweather(_ style: Font.TextStyle, weight: MerriweatherWeight = .regular) -> Font {
        let uiStyle = style.uiTextStyle
        let traits = UITraitCollection(preferredContentSizeCategory: .large)
        let ui = UIFont.preferredFont(forTextStyle: uiStyle, compatibleWith: traits)
        return Font.custom(weight.postScriptName, size: ui.pointSize, relativeTo: style)
    }

    /// Fixed optical size (matches design px/pt specs; not scaled to Dynamic Type).
    static func merriweatherFixed(size: CGFloat, weight: MerriweatherWeight) -> Font {
        Font.custom(weight.postScriptName, size: size)
    }

    /// Bundled Mulish static faces (`Mulish-*.ttf`); register in `Info.plist` (`UIAppFonts`).
    enum MulishWeight {
        case regular
        case semibold
        case bold

        var postScriptName: String {
            switch self {
            case .regular: "Mulish-Regular"
            case .semibold: "Mulish-SemiBold"
            case .bold: "Mulish-Bold"
            }
        }
    }

    static func mulishFixed(size: CGFloat, weight: MulishWeight = .regular) -> Font {
        Font.custom(weight.postScriptName, size: size)
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
