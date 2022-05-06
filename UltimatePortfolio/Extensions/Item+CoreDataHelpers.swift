//
//  Item+CoreDataHelpers.swift
//  UltimatePortfolio
//
//  Created by Elias Myronidis on 10/4/22.
//

import Foundation

extension Item {
    enum SortOrder {
        case optimized
        case creationDate
        case title
    }

    var itemTitle: String {
        title ?? NSLocalizedString("new_item", comment: "The fallback item title")
    }

    var itemDetail: String {
        detail ?? ""
    }

    var itemCreationDate: Date {
        creationDate ?? Date()
    }

    static var example: Item {
        let controller = DataController.preview
        let viewContext = controller.container.viewContext

        let item = Item(context: viewContext)
        item.title = "Example item"
        item.detail = "This is an example item"
        item.priority = 3
        item.creationDate = Date()

        return item
    }
}
