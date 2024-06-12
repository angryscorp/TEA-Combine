import Combine

public enum TEA {
    
    public static func start<State, Event, Effect, Environment>(
        initialState: State,
        environment: Environment,
        feedback: (AnyPublisher<State, Never>) -> AnyPublisher<Event, Never>,
        transform: @escaping (State, Event, Environment) -> AnyPublisher<Effect, Never>,
        apply: @escaping (State, Effect) -> State
    ) -> AnyCancellable {
    
        let effectSubject = PassthroughSubject<Effect, Never>()

        let stateSubject = CurrentValueSubject<State, Never>(initialState)
        
        let state = stateSubject.share().eraseToAnyPublisher()
        
        let effectsSubscription = effectSubject
            .scan(initialState, apply)
            .sink(receiveValue: stateSubject.send)

        let eventsSubscription = feedback(state)
            .flatMap { event in transform(stateSubject.value, event, environment) }
            .sink(receiveValue: effectSubject.send)

        return AnyCancellable {
            eventsSubscription.cancel()
            effectsSubscription.cancel()
        }
    }
    
    public static func start<State, Event, Effect, Environment>(
        initialState: State,
        environment: Environment,
        feedback: (AnyPublisher<State, Never>) -> AnyPublisher<Event, Never>,
        transform: @escaping (State, Event, Environment) -> AnyPublisher<Effect, Never>,
        apply: @escaping (State, Effect) -> State,
        store: (AnyCancellable) -> Void
    ) -> AnyPublisher<State, Never> {
        let effectSubject = PassthroughSubject<Effect, Never>()

        let stateSubject = CurrentValueSubject<State, Never>(initialState)

        let state = stateSubject.share().eraseToAnyPublisher()

        let effectsSubscription = effectSubject
            .scan(initialState, apply)
            .sink(receiveValue: stateSubject.send)

        let eventsSubscription = feedback(state)
            .flatMap { event in transform(stateSubject.value, event, environment) }
            .sink(receiveValue: effectSubject.send)

        let subscription = AnyCancellable {
            eventsSubscription.cancel()
            effectsSubscription.cancel()
        }

        store(subscription)

        return state.eraseToAnyPublisher()
    }
}
