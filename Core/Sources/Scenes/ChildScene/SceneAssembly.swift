import Architecture
import Combine
import UIKit

public enum Scene {
    
    public static func create(
        in rootViewController: UIViewController,
        getSomething: @escaping () -> AnyPublisher<[Int], Never>
    ) -> AnyPublisher<Int?, Never> {
        
        let env = SceneEnvironment(getSomething: getSomething)

        let vc = ViewController()
        rootViewController.present(vc, animated: true)
        
        return TEA.start(
            initialState: SceneState(),
            environment: env,
            feedback: vc.bind,
            transform: SceneReducer.transform,
            apply: SceneReducer.apply,
            store: vc.store
        )
        .map(\.result)
        .handleEvents(receiveOutput: { [weak vc] _ in vc?.dismiss(animated: true) })
        .eraseToAnyPublisher()
    }
}
