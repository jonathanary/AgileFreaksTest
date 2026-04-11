import SwiftUI

struct PosterCard: View {
    let imageURL: String?
    let width: CGFloat
    let height: CGFloat

    init(imageURL: String?, width: CGFloat = 150, height: CGFloat = 220) {
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
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }

    private var placeholder: some View {
        RoundedRectangle(cornerRadius: 12)
            .fill(Color.gray.opacity(0.2))
            .overlay {
                Image(systemName: "film")
                    .font(.title2)
                    .foregroundStyle(.gray)
            }
    }
}

#Preview {
    PosterCard(imageURL: nil)
}
