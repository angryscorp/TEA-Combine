import Combine
import UIKit

final class ViewController: UITableViewController {

    private var dataSource: [Int] = []
    private let eventSubject = CurrentValueSubject<SceneEvent, Never>(.userDidStart)
    private var subscriptions = Set<AnyCancellable>()

    func store(_ subscription: AnyCancellable) {
        subscriptions.update(with: subscription)
    }
    
    func bind(state: AnyPublisher<SceneState, Never>) -> AnyPublisher<SceneEvent, Never> {
        state
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { [unowned self] state in
                    self.dataSource = state.something
                    self.tableView.reloadData()
            })
            .store(in: &subscriptions)

        return eventSubject.eraseToAnyPublisher()
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        dataSource.count
    }
    
    override func tableView(
        _ tableView: UITableView,
        cellForRowAt indexPath: IndexPath
    ) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.textLabel?.text = "\(dataSource[indexPath.row])"
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        eventSubject.send(.userDidSelect(dataSource[indexPath.row]))
    }
}
