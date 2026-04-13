import SwiftUI

struct GenreTag: View {
    let title: String
    private static let fontSize: CGFloat = 8

    var body: some View {
        Text(title.uppercased())
            .font(.mulishFixed(size: Self.fontSize, weight: .bold))
            .foregroundStyle(Color.genreTagText)
            .padding(.horizontal, 10)
            .padding(.vertical, 4)
            .background(
                Capsule()
                    .fill(Color.genreTagBackground)
            )
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
