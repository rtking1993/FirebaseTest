// MARK: Frameworks

// MARK: Frameworks

import Foundation
import FirebaseDatabase

// MARK: ItemsRemote

class ItemsRemote {

    // MARK: Constants

    static let itemsReference = Database.database().reference().child("items")

    // MARK: POST Methods

    static func postItem(item: Item) {
        itemsReference.childByAutoId().setValue(item.toAnyObject())
    }

    // MARK: GET Methods

    static func getAllItems(completion: @escaping(_ items: [Item]) -> Void) {
        itemsReference.observe(.value) { snapshot in
            var items: [Item] = []

            for item in snapshot.children {
                guard let item = item as? DataSnapshot,
                      let currentItem = Item(snapshot: item) else {
                    continue
                }

                items.append(currentItem)
            }

            completion(items)
        }
    }
}
