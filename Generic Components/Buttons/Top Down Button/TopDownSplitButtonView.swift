import SwiftUI

struct TopDownSplitButtonView : View {
    
    @State var isPressed1: Bool = false
    @State var isPressed2: Bool = false

    @State var opacity1: CGFloat = 1.0
    @State var opacity2: CGFloat = 1.0
    
    let height: CGFloat = 40
    let width: CGFloat = 100
    
    var body: some View {
        HStack (spacing: 0) {
            Button {
                
            } label: {
                Text("Test 1")
                    .frame(maxWidth: width, maxHeight: height)
                    .background(
                        UnevenRoundedRectangle(cornerRadii: .init(topLeading: 25.0, bottomLeading: 25.0))
                            .fill(Color.cyan)
                            .stroke(.black, lineWidth: 1.0)
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                            .shadow(color: self.isPressed1 ? Color.clear : Color.black.opacity(0.3), radius: 3, x: 5, y: 5)
                    )
            }
            .removeDefaultButtonStyle()
            .scaleEffect(isPressed1 ? 0.9 : 1.0)
            .opacity(opacity1)
            .animation(.easeInOut(duration: 0.1), value: isPressed1)
            .simultaneousGesture(DragGesture(minimumDistance: 0)
                .onChanged { _ in
                    self.isPressed1 = true
                    self.opacity1 = 0.5
                }
                .onEnded { _ in
                    self.isPressed1 = false
                    self.opacity1 = 1.0
                }
            )
            
            Button {
                
            } label: {
                Text("Test 1")
                    .frame(maxWidth: width, maxHeight: height)
                    .background(
                        UnevenRoundedRectangle(cornerRadii: .init(bottomTrailing: 25.0, topTrailing: 25.0))
                            .fill(Color.cyan)
                            .stroke(.black, lineWidth: 1.0)
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                            .shadow(color: self.isPressed1 ? Color.clear : Color.black.opacity(0.3), radius: 3, x: 5, y: 5)
                    )
            }
            .removeDefaultButtonStyle()
            .scaleEffect(isPressed2 ? 0.9 : 1.0)
            .opacity(opacity2)
            .animation(.easeInOut(duration: 0.1), value: isPressed2)
            .simultaneousGesture(DragGesture(minimumDistance: 0)
                .onChanged { _ in
                    self.isPressed2 = true
                    self.opacity2 = 0.5
                }
                .onEnded { _ in
                    self.isPressed2 = false
                    self.opacity2 = 1.0
                }
            )
        }
    }
}


#Preview {
    TopDownSplitButtonView()
}
