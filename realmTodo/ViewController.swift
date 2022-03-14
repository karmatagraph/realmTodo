//
//  ViewController.swift
//  realmTodo
//
//  Created by karma on 3/11/22.
//

import UIKit
import RealmSwift

class ViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    
    // create instance of the db
    let realm = try! Realm()
    var tasks: [Tasktodo] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        
        // location of the realm file
        print("Realm is located at:", realm.configuration.fileURL!)
        
        tableView.dataSource = self
        tableView.delegate = self
        getData()
        
        // add the left add button
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(didTapAdd))
        
    }
    
    
    @objc func didTapAdd(){
        // alert pop up
        let alert = UIAlertController(title: "New Item", message: "Enter a new Task", preferredStyle: .alert)
        // textfield for the alert box
        alert.addTextField(configurationHandler: nil)
        
        // add submit action button which will save it to the core data
        // weak self to address memory leak
        alert.addAction(UIAlertAction(title: "Submit", style: .cancel, handler: {[weak self]_ in
            // validation of the textfield done in the closure
            guard let field = alert.textFields?.first, let text = field.text, !text.isEmpty else{
                return
            }
            // add it to the core data
            let newTask = Tasktodo()
            newTask.name = text
            newTask.createdAt = Date.now
            self?.saveData(task: newTask)
            
            
        }))
        
        alert.addAction(UIAlertAction(title: "cancel", style: .destructive, handler: nil))
        
        
        
        present(alert, animated: true)
    }
    

    // REALM
    func getData(){
        // Get all tasks in the realm
        tasks = Array(realm.objects(Tasktodo.self))
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
        print("the task from db: \(tasks)")
    }
    
    func saveData(task: Tasktodo){
        do{
            realm.beginWrite()
            realm.add(task)
            try realm.commitWrite()
            getData()
            
        }catch let error{
            print("error saving data: \(error)")
        }
        
    }
    
    func updateData(old: Tasktodo, newName: String){
        
        do{
            realm.beginWrite()
            old.name = newName
            try realm.commitWrite()
            getData()
        }catch let error{
            print("error updating: \(error)")
        }
        
    }
    
    func deleteData(task: Tasktodo){
        do{
            realm.beginWrite()
            realm.delete(task)
            try realm.commitWrite()
            getData()
            
        }catch let error{
            print(error)
        }
    }
}

extension ViewController: UITableViewDelegate{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // the task is selected
        tableView.deselectRow(at: indexPath, animated: true)
        
        // get the selected row value
        let item = tasks[indexPath.row]
        // alert pop up
        let sheet = UIAlertController(title: "Edit", message: nil, preferredStyle: .actionSheet)
        
        // add submit action button which will save it to the core data
        // weak self to address memory leak
        sheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        sheet.addAction(UIAlertAction(title: "Edit", style: .default, handler: { _ in
            let alert = UIAlertController(title: "Edit your Item", message: "Edit Task", preferredStyle: .alert)
            // textfield for the alert box
            alert.addTextField(configurationHandler: nil)
            // show the name to be edited
            alert.textFields?.first?.text = item.name
            // add submit action button which will save it to the core data
            // weak self to address memory leak
            alert.addAction(UIAlertAction(title: "Save", style: .cancel, handler: {[weak self] _ in
                // validation of the textfield done in the closure
                guard let field = alert.textFields?.first, let newName = field.text, !newName.isEmpty else{
                    return
                }
                // add it to the core data
                self?.updateData(old: item, newName: newName)
            }))
            self.present(alert, animated: true, completion: nil)
        }))
        
        sheet.addAction(UIAlertAction(title: "Delete", style: .destructive, handler: { [weak self] _ in
            self?.deleteData(task: item)
        }))
        present(sheet, animated: true, completion: nil)
    }
}


extension ViewController: UITableViewDataSource{
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let task = tasks[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "TaskTableViewCell",for: indexPath) as! TaskTableViewCell
        cell.setData(task: task)
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tasks.count
    }
    
    
}

