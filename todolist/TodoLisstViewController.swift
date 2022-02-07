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

    //todo : todoViewModal 만들기
    
    let todoListViewModel = TodoViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // todo : 키보드 디텍션
        
        NotificationCenter.default.addObserver(self, selector: #selector(adjustInputView), name:  UIResponder.keyboardWillShowNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(adjustInputView), name:  UIResponder.keyboardWillHideNotification, object: nil)
        
        // todo : 데이터 불러오기
        todoListViewModel.loadTasks()
//        
//        let todo = TodoManager.shared.createTodo(detail: "🤜펀치", isToday: true)
//        Storage.saveTodo(todo, fileName: "test.json")
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
//        let todo = Storage.restoreTodo("test.json")
//        print("========\(todo)")
    }
    
    
    
    @IBAction func isTodaysButtonTapped(_ sender: Any){
        //todo : 투데이 버튼 토글 작업
        isTodayButton.isSelected = !isTodayButton.isSelected
        
    }
    @IBAction func addTaskButtonTapped(_ sender : Any){
        // todo: TOdo 태스크 추가
        // add task to view modal
        // adan tableview reload or update
        
        guard let detail = inputTextField.text, detail.isEmpty == false else { return }
        
        let todo = TodoManager.shared.createTodo(detail: detail, isToday: isTodayButton.isSelected)
        todoListViewModel.addTodo(todo)
        collectionView.reloadData()
        inputTextField.text = ""
        isTodayButton.isSelected = false
        
        
    }
    
    //todo : 백그라운드 탭할때, 키보드 내려오게 하기
    
    @IBAction func tapBG(_ sender: Any) {
        inputTextField.resignFirstResponder()
    }
    
}

extension TodoListViewController {
    @objc private func adjustInputView(noti: Notification) {
        guard let userInfo = noti.userInfo else { return }
        // TODO: 키보드 높이에 따른 인풋뷰 위치 변경
        guard let keyboardFrame = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else{ return }
        
        if noti.name  ==  UIResponder.keyboardWillShowNotification {
            let adjustmentHeight =  keyboardFrame.height - view.safeAreaInsets.bottom
            inputViewBottom.constant = adjustmentHeight
        } else {
            inputViewBottom.constant = 0
        }
        print("keyborard endframe ===>\(keyboardFrame)")
    }
}

extension TodoListViewController : UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        //todo : 섹션 몇개?
        return todoListViewModel.numOfSection
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        //todo : 섹션 아이템 몇개
        if section == 0 {
           return todoListViewModel.todayTodos.count
        }else {
            return todoListViewModel.upcompingTodos.count
        }
        
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        //todo : 커스텀쎌
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TodoListCell", for: indexPath) as? TodoListCell else {
            return UICollectionViewCell()
        }
  
        
        var todo : Todo
        if indexPath.section == 0 {
        todo =  todoListViewModel.todayTodos[indexPath.item]
        }else{
          todo =  todoListViewModel.upcompingTodos[indexPath.item]
        }
        cell.updateUI(todo: todo)
        
        //todo : todo 를 이용해서 updateUI
        //todo :  donbuttonhandler 작성
        //todo : deleteButtonHandler 작성
        
        cell.donButtonTapHandler = { isDone in
            todo.isDone = isDone
            self.todoListViewModel.updateTodo(todo)
            self.collectionView.reloadData()
            
        }
        
        cell.deleteButtonTapHandler = {
            self.todoListViewModel.deleteTodo(todo)
            self.collectionView.reloadData()
            
        }
        
        
       return cell
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
    @IBOutlet weak var strikeThroughtView : UIView!
    
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
    
    func updateUI(todo : Todo){
        // 셀 업데이트 하기
        checkButton.isSelected = todo.isDone
        descriptionLabel.text = todo.detail
        descriptionLabel.alpha = todo.isDone ? 0.2 : 1
        deleteButton.isHidden =  todo.isDone == false
        showStrikeThrough(todo.isDone)
    }
    
    private func showStrikeThrough(_ show: Bool){
        if show{
            strikeThroughWidth.constant = 200
        }else{
            strikeThroughWidth.constant = 0
        }
    }
    
    func reset(){
        //todo : reset 로직 구현
        descriptionLabel.alpha = 1
        deleteButton.isHidden = false
        showStrikeThrough(false)
    }
    
    @IBAction func checkButtonTapped(_ sender : Any){
        //todo : check button 처리 & todo리스트 관리하는 곳에서 done 처리 제공
        checkButton.isSelected =  !checkButton.isSelected
        let isDone = checkButton.isSelected
        showStrikeThrough(false)
        descriptionLabel.alpha = isDone ? 0.2 : 1
        deleteButton.isHidden = !isDone
        donButtonTapHandler?(isDone)
        print("클릭했자")
    }
    
    @IBAction func deleteButtonTapped(_ sender : Any){
        //todo : deletetbutton 처리 & todo리스트 관리하는 곳에서 delete처리 제공
        deleteButtonTapHandler?()
        //deleteButtonTapHandler?()

    }
}

class TodoListHeaderView : UICollectionReusableView{
    @IBOutlet weak var sectionTitleLabel : UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
    }
}


