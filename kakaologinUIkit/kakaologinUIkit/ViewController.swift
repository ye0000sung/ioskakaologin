//
//  ViewController.swift
//  kakaologinUIkit
//
//  Created by 윤예성 on 2023/11/08.
//

import UIKit
import SnapKit
import Combine

class ViewController: UIViewController {
    
    var subscriptions = Set<AnyCancellable>()
     lazy var kakaoLoginStatusLabel : UILabel = {
        let label = UILabel()
         label.text = "로그인 여부 라벨"
         return label
    }()
    
    lazy var KakaoLoginButton : UIButton = {
       let btn = UIButton()
        btn.setTitle("카카오 로그인", for: .normal)
        btn.configuration = .filled()
        btn.addTarget(self, action: #selector(loginBtnClicked), for: .touchUpInside)
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
   }()
    
    lazy var KakaoLogoutButton : UIButton = {
       let btn = UIButton()
        btn.setTitle("카카오 로그아웃", for: .normal)
        btn.configuration = .filled()
        btn.addTarget(self, action: #selector(logoutBtnClicked), for: .touchUpInside)
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
   }()
    
    lazy var stackView : UIStackView = {
        let stack = UIStackView()
        stack.spacing = 12
        stack.axis = .vertical
        stack.alignment = .center
        stack.distribution = .fill
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()

    
    lazy var kakaoAuthVM: KakaoAuthVM = { KakaoAuthVM() }()                 
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        kakaoLoginStatusLabel.snp.makeConstraints { make in
            make.height.greaterThanOrEqualTo(70)
        }
        stackView.addArrangedSubview(kakaoLoginStatusLabel)
        stackView.addArrangedSubview(KakaoLoginButton)
        stackView.addArrangedSubview(KakaoLogoutButton)
        
        
        self.view.addSubview(stackView)
        
        
        stackView.snp.makeConstraints { make in
            make.center.equalTo(self.view)
        }
        setBindings()
        
        
    }
    //mark button action
    @objc func loginBtnClicked(){
        print("loginBtnClicked() called")
        kakaoAuthVM.KakaoLogin()
        
    }
    @objc func logoutBtnClicked(){
        print("logoutBtnClicked() called")
        kakaoAuthVM.kakaoLogout()
    }
}
extension ViewController{
    fileprivate func setBindings(){
        self.kakaoAuthVM.$isLoggedIN.sink{[weak self] isLoggedIN in
            guard let self = self else { return }
            self.kakaoLoginStatusLabel.text = isLoggedIN ? "로그인 상태" :
            "로그아웃 상태"
        }
        .store(in: &subscriptions)
    }
}

#if DEBUG

import SwiftUI

struct ViewControllerPresentable: UIViewControllerRepresentable{
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
        
    }
    func makeUIViewController(context: Context) -> some UIViewController {
        ViewController()
    }
    
}

struct ViewControllerPrepresentable_PreviewProivder : PreviewProvider {
    static var previews: some View {
        ViewControllerPresentable()
    }
}

#endif



