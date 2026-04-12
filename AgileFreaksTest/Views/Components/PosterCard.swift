import SwiftUI

struct PosterCard: View {
    let imageURL: String?
    let width: CGFloat
    let height: CGFloat

    init(imageURL: String?, width: CGFloat = 143, height: CGFloat = 212) {
        self.imageURL = imageURL
        self.width = width
        self.height = height
    }

    private var resolvedURL: URL? {
        imageURL.flatMap { URL(string: $0) }
    }

    var body: some View {
        Group {
            if let url = resolvedURL {
                AsyncImage(url: url) { phase in
                    switch phase {
                    case .success(let image):
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                    case .failure:
                        placeholder
                    case .empty:
                        ProgressView()
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                            .background(Color.gray.opacity(0.1))
                    @unknown default:
                        placeholder
                    }
                }
            } else {
                placeholder
            }
        }
        .frame(width: width, height: height)
        .clipShape(RoundedRectangle(cornerRadius: 5))
    }

    private var placeholder: some View {
        RoundedRectangle(cornerRadius: 5)
            .fill(Color.gray.opacity(0.2))
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
