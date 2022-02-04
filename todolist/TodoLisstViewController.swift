//
//  ViewController.swift
//  todolist
//
//  Created by Jooeun Kim on 2022/02/04.
//

import UIKit

class TodoListViewController: UIViewController {

//    @IBOutlet week var collectionView : UICollectionView!
//    @IBOutlet week var inputViewBottom : NSLayoutConstraint!
//    @IBOutlet week var inputTextField : UITextField!
//
//    @IBOutlet week var isTodayButton : UIButton!
//    @IBOutlet week var addButton : UIButton!
//
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        // todo : 키보드 디텍션
        
        // todo : 데이터 불러오기
        
        
    }
    
    @IBAction func isTodaysButtonTapped(_ sender: Any){
        //todo : 투데이 버튼 토글 작업
        
    }
    @IBAction func addTaskButtonTapped(_ sender : Any){
        // todo: TOdo 태스크 추가
        // add task to view modal
        // adan tableview reload or update
        
    }
    


}

extension TodoListViewController{
    @objc private func adjustInputView(noti: Notification){
        guard let userInfo =  noti.userInfo else { return }
    }
}

