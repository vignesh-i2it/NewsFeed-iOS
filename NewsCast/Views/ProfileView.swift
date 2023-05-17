//
//  ProfileView.swift
//  NewsCast
//
//  Created by Vignesh on 24/04/23.
//


import SwiftUI
import FirebaseAuth
import iPhoneNumberField
import Combine


struct ProfileView: View {
    @StateObject var viewModel: ProfileViewModel
    
    @Environment(\.managedObjectContext) var moc
    @Environment(\.dismiss) private var dismiss
    
    @State private var isAuthenticatingName = false
    @State private var isAuthenticatingPhone = false
    @State private var name = ""
    @State private var phone = ""
    
    
    @FetchRequest(sortDescriptors: [], predicate: NSPredicate(format: "isActive == true")) var users: FetchedResults<User>

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

    
    private func searchUser() -> User?{
        var user : User?
        let request = User.fetchRequest()
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
    
    var body: some View {
    
        NavigationView{
            ForEach(users, id: \.self) { user in
                VStack {
                    Spacer()
                    ProfileImage(url: user.image)//url: viewModel.imageURL)
                                    .frame(width: 200, height: 200)
                        Spacer()
//                        Text(viewModel.name)
//                            .font(.title2)
//                            .bold()
//                            .padding()
                        ImagePickerButton(imageURL: $viewModel.imageURL) {
                            Label("Choose Image", systemImage: "photo.fill")
                        }
                        
                        Spacer()

                    HStack{
                        Text("Name  : ")
                        //.font(.title2)
                            .font(Font.custom("Helvetica", size: 20))
                            .foregroundColor(.gray)
                        Text(user.name ?? "Unknown")
                            .font(.title2)
                            .bold()
                        
                        
                        Spacer()
                        
//                        Button("load") {
//                            loadArticle()
//                        }
                        
                        Button {
                            isAuthenticatingName.toggle()
                            
                            let user = searchUser()
                            user?.image = $viewModel.imageURL.wrappedValue
                            
                            do {
                                try moc.save()
                            } catch {
                                print(error.localizedDescription)
                            }
     
                        } label: {
                            Image(systemName: "highlighter")
                        }
                        .alert("Enter your name", isPresented: $isAuthenticatingName) {
                            TextField("Name", text: $name)
                                .textInputAutocapitalization(.never)
                            
                            Button("Save", action: {
                                let user = searchUser()
                                user?.name = name
                                
                                do {
                                    try moc.save()
                                } catch {
                                    print(error.localizedDescription)
                                }
                            })
                            
                        } message: {
                            Text("")
                        }
                        
                    }
                    .padding(EdgeInsets(top: 35, leading: 50, bottom: 0, trailing: 60))
                    
                    HStack{
                        Text("Phone : ")
                            .font(Font.custom("Helvetica", size: 20))
                            .foregroundColor(.gray)
                        
                        Text(user.phone ?? "Unknown")
                            .font(.title2)
                            .bold()
                        
                        Spacer()
                        
                        Button {
                            isAuthenticatingPhone.toggle()
                            
                        } label: {
                            Image(systemName: "highlighter")
                        }
                        .alert("Enter your phone number", isPresented: $isAuthenticatingPhone) {
//                            TextField("Phone", text: $phone)
//                                .textInputAutocapitalization(.never)
                            
                            TextField("Phone", text: $phone)
                                        .keyboardType(.numberPad)
                                        .onReceive(Just(phone)) { newValue in
                                            let filtered = newValue.filter { "0123456789".contains($0) }
                                            if filtered != newValue {
                                                self.phone = filtered
                                            }
                                        }
                            

                            
                            Button("save", action: {
                                let user = searchUser()
                                
                                user?.phone = phone
                                
                                do {
                                    try moc.save()
                                } catch {
                                    print(error.localizedDescription)
                                }
                            })
                            
                        } message: {
                            Text("")
                        }
                    }
                    .padding(EdgeInsets(top: 2, leading: 50, bottom: 40, trailing: 60))
                    
                    Button("Sign Out", action: {
                        //try! Auth.auth().signOut()
                        viewModel.signOut()
                    })
                    .foregroundColor(.white)
                    .frame(width: 200, height: 50)
                    .background(.blue)
                    .cornerRadius(50)
                    .padding()
                    .font(.title2)
                    Spacer()
                }
            }
            .navigationTitle("Profile")
            
        }
        //.alert("Error", error: $viewModel.error)
        .disabled(viewModel.isWorking)
    }
}
