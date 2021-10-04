//
//  ContentView.swift
//  Canvas
//
//  Created by Local Administrator on 27/09/21.
//

import SwiftUI

@available(iOS 15.0, *)
struct ContentView: View {
    
    @State var lines : [Line] = []
    @State var deletedLine : [Line] = []
    
    @State var selectedColor : Color = .black
    @State var selectedWidth : CGFloat = 1
    
    var body: some View {
        VStack {
            ColorPicker("Select Color", selection: $selectedColor)
            Slider(value: $selectedWidth, in: 0...10)
            HStack{
                Button("Undo"){
                    dump(lines)
                    guard let last = lines.last else {
                        return
                    }
                    deletedLine.append(last)
                    lines.removeLast()
                }
                Button("Redo"){
                    guard let last = deletedLine.last else {
                        return
                    }
                    lines.append(last)
                    deletedLine.removeLast()
                }
            }
            Canvas{ context,size in
                for line in lines{
                    var path = Path()
                    path.addLines(line.points)
                    context.stroke(path, with: .color(line.color), lineWidth: line.lineWidth)
                }
            }
            .gesture(
                DragGesture(minimumDistance: 0, coordinateSpace: .local)
                    .onChanged({ value in
                        let loc = value.location
                        
                        if value.translation.width + value.translation.height == 0{
                            lines.append(
                                Line(points: [loc], color: selectedColor, lineWidth: selectedWidth)
                            )
                            deletedLine = []
                        }else{
                            let lastIndex = lines.count - 1
                            lines[lastIndex].points.append(loc)
                        }
                    })
            )
            
        }
    }
}


struct Line {
    var points : [CGPoint] = []
    var color : Color = .blue
    var lineWidth : CGFloat = 1
}


@available(iOS 15.0, *)
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
