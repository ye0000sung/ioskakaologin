//
//  KakaoAuthVM.swift
//  kakaologinUIkit
//
//  Created by 윤예성 on 2023/11/08.
//

import Foundation
import Combine
import KakaoSDKAuth
import KakaoSDKUser

class KakaoAuthVM: ObservableObject {
    var subscriptions = Set<AnyCancellable>()
    
    @Published var isLoggedIN : Bool = false
    
    init(){
        print("kakaoAuthVM- init() called")
    }
    
    func kakaoLoginWithApp() async -> Bool{
        await withCheckedContinuation{ continuation in
            
            if (UserApi.isKakaoTalkLoginAvailable()) {
                
                
                UserApi.shared.loginWithKakaoTalk {(oauthToken, error) in
                    if let error = error {
                        print(error)
                        continuation.resume(returning: false)
                    }
                    else {
                        print("loginWithKakaoTalk() success.")
                        //do something
                        _ = oauthToken
                        continuation.resume(returning: true)
                        self.bringname()
                    }
                }
            }
        }
    }
    func kakaoLoginWithAccount() async -> Bool{
        await withCheckedContinuation{ continuation in
            UserApi.shared.loginWithKakaoAccount {(oauthToken, error) in
                if let error = error {
                    print(error)
                    continuation.resume(returning: false)
                    
                }
                else {
                    print("loginWithKakaoAccount() success.")
                    continuation.resume(returning: true)
                    self.bringname()
                    //do something
                    _ = oauthToken
                }
            }
        }
    }
    func bringname(){
        UserApi.shared.me() {(user, error) in
            if let error = error {
                print(error)
            }
            else {
                print("me() success.")
                
                //do something
                _ = user
            }
        }
    }
    @MainActor
    func KakaoLogin(){
        print("KakaoAuthVM - handleKakaoLogin() called")
        Task{
            // 카카오톡 실행 가능 여부 확인
            if (UserApi.isKakaoTalkLoginAvailable()) {
                isLoggedIN = await kakaoLoginWithApp()
            }else {
                isLoggedIN = await kakaoLoginWithAccount()
            }
        }
    }
    @MainActor
    func kakaoLogout(){
        Task{
            if await handlekakaoLogout(){
                self.isLoggedIN = false
            }
        }
    }
    //logout
    func handlekakaoLogout() async -> Bool{
        await withCheckedContinuation{ continuation in
            UserApi.shared.logout {(error) in
                if let error = error {
                    print(error)
                    continuation.resume(returning: false)
                }
                else {
                    print("logout() success.")
                    continuation.resume(returning: true)
                }
            }
        }
    }
}
        
      
