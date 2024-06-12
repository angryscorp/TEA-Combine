import Combine

public enum SceneReducer {
    
    public static func transform(
        state: SceneState,
        event: SceneEvent,
        env: SceneEnvironment
    ) -> AnyPublisher<SceneEffect, Never> {
        switch event {
        case .userDidRequestDecrease:
            return env.getRandomNumber()
                .map { SceneEffect.resultDidReceive(-$0) }
                .eraseToAnyPublisher()
            
        case .userDidRequestIncrease:
            return env.getRandomNumber()
                .map { SceneEffect.resultDidReceive($0) }
                .eraseToAnyPublisher()
            
        case .userDidRequestSomething:
            return env.selectSomething()
                .map(SceneEffect.somethingDidReceive)
                .eraseToAnyPublisher()
        }
    }

    public static func apply(
        state: SceneState,
        effect: SceneEffect
    ) -> SceneState {
        switch effect {
        case let .resultDidReceive(value):
            return .init(
                something: state.something,
                currentValue: state.currentValue + value,
                counter: state.counter + 1
            )
            
        case let .somethingDidReceive(value):
            return .init(
                something: value,
                currentValue: state.currentValue,
                counter: state.counter
            )
        }
    }
}
