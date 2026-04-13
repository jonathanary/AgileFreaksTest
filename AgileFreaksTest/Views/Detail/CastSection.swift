import Foundation
import SwiftUI

struct CastSection: View {
    let characters: CharacterConnection?
    private static let titleSize: CGFloat = 16

    var body: some View {
        if let edges = characters?.edges, !edges.isEmpty {
            VStack(alignment: .leading, spacing: 12) {
                HStack(alignment: .center) {
                    Text("Cast")
                        .font(.merriweatherFixed(size: Self.titleSize, weight: .bold))
                        .foregroundStyle(Color.standardSectionTitle)
                        .tracking(Self.titleSize * 0.02)
                        .lineSpacing(0)

                    Spacer(minLength: 8)

                    SectionSeeMoreButton()
                }

                ScrollView(.horizontal, showsIndicators: false) {
                    LazyHStack(alignment: .top, spacing: 16) {
                        ForEach(edges, id: \.node?.id) { edge in
                            if let character = edge.node {
                                CastCard(character: character, voiceActor: edge.voiceActors?.first)
                            }
                        }
                    }
                }
            }
        }
    }
}

private struct CastCard: View {
    let character: Character
    let voiceActor: Staff?
    private static let nameTextSize: CGFloat = 12

    private var imageURL: URL? {
        (character.image?.large ?? character.image?.medium).flatMap { URL(string: $0) }
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
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
            .frame(width: 72, height: 72)
            .clipShape(RoundedRectangle(cornerRadius: 5))

            Text(character.name?.full ?? "Unknown")
                .font(.mulishFixed(size: Self.nameTextSize, weight: .regular))
                .foregroundStyle(Color.standardSectionTitle)
                .lineLimit(2)
                .multilineTextAlignment(.leading)
                .frame(width: 80, alignment: .topLeading)
        }
        .frame(width: 80, alignment: .topLeading)
    }

    private var placeholder: some View {
        Color.gray.opacity(0.2)
            .overlay {
                Image(systemName: "person.fill")
                    .foregroundStyle(.gray)
            }
    }
}

#Preview("Section") {
    CastSection(
        characters: Media.mockDetail.characters
    )
}

#Preview("Cast card") {
    if let character = Media.mockDetail.characters?.edges?.first?.node {
        CastCard(character: character, voiceActor: nil)
    }
}
