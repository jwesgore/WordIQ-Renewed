import SwiftUI

struct ClockView: View {
    
    @ObservedObject var clockVM: ClockViewModel
    
    var body: some View {
        if clockVM.isClockTimer {
            Text(TimeUtility.formatTimeShort(clockVM.timeRemaining))
        } else {
            Text(TimeUtility.formatTimeShort(clockVM.timeElapsed))
        }
    }
}

#Preview {
    ClockView(clockVM: ClockViewModel(timeLimit: 60))
}
