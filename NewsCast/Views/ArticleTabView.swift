//
//  ArticleTabView.swift
//  NewsCast
//
//  Created by Vignesh on 21/04/23.
//

import SwiftUI

struct ArticleTabView: View {
    
    @Environment(\.managedObjectContext) var moc
    @Environment(\.dismiss) private var dismiss
    
    @FetchRequest(sortDescriptors: []) var articles: FetchedResults<Article>
    
    
    
    @State private var showSafari: Bool = false
    
    private func searchUser() -> User?{
        var user : User?
        let request = User.fetchRequest() // NSFetchRequest<User>(entityName: "User")
        request.predicate = NSPredicate(format: "isActive == true")

        do {
            let results = try moc.fetch(request)
            if results.count > 0{
                user =  results[0]
            }
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
        return user
    }
    
    private func searchFavorites(articleId: String, email: String) -> Favorites?{
        var favorite : Favorites?
        let request = Favorites.fetchRequest() // NSFetchRequest<User>(entityName: "User")
        request.predicate = NSPredicate(format: "articleId ==  %@ AND email == %@", articleId, email)

        do {
            let results = try moc.fetch(request)
            if results.count > 0{
                favorite =  results[0]
            }
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
        return favorite
    }
    
    
    //    private func collectFavorites(email: String) -> [String] {
    //        var favorites = [Favorites]()
    //        let request = Favorites.fetchRequest() // NSFetchRequest<User>(entityName: "User")
    //        request.predicate = NSPredicate(format: "email ==  %@ AND isFavorite == true", email)
    //
    //        do {
    //            let results = try moc.fetch(request)
    //            if results.count > 0 {
    //                favorites =  results
    //            }
    //        } catch let error as NSError {
    //            print("Could not fetch. \(error), \(error.userInfo)")
    //        }
    //        //return favorites
    //
    //        var articleIds = [String]()
    //
    //        for item in favorites {
    //            articleIds.append(item.articleId ?? "")
    //        }
    //
    //        return articleIds
    //    }
    //
    

    
    
    var body: some View {
        NavigationView{
            ScrollView {
                VStack(alignment: .leading) {
                    
                    ForEach(articles, id: \.self) { article in
                        HStack(alignment: .top) {
                            AsyncImage(
                                url: URL(string: article.urlToImage ?? ""),
                                           content: { image in
                                               image
                                                .resizable()
                                                .frame(width: 100, height: 100)
                                                .padding(EdgeInsets(top: 0, leading: 10, bottom: 0, trailing: 0))
                                                .onTapGesture {
                                                    showSafari.toggle()
                                            }
                                           },
                                           placeholder: {
                                               ZStack{
                                                   Color.gray
                                                       
                                                   ProgressView()
                                               }
                                               .frame(width: 100, height: 100)
                                               .padding(EdgeInsets(top: 0, leading: 10, bottom: 0, trailing: 0))
                                               
                                           }
                                       )

                                VStack(alignment: .leading) {
                                    Text(article.title ?? "Unknown")
                                        .foregroundColor(.black)
                                        .font(.system(size: 17, weight: .semibold))
                                        .lineLimit(3)
                                        .onTapGesture {
                                                showSafari.toggle()
                                        }
                                        .fullScreenCover(isPresented: $showSafari, content: {
                                            SFSafariViewWrapper(url: URL(string: article.url ?? "")!)
                                        })
                                       

                                    Spacer()
                                    
                                    HStack(alignment: .bottom){
                                        Text("TechCrunch ‧ 1 month ago")
                                            .foregroundColor(.gray)
                                            .font(.system(size: 15, weight: .regular))
                                        
                                        Spacer()
                                        
                                        Button {
                                           
                                            
                                            let favorite = Favorites(context: moc)
                                            
                                            let user =  searchUser()
                                            //let userEmail = user?.email
                                            
                                            //let favoriteArticle =  searchFavorites(articleId: article.id ?? "", email: user?.email)
                                            
                                            let favoriteArticle =  searchFavorites(articleId: article.id ?? "", email: user?.email ?? "")

                                            
                                            
                                            
                                            
                                            if favoriteArticle == nil {
                                                
                                                
                                                //favorite.email = user?.email
                                                favorite.articleId = article.id
                                                favorite.isFavorite = true
                                                favorite.title = article.title
                                                favorite.url = article.url
                                                favorite.urlToImage = article.urlToImage
                                                favorite.email = user?.email
                                                
                                                
                                                favorite.origin = user
                                                
                                                do {
                                                    try moc.save()
                                                } catch {
                                                    print(error.localizedDescription)
                                                }
                                                
                                            } else {
                                                
                                                
                                                //favoriteArticle?.isFavorite.toggle()
                                                moc.delete(favorite)
                                            
                                                do {
                                                    try moc.save()
                                                } catch {
                                                    print(error.localizedDescription)
                                                }
                                            }
                                            
                                        } label: {
                                            
                                            //let favoriteArticle =  searchFavorites(articleId: article.id ?? "", email: user.email)
                                            let user =  searchUser()
                                            let favoriteArticle =  searchFavorites(articleId: article.id ?? "", email: user?.email ?? "")
                                            
                                            if favoriteArticle == nil {
                                                Image(systemName: "heart")
                                            } else {
                                                Image(systemName: "heart.fill")
                                            }
                                            
                                            
                                        }
                                        .buttonStyle(.bordered)
                                          
                                        }
                                    }

                                    

            
                        }
                      .fixedSize(horizontal: false, vertical: true)
                      .frame(maxHeight: 100)
                      .padding(EdgeInsets(top: 5, leading: 0, bottom: 5, trailing: 0))
                    }
                }
                .navigationBarTitle(Text("Headlines"))
                .padding(.trailing, 10)
            }//.navigationBarTitle(Text("Headlineses"))
        }
            
    }
}
    
    struct ArticleTabView_Previews: PreviewProvider {
        static var previews: some View {
            ArticleTabView()
        }
    }

