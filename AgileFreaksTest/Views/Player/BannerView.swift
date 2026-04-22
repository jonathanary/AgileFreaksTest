import SwiftUI

struct BannerView: View {
    let title: String
    let buttonText: String
    @State var ticker: String
    let seeMore: () -> Void
    var body: some View {
        VStack(alignment: .leading, spacing: .zero) {
            HStack {
                Text(title)
                Button(action: seeMore) {
                    Text(buttonText)
                }
                .buttonStyle(.bordered)
            }
            Text(ticker)
        }
        .frame(width: 200, height: 100)
        .background(.white) // Maybe gradient
    }
}

#Preview {
    BannerView(title: "Title", buttonText: "Grab yours now", ticker: "12", seeMore: {})
}
