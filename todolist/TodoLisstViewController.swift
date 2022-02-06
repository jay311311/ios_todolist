//
//  ViewController.swift
//  todolist
//
//  Created by Jooeun Kim on 2022/02/04.
//

import UIKit

class TodoListViewController: UIViewController {

    @IBOutlet weak var collectionView : UICollectionView!
    @IBOutlet weak var inputViewBottom : NSLayoutConstraint!
    @IBOutlet weak var inputTextField : UITextField!

    @IBOutlet weak var isTodayButton : UIButton!
    @IBOutlet weak var addButton : UIButton!

    //todo : todoModal 만들기
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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

extension TodoListViewController {
    @objc private func adjustInputView(noti: Notification) {
        guard let userInfo = noti.userInfo else { return }
        // TODO: 키보드 높이에 따른 인풋뷰 위치 변경
        
    }
}

extension TodoListViewController : UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        //todo : 섹션 몇개?
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        //todo : 섹션 아이템 몇개
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        //todo : 커스텀쎌
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TodoListCell", for: indexPath) as? TodoListCell else {
            return UICollectionViewCell()
        }
        return cell
        //todo : todo 를 이용해서 updateUI
        //todo :  donbuttonhandler 작성
        //todo : deleteButtonHandler 작성
        
     //  return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        switch kind {
        case UICollectionView.elementKindSectionHeader:
            guard let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "TodoListHeaderView", for: indexPath) as? TodoListHeaderView else {
                return UICollectionReusableView()
            }
            
            guard let section = TodoViewModel.Section(rawValue: indexPath.section) else {
                return UICollectionReusableView()
            }

            header.sectionTitleLabel.text = section.title
            return header
        default:
            return UICollectionReusableView()
        }
    }
}


extension TodoListViewController : UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView : UICollectionView, layout collectionViewLayout : UICollectionViewLayout, sizeForItemAt indexPath : IndexPath ) -> CGSize {
        // todo : 사이즈 계산하기
        
        let width : CGFloat = collectionView.bounds.width
        let height: CGFloat = 50
        return CGSize(width: width, height: height)
        
    }
}


class TodoListCell : UICollectionViewCell{
    @IBOutlet weak var checkButton : UIButton!
    @IBOutlet weak var descriptionLabel : UILabel!
    @IBOutlet weak var deleteButton : UIButton!
    
    @IBOutlet weak var strikeThroughWidth : NSLayoutConstraint!
    
    var donButtonTapHandler: ((Bool) -> Void)?
    var deleteButtonTapHandler:(() -> Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        reset()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        reset()
    }
    
    func updateUI(todo : Any){
        // 셀 업데이트 하기 any ->  Todo 수정
    }
    
    private func showStrikeThrough(_ show: Bool){
        if show{
            strikeThroughWidth.constant = descriptionLabel.bounds.width
        }else{
            strikeThroughWidth.constant = 0
        }
    }
    
    func reset(){
        //todo : reset 로직 구현
        
    }
    
    @IBAction func checkButtonTapped(_ sender : Any){
        //todo : check button 처리
    }
    
    @IBAction func deleteButtonTapped(_ sender : Any){
        //todo : eletetbutton 처리
        deleteButtonTapHandler?()

    }
}

class TodoListHeaderView : UICollectionReusableView{
    @IBOutlet weak var sectionTitleLabel : UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
    }
}


