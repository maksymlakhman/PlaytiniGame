import Foundation

class GameModel {
    var collisionCount: Int = 0
    
    func incrementCollision() {
        collisionCount += 1
    }
    
    func reset() {
        collisionCount = 0
    }
    
    func isGameOver() -> Bool {
        return collisionCount >= 5
    }
}

