import Foundation

/// Model to assist with sending a challenge request to a user
struct ChallengeRequestModel : Codable {
    let challengeRequestId: UUID
    let senderId: UUID
    let receiverId: UUID
    
    let challengeWord: String
    let challengeType: String
    
    let senderDidSolve: Bool
    let senderNumValidGuesses: Int
    let senderTimeElapsed: Int
}
