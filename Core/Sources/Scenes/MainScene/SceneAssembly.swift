import Architecture
import Combine
import UIKit

public struct MainScene {
    
    public static func create(
        setRootVC: (UIViewController) -> Void,
        selectSomething: @escaping (UIViewController) -> AnyPublisher<Int?, Never>
    ) {
        let vc = ViewController()
                
        let env = SceneEnvironment(
            getRandomNumber: { Just(Int.random(in: 1...9)).eraseToAnyPublisher() },
            selectSomething: { selectSomething(vc) }
        )
        
        TEA.start(
            initialState: SceneState(),
            environment: env,
            feedback: vc.bind,
            transform: SceneReducer.transform,
            apply: SceneReducer.apply
        ).store(in: &vc.subscriptions)

        setRootVC(vc)
    }
}
