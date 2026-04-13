import SwiftUI

enum Design {

    // MARK: - Spacing

    enum Spacing {
        static let xxs: CGFloat = 4
        static let xs: CGFloat = 6
        static let sm: CGFloat = 8
        static let md: CGFloat = 12
        static let lg: CGFloat = 16
        static let xl: CGFloat = 20
        static let xxl: CGFloat = 24
    }

    // MARK: - Corner Radii

    enum CornerRadius {
        static let small: CGFloat = 5
        static let medium: CGFloat = 12
        static let large: CGFloat = 24
    }

    // MARK: - Poster / Card Sizing

    enum PosterSize {
        static let nowShowingWidth: CGFloat = 143
        static let nowShowingHeight: CGFloat = 212
        static let popularWidth: CGFloat = 85
        static let popularHeight: CGFloat = 128
        static let castAvatar: CGFloat = 72
        static let castNameWidth: CGFloat = 80
    }

    // MARK: - Banner

    enum Banner {
        static let height: CGFloat = 300
        static let playIconSize: CGFloat = 45
    }

    // MARK: - Shadow

    struct ShadowStyle {
        let color: Color
        let radius: CGFloat
        let offsetX: CGFloat
        let offsetY: CGFloat
    }

    enum Shadows {
        static let posterCard = ShadowStyle(color: .black.opacity(0.18), radius: 8, offsetX: 0, offsetY: 4)
        static let playTrailer = ShadowStyle(color: .black.opacity(0.5), radius: 4, offsetX: 0, offsetY: 2)
    }

    // MARK: - Typography

    static let letterSpacingRatio: CGFloat = 0.02

    enum FontSize {
        static let genreTag: CGFloat = 8
        static let seeMore: CGFloat = 10
        static let caption: CGFloat = 12
        static let body: CGFloat = 14
        static let sectionDescription: CGFloat = 16
        static let movieTitle: CGFloat = 20
        static let sectionTitle: CGFloat = 21
    }

    // MARK: - InfoColumn

    enum InfoColumn {
        static let minWidth: CGFloat = 109
    }

    // MARK: - Skeleton

    enum Skeleton {
        static let titleWidth: CGFloat = 120
        static let titleHeight: CGFloat = 14
        static let subtitleWidth: CGFloat = 80
        static let subtitleHeight: CGFloat = 12
        static let textCornerRadius: CGFloat = 4
        static let popularPosterWidth: CGFloat = 100
        static let popularPosterHeight: CGFloat = 140
        static let popularTextHeight: CGFloat = 18
        static let genreTagWidth: CGFloat = 56
        static let genreTagHeight: CGFloat = 22
        static let genreTagRadius: CGFloat = 10
        static let skeletonSpacing: CGFloat = 14
        static let loadMoreWidth: CGFloat = 48
    }

    // MARK: - GenreTag

    enum GenreTagStyle {
        static let horizontalPadding: CGFloat = 10
    }

    // MARK: - Error View

    enum ErrorView {
        static let minHeight: CGFloat = 300
    }

    // MARK: - Network

    enum Network {
        static let baseURL = "https://graphql.anilist.co"
        static let timeoutInterval: TimeInterval = 30
        static let perPage = 10
    }
}

extension View {
    func designShadow(_ style: Design.ShadowStyle) -> some View {
        shadow(color: style.color, radius: style.radius, x: style.offsetX, y: style.offsetY)
    }
}
