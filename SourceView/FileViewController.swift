//
//  FileViewController.swift
//  SourceView
//
//  Translated by OOPer in cooperation with shlab.jp, on 2015/4/6.
//
//
/*
 Copyright (C) 2016 Apple Inc. All Rights Reserved.
 See LICENSE.txt for this sample’s licensing information

 Abstract:
 View controller object to host the UI for file information
 */

import Cocoa

@objc(FileViewController)
class FileViewController: NSViewController {
    
    var url: NSURL?
    
    @IBOutlet private var fileIcon: NSImageView!
    @IBOutlet private var fileName: NSTextField!
    @IBOutlet private var fileSize: NSTextField!
    @IBOutlet private var modDate: NSTextField!
    @IBOutlet private var creationDate: NSTextField!
    @IBOutlet private var fileKindString: NSTextField!
    
    //MARK: -
    
    // -------------------------------------------------------------------------------
    //	awakeFromNib
    // -------------------------------------------------------------------------------
    override func awakeFromNib() {
        // listen for changes in the url for this view
        self.addObserver(self,
            forKeyPath: "url",
            options: [.New, .Old],
            context: nil)
    }
    
    // -------------------------------------------------------------------------------
    //	dealloc
    // -------------------------------------------------------------------------------
    deinit {
        self.removeObserver(self, forKeyPath: "url")
    }
    
    // -------------------------------------------------------------------------------
    //	observeValueForKeyPath:ofObject:change:context
    //
    //	Listen for changes in the file url.
    // -------------------------------------------------------------------------------
    override func observeValueForKeyPath(keyPath: String?,
        ofObject object: AnyObject?,
        change: [String : AnyObject]?,
        context: UnsafeMutablePointer<Void>)
    {
        if let url = self.url, path = url.path {
            // name
            self.fileName.stringValue = NSFileManager.defaultManager().displayNameAtPath(path)
            
            // icon
            let iconImage = NSWorkspace.sharedWorkspace().iconForFile(path)
            iconImage.size = NSMakeSize(64, 64)
            self.fileIcon.image = iconImage
            if let attr = try? NSFileManager.defaultManager().attributesOfItemAtPath(path) {
                // file size
                let theFileSize = attr[NSFileSize] as! NSNumber
                self.fileSize.stringValue = "\(theFileSize.stringValue) KB on disk"
                
                // creation date
                let fileCreationDate = attr[NSFileCreationDate] as! NSDate
                self.creationDate.stringValue = fileCreationDate.description
                
                // mod date
                let fileModDate = attr[NSFileModificationDate] as! NSDate
                self.modDate.stringValue = fileModDate.description
            }
            
            // kind string
            var kindStr: AnyObject?
            _ = try? url.getResourceValue(&kindStr, forKey: NSURLLocalizedTypeDescriptionKey)
            if let str = kindStr as? String {
                self.fileKindString.stringValue = str
            }
        } else {
            self.fileName.stringValue = ""
            self.fileIcon.image = nil
            self.fileSize.stringValue = ""
            self.creationDate.stringValue = ""
            self.modDate.stringValue = ""
            self.fileKindString.stringValue = ""
        }
    }
    
}