import SwiftUI

/// Top down button view
/// Button has the ability to
/// - Change opacity
/// - Change scale
/// - Perform delayed action
struct TopDownButtonView<Content: View>: View {

    @State var isPressed = false
    @State var opacity: Double = 1.0
    
    @ObservedObject var viewModel: TopDownButtonViewModel
    
    let content: Content
    
    init (_ viewModel : TopDownButtonViewModel, @ViewBuilder content: () -> Content) {
        self.viewModel = viewModel
        self.content = content()
    }
    
    var body : some View  {
        Button {
            viewModel.performAction()
        } label: {
            content
                .frame(maxWidth: viewModel.width, maxHeight: viewModel.height)
                .background(
                    RoundedRectangle(cornerRadius: viewModel.cornerRadius)
                        .fill(viewModel.backgroundColor)
                        .stroke(viewModel.borderColor, lineWidth: viewModel.borderThickness)
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .shadow(
                            color: viewModel.hasShadow
                                ? (self.isPressed ? Color.clear : Color.black.opacity(0.3))
                                : Color.clear,
                            radius: viewModel.hasShadow ? 3 : 0,
                            x: viewModel.hasShadow ? 5 : 0,
                            y: viewModel.hasShadow ? 5 : 0
                        )
                )
        }
        .removeDefaultButtonStyle()
        .scaleEffect(isPressed ? viewModel.pressedScale : 1.0)
        .opacity(opacity)
        .animation(.easeInOut(duration: viewModel.animationDuration), value: isPressed)
        .simultaneousGesture(DragGesture(minimumDistance: 0)
            .onChanged { _ in
                self.isPressed = true
                self.opacity = self.viewModel.pressedOpacity
            }
            .onEnded { _ in
                self.isPressed = false
                self.opacity = 1.0
            }
        )
    }
}

#Preview {
    TopDownButtonView(TopDownButtonViewModel(height: 50, width: 300)) {
        Text("Test Text")
            .robotoSlabFont(.title, .regular)
    }
}
