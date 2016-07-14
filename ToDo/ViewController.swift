//
//  ViewController.swift
//  ToDo
//
//  Created by 杨逸飞 on 16/7/11.
//  Copyright © 2016年 杨逸飞. All rights reserved.
//

import UIKit

var todos: [TodoModel] = []
var filteredTodos: [TodoModel] = []

func dateFromString(dateStr: String) ->NSDate?{
    let dateFormatter = NSDateFormatter()
    dateFormatter.dateFormat = "yyyy-MM-dd"
    let date = dateFormatter.dateFromString(dateStr)
    return date
}

class ViewController: UIViewController,UITableViewDataSource,UITableViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    let searchController = UISearchController(searchResultsController: nil)
    //通过参数searchResultsController传nil来初始化UISearchController
    
    //MARK - UITableViewDataSource
    @available(iOS 2.0, *)
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        //if tableView == searchDisplayController?.searchResultsTableView
        if (self.searchController.active) {
            return filteredTodos.count
        }
        else {
            return todos.count
        }
    }
    
    @available(iOS 2.0, *)
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
        let cell = self.tableView.dequeueReusableCellWithIdentifier("todoCell")! as UITableViewCell
        var todo: TodoModel
        if searchController.active && searchController.searchBar.text != "" {
            todo = filteredTodos[indexPath.row] as TodoModel
        }
        else {
            todo = todos[indexPath.row] as TodoModel
        }
        let image = cell.viewWithTag(101) as! UIImageView
        let title = cell.viewWithTag(102) as! UILabel
        let date = cell.viewWithTag(103) as! UILabel
        image.image = UIImage(named: todo.image)
        title.text = todo.title
        let locale = NSLocale.currentLocale()
        let dateFormat = NSDateFormatter.dateFormatFromTemplate("yyyy-MM-dd", options: 0, locale: locale)
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = dateFormat
        date.text = dateFormatter.stringFromDate(todo.date)
        return cell
    }
    
    //MARK - UITableViewDelegate
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath){
        if editingStyle == UITableViewCellEditingStyle.Delete{
            todos.removeAtIndex(indexPath.row)
            self.tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Automatic)
        }
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 80
    }
    
    //MARK - Move Cell
    @available(iOS 2.0, *)
    func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return editing
    }
    
    @available(iOS 2.0, *)
    func tableView(tableView: UITableView, moveRowAtIndexPath sourceIndexPath: NSIndexPath, toIndexPath destinationIndexPath: NSIndexPath){
        let todo = todos.removeAtIndex(sourceIndexPath.row)
        todos.insert(todo, atIndex: destinationIndexPath.row)
    }
    
    //MARK - Edit Mode
    override func setEditing(editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        self.tableView.setEditing(editing, animated: animated)
    }
    
    //MARK - close
    @IBAction func close(segue: UIStoryboardSegue){
        tableView.reloadData()
    }
    
    //MARK -Segue
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "EditTodo" {
            let vc = segue.destinationViewController as! DetailViewController
            let indexPath = tableView.indexPathForSelectedRow
            
            //deselect(cancel the grey)
            tableView.deselectRowAtIndexPath(indexPath!, animated: false)
            
            if let index:NSIndexPath = indexPath {
                if searchController.active && searchController.searchBar.text != "" {
                    vc.todo = filteredTodos[index.row]
                }
                else {
                    vc.todo = todos[index.row]
                }
            }
        }
    }
    
    //MARK - save the result of search
    func filterContentForSearchText(searchText: String, scope: String = "All") {
        filteredTodos = todos.filter { TodoModel in
        return TodoModel.title.lowercaseString.containsString(searchText.lowercaseString)
        }
        tableView.reloadData()
    }
    
    //MARK - system init
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        todos = [TodoModel(id: "1", image: "child-selected", title: "1.去游乐场", date: dateFromString("2014-11-02")!),
            TodoModel(id: "2", image: "shopping-cart-selected",title: "2.购物", date: dateFromString("2014-10-28")!),
            TodoModel(id: "3", image: "phone-selected", title: "3.打电话", date: dateFromString("2014-10-30")!),
            TodoModel(id: "4", image: "travel-selected", title: "4.Travel to Europe", date: dateFromString("2014-10-31")!)]
        
        navigationItem.leftBarButtonItem = editButtonItem()
        
        //searchController config
        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = false
        definesPresentationContext = true
        tableView.tableHeaderView = searchController.searchBar
        searchController.searchBar.placeholder = "搜索Todo"
        
        //hide searchBar
        //var contentOffset = tableView.contentOffset
        //contentOffset.y += searchController.searchBar.frame.size.height
        //tableView.contentOffset = contentOffset
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}

extension ViewController: UISearchResultsUpdating {
    func updateSearchResultsForSearchController(searchController: UISearchController) {
        filterContentForSearchText(searchController.searchBar.text!)
    }
}