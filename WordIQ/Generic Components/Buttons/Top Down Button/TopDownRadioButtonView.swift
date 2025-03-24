import SwiftUI

struct TopDownRadioButtonView<Content: View> : View {
    
    @ObservedObject var viewModel : TopDownRadioButtonViewModel
    @State var opacity: Double = 1.0
    let content: Content
    
    init(_ viewModel: TopDownRadioButtonViewModel, @ViewBuilder content: () -> Content) {
        self.viewModel = viewModel
        self.content = content()
    }
    
    var body: some View {
        Button {
            viewModel.performAction()
        } label: {
            content
                .frame(maxWidth: viewModel.width, maxHeight: viewModel.height)
                .background(
                    RoundedRectangle(cornerRadius: viewModel.cornerRadius)
                        .fill(viewModel.activeBackgroundColor)
                        .stroke(viewModel.borderColor, lineWidth: viewModel.borderThickness)
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .shadow(color: viewModel.isPressed ? Color.clear : Color.black.opacity(0.3), radius: 3, x: 5, y: 5)
                )
        }
        .removeDefaultButtonStyle()
        .scaleEffect(viewModel.isPressed ? 1.0: viewModel.pressedScale)
        .opacity(opacity)
        .animation(.easeInOut(duration: viewModel.animationDuration), value: viewModel.isPressed)
        .onAppear{
            opacity = viewModel.isPressed ? 1.0 : viewModel.pressedOpacity
        }
        .onChange(of: viewModel.isPressed) {
            opacity = viewModel.isPressed ? 1.0 : viewModel.pressedOpacity
        }
    }
}

struct TopDownRadioButton_Previews: PreviewProvider {
    static var previews: some View {
        let manager = TopDownRadioButtonGroupViewModel()
        let button1 = TopDownRadioButtonViewModel(height: 100, width: 200, groupManager: manager)
        let button2 = TopDownRadioButtonViewModel(height: 100, width: 200, groupManager: manager, isPressed: true)
        let button3 = TopDownRadioButtonViewModel(height: 100, width: 200, groupManager: manager)
        manager.add(button1, button2, button3)
        
        return VStack(spacing: 20) {
            TopDownRadioButtonView(button1) { Text("Button 1") }
            TopDownRadioButtonView(button2) { Text("Button 2") }
            TopDownRadioButtonView(button3) { Text("Button 3") }
        }
        .padding()
        .previewDisplayName("3D Radio Button Preview")
        .previewLayout(.sizeThatFits)
    }
}
