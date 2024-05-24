//
//  ContentView.swift
//  SwiftUIMarathon09
//
//  Created by Mike Rudoy on 24/05/2024.
//

import SwiftUI

struct ContentView: View {
    
    let csize = CGFloat(100)
    
    let startPoint = CGPoint(x: UIScreen.main.bounds.width / 2.0, y:  UIScreen.main.bounds.height / 2.0)
    
    @State private var position = CGSize(width: 0, height: 0)
    
    func dragGesture() -> some Gesture {
        DragGesture()
            .onChanged({ g in
                withAnimation {
                    self.position = g.translation
                }
            }).onEnded({ g in
                self.position = .zero
            })
    }
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                Rectangle()
                    .fill(
                        .radialGradient(colors: [.yellow,  .red], center: .center, startRadius: csize / 2, endRadius: csize)
                    )
                    .mask {
                        Canvas { context, size in
                            let c0 = context.resolveSymbol(id: 0)!
                            let c1 = context.resolveSymbol(id: 1)!
                            context.addFilter(.alphaThreshold(min: 0.5, color: Color.red))
                            context.addFilter(.blur(radius: 15, options: .dithersResult))
                            context.drawLayer { ctx in
                                ctx.draw(c0, at: startPoint)
                                ctx.draw(c1, at: startPoint)
                            }
                        } symbols: {
                            Circle()
                                .fill(.yellow)
                                .frame(width: csize, height: csize)
                                .tag(0)
                            Circle()
                                .fill(.red)
                                .frame(width: csize, height: csize)
                                .offset(x: position.width, y: position.height)
                                .tag(1)
                        }
                    }
                    .animation(.bouncy, value: self.position)
                Image(systemName: "cloud.sun.rain.fill")
                    .symbolRenderingMode(.hierarchical)
                    .foregroundColor(.white)
                    .font(.largeTitle)
                    .frame(width: csize, height: csize)
                    .tint(.blue)
                    .offset(position)
                    .gesture(dragGesture())
                    .animation(.bouncy, value: self.position)
            }.ignoresSafeArea()
                .background(.black)
        }
                
    }
}

#Preview {
    ContentView()
}
