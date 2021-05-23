//
//  TodoListView.swift
//  Todo-MongoDB_Realm
//
//  Created by Josh R on 5/21/21.
//

import RealmSwift
import SwiftUI

struct TodoListView: View {
    @Environment(\.presentationMode) var presentationMode
    @ObservedResults(Todo.self) var todos

    @State private var realmService = DefaultRealmService()

    @State private var newTodo: String = ""

    var body: some View {
        VStack {
            HStack {
                TextField("Enter Todo", text: $newTodo)
                Button(action: {
                    $todos.append(Todo(title: newTodo))
                }, label: {
                    Text("ADD")
                        .font(.headline)
                })
                .frame(width: /*@START_MENU_TOKEN@*/100/*@END_MENU_TOKEN@*/, height: 40, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                .background(Color.pink)
                .foregroundColor(.white)
                .cornerRadius(8)
            }.padding(.leading, 16)

            List {
                ForEach(todos) { todo in
                    Text(todo.title)
                }
                .listStyle(InsetGroupedListStyle())
                .background(Color.white)
            }
        }

        .ignoresSafeArea(edges: .bottom)
        .navigationBarBackButtonHidden(true)
        .navigationTitle("Todos")
        .toolbar {
            Button("Log Out") {
                realmService.signOut { result in
                    switch result {
                    case .success():
                        self.presentationMode.wrappedValue.dismiss()
                    case .failure(let error):
                        print("Error signing out: \(error.localizedDescription)")
                    }
                }
            }
        }
    }
}

struct TodoListView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            TodoListView().navigationTitle("Todos")
        }
    }
}
