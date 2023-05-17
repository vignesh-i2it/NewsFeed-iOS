//
//  CategoryListView.swift
//  NewsCast
//
//  Created by Vignesh on 18/04/23.
//

import SwiftUI

struct CategoriesListView: View {
    @State private var selectedItem: String?

    @State private var itemList = ["Top Headlines", "Business", "Technology", "Entertainment", "Sports", "Science", "Health"]

    var body: some View {
        NavigationView {
            Form {
                Picker("", selection: $selectedItem) {
                    ForEach(itemList, id: \.self) { item in
                        Text(item).tag("item" as String?)
                    }
                }
                .pickerStyle(.inline)
            }
            .background(
                NavigationLink (
                    tag: "item",
                    selection: $selectedItem,
                    destination: {
                        //AddItemView(add: { itemList.append($0); selectedItem = $0 })
                        ArticleTabView()
                    },
                    label: {EmptyView()}
                )
            )
            .navigationBarTitle(Text("Categories"))
        }
    }
}
