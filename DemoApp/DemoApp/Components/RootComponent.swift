import UIKit

struct RootComponent {
    
    let window: UIWindow

    init(window: UIWindow) {
        self.window = window
    }

    func makeRoot() {
        MainComponent(parent: self)
            .makeMain()
    }
}
