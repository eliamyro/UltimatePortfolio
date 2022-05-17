//
//  EditItemView.swift
//  UltimatePortfolio
//
//  Created by Elias Myronidis on 10/4/22.
//

import SwiftUI

struct EditItemView: View {
    @EnvironmentObject var dataController: DataController
    @State private var title: String
    @State private var detail: String
    @State private var priority: Int
    @State private var completed: Bool

    let item: Item

    init(item: Item) {
        self.item = item

        _title = State(wrappedValue: item.itemTitle)
        _detail = State(wrappedValue: item.itemDetail)
        _priority = State(wrappedValue: Int(item.priority))
        _completed = State(wrappedValue: item.completed)
    }

    var body: some View {
        Form {
            Section(header: Text("basic_settings")) {
                TextField("title", text: $title.onChange(update))
                TextField("description", text: $detail.onChange(update))
            }

            Section(header: Text("priority")) {
                Picker("priority", selection: $priority.onChange(update)) {
                    Text("low").tag(1)
                    Text("medium").tag(2)
                    Text("high").tag(3)
                }
                .pickerStyle(.segmented)
            }

            Section {
                Toggle("mark_completed", isOn: $completed.onChange(update))
            }
        }

        .navigationTitle("edit_item")
        .onDisappear(perform: save)
    }

    func update() {
        item.project?.objectWillChange.send()

        item.title = title
        item.detail = detail
        item.priority = Int16(priority)
        item.completed = completed
    }

    func save() {
        dataController.update(item)
    }
}

struct EditItemView_Previews: PreviewProvider {
    static var previews: some View {
        EditItemView(item: Item.example)
    }
}
