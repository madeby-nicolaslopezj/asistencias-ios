//
//  CoursesIndexViewController.swift
//  Asistencias
//
//  Created by Nicolás López on 11-06-15.
//  Copyright (c) 2015 Nicolás López. All rights reserved.
//

import UIKit
import Meteor
import CoreData
import YIInnerShadowView

class CoursesIndexViewController: FetchedResultsTableViewController, UIViewControllerTransitioningDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.makeItCool()
        self.tableView.rowHeight = UITableViewAutomaticDimension;
        self.tableView.estimatedRowHeight = 200
        self.managedObjectContext = Meteor.mainQueueManagedObjectContext
    }
    
    // MARK: - Styling
    
    func makeItCool() {
        //self.view.layer.masksToBounds = false
        //self.tableView.layer.masksToBounds = true
        //self.addBorder()
    }
    
    func addBorder() {
        self.view.layer.borderColor = UIColor.grayColor().CGColor
        self.view.layer.borderWidth = 2
    }
    
    // MARK: - Meteor
    
    override func configureSubscriptionLoader(subscriptionLoader: SubscriptionLoader) {
        subscriptionLoader.addSubscriptionWithName("app.courses")
    }
    
    override func createFetchedResultsController() -> NSFetchedResultsController? {
        let fetchRequest = NSFetchRequest(entityName: "Course")
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "name", ascending: true)]
        
        return NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: managedObjectContext, sectionNameKeyPath: nil, cacheName: nil)
    }
    
    // MARK: - FetchedResultsTableViewDataSourceDelegate
    /*
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if let course = dataSource.objectAtIndexPath(indexPath) as? Course {
            return CourseTableViewCell.getHeightForCourse(course)
        }
        
        return 0
    }
    */
    
    func dataSource(dataSource: FetchedResultsTableViewDataSource, configureCell cell: CourseTableViewCell, forObject object: NSManagedObject, atIndexPath indexPath: NSIndexPath) {
        if let course = object as? Course {
            cell.nameLabel!.text = course.name
            cell.teacherLabel!.text = course.teacher
            cell.codeLabel!.text = course.abbreviation
        }
    }
    

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let coursesShowViewController = segue.destinationViewController as? CoursesShowViewController {
            if let selectedCourse = dataSource.selectedObject as? Course {
                coursesShowViewController.managedObjectContext = managedObjectContext
                coursesShowViewController.courseID = selectedCourse.objectID
                coursesShowViewController.transitioningDelegate = self
                coursesShowViewController.modalPresentationStyle = .Custom
            }
        }
    }
    
    
    // MARK: UIViewControllerTransitioningDelegate
    
    func animationControllerForPresentedController(presented: UIViewController, presentingController presenting: UIViewController, sourceController source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        var transition = SecondTransition()
        transition.transitionMode = .Present
        return transition
    }
    
    func animationControllerForDismissedController(dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        var transition = SecondTransition()
        transition.transitionMode = .Dismiss
        return transition
    }

}
