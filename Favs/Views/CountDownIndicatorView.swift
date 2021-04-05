    //
    //  CountDownIndicatorView.swift
    //  Favs
    //
    //  Created by yum on 2021/03/28.
    //
    
    import SwiftUI
    
    enum CountDownStatus {
        case counting
        case finished
        case waiting
    }
    
    struct CountDownIndicatorView: View {
        var lineWidth: CGFloat = 8
        var font: Font?
        @State var count: Int = 10
        var onStopped: () -> Void = {}
        
        @State private var status: CountDownStatus = .waiting
        @EnvironmentObject var holder: TimerHolder
        
        var body: some View {
            ZStack {
                IndicatorView(lineWidth: self.lineWidth)
                
                Group {
                    if self.holder.count <= self.count {
                        Text(String(self.count - self.holder.count))
                            .font(font ?? .body)
                            .onAppear {
                                if self.status != .counting {
                                    self.status = .counting
                                    self.holder.start()
                                }
                            }
                    } else {
                        Text(String(0))
                            .font(font ?? .body)
                            .onAppear {
                                if self.status == .counting {
                                    self.status = .finished
                                    self.holder.stop()
                                    self.onStopped()
                                }
                            }
                    }
                }
            }
        }
    }
    
    struct CountDownIndicatorView_Previews: PreviewProvider {
        
        static var previews: some View {
            CountDownIndicatorView()
                .environmentObject(TimerHolder())
                .frame(width: 160, height: 160)
        }
        
        static func createHolder() -> TimerHolder {
            let holder = TimerHolder()
            holder.start()
            return holder
        }
    }
