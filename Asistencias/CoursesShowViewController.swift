//
//  CoursesShowViewController.swift
//  Asistencias
//
//  Created by Nicolás López on 11-06-15.
//  Copyright (c) 2015 Nicolás López. All rights reserved.
//

import UIKit
import CoreData
import Meteor

class CoursesShowViewController: FetchedResultsViewController {
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var startSessionButton: UIButton!
    @IBOutlet weak var rutInputContainerView: UIView!
    
    var rutInputViewController: RutInputViewController?
    
    // MARK: - Model

    var courseID: NSManagedObjectID? {
        didSet {
            assert(managedObjectContext != nil)
            
            if courseID != nil {
                if courseID != oldValue {
                    course = managedObjectContext!.existingObjectWithID(self.courseID!, error: nil) as? Course
                }
            } else {
                course = nil
            }
        }
    }
    
    private var courseObserver: ManagedObjectObserver?

    private var course: Course? {
        didSet {
            if course != oldValue {
                if course != nil {
                    courseObserver = ManagedObjectObserver(course!) { (changeType) -> Void in
                        switch changeType {
                        case .Deleted, .Invalidated:
                            self.course = nil
                        case .Updated, .Refreshed:
                            self.courseDidChange()
                        default:
                            break
                        }
                    }
                } else {
                    courseObserver = nil
                    resetContent()
                }
                
                courseDidChange()
                setNeedsLoadContent()
            }
        }
    }
    
    func courseDidChange() {
        
        if isViewLoaded() {
            updateViewWithModel()
        }
    }
    
    // MARK: - View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //addTaskContainerView.preservesSuperviewLayoutMargins = true
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        updateViewWithModel()
    }
    
    // MARK: - Content Loading
    
    override func loadContent() {
        if course == nil {
            return
        }
        
        super.loadContent()
    }
    
    override func configureSubscriptionLoader(subscriptionLoader: SubscriptionLoader) {
        if course != nil {
            subscriptionLoader.addSubscriptionWithName("app.course", parameters: course!)
        }
    }
    
    // MARK: - Updating View
    
    func updateViewWithModel() {
        if course == nil {
            
        } else {
            
            println(course?.students)
            
            self.nameLabel!.text = course?.name
            
        }
    }
    
    // MARK: - Actions

    @IBAction func closeButtonClicked(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func startSessionButtonClicked(sender: AnyObject) {
        
    }
    
    // MARK: - Rut Delegate
    
    func getStudentNameWithRut(rut: String) -> String? {
        
        let fetchRequest = NSFetchRequest(entityName: "Student")
        fetchRequest.predicate = NSPredicate(format: "rut == %@", rut)
        fetchRequest.fetchLimit = 1;
        
        var error: NSErrorPointer = nil
        var results: Array = managedObjectContext.executeFetchRequest(fetchRequest, error: error)!
        
        if results.count == 1 {
            var student = results[0] as! Student
            return student.name
        }
        
        return nil
    }
    
    // MARK: - Navigation
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showRutInput" {
            rutInputViewController = segue.destinationViewController as? RutInputViewController
            rutInputViewController?.coursesShowViewController = self
        }
    }
    
}
