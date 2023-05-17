//
//  MainTabView.swift
//  NewsCast
//
//  Created by Vignesh on 13/04/23.
//

import SwiftUI

enum Tabs: String {
    case Headlines
    case Categories
    case Favourites
    case Profile
}

struct MainTabView: View {
    @Environment(\.managedObjectContext) var moc
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject private var factory: ViewModelFactory

    
    @State var selectedTab: Tabs = .Headlines

    
    @FetchRequest(sortDescriptors: []) var articles: FetchedResults<Article>
    
    var body: some View {
        //VStack{
            //NavigationView {
                TabView(selection: $selectedTab) {
                    ArticleTabView()
                        .tabItem {
                            Label("News", systemImage: "newspaper")
                        }.tag(Tabs.Headlines)
                    
                    CategoriesListView()
                        .tabItem {
                            Label("Categories", systemImage: "list.dash")
                        }.tag(Tabs.Categories)
                    
                    FavouritesView()
                        .tabItem {
                            Label("Favourites", systemImage: "heart.fill")
                        }.tag(Tabs.Favourites)
                    
                    ProfileView(viewModel: factory.makeProfileViewModel())
                        .tabItem {
                            Label("Profile", systemImage: "person")
                        }.tag(Tabs.Profile)
                }
                .navigationBarTitle(selectedTab.rawValue.capitalized)
            //}
           // .navigationBarBackButtonHidden()
            //.navigationBarHidden(true)
       // }
    }
    
    func loadArticle() {
        print(NSTemporaryDirectory())

        let data: Data
        
        let filename = "News.json"
        guard let file = Bundle.main.url(forResource: "news.json", withExtension: nil)
        else {
            fatalError("Couldn't find \(filename) in main bundle.")
        }
        do {
            data = try Data(contentsOf: file)
        } catch {
            fatalError("Couldn't load \(filename) from main bundle:\n\(error)")
        }
        do {
            if let json = try JSONSerialization.jsonObject(with: data, options: []) as? Any {
                print(json)
                if let jsonObj = json as? NSDictionary{
                    if let articlesArray = jsonObj.value(forKey: "articles") as? NSArray{
                        print(articlesArray)
                        for array in articlesArray {
                            if let obj = array as? NSDictionary{
                                
                                let article = Article(context: moc)
                                
                                article.title = obj.value(forKey: "title") as? String ?? ""
                                article.urlToImage = obj.value(forKey: "urlToImage") as? String ?? ""
                                //article.chronicle = obj.value(forKey: "description") as? String ?? ""
                                article.url = obj.value(forKey: "url") as? String ?? ""
                                article.id = UUID().uuidString
                                //article.isFavorite = false
                                
                                do {
                                    try moc.save()
                                    
                                } catch {
                                    print(error.localizedDescription)
                                }
                            }
                            
                        }
                    }
                }
            }
        } catch let error as NSError {
            print("Failed to load: \(error.localizedDescription)")
        }
    }

}

struct MainTabView_Previews: PreviewProvider {
    static var previews: some View {
        MainTabView()
    }
}
