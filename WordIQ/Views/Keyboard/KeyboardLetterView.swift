import SwiftUI

struct KeyboardLetterView : View {
    
    @ObservedObject var letterVM : KeyboardLetterViewModel
    
    init(_ letterVM: KeyboardLetterViewModel) {
        self.letterVM = letterVM
    }
    
    var body: some View {
        Button(
            action: { letterVM.PerformAction() },
            label: {
                Text(letterVM.letter.stringValue)
                    .font(.custom(RobotoSlabOptions.Weight.regular, size: CGFloat(RobotoSlabOptions.Size.title2)))
                    .foregroundStyle(letterVM.fontColor)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
        )
        .frame(width:letterVM.width, height: letterVM.height)
        .background(letterVM.backgroundColor.color)
        .overlay(
            RoundedRectangle(cornerRadius: letterVM.cornerRadius)
                .stroke(letterVM.borderColor, lineWidth: letterVM.borderThickness)
        )
        .clipShape(RoundedRectangle(cornerRadius: letterVM.cornerRadius))

    }
}

#Preview {
    VStack {
        HStack{
            KeyboardLetterView(KeyboardLetterViewModel(letter: .A))
            KeyboardLetterView(KeyboardLetterViewModel(letter: .A))
            KeyboardLetterView(KeyboardLetterViewModel(letter: .A))
            KeyboardLetterView(KeyboardLetterViewModel(letter: .A))
            KeyboardLetterView(KeyboardLetterViewModel(letter: .A))
            KeyboardLetterView(KeyboardLetterViewModel(letter: .A))
            KeyboardLetterView(KeyboardLetterViewModel(letter: .A))
            KeyboardLetterView(KeyboardLetterViewModel(letter: .A))
            KeyboardLetterView(KeyboardLetterViewModel(letter: .A))
            KeyboardLetterView(KeyboardLetterViewModel(letter: .A))
        }
        HStack{
            KeyboardLetterView(KeyboardLetterViewModel(letter: .A))
            KeyboardLetterView(KeyboardLetterViewModel(letter: .A))
            KeyboardLetterView(KeyboardLetterViewModel(letter: .A))
            KeyboardLetterView(KeyboardLetterViewModel(letter: .A))
            KeyboardLetterView(KeyboardLetterViewModel(letter: .A))
            
        }
        HStack{
            KeyboardLetterView(KeyboardLetterViewModel(letter: .A))
            KeyboardLetterView(KeyboardLetterViewModel(letter: .A))
        }
    }
}
