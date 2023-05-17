//
//  TempView.swift
//  NewsCast
//
//  Created by Vignesh on 21/04/23.
//

import SwiftUI

struct TempView: View {
    var body: some View {
        TabView {
            ArticleTabView()
                .tabItem {
                    Label("News", systemImage: "newspaper")
                }
            
            CategoriesListView()
                .tabItem {
                    Label("Categories", systemImage: "list.dash")
                    
                }
            
            SignInView()
                .tabItem {
                    Label("SignIn", systemImage: "heart.fill")
                }
            
            ContentView()
                .tabItem {
                    Label("Something", systemImage: "person")
                }
        }
        .background(.blue)
        .navigationTitle("Headlines")
        .navigationBarBackButtonHidden()
        .navigationBarItems(trailing: Button("Loader"){
        })
    }
}

struct TempView_Previews: PreviewProvider {
    static var previews: some View {
        TempView()
    }
}
