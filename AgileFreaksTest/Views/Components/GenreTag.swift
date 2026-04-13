import SwiftUI

struct GenreTag: View {
    let title: String

    var body: some View {
        Text(title.uppercased())
            .font(.mulishFixed(size: Design.FontSize.genreTag, weight: .bold))
            .foregroundStyle(Color.genreTagText)
            .padding(.horizontal, Design.GenreTagStyle.horizontalPadding)
            .padding(.vertical, Design.Spacing.xxs)
            .background(
                Capsule()
                    .fill(Color.genreTagBackground)
            )
            .accessibilityLabel("Genre: \(title)")
    }
}

#Preview {
    HStack {
        GenreTag(title: "Action")
        GenreTag(title: "Fantasy")
        GenreTag(title: "Horror")
    }
    .padding()
}
