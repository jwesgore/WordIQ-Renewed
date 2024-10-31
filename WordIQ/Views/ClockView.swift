import SwiftUI

struct ClockView: View {
    
    @ObservedObject var clockVM: ClockViewModel
    
    var body: some View {
        if clockVM.isClockTimer {
            Text(clockVM.formatTimeShort(clockVM.timeRemaining))
        } else {
            Text(clockVM.formatTimeShort(clockVM.timeElapsed))
        }
    }
}

#Preview {
    ClockView(clockVM: ClockViewModel(timeLimit: 60))
}
