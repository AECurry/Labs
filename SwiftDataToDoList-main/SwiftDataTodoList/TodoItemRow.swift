//
//  TodoItemRow.swift
//  SwiftDataTodoList
//
//  Created by Parker Rushton on 6/2/25.
//

import SwiftUI


struct TodoItemRow: View {
    let item: TodoItem
    let onTap: () -> Void
    
    var body: some View {
        HStack {
            Image(systemName: item.isCompleted ? "checkmark.circle.fill" : "circle")
                .foregroundColor(item.isCompleted ? .green : .gray)
            
            VStack(alignment: .leading) {
                Text(item.title)
                    .strikethrough(item.isCompleted)
                Text(item.createdAt, style: .date)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
        }
        .padding(.vertical, 8)
        .contentShape(Rectangle())
        .onTapGesture(perform: onTap)
    }
}

#Preview(traits: .sizeThatFitsLayout) {
    TodoItemRow(item: TodoItem(title: "Buy milk"), onTap: { })
}
