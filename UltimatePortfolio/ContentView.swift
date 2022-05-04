//
//  ContentView.swift
//  UltimatePortfolio
//
//  Created by Elias Myronidis on 8/4/22.
//

import SwiftUI

struct ContentView: View {
    @SceneStorage("selectedView") var selectedView: String?

    var body: some View {
        TabView(selection: $selectedView) {
            HomeView()
                .tag(HomeView.tag)
                .tabItem {
                    Label("home", systemImage: "house")
                }

            ProjectsView(showClosedProjects: false)
                .tag(ProjectsView.openTag)
                .tabItem {
                    Label("open", systemImage: "list.bullet")
                }

            ProjectsView(showClosedProjects: true)
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
