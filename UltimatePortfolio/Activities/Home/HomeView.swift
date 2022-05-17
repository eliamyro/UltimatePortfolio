//
//  HomeView.swift
//  UltimatePortfolio
//
//  Created by Elias Myronidis on 9/4/22.
//

import CoreData
import CoreSpotlight
import SwiftUI

struct HomeView: View {
    static let tag: String? = "Home"

    @StateObject private var viewModel: ViewModel

    let projectRows: [GridItem] = [
        GridItem(.fixed(100))
    ]

    init(dataController: DataController) {
        let viewModel = ViewModel(dataController: dataController)
        _viewModel = StateObject(wrappedValue: viewModel)
    }

    var body: some View {
        NavigationView {
                ScrollView {
                    if let item = viewModel.selectedItem {
                        NavigationLink(
                            destination: EditItemView(item: item),
                            tag: item,
                            selection: $viewModel.selectedItem,
                            label: EmptyView.init
                        )
                        .id(item)
                    }

                    VStack(alignment: .leading) {
                        ScrollView(.horizontal, showsIndicators: false) {
                            LazyHGrid(rows: projectRows) {
                                ForEach(viewModel.projects, content: ProjectSummaryView.init)
                            }
                            .padding([.horizontal, .top])
                            .fixedSize(horizontal: false, vertical: true)
                        }

                        VStack(alignment: .leading) {
                            ItemListView(title: "up_next", items: viewModel.upNext)
                            ItemListView(title: "more_to_explore", items: viewModel.moreToExplore)
                        }
                        .padding(.horizontal)
                    }
                }
                .background(Color.systemGroupedBackground)
                .navigationTitle("home")
                .onContinueUserActivity(CSSearchableItemActionType, perform: loadSpotlightItem)
            }
        }

    func loadSpotlightItem(_ userActivity: NSUserActivity) {
        if let uniqueIdentifier = userActivity.userInfo?[CSSearchableItemActivityIdentifier] as? String {
            viewModel.selectItem(with: uniqueIdentifier)
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView(dataController: DataController.preview)
    }
}
