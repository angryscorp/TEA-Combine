import Combine

enum SceneReducer {
    
    static func transform(
        state _: SceneState,
        event: SceneEvent,
        env: SceneEnvironment
    ) -> AnyPublisher<SceneEffect, Never> {
        switch event {
        case .userDidStart:
            return env.getSomething()
                .map(SceneEffect.somethingDidReceive)
                .eraseToAnyPublisher()
            
        case .userDidFinish:
            return Just(SceneEffect.resultDidReceive(nil))
                .eraseToAnyPublisher()
            
        case let .userDidSelect(value):
            return Just(SceneEffect.resultDidReceive(value))
                .eraseToAnyPublisher()
        }
    }

    static func apply(
        state: SceneState,
        effect: SceneEffect
    ) -> SceneState {
        switch effect {
        case let .somethingDidReceive(value):
            return .init(something: value, result: nil)
            
        case let .resultDidReceive(value):
            return .init(something: state.something, result: value)
        }
    }
}
