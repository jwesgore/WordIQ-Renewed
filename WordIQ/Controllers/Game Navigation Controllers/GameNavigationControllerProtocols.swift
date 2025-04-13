
protocol GameNavigationControllerProtocol {
    func startGame(complete: @escaping () -> Void)
    func goToGameOverView(immediate: Bool, complete: @escaping () -> Void)
    func goToGameView(immediate: Bool, complete: @escaping () -> Void)
}
