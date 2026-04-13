import SwiftUI

struct PosterCard: View {
    let imageURL: String?
    let width: CGFloat
    let height: CGFloat

    init(
        imageURL: String?,
        width: CGFloat = Design.PosterSize.nowShowingWidth,
        height: CGFloat = Design.PosterSize.nowShowingHeight
    ) {
        self.imageURL = imageURL
        self.width = width
        self.height = height
    }

    var body: some View {
        RemoteImage(
            url: imageURL.flatMap { URL(string: $0) },
            placeholder: AnyView(posterPlaceholder)
        )
        .frame(width: width, height: height)
        .clipShape(RoundedRectangle(cornerRadius: Design.CornerRadius.small))
        .designShadow(Design.Shadows.posterCard)
    }

    private var posterPlaceholder: some View {
        RoundedRectangle(cornerRadius: Design.CornerRadius.small)
            .fill(Color.skeletonFill)
            .overlay {
                Image(systemName: "film")
                    .font(.title2)
                    .foregroundStyle(.gray)
            }
    }
}

#Preview("Placeholder") {
    PosterCard(imageURL: nil)
}

#Preview("Remote image") {
    PosterCard(imageURL: "https://picsum.photos/seed/poster/300/440")
}
