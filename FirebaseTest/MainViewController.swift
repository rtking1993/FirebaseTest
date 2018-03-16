import UIKit
import FirebaseDatabase

// MARK: MainViewController

class MainViewController: UIViewController {

    // MARK: Outlets

    @IBOutlet var addView: UIView!
    @IBOutlet var addTextField: UITextField!
    @IBOutlet var addButton: UIButton!
    @IBOutlet var myTableView: UITableView!

    // MARK: Variables

    var items: Array<DataSnapshot> = []

    // MARK: View Methods

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.

        addFirebaseObservers()
    }

    // MARK: Action Methods

    @IBAction func add(_ sender: Any?) {
        guard let itemText = addTextField.text else {
            return
        }

        let itemReference = Database.database().reference().child("items")
        let item = ["item": itemText]
        itemReference.setValue(item)
    }

    // MARK: Helper Methods

    private func addFirebaseObservers() {
        let itemReference = Database.database().reference().child("items")

        // Listen for new comments in the Firebase database
        itemReference.observe(.childAdded, with: { (snapshot) -> Void in
            self.items.append(snapshot)
            self.myTableView.insertRows(at: [IndexPath(row: self.items.count-1, section: 0)], with: UITableViewRowAnimation.automatic)
        })

        // Listen for deleted comments in the Firebase database
        itemReference.observe(.childRemoved, with: { (snapshot) -> Void in
            let index = self.indexOfMessage(snapshot)
            self.items.remove(at: index)
            self.myTableView.deleteRows(at: [IndexPath(row: index, section: 0)], with: UITableViewRowAnimation.automatic)
        })
    }

    private func indexOfMessage(_ snapshot: DataSnapshot) -> Int {
        var index = 0
        for  item in self.items {
            if snapshot.key == item.key {
                return index
            }
            index += 1
        }
        return -1
    }
}

// MARK: UITableViewDataSource Methods

extension MainViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: UITableViewCellStyle.default, reuseIdentifier: "Cell")
        let itemDict = items[indexPath.row].value as? [String : AnyObject]


        return cell
    }
}
