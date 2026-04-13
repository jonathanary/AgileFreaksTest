import SwiftUI

struct CastSection: View {
    let cast: [CastMember]

    var body: some View {
        if !cast.isEmpty {
            VStack(alignment: .leading, spacing: Design.Spacing.md) {
                SectionHeaderRow(title: "Cast")

                ScrollView(.horizontal, showsIndicators: false) {
                    LazyHStack(alignment: .top, spacing: Design.Spacing.lg) {
                        ForEach(cast) { member in
                            CastCard(member: member)
                        }
                    }
                }
            }
        }
    }
}

private struct CastCard: View {
    let member: CastMember

    var body: some View {
        VStack(alignment: .leading, spacing: Design.Spacing.xs) {
            RemoteImage(
                url: member.imageURL.flatMap { URL(string: $0) },
                placeholder: AnyView(personPlaceholder)
            )
            .frame(width: Design.PosterSize.castAvatar, height: Design.PosterSize.castAvatar)
            .clipShape(RoundedRectangle(cornerRadius: Design.CornerRadius.small))

            Text(member.name)
                .font(.mulishFixed(size: Design.FontSize.caption, weight: .regular))
                .foregroundStyle(Color.standardSectionTitle)
                .lineLimit(2)
                .multilineTextAlignment(.leading)
                .frame(width: Design.PosterSize.castNameWidth, alignment: .topLeading)
        }
        .frame(width: Design.PosterSize.castNameWidth, alignment: .topLeading)
        .accessibilityElement(children: .combine)
        .accessibilityLabel(member.name)
    }

    private var personPlaceholder: some View {
        Color.skeletonFill
            .overlay {
                Image(systemName: "person.fill")
                    .foregroundStyle(.gray)
            }
    }
}

#Preview("Section") {
    CastSection(cast: Movie.mockDetail.cast)
}
