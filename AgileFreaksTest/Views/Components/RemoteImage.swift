import SwiftUI

struct RemoteImage: View {
    let url: URL?
    var placeholder: AnyView = AnyView(defaultPlaceholder)

    var body: some View {
        if let url {
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
                        .background(Color.placeholderBackground)
                @unknown default:
                    placeholder
                }
            }
        } else {
            placeholder
        }
    }

    private static var defaultPlaceholder: some View {
        Color.skeletonFill
            .overlay {
                Image(systemName: "film")
                    .font(.title2)
                    .foregroundStyle(.gray)
            }
    }
}
