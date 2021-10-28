//
//  ContentView.swift
//  BSImagePickerSwiftUi_test
//
//  Created by 의정 on 2021/10/28.
//

import SwiftUI
import BSImagePicker

struct ContentView: View {

    @StateObject var viewModel : PhotoPickerVM = PhotoPickerVM()
    
    @State private var showingSheet = false

    @State private var selectedImage : UIImage? = nil
    
    var body: some View {
        VStack{
            
            Image(uiImage: selectedImage ?? UIImage(systemName: "photo")!)
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: 300, height: 300)
                .clipped()
            
            Button("BSImagePicker 띄우기") {
                showingSheet.toggle()
            }
            .fullScreenCover(isPresented: $showingSheet, onDismiss: {
                print("dismiss 되었다.")
            }, content: {
                BSImageSwiftUiView(viewModel: viewModel)
            })
            .onReceive(viewModel.$selectedImg, perform: { img in
                self.selectedImage = img
            })
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}


extension View {
    func compatibleFullScreen<Content: View>(isPresented: Binding<Bool>, @ViewBuilder content: @escaping () -> Content) -> some View {
        self.modifier(PresentFullScreenModifier(isPresented: isPresented, builder: content))
    }
}


/// 풀 스크린 모디파이어
struct PresentFullScreenModifier<V: View>: ViewModifier {
    let isPresented: Binding<Bool>
    let builder: () -> V

    @ViewBuilder
    func body(content: Content) -> some View {
        if #available(iOS 14.0, *) {
            content.fullScreenCover(isPresented: isPresented, content: builder)
        } else {
            content.sheet(isPresented: isPresented, content: builder)
        }
    }
}
