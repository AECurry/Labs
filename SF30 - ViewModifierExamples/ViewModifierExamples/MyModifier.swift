//
//  MyModifier.swift
//  ViewModifierExamples
//
//  Created by Toby Youngberg on 9/15/25.
//

import SwiftUI

struct MyModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.headline)
            .bold()
            .italic()
            .strikethrough()
            .underline()
            .tint(.blue)
            .border(Color.pink, width: 42)
            .overlay(RoundedRectangle(cornerRadius: 40) .stroke(Color.blue, lineWidth: 2))
            .background(Color.brown)
            .frame(width: 260, height: 180)
            .padding(55)
            .offset(x: 10, y: 10)
            .position(x: 50, y: 50)
    }
}

extension View {
    func myModifier() -> some View {
        modifier(MyModifier())
    }
}

#Preview {
    MyView()
    
}


struct MyCustom: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.title)
            .bold()
            .italic()
            .strikethrough()
            .underline()
            .tint(.blue)
            .border(Color.red, width: 2)
            .frame(width: 260, height: 80)
            .background(RoundedRectangle(cornerRadius: 16) .stroke(Color.green, lineWidth: 2) .fill(Color.yellow) )
            .padding(24)
            .offset(x: 10, y: 10)
            .position(x: 190, y: 200)
    }
}

extension View {
    func myCustom() -> some View {
        modifier(MyCustom())
    }
}

#Preview {
    MyView()
    
}
