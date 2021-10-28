//
//  PhotoPickerVM.swift
//  BSImagePickerSwiftUi_test
//
//  Created by 의정 on 2021/10/28.
//

import Foundation
import Combine
import Photos
import UIKit

/// 사진 선택 뷰모델
class PhotoPickerVM: ObservableObject {

    /// 새로고침
    var reloadEvent = PassthroughSubject<(), Never>()
    
    @Published var didFinishLoading : Bool = false {
        didSet{
            print(#file, #function, #line, "didFinishLoading: \(didFinishLoading)")
        }
    }
    
    @Published var selectedImg : UIImage? = nil
    
    lazy var isLoading : AnyPublisher<Bool, Never> = $didFinishLoading.removeDuplicates().eraseToAnyPublisher()
    
    var isLoadingEvent = PassthroughSubject<Bool, Never>()
    
    init() {

    }
    
} //
