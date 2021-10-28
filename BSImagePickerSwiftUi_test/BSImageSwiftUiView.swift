//
//  BSImageSwiftUiView.swift
//  BSImagePickerSwiftUi_test
//
//  Created by 의정 on 2021/10/28.
//

import Foundation
import SwiftUI
import UIKit
import BSImagePicker
import Combine
import Photos

struct BSImageSwiftUiView : UIViewControllerRepresentable {
    
    @ObservedObject var viewModel: PhotoPickerVM
    
    func makeUIViewController(context: Context) -> ImagePickerController {
        
        print("BSImageSwiftUiView - makeUIViewController()")
        
        
        let imagePicker = ImagePickerController()
        imagePicker.settings.selection.max = 1
        imagePicker.settings.theme.selectionStyle = .checked
        imagePicker.settings.fetch.assets.supportedMediaTypes = [.image] // 지원 미디어 타입
        imagePicker.settings.selection.unselectOnReachingMax = true

        imagePicker.albumButton.tintColor = UIColor.green
        imagePicker.cancelButton.tintColor = UIColor.red
        imagePicker.doneButton = UIBarButtonItem(title: "완료지롱", style: .done, target: nil, action: nil)
        let start = Date()
        
        imagePicker.imagePickerDelegate = context.coordinator
        
        return imagePicker
    }
    
    func updateUIViewController(_ uiViewController: ImagePickerController, context: Context) {
        print("BSImageSwiftUiView - updateUIViewController()")
    }
    
    // 변경 사항을 전달하는 데 사용하는 사용자 지정 인스턴스를 만듭니다.
    func makeCoordinator() -> Coordinator {
        Coordinator(self, viewModel)
    }
    
    // 탐색 변경을 수락 또는 거부하고 탐색 요청의 진행 상황을 추적
    class Coordinator : NSObject {
        
        var parent: BSImageSwiftUiView
        var foo: AnyCancellable? = nil
        
        var delegate: ImagePickerControllerDelegate?
        
        private var viewModel : PhotoPickerVM
       
        var subscriptions = Set<AnyCancellable>()
        
       // 생성자
        init(_ parent: BSImageSwiftUiView, _ viewModel: PhotoPickerVM) {
            print(#file, #function, #line, "")
            
            // 뷰모델 연결
            self.viewModel = viewModel
            
            self.parent = parent
       } // init()

       // 소멸자
       deinit {
           print(#file, #function, #line, "")
           foo?.cancel()
       }
        
    } // Coordinator
    
}


extension BSImageSwiftUiView.Coordinator : ImagePickerControllerDelegate {
    
    func imagePicker(_ imagePicker: ImagePickerController, didSelectAsset asset: PHAsset) {
        print("didSelectAsset: asset: \(asset)")
        
        self.getImageFromAsset(asset: asset, completion: { fetchedImg in
            print("가져온 이미지 : fetchedImg")
            self.viewModel.selectedImg = fetchedImg
        })
    }
    
    func imagePicker(_ imagePicker: ImagePickerController, didDeselectAsset asset: PHAsset) {
        print("didDeselectAsset: asset: \(asset)")
    }
    
    func imagePicker(_ imagePicker: ImagePickerController, didFinishWithAssets assets: [PHAsset]) {
        print("didFinishWithAssets: assets: \(assets.count)")
    }
    
    func imagePicker(_ imagePicker: ImagePickerController, didCancelWithAssets assets: [PHAsset]) {
        print("didCancelWithAssets: assets: \(assets.count)")
    }
    
    func imagePicker(_ imagePicker: ImagePickerController, didReachSelectionLimit count: Int) {
        print("didReachSelectionLimit: count")
    }
    
}


extension BSImageSwiftUiView.Coordinator {
    // 컴플레션 핸들러로 이미지 가져오기
    func getImageFromAsset(asset: PHAsset, completion: @escaping (UIImage) -> Void){
        
        // 이미지 메모리에 캐시
        let imageManager = PHCachingImageManager()
        
        // 캐시 퀄리티 설정
        imageManager.allowsCachingHighQualityImages = true
        
        // 이미지 요청시 속성 설정
        let imageOptions = PHImageRequestOptions()
        imageOptions.deliveryMode = .highQualityFormat
        imageOptions.isSynchronous = false
        
        // 메모리 사용량을 줄이기 위해 이미지 썸네일 사이즈 만큼 가져오기
        let size = CGSize(width: 300, height: 300)
        
        // 이미지 매니져로 이미지 요청해서 가져오기
        imageManager.requestImage(for: asset, targetSize: size, contentMode: .aspectFill, options: imageOptions) { fetchedImage, _ in

            guard let resizedImage = fetchedImage else { return }

            // 컴플레션 터트려서 이미지 가져왔다고 알려주기
            completion(resizedImage)
        }
    }
}
