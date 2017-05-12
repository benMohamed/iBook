//
//  SettingVC.swift
//  Books
//
//  Created by bendnaiba on 3/11/17.
//  Copyright © 2017 AppCoda. All rights reserved.
//

import UIKit
import SwiftyPickerPopover

protocol AddBookViewDelegate {
    func bookAdded()
    func categoryAdded()
}

enum AddType {
    case category
    case book
}


class AddBookView: UIView, UITextFieldDelegate {
    
    //Add Category
    @IBOutlet weak var scrollCategory: UIScrollView!
    @IBOutlet weak var textFieldNameCategory: TextFieldValidator!
    @IBOutlet weak var btnAddCategory: UIButton!
    
    //Add Book
    @IBOutlet weak var btnCategory: UIButton!
    @IBOutlet weak var btnSave: UIButton!
    @IBOutlet weak var textFieldImageBook: TextFieldValidator!
    @IBOutlet weak var textFieldUrlBook: TextFieldValidator!
    @IBOutlet weak var textFieldNameBook: TextFieldValidator!
    @IBOutlet weak var scrollBooks: UIScrollView!
    @IBOutlet weak var textFieldAuthor: TextFieldValidator!
    
    var delegate:AddBookViewDelegate?
    var isError:Bool = true
    var parentVC:UIViewController?
    var addType:AddType = .book
    var mArrayCategory:NSMutableArray?
    
    
    class func instanceFromNib(addType:AddType) -> UIView {
        let addBookView = UINib(nibName: "AddBookView", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! AddBookView
        addBookView.addType = addType
        switch addBookView.addType {
        case .category:
            addBookView.scrollBooks.isHidden = true
            addBookView.scrollCategory.isHidden = false
            break
        case .book:
            addBookView.scrollBooks.isHidden = false
            addBookView.scrollCategory.isHidden = true
            break
        default:
            break
        }
        DataManager.addCorner(radius: 5.0, view: addBookView.scrollCategory)
        DataManager.addCorner(radius: 5.0, view: addBookView.scrollBooks)
        DataManager.addCorner(radius: 5.0, view: addBookView.btnSave)
        DataManager.addCorner(radius: 5.0, view: addBookView.btnAddCategory)
        addBookView.textFieldNameCategory.add(validator: LenghtValidator(validationEvent: .perCharacter, min: 3))
        addBookView.textFieldNameBook.add(validator: LenghtValidator(validationEvent: .perCharacter, min: 3))
        addBookView.textFieldUrlBook.add(validator: PatternValidator(pattern: .url))
        let validationNameBlock:((_: [Error]) -> Void)? = { [weak addBookView] (errors: [Error]) -> Void in
            if let error = errors.first {
                print("not valid %@", error)
                addBookView?.textFieldNameBook.setBottomBorder(color: UIColor.init(red: 249.0/255.0, green: 113.0/255.0, blue: 115.0/255.0, alpha: 1.0))
            } else {
                print("goood")
                addBookView?.textFieldNameBook.setBottomBorder(color: UIColor.init(red: 212.0/255.0, green: 212.0/255.0, blue: 212.0/255.0, alpha: 1.0))
            }
        }
        let validationCategoryBlock:((_: [Error]) -> Void)? = { [weak addBookView] (errors: [Error]) -> Void in
            if let error = errors.first {
                print(error)
                addBookView?.textFieldNameCategory.setBottomBorder(color: UIColor.init(red: 249.0/255.0, green: 113.0/255.0, blue: 115.0/255.0, alpha: 1.0))
            } else {
                addBookView?.textFieldNameCategory.setBottomBorder(color: UIColor.init(red: 212.0/255.0, green: 212.0/255.0, blue: 212.0/255.0, alpha: 1.0))
            }
        }
        let validationUrlBlock:((_: [Error]) -> Void)? = { [weak addBookView] (errors: [Error]) -> Void in
            if let error = errors.first {
                print(error)
                addBookView?.textFieldUrlBook.setBottomBorder(color: UIColor.init(red: 249.0/255.0, green: 113.0/255.0, blue: 115.0/255.0, alpha: 1.0))
            } else {
                addBookView?.textFieldUrlBook.setBottomBorder(color: UIColor.init(red: 212.0/255.0, green: 212.0/255.0, blue: 212.0/255.0, alpha: 1.0))
            }
        }
        
        addBookView.textFieldNameBook.validationBlock = validationNameBlock
        addBookView.textFieldNameCategory.validationBlock = validationCategoryBlock
        addBookView.textFieldUrlBook.validationBlock = validationUrlBlock
        
        return addBookView
    }
    
    //MARK: - Action -
    
    @IBAction func closePushed(_ sender: UIButton) {
        self.removeFromSuperview()
    }
    @IBAction func categoryPushed(_ sender: UIButton) {
        let frame = self.btnCategory.frame
        StringPickerPopover.appearFrom(
            originView: self.btnCategory,
            baseView: self.scrollBooks,
            baseViewController: self.parentVC!,
            title: "Category",
            choices: self.mArrayCategory as! [String],
            initialRow:0,
            doneAction:{selectedRow, selectedString in
                sender.setTitle(selectedString, for: .normal)
        } ,
            cancelAction: {
                print("cancel")
        }
        )
    }
    
    @IBAction func savePushed(_ sender: UIButton) {
        if !self.textFieldNameBook.isValid() {
            self.textFieldNameBook.becomeFirstResponder()
            return
        }
        if !self.textFieldUrlBook.isValid() {
            self.textFieldUrlBook.becomeFirstResponder()
            return
        }
        if self.btnCategory.title(for: .normal) == "Category" {
            self.categoryPushed(self.btnCategory)
            return
        }
        //read local data
        let mArrayBooks:NSMutableArray = NSMutableArray(array: UserDefaults.standard.object(forKey: "BooksList") as! [Any])
        let searching = self.btnCategory.title(for: .normal)
        //let namePredicate = NSPredicate(format: "category == %@",searching!)
        //let filteredArray:Array = mArrayBooks.filter { namePredicate.evaluate(with: $0) }
        for i in 0 ..< mArrayBooks.count {
            let dicoCategory:NSMutableDictionary = NSMutableDictionary(dictionary:mArrayBooks.object(at: i) as! NSDictionary)
            if dicoCategory.getStringForKey(aKey: "category") == searching {
                let newBook:NSDictionary = NSDictionary.init(objects:[self.textFieldNameBook.text, self.textFieldUrlBook.text, self.textFieldImageBook.text, self.textFieldAuthor.text], forKeys: ["name" as NSCopying, "url" as NSCopying,"author" as NSCopying, "image" as NSCopying])
                let mArray:NSMutableArray = NSMutableArray(array: dicoCategory.getArrayForKey(aKey: "liste"))
                mArray.add(newBook)
                dicoCategory.setValue(mArray, forKey: "liste")
                mArrayBooks.replaceObject(at: i, with: dicoCategory)
                break
            }
        }
        UserDefaults.standard.set(mArrayBooks, forKey: "BooksList")
        
        DataManager.showMessage(message: "Book Added", theme: .success)
        self.closePushed(self.btnSave)
        self.delegate?.bookAdded()
    }
    
    @IBAction func addCategoryPushed(_ sender: UIButton) {
        if !self.textFieldNameCategory.isValid() {
            self.textFieldNameCategory.becomeFirstResponder()
            return
        }
        let mArrayBooks:NSMutableArray = NSMutableArray(array: UserDefaults.standard.object(forKey: "BooksList") as! [Any])
        let newCategory:NSDictionary = NSDictionary.init(objects:[self.textFieldNameCategory.text, NSArray()], forKeys: ["category" as NSCopying, "liste" as NSCopying])
        mArrayBooks.add(newCategory)
        UserDefaults.standard.set(mArrayBooks, forKey: "BooksList")
        
        DataManager.showMessage(message: "Category Added", theme: .success)
        self.closePushed(self.btnAddCategory)
        self.delegate?.categoryAdded()
    }
    //MARK: - TextField Delegate -
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.dismissKeyBoard()
        return true
    }
    
    func dismissKeyBoard() {
        self.textFieldImageBook.resignFirstResponder()
        self.textFieldNameBook.resignFirstResponder()
        self.textFieldUrlBook.resignFirstResponder()
        self.textFieldNameCategory.resignFirstResponder()
        self.textFieldAuthor.resignFirstResponder()
        
    }
    
    
}
