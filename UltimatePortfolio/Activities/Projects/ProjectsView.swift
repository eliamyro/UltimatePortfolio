//
//  ProjectsView.swift
//  UltimatePortfolio
//
//  Created by Elias Myronidis on 9/4/22.
//

import SwiftUI

struct ProjectsView: View {
    static let openTag: String? = "Open"
    static let closedTag: String? = "Closed"

    @StateObject var viewModel: ViewModel
    @State private var showingSortOrder = false

    init(dataController: DataController, showClosedProjects: Bool) {
        let viewModel = ViewModel(dataController: dataController, showClosedProjects: showClosedProjects)
        _viewModel = StateObject(wrappedValue: viewModel)
    }

    var projectsList: some View {
        List {
            ForEach(viewModel.projects) { project in
                Section(header: ProjectHeaderView(project: project)) {
                    ForEach(project.projectItems(using: viewModel.sortOrder)) { item in
                        ItemRowView(project: project, item: item)
                    }
                    .onDelete { offsets in
                        viewModel.delete(offsets, from: project)
                    }

                    if viewModel.showClosedProjects == false {
                        Button {
                            withAnimation {
                                viewModel.addItem(to: project)
                            }
                        } label: {
                            Label("add_item", systemImage: "plus")
                        }
                    }
                }
            }
        }
        .listStyle(.insetGrouped)
    }

    var addProjectToolbarItem: some ToolbarContent {
        ToolbarItem(placement: .navigationBarTrailing) {
            if viewModel.showClosedProjects == false {
                Button {
                    withAnimation {
                        viewModel.addProject()
                    }
                } label: {
                    if UIAccessibility.isVoiceOverRunning {
                        Text("add_project")
                    } else {
                        Label("add_project", systemImage: "plus")
                    }
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
                if viewModel.projects.isEmpty {
                    Text("nothing_here_message")
                        .foregroundColor(.secondary)
                } else {
                    projectsList
                }
            }

            .navigationTitle(viewModel.showClosedProjects ? "closed_projects" : "open_projects")
            .toolbar {
                addProjectToolbarItem
                sortOrderToolbarItem
            }
            .confirmationDialog("change_items_sorting", isPresented: $showingSortOrder) {
                Button("optimized") { viewModel.sortOrder = .optimized}
                Button("creation_date") { viewModel.sortOrder = .creationDate }
                Button("title") { viewModel.sortOrder = .title }
            } message: {
                Text("sort_items")
            }

            SelectSomethingView()
        }
    }
}

struct ProjectsView_Previews: PreviewProvider {
    static var previews: some View {
        ProjectsView(dataController: DataController.preview, showClosedProjects: false)
    }
}
