import Combine

struct SceneEnvironment {
    let getSomething: () -> AnyPublisher<[Int], Never>
}

struct SceneState: Equatable {
    var something: [Int] = []
    var result: Int? = nil
}

enum SceneEvent {
    case userDidStart
    case userDidSelect(Int)
    case userDidFinish
}

enum SceneEffect {
    case somethingDidReceive([Int])
    case resultDidReceive(Int?)
}
