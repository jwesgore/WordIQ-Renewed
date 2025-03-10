import SwiftUI

class ClockViewModel: ObservableObject, ClockViewModelObserver {
    
    // MARK: Action Properties
    var timeLimit: Int
    @Published var timeRemaining: Int
    @Published var timeElapsed: Int
    var isClockActive: Bool
    var isClockTimer: Bool
    var timer: Timer?
    var observers: [ClockViewModelObserver]
    
    init(timeLimit: Int, isClockTimer: Bool = true) {
        self.timeElapsed = 0
        self.isClockActive = false
        self.observers = [ClockViewModelObserver]()
        
        self.timeLimit = timeLimit
        self.timeRemaining = timeLimit
        self.isClockTimer = isClockTimer
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
}

/// Protocol to support ClockViewModel communication
protocol ClockViewModelObserver {
    func timerAtZero()
}
