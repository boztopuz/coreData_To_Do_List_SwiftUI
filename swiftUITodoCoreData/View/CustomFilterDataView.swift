//
//  CustomFilterDataView.swift
//  swiftUITodoCoreData
//
//  Created by Burak Öztopuz on 9.06.2023.
//

import SwiftUI

struct CustomFilterDataView<Content: View>: View {
    var content: ([Task], [Task]) -> Content
    @FetchRequest private var result: FetchedResults<Task>
    init(filterDate: Date, @ViewBuilder content: @escaping ([Task], [Task]) -> Content) {
        let calendar = Calendar.current
        let startDay = calendar.startOfDay(for: filterDate)
        let endOfDay = calendar.date(bySettingHour: 23, minute: 59, second: 59, of: startDay)!
        
        let predicate = NSPredicate(format: "date >= %@ AND date <= %@", argumentArray: [startDay, endOfDay])
        
        _result = FetchRequest(entity: Task.entity(), sortDescriptors: [
            NSSortDescriptor(keyPath: \Task.date, ascending: false)
        ], predicate: predicate, animation: .easeInOut(duration: 0.25))
        
        self.content = content
    }
    
    var body: some View {
        content(separateTasks().0, separateTasks().1)
    }
    
    func separateTasks() -> ([Task], [Task]) {
        let pendingTasks = result.filter { !$0.isComplete }
        let completedTasks = result.filter { !$0.isComplete }
        
        return (pendingTasks, completedTasks)
    }
}

struct CustomFilterDataView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
