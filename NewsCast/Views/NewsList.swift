//
//  NewsList.swift
//  NewsCast
//
//  Created by Vignesh on 25/04/23.
//

import SwiftUI

struct NewsList: View {
    
    @Environment(\.managedObjectContext) var moc
    @Environment(\.dismiss) private var dismiss
    
    @FetchRequest(sortDescriptors: []) var articles: FetchedResults<Article>
    
    @State private var showSafari: Bool = false

    
    var body: some View {
        List(articles) { article in
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
                            Text("Fox news")
                                .foregroundColor(.gray)
                                .font(.system(size: 15, weight: .regular))
                            
                            Spacer()
                            
                            Button {
                                print("")
                            } label: {
                                Image(systemName: "heart")
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
}


struct NewsList_Previews: PreviewProvider {
    static var previews: some View {
        NewsList()
    }
}
