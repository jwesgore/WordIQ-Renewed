import SwiftUI

/// 3D Button with Radio behavior
struct ThreeDRadioButtonView<Content: View>: View {
    
    @ObservedObject var threeDButtonVM : ThreeDRadioButtonViewModel
    @State var offset: CGFloat
    let content: Content
    
    init(_ threeDButtonVM: ThreeDRadioButtonViewModel, @ViewBuilder content: () -> Content) {
        self.threeDButtonVM = threeDButtonVM
        self.offset = threeDButtonVM.depth
        self.content = content()
    }
    
    var body: some View {
        Button {
            threeDButtonVM.performAction()
        } label: {
            ZStack {
                RoundedRectangle(cornerRadius: threeDButtonVM.cornerRadius)
                    .fill(threeDButtonVM.shadowColor)
                    .stroke(threeDButtonVM.borderColor, lineWidth: threeDButtonVM.borderThickness)
                    .frame(maxWidth: threeDButtonVM.width, maxHeight: threeDButtonVM.height)
                    .shadow(color: threeDButtonVM.isPressed ? Color.clear : Color.black.opacity(0.3), radius: 5, x: 5, y: 5)
                
                content
                    .frame(maxWidth:threeDButtonVM.width, maxHeight: threeDButtonVM.height)
                    .background(
                        RoundedRectangle(cornerRadius: threeDButtonVM.cornerRadius)
                            .fill(threeDButtonVM.activeBackgroundColor)
                            .stroke(threeDButtonVM.borderColor, lineWidth: threeDButtonVM.borderThickness)
                    )
                    .offset(CGSize(width: 0.0, height: self.offset))

            }
        }
        .removeDefaultButtonStyle()
        .onAppear{
            self.offset = threeDButtonVM.isPressed ? 0.0 : threeDButtonVM.depth
        }
        .onChange(of: threeDButtonVM.isPressed) {
            self.offset = threeDButtonVM.isPressed ? 0.0 : threeDButtonVM.depth
        }
    }
}

struct ThreeDRadioButtonView_Previews: PreviewProvider {
    static var previews: some View {
        let manager = ThreeDRadioButtonGroupViewModel()
        let button1 = ThreeDRadioButtonViewModel(height: 100, width: 200, groupManager: manager)
        let button2 = ThreeDRadioButtonViewModel(height: 100, width: 200, groupManager: manager)
        manager.add(button1, button2)
        
        return VStack(spacing: 20) {
            ThreeDRadioButtonView(button1) { Text("Button 1") }
            ThreeDRadioButtonView(button2) { Text("Button 2") }
        }
        .padding()
        .previewDisplayName("3D Radio Button Preview")
        .previewLayout(.sizeThatFits)
    }
}

struct InnerShadowModifier: ViewModifier {
    var color: Color
    var radius: CGFloat
    var x: CGFloat
    var y: CGFloat

    func body(content: Content) -> some View {
        content
            .overlay(
                RoundedRectangle(cornerRadius: 25)
                    .stroke(color, lineWidth: 1)
                    .shadow(color: color, radius: radius, x: x, y: y)
                    .mask(RoundedRectangle(cornerRadius: 25).fill(LinearGradient(gradient: Gradient(colors: [.black, .white]), startPoint: .topLeading, endPoint: .center)))
                    .blur(radius: radius)
                    .offset(x: x, y: y)
            )
    }
}

extension View {
    func innerShadow(color: Color, radius: CGFloat, x: CGFloat, y: CGFloat) -> some View {
        self.modifier(InnerShadowModifier(color: color, radius: radius, x: x, y: y))
    }
}
