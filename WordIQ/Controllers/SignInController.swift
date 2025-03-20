import FirebaseCore
import GoogleSignIn
import FirebaseAuth

/// Controller to assist with user accounts
class SignInController {
    
    static let shared = SignInController()
    
    let auth = Auth.auth()
    
    /// Assists with signing in using Google authentication
    func signInWithGoogle(completion: @escaping (Result<Void, GoogleSignInError>) -> Void) {
        guard let clientID = FirebaseApp.app()?.options.clientID else { return }
        
        // Create Google Sign In configuration object.
        let config = GIDConfiguration(clientID: clientID)
        GIDSignIn.sharedInstance.configuration = config
        
        // Start the sign in flow!
        guard let topViewController = UIApplication.topViewController() else { return completion(.failure(.unableToGetTopViewController)) }
        
        GIDSignIn.sharedInstance.signIn(withPresenting: topViewController) { [unowned self] result, error in

            guard let user = result?.user,
                  let idToken = user.idToken?.tokenString,
                  error == nil
            else { return completion(.failure(.signInPresentationFailed)) }
            
            let credential = GoogleAuthProvider.credential(withIDToken: idToken,
                                                           accessToken: user.accessToken.tokenString)
            
            auth.signIn(with: credential) { result, error in
                
            }
        }
    }
}

enum GoogleSignInError: Error {
    case unableToGetTopViewController
    case signInPresentationFailed
    case authenticationFailed
}

/// Extension to get top level view controller for some god forsaken reason
extension UIApplication {
    class func topViewController(controller: UIViewController? = UIApplication.shared.connectedScenes
        .compactMap { $0 as? UIWindowScene }
        .flatMap { $0.windows }
        .first(where: { $0.isKeyWindow })?.rootViewController) -> UIViewController? {

        if let navigationController = controller as? UINavigationController {
            return topViewController(controller: navigationController.visibleViewController)
        } else if let tabBarController = controller as? UITabBarController,
                  let selectedViewController = tabBarController.selectedViewController {
            return topViewController(controller: selectedViewController)
        } else if let presentedViewController = controller?.presentedViewController {
            return topViewController(controller: presentedViewController)
        } else {
            return controller
        }
    }
}
