//
//  HomeView.swift
//  UltimatePortfolio
//
//  Created by Elias Myronidis on 9/4/22.
//

import CoreData
import SwiftUI

struct HomeView: View {
    static let tag: String? = "Home"

    @EnvironmentObject var dataController: DataController
    @FetchRequest(
        entity: Project.entity(),
        sortDescriptors: [NSSortDescriptor(keyPath: \Project.title, ascending: true)],
        predicate: NSPredicate(format: "closed = false")
    ) var projects: FetchedResults<Project>

    @FetchRequest var items: FetchedResults<Item>

    let projectRows: [GridItem] = [
        GridItem(.fixed(100))
    ]

    init() {
        let fetchRequest: NSFetchRequest<Item> = Item.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(keyPath: \Item.priority, ascending: false)]
        let completedPredicate = NSPredicate(format: "completed = false")
        let openPredicate = NSPredicate(format: "project.closed = false")
        let compoundPredicate = NSCompoundPredicate(type: .and, subpredicates: [completedPredicate, openPredicate])
        fetchRequest.predicate = compoundPredicate
        fetchRequest.fetchLimit = 10

        _items = FetchRequest(fetchRequest: fetchRequest)
    }

    var body: some View {
        NavigationView {
            VStack {
                ScrollView {
                    VStack(alignment: .leading) {
                        ScrollView(.horizontal, showsIndicators: false) {
                            LazyHGrid(rows: projectRows) {
                                ForEach(projects, content: ProjectSummaryView.init)
                            }
                            .padding([.horizontal, .top])
                            .fixedSize(horizontal: false, vertical: true)
                        }

                        VStack(alignment: .leading) {
                            ItemListView(title: "up_next", items: items.prefix(3))
                            ItemListView(title: "more_to_explore", items: items.dropFirst(3))
                        }
                        .padding(.horizontal)
                    }
                }
                .background(Color.systemGroupedBackground)
            }

            .navigationTitle("home")
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}