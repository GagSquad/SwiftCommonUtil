//
//  BaseCoreData.swift
//  CommonUtil
//
//  Created by lijunjie on 15/12/7.
//  Copyright © 2015年 lijunjie. All rights reserved.
//

import Foundation
import CoreData

public class BaseCoreData {
    var persistentStoreCoordinator: NSPersistentStoreCoordinator? {
        get {
            if managedObjectModel != nil {
                return nil;
            }
            
            if self.persistentStoreCoordinator != nil {
                return self.persistentStoreCoordinator;
            }

            let databasePath = self.getPath();
            let storeURL = NSURL.fileURLWithPath(databasePath);
            
            self.persistentStoreCoordinator = NSPersistentStoreCoordinator.init(managedObjectModel:managedObjectModel!);
            
            do {
                try persistentStore = self.persistentStoreCoordinator?.addPersistentStoreWithType(storeType, configuration: nil, URL: storeURL, options: nil);
            } catch {
                print("Unresolved error");
                abort();
            }
            
            if persistentStore == nil {
                print("Unresolved error");
                abort();
            }
            return self.persistentStoreCoordinator;
        }
        set {
            self.persistentStoreCoordinator = newValue;
        }
    }
    var managedObjectModel: NSManagedObjectModel? {
        get {
            if modelFileName.isEmpty {
                return nil;
            }
            
            if self.managedObjectModel != nil {
                return self.managedObjectModel;
            }
            
            let rag = modelFileName.rangeOfString(".momd");
            var copymodFileName = modelFileName;
            
            if  let r =  rag {
                copymodFileName = modelFileName.substringToIndex(r.endIndex);
            }
            let modelURL = NSBundle.mainBundle().URLForResource(copymodFileName, withExtension: "momd");
            return NSManagedObjectModel(contentsOfURL: modelURL!);
        }
        set {
            self.managedObjectModel = newValue;
        }
    }
    var managedObjectContext: NSManagedObjectContext?;
    var persistentStore: NSPersistentStore?;
    var modelFileName: String = "";
    var savePath: String = "";
    var saveName: String = "";
    var storeType: String = "";
    
    public init(modelFileName: String, savePath: String, saveName: String, storeType: String) {
        self.modelFileName = modelFileName;
        self.saveName = saveName;
        self.savePath = savePath;
        self.storeType = storeType;
        self.initManagedObjectContext();
    }
    
    public func cleanUp() {
        persistentStoreCoordinator = nil;
        managedObjectModel = nil;
        managedObjectContext = nil;
        persistentStore = nil;
    }
    
    public func initManagedObjectContext() {
        if managedObjectModel != nil {
            return;
        }
        
        if persistentStoreCoordinator != nil {
            return;
        }
        
        if managedObjectContext != nil {
            managedObjectContext = NSManagedObjectContext.init(concurrencyType: .PrivateQueueConcurrencyType);
            managedObjectContext?.persistentStoreCoordinator = persistentStoreCoordinator;
            managedObjectContext?.mergePolicy = NSMergeByPropertyStoreTrumpMergePolicy;
        }
    }
    
    private func getPath() -> String {
        let fileMgr: NSFileManager = NSFileManager.defaultManager();
        
        if !fileMgr.fileExistsAtPath(savePath) {
            do {
                try fileMgr.createDirectoryAtPath(savePath, withIntermediateDirectories: true, attributes: nil);
            } catch {
                print("创建文件失败！");
            }
        }
        return (savePath as NSString).stringByAppendingPathComponent(saveName);
    }
    
    public func performBlock(block: () -> Void) {
        let moc = managedObjectContext;
        moc?.performBlock(block);
    }
    
    public func performBlock(block: (moc: NSManagedObjectContext) -> Void, complete: () -> Void) {
        let moc = managedObjectContext;
        moc?.performBlock({ () -> Void in
            block(moc: moc!);
            dispatch_async(dispatch_get_main_queue(), complete);
        });
    }

    public func safelySaveContextMOC() {
        self.managedObjectContext?.performBlockAndWait({ () -> Void in
            self.saveContextMOC();
        });
    }
    
    public func unsafelySaveContextMOC() {
        self.managedObjectContext?.performBlockAndWait({ () -> Void in
            self.saveContextMOC();
        });
    }
    
    public func saveContextMOC() {
        self.managedObjectContext?.performBlock({ () -> Void in
            self.saveContext(self.managedObjectContext!);
        });
    }
    
    public func saveContext(savedMoc:NSManagedObjectContext) -> Bool {
        var contextToSave:NSManagedObjectContext? = savedMoc;
        while (contextToSave != nil) {
            var success = false;
            do {
                let s: NSSet = (contextToSave?.insertedObjects)! as NSSet;
                try contextToSave?.obtainPermanentIDsForObjects(s.allObjects as! [NSManagedObject]);
            } catch {
                print("保存失败！！！");
                return false;
            }
            if contextToSave?.hasChanges == true {
                do {
                    try contextToSave?.save();
                    success = true;
                } catch {
                    print("Saving of managed object context failed");
                    success = false;
                }
            } else {
                success = true;
            }
            if success == false {
                return false;
            }
            if contextToSave!.parentContext == nil && contextToSave!.persistentStoreCoordinator == nil {
                print("Reached the end of the chain of nested managed object contexts without encountering a persistent store coordinator. Objects are not fully persisted.");
                return false;
            }
            contextToSave = contextToSave?.parentContext;
        }
        return true;
    }
}
