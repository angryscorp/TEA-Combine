import UIKit
import Combine

final class ViewController: UIViewController {

    var subscriptions = Set<AnyCancellable>()
    
    private let counterLabel = UILabel()
    private let currentValueLabel = UILabel()
    private let somethingLabel = UILabel()
    private let increaseButton = UIButton(type: .system)
    private let decreaseButton = UIButton(type: .system)
    private let somethingButton = UIButton(type: .system)
    private let eventSubject = PassthroughSubject<SceneEvent, Never>()

    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        layout()
    }
    
    func bind(state: AnyPublisher<SceneState, Never>) -> AnyPublisher<SceneEvent, Never> {
        state
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { [unowned self] state in
                self.somethingLabel.text = "Something: " + (state.something.map {"\($0)"} ?? "nil")
                self.counterLabel.text = "Counter: \(state.counter)"
                self.currentValueLabel.text = "Current value: \(state.currentValue)"
                
            })
            .store(in: &subscriptions)
        
        return eventSubject.eraseToAnyPublisher()
    }

    private func setup() {
        view.backgroundColor = .systemBackground
        
        [counterLabel, currentValueLabel, somethingLabel].forEach { subview in
            subview.textColor = .systemBlue
            subview.textAlignment = .center
        }
        
        [increaseButton, decreaseButton, somethingButton].forEach { button in
            button.layer.borderColor = UIColor.systemBlue.cgColor
            button.layer.cornerRadius = 5
            button.layer.borderWidth = 1
        }

        increaseButton.setTitle("Increase", for: .normal)
        decreaseButton.setTitle("Decrease", for: .normal)
        somethingButton.setTitle("Something", for: .normal)
        
        increaseButton.addTarget(self, action: #selector(increase), for: .touchUpInside)
        decreaseButton.addTarget(self, action: #selector(decrease), for: .touchUpInside)
        somethingButton.addTarget(self, action: #selector(doSelect), for: .touchUpInside)
    }
    
    private func layout() {
        let stack = UIStackView(
            arrangedSubviews: [
                somethingLabel,
                currentValueLabel,
                counterLabel,
                increaseButton,
                decreaseButton,
                somethingButton
            ]
        )
        
        stack.axis = .vertical
        stack.spacing = 8
        stack.setCustomSpacing(32, after: counterLabel)
        
        view.addSubview(stack)
        stack.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            stack.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            stack.centerYAnchor.constraint(equalTo: view.centerYAnchor),
        ])
    }
    
    @objc
    private func doSelect() {
        eventSubject.send(.userDidRequestSomething)
    }
    
    @objc
    private func increase() {
        eventSubject.send(.userDidRequestIncrease)
    }
    
    @objc
    private func decrease() {
        eventSubject.send(.userDidRequestDecrease)
    }
}
