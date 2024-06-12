import Combine
@testable import MainScene
import XCTest

final class MainSceneTestCase: XCTestCase, TEATestCase {
    
    typealias State = SceneState
    typealias Event = SceneEvent
    typealias Effect = SceneEffect
    typealias Environment = SceneEnvironment

    var environment: SceneEnvironment {
        .init(
            getRandomNumber: { Just(5).eraseToAnyPublisher() },
            selectSomething: { Just(1).eraseToAnyPublisher() }
        )
    }

    var transform: (SceneState, SceneEvent, SceneEnvironment) -> AnyPublisher<SceneEffect, Never> {
        SceneReducer.transform
    }
    
    var apply: (SceneState, SceneEffect) -> SceneState {
        SceneReducer.apply
    }
    
    var cancellables = Set<AnyCancellable>()
    
    func test_userDidRequestIncrease() {
        test(
            event: .userDidRequestIncrease,
            initialState: .init(currentValue: 2, counter: 2),
            expectedState: .init(currentValue: 7, counter: 3)
        )
    }

    func test_userDidRequestDecrease() {
        test(
            event: .userDidRequestDecrease,
            initialState: .init(currentValue: 23, counter: 2),
            expectedState: .init(currentValue: 18, counter: 3)
        )
    }

    func test_userDidRequestDoubleIncreaseAndDecrease() {
        test(
            events: [.userDidRequestIncrease, .userDidRequestIncrease, .userDidRequestDecrease],
            initialState: .init(currentValue: 23, counter: 2),
            expectedState: .init(currentValue: 28, counter: 5)
        )
    }

    func test_userDidRequestIncrease_twice() {
        test(
            events: [.userDidRequestIncrease, .userDidRequestIncrease],
            initialState: .init(currentValue: 2, counter: 2),
            expectedState: .init(currentValue: 12, counter: 4)
        )
    }
    
    func test_userDidRequestSomething() {
        test(
            events: [.userDidRequestSomething],
            initialState: .init(something: nil, currentValue: 2, counter: 2),
            expectedState: .init(something: 1, currentValue: 2, counter: 2)
        )
    }
    
    func test_userDidRequestSomethingAndIncrease() {
        test(
            events: [.userDidRequestSomething, .userDidRequestIncrease],
            initialState: .init(something: nil, currentValue: 2, counter: 2),
            expectedState: .init(something: 1, currentValue: 7, counter: 3)
        )
    }
}
