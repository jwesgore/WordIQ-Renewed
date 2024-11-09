import SwiftUI

/// Stylized 3D button
struct ThreeDButtonView<Content: View>: View {
    
    @ObservedObject var threeDButtonVM : ThreeDButtonViewModel
    @State var offset: CGFloat
    let content: Content
    
    init(_ threeDButtonVM: ThreeDButtonViewModel, @ViewBuilder content: () -> Content) {
        self.threeDButtonVM = threeDButtonVM
        self.offset = threeDButtonVM.depth
        self.content = content()
    }
    
    var body: some View {
        Button(
            action: {
                threeDButtonVM.PerformAction()
            }, label: {
                ZStack {
                    content
                        .frame(maxWidth:threeDButtonVM.width, maxHeight: threeDButtonVM.height)
                        .background(
                            RoundedRectangle(cornerRadius: threeDButtonVM.cornerRadius)
                                .fill(threeDButtonVM.backgroundColor)
                                .stroke(threeDButtonVM.borderColor, lineWidth: threeDButtonVM.borderThickness)
                        )
                        .offset(CGSize(width: 0.0, height: self.offset))
                        .zIndex(threeDButtonVM.zindex + 10.0)
                    
                    RoundedRectangle(cornerRadius: threeDButtonVM.cornerRadius)
                        .fill(threeDButtonVM.shadowColor)
                        .stroke(threeDButtonVM.borderColor, lineWidth: threeDButtonVM.borderThickness)
                        .frame(maxWidth: threeDButtonVM.width, maxHeight: threeDButtonVM.height)
                        .zIndex(threeDButtonVM.zindex)
                }
            }
        )
        .buttonStyle(NoAnimation())
        .simultaneousGesture(DragGesture(minimumDistance: 0)
            .onChanged { _ in
                withAnimation(.easeInOut(duration: threeDButtonVM.speed)) {
                    self.offset = 0.0
                }
            }
            .onEnded { _ in
                withAnimation(.easeInOut(duration: threeDButtonVM.speed)) {
                    self.offset = threeDButtonVM.depth
                }
            }
        )
    }
}

/// Removes animation from button
struct NoAnimation: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
    }
}

#Preview {
    ThreeDButtonView(ThreeDButtonViewModel(height: 100, width: 200, action: {})) {
        Text("Hello")
    }
}
