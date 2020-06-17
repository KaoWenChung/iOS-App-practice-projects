//
//  FeedParser.swift
//  SimpleRSSReader
//
//  Created by wyn on 2020/5/20.
//  Copyright © 2020 AppCoda. All rights reserved.
//

import Foundation

typealias ArticleItem = (title: String, description: String, pubDate: String)

class FeedParser: NSObject, XMLParserDelegate {
    
    private var rssItems: [ArticleItem] = []
    private var currentElement = ""
    private var currentTitle: String = "" {
        didSet {
            currentTitle = currentTitle.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        }
    }
    private var currentDescription: String = "" {
        didSet {
            currentDescription = currentDescription.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        }
    }
    private var currentPubDate: String = "" {
        didSet {
            currentPubDate = currentPubDate.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        }
    }
    private var parserCompletionHandler:(([(title: String, description: String, pubDate: String)]) -> Void)?
    
    
    enum RssTag: String {
        case item = "item"
        case title = "title"
        case description = "description"
        case pubDate = "pubDate"
    }
    
    func parseFeed(feedUrl: String, completionHandler: (([(title: String, description: String, pubDate: String)]) -> Void)?) -> Void {
    
        self.parserCompletionHandler = completionHandler
        
        let request = URLRequest(url: URL(string: feedUrl)!)
        let urlSession = URLSession.shared
        let task = urlSession.dataTask(with: request, completionHandler: { (data, response, error) -> Void in
            guard let data = data else {
                if let error = error { print(error) }
            return
            }
            
            // Parse XML data
            let parser = XMLParser(data: data)
            parser.delegate = self
            parser.parse()
            
        })
        
        task.resume()
    }
    
    func parserDidStartDocument(_ parser: XMLParser) {
        rssItems = []
    }
    
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attrubuteDict: [String : String] = [:]) {
    
        currentElement = elementName
        
        if currentElement == RssTag.item.rawValue {
            currentTitle = ""
            currentDescription = ""
            currentPubDate = ""
        }
    }
    
    func parser(_ parser: XMLParser, foundCharacters string: String) {
        
        switch currentElement {
        case RssTag.title.rawValue: currentTitle += string
        case RssTag.description.rawValue: currentDescription += string
        case RssTag.pubDate.rawValue: currentPubDate += string
        default: break
        }
    }
    
    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        if elementName == RssTag.item.rawValue {
            let rssItem = (title: currentTitle, description: currentDescription, pubDate: currentPubDate)
            rssItems += [rssItem]
        }
    }
    
    func parserDidEndDocument(_ parser: XMLParser) {
        parserCompletionHandler?(rssItems)
    }
    
    func parser(_ parser: XMLParser, parseErrorOccurred parseError: Error) {
        print(parseError.localizedDescription)
    }
}
