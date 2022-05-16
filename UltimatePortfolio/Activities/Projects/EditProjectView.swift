//
//  EditProjectView.swift
//  UltimatePortfolio
//
//  Created by Elias Myronidis on 12/4/22.
//

import CoreHaptics
import SwiftUI

struct EditProjectView: View {
    @EnvironmentObject var dataController: DataController
    @Environment(\.dismiss) var dismiss

    @ObservedObject var project: Project
    @State private var title: String
    @State private var detail: String
    @State private var color: String
    @State private var showingDeleteConfirm: Bool = false

    @State private var hapticEngine = try? CHHapticEngine()

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
            Section(header: Text("basic_settings")) {
                TextField("title", text: $title.onChange(update))
                TextField("description", text: $detail.onChange(update))
            }

            Section(header: Text("custom_project_color")) {
                LazyVGrid(columns: colorColumns) {
                    ForEach(Project.colors, id: \.self, content: colorButton)
                }
                .padding(.vertical)
            }

            Section {
                Button(project.closed ? "reopen_project" : "close_project", action: toggleClosed)

                Button("delete_project", role: .destructive) {
                    showingDeleteConfirm.toggle()
                }
            } footer: {
                Text("close_project_message")
            }
        }

        .navigationTitle("edit_project")
        .onDisappear(perform: dataController.save)
        .alert(isPresented: $showingDeleteConfirm) {
            Alert(
                title: Text("delete_project"),
                message: Text("delete_project_message"),
                primaryButton: .default(Text("delete"), action: delete),
                secondaryButton: .cancel()
            )
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

    func toggleClosed() {
        project.closed.toggle()

        if project.closed {
            do {
                try hapticEngine?.start()
                let sharpness = CHHapticEventParameter(parameterID: .hapticSharpness, value: 0)
                let intensity = CHHapticEventParameter(parameterID: .hapticIntensity, value: 1)

                let start = CHHapticParameterCurve.ControlPoint(relativeTime: 0, value: 1)
                let end = CHHapticParameterCurve.ControlPoint(relativeTime: 1, value: 0)

                let parameterCurve = CHHapticParameterCurve(
                    parameterID: .hapticIntensityControl,
                    controlPoints: [start, end],
                    relativeTime: 0
                )

                let event1 = CHHapticEvent(
                    eventType: .hapticTransient,
                    parameters: [sharpness, intensity],
                    relativeTime: 0
                )

                let event2 = CHHapticEvent(eventType: .hapticContinuous,
                                           parameters: [sharpness, intensity],
                                           relativeTime: 0.125,
                                           duration: 1
                )

                let pattern = try CHHapticPattern(events: [event1, event2], parameterCurves: [parameterCurve])

                let player = try hapticEngine?.makePlayer(with: pattern)
                try player?.start(atTime: 0)
            } catch {
                print("Failed to create haptic.")
            }
        }
    }

    func colorButton(for item: String) -> some View {
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

struct EditProjectView_Previews: PreviewProvider {
    static let dataController = DataController.preview

    static var previews: some View {
        EditProjectView(project: Project.example)
            .environment((\.managedObjectContext), dataController.container.viewContext)
            .environmentObject(dataController)
    }
}
