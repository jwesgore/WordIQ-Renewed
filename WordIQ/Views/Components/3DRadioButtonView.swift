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
        Button(
            action: {
                threeDButtonVM.PerformAction()
            }, label: {
                ZStack {
                    content
                        .frame(maxWidth:threeDButtonVM.width, maxHeight: threeDButtonVM.height)
                        .background(
                            RoundedRectangle(cornerRadius: threeDButtonVM.cornerRadius)
                                .fill(threeDButtonVM.buttonIsPressed ? threeDButtonVM.selectedBackgroundColor : threeDButtonVM.backgroundColor)
                                .stroke(threeDButtonVM.borderColor, lineWidth: threeDButtonVM.borderThickness)
                        )
                        .offset(CGSize(width: 0.0, height: self.offset))
                        .zIndex(threeDButtonVM.zindex + 1.0)
                    
                    RoundedRectangle(cornerRadius: threeDButtonVM.cornerRadius)
                        .fill(threeDButtonVM.shadowColor)
                        .stroke(threeDButtonVM.borderColor, lineWidth: threeDButtonVM.borderThickness)
                        .frame(maxWidth: threeDButtonVM.width, maxHeight: threeDButtonVM.height)
                        .zIndex(threeDButtonVM.zindex)
                }
            }
        )
        .buttonStyle(NoAnimation())
        .onAppear{
            DispatchQueue.main.asyncAfter(deadline: .now() + threeDButtonVM.delay) {
                self.offset = threeDButtonVM.buttonIsPressed ? 0.0 : threeDButtonVM.depth
            }
        }
        .onChange(of: threeDButtonVM.buttonIsPressed) {
            withAnimation(.easeInOut(duration: threeDButtonVM.speed)) {
                self.offset = threeDButtonVM.buttonIsPressed ? 0.0 : threeDButtonVM.depth
            }
        }
    }
}

struct MyView_Previews: PreviewProvider {
    static var previews: some View {
        let manager = ThreeDRadioButtonGroupViewModel()
        let button1 = ThreeDRadioButtonViewModel(groupManager: manager, height: 100, width: 200)
        let button2 = ThreeDRadioButtonViewModel(groupManager: manager, height: 100, width: 200)
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
