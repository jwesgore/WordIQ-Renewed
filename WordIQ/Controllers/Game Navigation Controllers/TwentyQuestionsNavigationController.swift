
class TwentyQuestionsNavigationController: NavigationControllerBase, GameNavigationControllerProtocol {

    var gameOptions: SingleWordGameOptionsModel {
        return AppNavigationController.shared.singleWordGameOptionsModel
    }
    
    init() {
        super.init(.twentyQuestionsGame)
    }
    
    func startGame(complete: @escaping () -> Void = {}) {
        goToGameView(immediate: true) {
            complete()
        }
    }
    
    func goToGameOverView(immediate: Bool = false, complete: @escaping () -> Void = {}) {
        if immediate {
            goToView(.gameOver) {
                complete()
            }
        } else {
            goToViewWithAnimation(.gameOver) {
                complete()
            }
        }
    }
    
    func goToGameView(immediate: Bool = false, complete: @escaping () -> Void = {}) {
        if immediate {
            goToView(.twentyQuestionsGame) {
                complete()
            }
        } else {
            goToViewWithAnimation(.twentyQuestionsGame, delay: 0.5) {
                complete()
            }
        }
    }
}

