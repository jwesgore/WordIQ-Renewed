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
                threeDButtonVM.performAction()
            }, label: {
                ZStack {
                    RoundedRectangle(cornerRadius: threeDButtonVM.cornerRadius)
                        .fill(threeDButtonVM.shadowColor)
                        .stroke(threeDButtonVM.borderColor, lineWidth: threeDButtonVM.borderThickness)
                        .frame(maxWidth: threeDButtonVM.width, maxHeight: threeDButtonVM.height)
                        .shadow(color: self.offset == 0.0 ? Color.clear : Color.black.opacity(0.3), radius: 5, x: 5, y: 5)
                        
                    content
                        .frame(maxWidth:threeDButtonVM.width, maxHeight: threeDButtonVM.height)
                        .background(
                            RoundedRectangle(cornerRadius: threeDButtonVM.cornerRadius)
                                .fill(threeDButtonVM.backgroundColor)
                                .stroke(threeDButtonVM.borderColor, lineWidth: threeDButtonVM.borderThickness)
                        )
                        .offset(CGSize(width: 0.0, height: self.offset))
                }
            }
        )
        .removeDefaultButtonStyle()
        .simultaneousGesture(DragGesture(minimumDistance: 0)
            .onChanged { _ in
                self.offset = 0.0
            }
            .onEnded { _ in
                self.offset = threeDButtonVM.depth
            }
        )
    }
}

//#Preview {
//    ThreeDButtonView(ThreeDButtonViewModel(height: 100, width: 200, action: {}, speed: 0.02)) {
//        Text("Hello")
//    }
//}
