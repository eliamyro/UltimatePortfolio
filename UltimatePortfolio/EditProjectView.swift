//
//  EditProjectView.swift
//  UltimatePortfolio
//
//  Created by Elias Myronidis on 12/4/22.
//

import SwiftUI

struct EditProjectView: View {
    @EnvironmentObject var dataController: DataController
    @Environment(\.dismiss) var dismiss
    
    let project: Project
    @State private var title: String
    @State private var detail: String
    @State private var color: String
    @State private var showingDeleteConfirm: Bool = false
    
    let colorColumns = [
        GridItem(.adaptive(minimum: 44))
    ]
    
    init(project: Project) {
        self.project = project
        _title = State(wrappedValue: project.projectTitle)
        _detail = State(wrappedValue: project.projectDetail)
        _color = State(wrappedValue: project.projectColor)
    }
    
    var body: some View {
        Form {
            Section(header: Text("Basic Settings")) {
                TextField("Title", text: $title.onChange(update))
                TextField("Description", text: $detail.onChange(update))
            }
            
            Section(header: Text("Custom Project Color")) {
                LazyVGrid(columns: colorColumns) {
                    ForEach(Project.colors, id: \.self) { item in
                        ZStack {
                            Color(item)
                                .aspectRatio(1, contentMode: .fit)
                                .cornerRadius(6)
                            if color == item {
                                Image(systemName: "checkmark.circle")
                                    .foregroundColor(.white)
                                    .font(.largeTitle)
                            }
                        }
                        .onTapGesture {
                            color = item
                            update()
                        }
                        .accessibilityElement(children: .ignore)
                        .accessibilityAddTraits(
                            color == item ? [.isButton, .isSelected] : [.isButton]
                        )
                        .accessibilityLabel(LocalizedStringKey(item))
                    }
                }
                .padding(.vertical)
            }
            
            Section {
                Button(project.closed ? "Reopen this project" : "Close this project") {
                    project.closed.toggle()
                    update()
                }
                
                Button("Delete this project", role: .destructive) {
                    showingDeleteConfirm.toggle()
                }
                
            } footer: {
                Text("Closing a project moves it from the Open to Closed tab. Deleting it removes the project entirely.")
            }
        }
        
        .navigationTitle("Edit Project")
        .onDisappear(perform: dataController.save)
        .alert(isPresented: $showingDeleteConfirm) {
            Alert(title: Text("Delete project?"), message: Text("Are you sure you want to delete this project? You will also delete all the items it contains."), primaryButton: .default(Text("Delete"), action: delete), secondaryButton: .cancel())
        }
    }
    
    func update() {
        project.title = title
        project.detail = detail
        project.color = color
    }
    
    func delete() {
        dataController.delete(project)
        update()
    }
}

struct EditProjectView_Previews: PreviewProvider {
    static let dataController = DataController.preview
    
    static var previews: some View {
        EditProjectView(project: Project.example)
            .environment((\.managedObjectContext), dataController.container.viewContext)
            .environmentObject(dataController)
    }
}
