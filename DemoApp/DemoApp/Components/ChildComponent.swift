import Combine
import ChildScene
import UIKit

struct ChildComponent {
    
    let parent: MainComponent
    let someDependency: () -> AnyPublisher<[Int], Never>

    init(parent: MainComponent) {
        self.parent = parent
        someDependency = {
            Just((1...10).map { _ in Int.random(in: 111 ... 999) })
                .eraseToAnyPublisher()
        }
    }
    
    func makeChild(
        rootViewController: UIViewController
    ) -> AnyPublisher<Int?, Never> {
        Scene.create(
            in: rootViewController,
            getSomething: someDependency
        )
    }
}
