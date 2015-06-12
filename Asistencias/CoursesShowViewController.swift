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
    
    private var sessionObserver: ManagedObjectObserver?
    
    private var privateSession: Session? {
        didSet {
            if privateSession != oldValue {
                if privateSession != nil {
                    sessionObserver = ManagedObjectObserver(privateSession!) { (changeType) -> Void in
                        switch changeType {
                        case .Deleted, .Invalidated:
                            self.privateSession = nil
                        case .Updated, .Refreshed:
                            self.sessionDidChange()
                        default:
                            break
                        }
                    }
                } else {
                    sessionObserver = nil
                    resetContent()
                }
                
                sessionDidChange()
                setNeedsLoadContent()
            }
        }
    }
    
    func sessionDidChange() {
        if isViewLoaded() {
            updateViewWithModel()
        }
    }
    
    var session: Session? {
        get {
            if course?.currentSession == nil {
                println("Creating session...")
                createSession()
            }
            
            privateSession = course?.currentSession
            
            return course?.currentSession
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
            self.nameLabel!.text = course?.name
        }
    }
    
    // MARK: - Actions

    @IBAction func closeButtonClicked(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
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
            self.markStudentAssistance(student)
            return student.name
        }
        
        return nil
    }
    
    func markStudentAssistance(student: Student) {
        println("Checking in...")
        self.session?.addStudent(student);
    }
    
    // MARK: - Create Session
    
    func createSession() {
        println("Creating new session")
        let courseId: String = Meteor.documentKeyForObjectID(course!.objectID).documentID as! String
        
        let newSession = NSEntityDescription.insertNewObjectForEntityForName("Session", inManagedObjectContext:managedObjectContext) as! Session
        newSession.course = courseId
        newSession.module = ModuleHelper.module
        
        var error = NSErrorPointer()
        if !managedObjectContext.save(error) {
            println("Encountered error saving objects: \(error)")
        } else {
            println("Session created")
        }
    }
    
    // MARK: - Navigation
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showRutInput" {
            rutInputViewController = segue.destinationViewController as? RutInputViewController
            rutInputViewController?.coursesShowViewController = self
        }
    }
    
}
