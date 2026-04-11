import SwiftUI

struct GenreTag: View {
    let title: String

    var body: some View {
        Text(title.uppercased())
            .font(.caption2)
            .fontWeight(.semibold)
            .foregroundStyle(Color.accentColor)
            .padding(.horizontal, 10)
            .padding(.vertical, 4)
            .background(
                Capsule()
                    .stroke(Color.accentColor, lineWidth: 1)
            )
    }
}

#Preview {
    HStack {
        GenreTag(title: "Action")
        GenreTag(title: "Fantasy")
        GenreTag(title: "Horror")
    }
}
