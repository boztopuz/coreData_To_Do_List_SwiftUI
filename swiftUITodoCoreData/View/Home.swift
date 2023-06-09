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
    @State private var showPendingTask: Bool = false
    @State private var showCompletedTask: Bool = false
    
    var body: some View {
        List{
            DatePicker(selection: $filterDate, displayedComponents: [.date]){
                
            }
            .labelsHidden()
            .datePickerStyle(.graphical)
            
            CustomFilterDataView(filterDate: filterDate) { pendingTask, completedTask in
                DisclosureGroup(isExpanded: $showPendingTask) {
                    if pendingTask.isEmpty {
                        Text("No Task's Found")
                            .font(.caption)
                            .foregroundColor(.gray)
                    }else{
                        ForEach(pendingTask) {
                            TaskRow(task: $0, isPendingTask: true)
                        }
                    
                    }
                    
                } label: {
                    Text("Pending Task's \(pendingTask.isEmpty ? "" : "(\(pendingTask.count))")")
                        .foregroundColor(.gray)
                        .font(.caption)
                }
                
                DisclosureGroup(isExpanded: $showCompletedTask) {
                    if completedTask.isEmpty {
                        Text("No Task's Found")
                            .font(.caption)
                            .foregroundColor(.gray)
                    }else {
                        ForEach(completedTask) {
                            TaskRow(task: $0, isPendingTask: false)
                        }
                    }
                    
                } label: {
                    Text("Completed Tasks \(completedTask.isEmpty ? "" : "(\(completedTask.count))")")
                        .foregroundColor(.gray)
                        .font(.caption)
                }
            }
            
            
            
            
            
        }
        .toolbar{
            ToolbarItem(placement: .bottomBar){
                Button {
                    do{
                        let task = Task(context: env.managedObjectContext)
                        task.id = .init()
                        task.date = filterDate
                        task.isComplete = false
                        
                        try env.managedObjectContext.save()
                        showPendingTask = true
                    }catch{
                        
                    }
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
    @ObservedObject var task: Task
    var isPendingTask: Bool
    
    @Environment(\.self) private var env
    @FocusState private var showKeyboard: Bool
    var body: some View {
        HStack(spacing: 12){
            Button {
                task.isComplete.toggle()
                save()
            } label: {
                Image(systemName: task.isComplete ? "checkmark.circle.fill" : "circle")
                    .font(.title)
                    .foregroundColor(.blue)
            }
            .buttonStyle(.plain)
            
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
                .foregroundColor(isPendingTask ? .primary : .gray)
                .strikethrough(!isPendingTask, pattern: .dash, color: .primary)
                
                Text((task.date ?? .init()).formatted(date: .omitted, time: .shortened))
                    .font(.callout)
                    .foregroundColor(.gray)
                    .overlay{
                        DatePicker(selection: .init(get: {
                            return task.date ?? .init()
                        }, set: { value in
                            task.date = value
                            save()
                        }),displayedComponents: [.hourAndMinute]) {
                            
                        }
                        .labelsHidden()
                        .blendMode(.destinationOver)
                    }
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
        .swipeActions(edge: .trailing, allowsFullSwipe: true) {
            Button(role: .destructive) {
                env.managedObjectContext.delete(task)
                save()
            } label: {
                Image(systemName: "trash.fill")
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
