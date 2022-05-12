//
//  ContentView.swift
//  UltimatePortfolio
//
//  Created by Elias Myronidis on 8/4/22.
//

import SwiftUI

struct ContentView: View {
    @SceneStorage("selectedView") var selectedView: String?
    @EnvironmentObject var dataController: DataController

    var body: some View {
        TabView(selection: $selectedView) {
            HomeView(dataController: dataController)
                .tag(HomeView.tag)
                .tabItem {
                    Label("home", systemImage: "house")
                }

            ProjectsView(dataController: dataController, showClosedProjects: false)
                .tag(ProjectsView.openTag)
                .tabItem {
                    Label("open", systemImage: "list.bullet")
                }

            ProjectsView(dataController: dataController, showClosedProjects: true)
                .tag(ProjectsView.closedTag)
                .tabItem {
                    Label("closed", systemImage: "checkmark")
                }

            AwardsView()
                .tag(AwardsView.tag)
                .tabItem {
                    Label("awards", systemImage: "rosette")
                }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static let dataController = DataController.preview

    static var previews: some View {
        ContentView()
            .environment((\.managedObjectContext), dataController.container.viewContext)
            .environmentObject(dataController)
    }
}
