//
//  ViewController.swift
//  TableviewSample
//
//  Created by Maochun Sun on 2020/7/2.
//  Copyright © 2020 Maochun. All rights reserved.
//

import UIKit
import SwipeCellKit

class testItem: NSObject{
    var name: String = ""
    var paused = false
}


class ViewController: UIViewController {
    
    var backgroundColor = UIColor.white
    var selItemText : String = ""
    var theItemArray = [testItem]()
    
    /*
    enum ActionDescriptor {
        
        func title(forDisplayMode displayMode: ButtonDisplayMode) -> String? {
            guard displayMode != .imageOnly else { return nil }
            
            return nil
        }
        
        func image(forStyle style: ButtonStyle, displayMode: ButtonDisplayMode) -> UIImage? {
            guard displayMode != .titleOnly else { return nil }
            
            return nil
        }
        
        var color: UIColor {
            return .white
        }
    }
    enum ButtonDisplayMode {
        case titleAndImage, titleOnly, imageOnly
    }

    enum ButtonStyle {
        case backgroundColor, circular
    }

    var buttonDisplayMode: ButtonDisplayMode = .titleAndImage
    var buttonStyle: ButtonStyle = .backgroundColor
    */

    
    lazy var theTableView: UITableView = {
        let tableView = UITableView(frame: CGRect(x:0, y:0, width: 0, height: 0), style: .plain)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.translatesAutoresizingMaskIntoConstraints = false
        //tableView.estimatedRowHeight = 70
        tableView.rowHeight = 90
        tableView.allowsSelection = true
        tableView.separatorStyle = .singleLine
        tableView.separatorColor = .gray
        tableView.isScrollEnabled = true
        tableView.backgroundColor = .white
        
        tableView.layer.cornerRadius = 12
        
        self.view.addSubview(tableView)
        

        NSLayoutConstraint.activate([
            
            tableView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 14),
            tableView.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 16),
            tableView.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -16),
            tableView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -40)
        
        ])
        
        tableView.register(SwipeTableViewCell.self, forCellReuseIdentifier: "DropdownListItemCell")
        
        return tableView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        self.view.backgroundColor = backgroundColor
        
        for i in 0..<100{
            let item = testItem()
            item.name = "Item \(i+1)"
            self.theItemArray.append(item)
        }
       
        self.theTableView.reloadData()
        
    }


}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        
        return self.theItemArray.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "DropdownListItemCell", for:indexPath)
        
        if let theCell = cell as? SwipeTableViewCell{
            theCell.selectionStyle = .default
            theCell.textLabel?.text = self.theItemArray[indexPath.row].name
            theCell.delegate = self
        }
        
        return cell
        
    }


    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 90
    }
}


extension ViewController: SwipeTableViewCellDelegate{
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
        
        let item = self.theItemArray[indexPath.row]
        
        if orientation == .left {
            
            let resumeAction = SwipeAction(style: .default, title: "Resume") { action, indexPath in
                print("ResumeAction ...")
                
                item.paused = false
                self.theTableView.reloadRows(at: [indexPath], with: UITableView.RowAnimation.none)
            }
            
            resumeAction.image = UIImage(named: "menu_resume_icon")
            resumeAction.backgroundColor = UIColor(red: 0xFF/255, green: 0x60/255, blue: 0x78/255, alpha: 1)
            
            
            let pauseAction = SwipeAction(style: .default, title: "Pause") { action, indexPath in
                print("PauseAction ...")
                
                item.paused = true
                self.theTableView.reloadRows(at: [indexPath], with: UITableView.RowAnimation.none)
            }
            
            pauseAction.image = UIImage(named: "menu_pause_icon")
            pauseAction.backgroundColor = UIColor(red: 0xFF/255, green: 0x60/255, blue: 0x78/255, alpha: 1)
            
            
            
            if item.paused{
                return [resumeAction]
            }else{
                return [pauseAction]
                    
            }
            
        }else{
            
            let callAction = SwipeAction(style: .default, title: "Call") { action, indexPath in
                print("callAction ...")
                
                self.theTableView.reloadRows(at: [indexPath], with: UITableView.RowAnimation.none)
            }
            callAction.image = UIImage(named: "menu_call_icon")
            callAction.backgroundColor = UIColor(red: 0xFF/255, green: 0xb6/255, blue: 0x63/255, alpha: 1)
           

            let navigateAction = SwipeAction(style: .default, title: "Navigate") { action, indexPath in
                print("navigationAction ...")
                
                self.theTableView.reloadRows(at: [indexPath], with: UITableView.RowAnimation.none)
            }
            
            navigateAction.image = UIImage(named: "menu_nav_icon")
            navigateAction.backgroundColor = UIColor(red: 0x3c/255, green: 0x94/255, blue: 0xe1/255, alpha: 1)
            
            let doneAction = SwipeAction(style: .default, title: "Done") { action, indexPath in
                print("doneAction ...")
                
                self.theTableView.reloadRows(at: [indexPath], with: UITableView.RowAnimation.none)
                
            }
            doneAction.image = UIImage(named: "menu_complete_icon")
            doneAction.backgroundColor = UIColor(red: 0x75/255, green: 0xc2/255, blue: 0x62/255, alpha: 1)
            
            
            return [callAction, doneAction, navigateAction]
                
        }
        
    }
    

    
    /*
    func configure(action: SwipeAction, with descriptor: ActionDescriptor) {
        action.title = descriptor.title(forDisplayMode: buttonDisplayMode)
        action.image = descriptor.image(forStyle: buttonStyle, displayMode: buttonDisplayMode)
        
        switch buttonStyle {
        case .backgroundColor:
            action.backgroundColor = descriptor.color
        case .circular:
            action.backgroundColor = .clear
            action.textColor = descriptor.color
            action.font = .systemFont(ofSize: 13)
            action.transitionDelegate = ScaleTransition.default
        }
    }
    */
}
