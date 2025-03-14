import SwiftUI

class ClockViewModel: ObservableObject, ClockViewModelObserver {
    
    // MARK: Properties
    var isClockActive = false
    var isClockTimer: Bool

    var observers = [ClockViewModelObserver]()
    
    @Published var timeElapsed: Int
    var timeLimit: Int
    @Published var timeRemaining: Int
    var timer: Timer?
    
    // MARK: Initializers
    /// Base initializer
    init (timeLimit: Int, isClockTimer: Bool = true) {
        self.timeElapsed = 0
        self.isClockActive = false
        
        self.timeLimit = timeLimit
        self.timeRemaining = timeLimit
        self.isClockTimer = isClockTimer
    }
    
    /// Save state initializer
    init (_ clockState : ClockSaveStateModel) {
        self.isClockActive = false
        self.isClockTimer = clockState.isClockTimer
        
        self.timeElapsed = clockState.timeElapsed
        self.timeLimit = clockState.timeLimit
        self.timeRemaining = clockState.timeRemaining
    }
    
    // MARK: Adjust Time Functions
    /// Add some amount of time to the clock
    func addTime(_ seconds: Int) -> Void {
        self.timeRemaining += seconds
    }
    
    /// Remove some amount of time from the clock
    func removeTime(_ seconds: Int) -> Void {
        self.timeRemaining -= seconds
    }
    
    // MARK: Clock Controls
    /// Resets the clock back to start values
    func resetClock(withStart: Bool = false) -> Void {
        if self.isClockActive { self.stopClock() }
        
        self.timeRemaining = self.timeLimit
        self.timeElapsed = 0
        
        if withStart { self.startClock() }
    }
    
    /// Starts the clock
    func startClock() -> Void {
        self.isClockActive = true
        
        if self.isClockTimer {
            self.timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
                if self.timeRemaining > 0 {
                    self.timeElapsed += 1
                    self.timeRemaining -= 1
                } else {
                    self.stopClock()
                    self.timerAtZero()
                }
            }
        } else {
            self.timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
                self.timeElapsed += 1
            }
        }
    }
    
    /// Stops the clock
    func stopClock() -> Void {
        if self.isClockActive {
            self.isClockActive = false
            self.timer?.invalidate()
        }
    }
    
    // MARK: ClockViewModelObserver Functions
    /// Adds an observer to the collection of observers
    func addObserver(_ observer: ClockViewModelObserver) {
        self.observers.append(observer)
    }
    
    /// Send signal to observers that time remaining has hit 0
    func timerAtZero() {
        self.observers.forEach { $0.timerAtZero() }
    }
    
    // MARK: Data Functions
    /// Get Clock Save State
    func getClockSaveState() -> ClockSaveStateModel {
        return ClockSaveStateModel(
            isClockTimer: self.isClockTimer,
            timeElapsed: self.timeElapsed,
            timeLimit: self.timeLimit,
            timeRemaining: self.timeRemaining
        )
    }
}

/// Protocol to support ClockViewModel communication
protocol ClockViewModelObserver {
    func timerAtZero()
}
