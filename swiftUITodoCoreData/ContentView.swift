//
//  ContentView.swift
//  swiftUITodoCoreData
//
//  Created by Burak Öztopuz on 9.06.2023.
//

import SwiftUI

struct ContentView: View {
    
    
    
    var body: some View {
        NavigationStack{
            Home()
                .navigationTitle("To-Do")
        }
    }
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
        
    }
}
