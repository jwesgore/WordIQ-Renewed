//
//  GameResultsModel+CoreDataProperties.swift
//  WordIQ
//
//  Created by Wesley Gore on 3/1/25.
//
//

import Foundation
import CoreData


extension GameResultsModel {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<GameResultsModel> {
        return NSFetchRequest<GameResultsModel>(entityName: "GameResultsModel")
    }

    @NSManaged public var date: Date?
    @NSManaged public var gameDifficulty: Int64
    @NSManaged public var gameMode: Int64
    @NSManaged public var gameResult: Int64
    @NSManaged public var id: UUID?
    @NSManaged public var numCorrectWords: Int64
    @NSManaged public var numInvalidGuesses: Int64
    @NSManaged public var numValidGuesses: Int64
    @NSManaged public var targetWord: String?
    @NSManaged public var timeElapsed: Int64
    @NSManaged public var timeLimit: Int64
    @NSManaged public var xp: Int64

}

extension GameResultsModel : Identifiable {

}
