// MARK: Frameworks

import UIKit

// MARK: MainViewController

class MainViewController: UIViewController {

    // MARK: Outlets

    @IBOutlet var addView: UIView!
    @IBOutlet var addTextField: UITextField!
    @IBOutlet var addButton: UIButton!
    @IBOutlet var myTableView: UITableView!

    // MARK: Variables

    var items: [Item] = [] {
        didSet {
            myTableView.reloadData()
        }
    }

    // MARK: View Methods

    override func viewDidLoad() {
        super.viewDidLoad()

        loadItems()
    }

    // MARK: Action Methods

    @IBAction func add(_ sender: Any?) {
        guard let itemText = addTextField.text else {
            return
        }

        textFieldFinished()
        let item: Item = Item(item: itemText)
        ItemsRemote.postItem(item: item)
    }

    // MARK: Helper Methods

    private func loadItems() {
        ItemsRemote.getAllItems { items in
            self.items = items
        }
    }

    private func textFieldFinished() {
        addTextField.text = nil
        addTextField.resignFirstResponder()
    }
}

// MARK: UITableViewDataSource Methods

extension MainViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: UITableViewCellStyle.default, reuseIdentifier: "Cell")
        let item = items[indexPath.row]
        cell.textLabel?.text = item.item
        return cell
    }
}
