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
                CustomFilterDataView(displaypendingTask: true, filterDate: filterDate) {
                    TaskRow(task: $0, isPendingTask: true)
                }
            } label: {
                Text("Pending Tasks")
                    .foregroundColor(.gray)
                    .font(.caption)
            }
            
            DisclosureGroup(isExpanded: $showCompletedTask) {
                CustomFilterDataView(displaypendingTask: false, filterDate: filterDate) {
                    TaskRow(task: $0, isPendingTask: false)
                }
            } label: {
                Text("Completed Tasks")
                    .foregroundColor(.gray)
                    .font(.caption)
            }
            
        }
        .toolbar{
            ToolbarItem(placement: .bottomBar){
                Button {
                    
                } label: {
                    HStack{
                        Image(systemName: "plus.circle.fill")
                            .font(.title3)
                        Text("New Task")
                    }
                    .fontWeight(.bold)
                }
                .frame(maxWidth: .infinity, alignment: .leading)

            }
        }
    }
}

struct Home_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

struct TaskRow: View {
    var task: Task
    var isPendingTask: Bool
    
    @Environment(\.self) private var env
    @FocusState private var showKeyboard: Bool
    var body: some View {
        HStack(spacing: 12){
            Button {
                
            } label: {
                Image(systemName: task.isComplete ? "checkmark.circle.fill" : "circle")
                    .font(.title)
                    .foregroundColor(.blue)
            }
            
            VStack(alignment: .leading, spacing: 4) {
                TextField("Task Title", text: .init(get: {
                    return task.title ?? ""
                }, set: { value in
                    task.title = value
                }))
                .focused($showKeyboard)
                .onSubmit {
                    removeEmtyTask()
                    save()
                }
                
                DatePicker(selection: .init(get: {
                    return task.date ?? .init()
                }, set: { value in
                    task.date = value
                    save()
                }),displayedComponents: [.hourAndMinute]) {
                    
                }
                .labelsHidden()
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            
        }
        .onAppear{
            if (task.title ?? "").isEmpty {
                showKeyboard = true
            }
        }
        .onChange(of: env.scenePhase) { newValue in
            if newValue != .active {
                removeEmtyTask()
                save()
            }
        }
    }
    
    func save() {
        do{
            try env.managedObjectContext.save()
        }catch{
            print(error.localizedDescription)
        }
    }
    
    func removeEmtyTask() {
        if ( task.title ?? "").isEmpty {
            env.managedObjectContext.delete(task)
        }
    }
}
