import Combine

public struct SceneEnvironment {
    let getRandomNumber: () -> AnyPublisher<Int, Never>
    let selectSomething: () -> AnyPublisher<Int?, Never>
}

public struct SceneState: Equatable {
    var something: Int? = nil
    var currentValue = 0
    var counter = 0
}

public enum SceneEvent {
    case userDidRequestIncrease
    case userDidRequestDecrease
    case userDidRequestSomething
}

public enum SceneEffect {
    case resultDidReceive(Int)
    case somethingDidReceive(Int?)
}
