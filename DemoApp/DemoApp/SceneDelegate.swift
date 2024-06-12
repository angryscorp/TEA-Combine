import UIKit

final class SceneDelegate: UIResponder, UIWindowSceneDelegate {
   
    var window: UIWindow?

    private var rootComponent: RootComponent?

    func scene(
        _ scene: UIScene,
        willConnectTo _: UISceneSession,
        options _: UIScene.ConnectionOptions
    ) {
        guard let windowScene = (scene as? UIWindowScene) else {
            return
        }

        let window = UIWindow(windowScene: windowScene)
        self.window = window

        rootComponent = RootComponent(window: window)
        rootComponent?.makeRoot()
    }
}
