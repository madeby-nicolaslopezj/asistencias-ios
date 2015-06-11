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

class CoursesIndexViewController: FetchedResultsTableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.managedObjectContext = Meteor.mainQueueManagedObjectContext
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
    
    func dataSource(dataSource: FetchedResultsTableViewDataSource, configureCell cell: CourseTableViewCell, forObject object: NSManagedObject, atIndexPath indexPath: NSIndexPath) {
        if let course = object as? Course {
            cell.course = course
            cell.nameLabel!.text = course.name
            cell.teacherLabel!.text = course.teacher
        }
    }
    

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let coursesShowViewController = segue.destinationViewController as? CoursesShowViewController {
            if let selectedCourse = dataSource.selectedObject as? Course {
                coursesShowViewController.managedObjectContext = managedObjectContext
                coursesShowViewController.courseID = selectedCourse.objectID
            }
        }
    }

}
