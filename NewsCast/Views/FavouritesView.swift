//
//  FavouritesView.swift
//  NewsCast
//
//  Created by Vignesh on 27/04/23.
//

import SwiftUI

struct FavouritesView: View {
    
    @Environment(\.managedObjectContext) var moc
    @Environment(\.dismiss) private var dismiss
    
    @FetchRequest(sortDescriptors: [], predicate: NSPredicate(format: "isActive == true")) var users: FetchedResults<User>
    
    
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
                    
                    ForEach(users, id: \.self) { user in
                        ForEach(user.favoriteArray, id: \.self) { favorite in
                            HStack(alignment: .top) {
                                AsyncImage(
                                    url: URL(string: favorite.urlToImage ?? ""),
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
                                    Text(favorite.title ?? "Unknown")
                                        .foregroundColor(.black)
                                        .font(.system(size: 17, weight: .semibold))
                                        .lineLimit(3)
                                        .onTapGesture {
                                            showSafari.toggle()
                                        }
                                        .fullScreenCover(isPresented: $showSafari, content: {
                                            SFSafariViewWrapper(url: URL(string: favorite.url ?? "")!)
                                        })
                                    
                                    
                                    Spacer()
                                    
                                    HStack(alignment: .bottom){
                                        Text("TechCrunch ‧ 1 month ago")
                                            .foregroundColor(.gray)
                                            .font(.system(size: 15, weight: .regular))
                                        
                                        Spacer()
                                        
                                        Button {
                                            // article.isFavorite.toggle()
                                            
                                            moc.delete(favorite)
                                            
                                            do {
                                                try moc.save()
                                            } catch {
                                                print(error.localizedDescription)
                                            }
                                            
                                        } label: {
                                            let user =  searchUser()
                                            let favoriteArticle =  searchFavorites(articleId: favorite.articleId ?? "", email: user?.email ?? "")
                                            
                                            if favoriteArticle   == nil {
                                                Image(systemName: "heart.fill")
                                            } else {
                                                Image(systemName: "heart.fill")
                                            }
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
                    .padding(.trailing, 10)
                }
                .navigationBarTitle(Text("Favourites"))
            }
        }
    }

    

