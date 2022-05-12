//
//  HomeViewModel.swift
//  UltimatePortfolio
//
//  Created by Elias Myronidis on 12/5/22.
//

import CoreData
import Foundation

extension HomeView {
    class ViewModel: NSObject, ObservableObject, NSFetchedResultsControllerDelegate {
        let dataController: DataController

        private let projectsController: NSFetchedResultsController<Project>
        private let itemsController: NSFetchedResultsController<Item>

        @Published var projects = [Project]()
        @Published var items = [Item]()

        var upNext: ArraySlice<Item> {
            items.prefix(3)
        }

        var moreToExplore: ArraySlice<Item> {
            items.dropFirst(3)
        }

        init(dataController: DataController) {
            self.dataController = dataController

            let projectsRequest: NSFetchRequest<Project> = Project.fetchRequest()
            projectsRequest.sortDescriptors = [NSSortDescriptor(keyPath: \Project.title, ascending: true)]
            projectsRequest.predicate = NSPredicate(format: "closed = false")
            projectsController = NSFetchedResultsController(
                fetchRequest: projectsRequest,
                managedObjectContext: dataController.container.viewContext,
                sectionNameKeyPath: nil,
                cacheName: nil
            )

            let itemsRequest: NSFetchRequest<Item> = Item.fetchRequest()
            itemsRequest.sortDescriptors = [NSSortDescriptor(keyPath: \Item.priority, ascending: false)]
            let completedPredicate = NSPredicate(format: "completed = false")
            let openPredicate = NSPredicate(format: "project.closed = false")
            let compoundPredicate = NSCompoundPredicate(type: .and, subpredicates: [completedPredicate, openPredicate])
            itemsRequest.predicate = compoundPredicate
            itemsRequest.fetchLimit = 10
            itemsController = NSFetchedResultsController(
                fetchRequest: itemsRequest,
                managedObjectContext: dataController.container.viewContext,
                sectionNameKeyPath: nil,
                cacheName: nil
            )

            super.init()
            projectsController.delegate = self
            itemsController.delegate = self

            do {
                try projectsController.performFetch()
                try itemsController.performFetch()
                projects = projectsController.fetchedObjects ?? []
                items = itemsController.fetchedObjects ?? []
            } catch {
                print("Failed to fetch initial data.")
            }
        }

        func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
            if let newProjects = controller.fetchedObjects as? [Project] {
                projects = newProjects
            } else if let newItems = controller.fetchedObjects as? [Item] {
                items = newItems
            }
        }

        func addSampleData() {
            dataController.deleteAll()
            try? dataController.createSampleData()
        }
    }
}
