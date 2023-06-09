//
//  CustomFilterDataView.swift
//  swiftUITodoCoreData
//
//  Created by Burak Öztopuz on 9.06.2023.
//

import SwiftUI

struct CustomFilterDataView<Content: View>: View {
    var content: (Task) -> Content
    @FetchRequest private var result: FetchedResults<Task>
    init(displaypendingTask: Bool, filterDate: Date, content: @escaping (Task) -> Content) {
        let calendar = Calendar.current
        let startDay = calendar.startOfDay(for: filterDate)
        let endOfDay = calendar.date(bySettingHour: 23, minute: 59, second: 59, of: startDay)!
        
        let predicate = NSPredicate(format: "date >= %@ AND date <= %@ AND isCompleted == %i", startDay as NSDate, (endOfDay as NSDate), !displaypendingTask)
        
        _result = FetchRequest(entity: Task.entity(), sortDescriptors: [
            NSSortDescriptor(keyPath: \Task.date, ascending: false)
        ], predicate: predicate, animation: .easeInOut(duration: 0.25))
        
        self.content = content
    }
    
    var body: some View {
        Group{
            if result.isEmpty{
                Text("No Task's Found")
                    .font(.caption)
                    .foregroundColor(.gray)
                    .listRowSeparator(.hidden)
            }else {
                ForEach(result){
                    content($0)
                }
            }
        }
    }
}

struct CustomFilterDataView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
