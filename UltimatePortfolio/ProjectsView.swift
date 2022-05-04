//
//  ProjectsView.swift
//  UltimatePortfolio
//
//  Created by Elias Myronidis on 9/4/22.
//

import SwiftUI

struct ProjectsView: View {
    @EnvironmentObject var dataController: DataController
    @Environment(\.managedObjectContext) var managedObjectContext
    
    static let openTag: String? = "Open"
    static let closedTag: String? = "Closed"
    
    @State private var showingSortOrder = false
    @State private var sortOrder: Item.SortOrder = .optimized
    
    var showClosedProjects: Bool
    @FetchRequest var projects: FetchedResults<Project>
    
    init(showClosedProjects: Bool) {
        self.showClosedProjects = showClosedProjects
        _projects = FetchRequest<Project>(entity: Project.entity(), sortDescriptors: [NSSortDescriptor(keyPath: \Project.creationDate, ascending: false)], predicate: NSPredicate(format: "closed = %d", showClosedProjects))
    }
    
    var projectsList: some View {
        List {
            ForEach(projects) { project in
                Section(header: ProjectHeaderView(project: project)) {
                    ForEach(project.projectItems(using: sortOrder)) { item in
                        ItemRowView(project: project, item: item)
                    }
                    .onDelete { offsets in
                        delete(offsets, from: project)
                    }
                    
                    if showClosedProjects == false {
                        Button {
                            addItem(to: project)
                        } label: {
                            if UIAccessibility.isVoiceOverRunning {
                                Text("add_item")
                            } else {
                                Label("add_item", systemImage: "plus")
                            }
                        }
                    }
                }
            }
        }
        .listStyle(.insetGrouped)
    }
    
    var addProjectToolbarItem: some ToolbarContent {
        ToolbarItem(placement: .navigationBarTrailing) {
            if showClosedProjects == false {
                Button(action: addProject) {
                    Label("add_project", systemImage: "plus")
                }
            }
        }
    }
    
    var sortOrderToolbarItem: some ToolbarContent {
        ToolbarItem(placement: .navigationBarLeading) {
            Button {
                showingSortOrder.toggle()
            } label: {
                Label("sort", systemImage: "arrow.up.arrow.down")
            }
        }
    }
    
    var body: some View {
        NavigationView {
            Group {
                if projects.isEmpty {
                    Text("nothing_here_message")
                        .foregroundColor(.secondary)
                } else {
                    projectsList
                }
            }
            
            .navigationTitle(showClosedProjects ? "closed_projects" : "open_projects")
            .toolbar {
                addProjectToolbarItem
                sortOrderToolbarItem
            }
            .confirmationDialog("change_items_sorting", isPresented: $showingSortOrder) {
                Button("optimized") { sortOrder = .optimized}
                Button("creation_date") { sortOrder = .creationDate }
                Button("title") { sortOrder = .title }
            } message: {
                Text("sort_items")
            }
            
            SelectSomethingView()
        }
    }
    
    private func addProject() {
        withAnimation {
            let project = Project(context: managedObjectContext)
            project.closed = false
            project.creationDate = Date()
            
            dataController.save()
        }
    }
    
    private func addItem(to project: Project) {
        withAnimation {
            let item = Item(context: managedObjectContext)
            item.project = project
            item.creationDate = Date()
            
            dataController.save()
        }
    }
    
    private func delete(_ offsets: IndexSet, from project: Project) {
        let allItems = project.projectItems(using: sortOrder)
        for offset in offsets {
            let item = allItems[offset]
            dataController.delete(item)
        }
        
        dataController.save()
    }
}

struct ProjectsView_Previews: PreviewProvider {
    static let dataController = DataController.preview
    
    static var previews: some View {
        ProjectsView(showClosedProjects: false)
            .environment((\.managedObjectContext), dataController.container.viewContext)
            .environmentObject(dataController)
    }
}
