import Combine
import MainScene
import UIKit

struct MainComponent {
    
    let parent: RootComponent

    func makeMain() {
        MainScene.create(
            setRootVC: { vc in
                parent.window.rootViewController = vc
                parent.window.makeKeyAndVisible()
            }, 
            selectSomething: makeSelectSomething
        )
    }
    
    private func makeSelectSomething(
        rootViewController: UIViewController
    ) -> AnyPublisher<Int?, Never> {
        ChildComponent(parent: self)
            .makeChild(rootViewController: rootViewController)
    }
}
