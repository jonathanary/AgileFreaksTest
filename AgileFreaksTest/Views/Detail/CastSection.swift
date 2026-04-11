import SwiftUI

struct CastSection: View {
    let characters: CharacterConnection?

    var body: some View {
        if let edges = characters?.edges, !edges.isEmpty {
            VStack(alignment: .leading, spacing: 12) {
                SectionHeader(title: "Cast")

                ScrollView(.horizontal, showsIndicators: false) {
                    LazyHStack(spacing: 16) {
                        ForEach(edges, id: \.node?.id) { edge in
                            if let character = edge.node {
                                CastCard(character: character, voiceActor: edge.voiceActors?.first)
                            }
                        }
                    }
                    .padding(.horizontal)
                }
            }
        }
    }
}

private struct CastCard: View {
    let character: Character
    let voiceActor: Staff?

    private var imageURL: URL? {
        (character.image?.large ?? character.image?.medium).flatMap { URL(string: $0) }
    }

    var body: some View {
        VStack(spacing: 6) {
            Group {
                if let url = imageURL {
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
            .frame(width: 80, height: 80)
            .clipShape(RoundedRectangle(cornerRadius: 12))

            Text(character.name?.full ?? "Unknown")
                .font(.caption)
                .fontWeight(.medium)
                .foregroundStyle(.primary)
                .lineLimit(2)
                .multilineTextAlignment(.center)
                .frame(width: 80)
        }
    }

    private var placeholder: some View {
        Color.gray.opacity(0.2)
            .overlay {
                Image(systemName: "person.fill")
                    .foregroundStyle(.gray)
            }
    }
}
