//
//  DatabaseController.swift
//  ACTouchBar
//
//  Created by Yuhel Tanaka on 2019/02/06.
//  Copyright © 2019 Yuhel Tanaka. All rights reserved.
//

import Cocoa
import CoreData

class ACDatabaseController: NSObject {
    
    static let shared = ACDatabaseController()
    let appDelegate: AppDelegate = NSApplication.shared.delegate as! AppDelegate

    
    func fetchProblemsInformationData() -> [Problem] {
        var problems:[Problem] = []
        
        let managedContext: NSManagedObjectContext = NSManagedObjectContext.init(concurrencyType: .mainQueueConcurrencyType)
        managedContext.parent = appDelegate.persistentContainer.viewContext
        
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "ProblemsDB")
        
        do {
            let fetchedArray = try managedContext.fetch(fetchRequest)

            for problem in fetchedArray {
                let id = problem.value(forKey: "id") as! String
                let title = problem.value(forKey: "title") as! String
                let contest_id = problem.value(forKey: "contest_id") as! String
                problems.append(Problem.init(id: id, contest_id: title, title: contest_id))
            }
        } catch let error {
            print(error)
        }
        return problems
    }
    
    func fetchSubmissionInformationData() -> [Submission] {
        var problems:[Submission] = []
        
        let managedContext: NSManagedObjectContext = NSManagedObjectContext.init(concurrencyType: .mainQueueConcurrencyType)
        managedContext.parent = appDelegate.persistentContainer.viewContext
        
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "SubmissionsDB")
        let sortDescripter = NSSortDescriptor(key: "id", ascending: false)
        fetchRequest.sortDescriptors = [sortDescripter]
        fetchRequest.fetchLimit = 100
        
        do {
            let fetchedArray = try managedContext.fetch(fetchRequest)
            
            for problem in fetchedArray {
                let contest_id = problem.value(forKey: "contest_id") as! String
                let epoch_second = problem.value(forKey: "epoch_second") as! Int
                let execution_time = problem.value(forKey: "contest_id") as? Int
                let id = problem.value(forKey: "id") as! Int
                let language = problem.value(forKey: "language") as! String
                let length = problem.value(forKey: "length") as! Int
                let point = problem.value(forKey: "point") as! Float
                let problem_id = problem.value(forKey: "problem_id") as! String
                let result = problem.value(forKey: "result") as! String
                let user_id = problem.value(forKey: "user_id") as! String
                let sub = Submission.init(execution_time: execution_time, point: point, result: result, problem_id: problem_id, user_id: user_id, epoch_second: epoch_second, contest_id: contest_id, id: id, language: language, length: length)
                problems.append(sub)
            }
        } catch let error {
            print(error)
        }
        return problems
    }
    
    func saveProblemsInformationData(problems: [Problem]) {
        let viewContext: NSManagedObjectContext = NSManagedObjectContext.init(concurrencyType: .privateQueueConcurrencyType)
        viewContext.parent = appDelegate.persistentContainer.viewContext
        viewContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
        
        for problem in problems {
            guard let entity = NSEntityDescription.entity(forEntityName: "ProblemsDB", in: viewContext) else {continue}
            let newRecord = NSManagedObject(entity: entity, insertInto: viewContext)
            
            newRecord.setValue(problem.id, forKey: "id")
            newRecord.setValue(problem.contest_id, forKey: "contest_id")
            newRecord.setValue(problem.title, forKey: "title")
        }
        
        do {
            try viewContext.save()
            print("success")
        }
        catch let error {
            print(error)
        }
    }
    
    func saveSubmissionsData(submissions: [Submission]) {
        let viewContext: NSManagedObjectContext = NSManagedObjectContext.init(concurrencyType: .privateQueueConcurrencyType)
        viewContext.parent = appDelegate.persistentContainer.viewContext
        
        for submission in submissions {
            guard let entity = NSEntityDescription.entity(forEntityName: "SubmissionsDB", in: viewContext) else {continue}
            let newRecord = NSManagedObject(entity: entity, insertInto: viewContext)
                        
            newRecord.setValue(submission.execution_time, forKey: "execution_time")
            newRecord.setValue(submission.point, forKey: "point")
            newRecord.setValue(submission.result, forKey: "result")
            newRecord.setValue(submission.problem_id, forKey: "problem_id")
            newRecord.setValue(submission.user_id, forKey: "user_id")
            newRecord.setValue(submission.epoch_second, forKey: "epoch_second")
            newRecord.setValue(submission.contest_id, forKey: "contest_id")
            newRecord.setValue(submission.id, forKey: "id")
            newRecord.setValue(submission.language, forKey: "language")
            newRecord.setValue(submission.length, forKey: "length")
        }
        
        do {
            try viewContext.save()
            print("success")
        }
        catch let error {
            print(error)
        }
    }
    
    func removeSubmissionData() {
        let managedContext: NSManagedObjectContext = NSManagedObjectContext.init(concurrencyType: .mainQueueConcurrencyType)
        managedContext.parent = appDelegate.persistentContainer.viewContext
        
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "SubmissionsDB")
        
        do {
            let fetchedArray = try managedContext.fetch(fetchRequest)
            print(fetchedArray)
            for i in fetchedArray {
                managedContext.delete(i)
            }
        } catch let error {
            print(error)
        }
        
        do {
            try managedContext.save()
            print("success")
        }
        catch let error {
            print(error)
        }
    }
    
    
    func removeInformationData() {
        let managedContext: NSManagedObjectContext = NSManagedObjectContext.init(concurrencyType: .mainQueueConcurrencyType)
        managedContext.parent = appDelegate.persistentContainer.viewContext
        
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "ProblemsDB")
        
        do {
            let fetchedArray = try managedContext.fetch(fetchRequest)
            print(fetchedArray)
            for i in fetchedArray {
                managedContext.delete(i)
            }
        } catch let error {
            print(error)
        }
        
        do {
            try managedContext.save()
            print("success")
        }
        catch let error {
            print(error)
        }
    }
    
}


