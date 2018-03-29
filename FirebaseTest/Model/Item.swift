import FirebaseDatabase

// MARK: Item

enum ItemParameters: String {
    case item = "item"
}

// MARK: Item

struct Item {

    // MARK: Constants

    let identifier: String
    var item: String
    let ref: DatabaseReference?

    // MARK: Init Methods

    init(identifier: String = "", item: String) {
        self.identifier = identifier
        self.item = item
        self.ref = nil
    }

    init?(snapshot: DataSnapshot) {
        identifier = snapshot.key

        guard let snapshotValue = snapshot.value as? [String: AnyObject],
              let item = snapshotValue[ItemParameters.item.rawValue] as? String else {
            return nil
        }

        self.item = item

        ref = snapshot.ref
    }

    func toAnyObject() -> Any {
        return [
            ItemParameters.item.rawValue: item
        ]
    }
}
