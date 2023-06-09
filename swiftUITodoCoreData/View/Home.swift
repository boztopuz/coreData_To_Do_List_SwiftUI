//
//  Home.swift
//  swiftUITodoCoreData
//
//  Created by Burak Öztopuz on 9.06.2023.
//

import SwiftUI

struct Home: View {
    //View Properties
    @Environment(\.self) private var env
    @State private var filterDate: Date = .init()
    @State private var showPendingTask: Bool = true
    @State private var showCompletedTask: Bool = true
    
    var body: some View {
        List{
            DatePicker(selection: $filterDate, displayedComponents: [.date]){
                
            }
            .labelsHidden()
            .datePickerStyle(.graphical)
            
            DisclosureGroup(isExpanded: $showPendingTask) {
               
            } label: {
                Text("Pending Tasks")
                    .foregroundColor(.gray)
                    .font(.caption)
            }
            
            DisclosureGroup(isExpanded: $showCompletedTask) {
               
            } label: {
                Text("Completed Tasks")
                    .foregroundColor(.gray)
                    .font(.caption)
            }
            
        }
    }
}

struct Home_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
