//
//  TaskTableViewCell.swift
//  realmTodo
//
//  Created by karma on 3/14/22.
//

import UIKit

class TaskTableViewCell: UITableViewCell {

    @IBOutlet weak var nameLbl: UILabel!
   
    
    func setData(task: Tasktodo){
        nameLbl.text = task.name
    }

}
