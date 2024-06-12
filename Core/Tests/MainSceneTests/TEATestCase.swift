import Architecture
import Combine
import XCTest

public protocol TEATestCase: XCTestCase where State: Equatable  {

    associatedtype State
    associatedtype Event
    associatedtype Effect
    associatedtype Environment
    
    var environment: Environment { get }
    var transform: (State, Event, Environment) -> AnyPublisher<Effect, Never> { get }
    var apply: (State, Effect) -> State { get }
    var cancellables: Set<AnyCancellable> { get set }
}

public extension TEATestCase {
    
    func test(
        event: Event,
        initialState: State,
        expectedState: State
    ) {
        test(
            events: [event],
            initialState: initialState,
            expectedState: expectedState
        )
    }
    
    func test(
        events: [Event],
        initialState: State,
        expectedState: State
    ) {
        let completed = expectation(description: String(describing: Self.self))

        TEA.start(
            initialState: initialState,
            environment: environment,
            feedback: { _ in events.publisher.eraseToAnyPublisher() },
            transform: transform,
            apply: apply,
            store: { cancellables.update(with: $0) }
        )
            .first()
            .sink(receiveValue: { newState in
                completed.fulfill()
                XCTAssertEqual(newState, expectedState)
            })
            .store(in: &cancellables)

        waitForExpectations(timeout: 1)
    }
}
