import SwiftUI

struct SkeletonRect: View {
    let width: CGFloat?
    let height: CGFloat
    var cornerRadius: CGFloat = Design.CornerRadius.medium
    var showSpinner: Bool = false
    var color: Color = .skeletonFill

    var body: some View {
        RoundedRectangle(cornerRadius: cornerRadius)
            .fill(color)
            .frame(width: width, height: height)
            .overlay {
                if showSpinner { ProgressView() }
            }
    }
}
