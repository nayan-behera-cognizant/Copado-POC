public with sharing class SearchKnowledgeBaseController {
    //Page Size
    private Static Final Integer PAGE_NUMBER = 5;
    //Search String used in ArticleList tag
    public String searchstring { get; set; }
    public SearchKnowledgeBaseController() {
        String qryString = 'SELECT Id, title, UrlName, LastPublishedDate,LastModifiedById FROM KnowledgeArticleVersion WHERE (PublishStatus = \'online\' and Language = \'en_US\')';// WITH DATA CATEGORY World_Wide__c AT Customer_Services__c '; //ABOVE Customer_Services__c';
        List<KnowledgeArticleVersion> articleList= Database.query(qryString);
        maxSize = articleList.size() ;
    }
    //Keeps track of current page & max size of article list
    Integer currentPage = 1;
    Integer maxSize = 1;
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    // Returns whether we need to see previous button or not
    /*public boolean getPrevRequired() {
        return currentPage > 1;
    }*/
    // Returns whether we need to see next button or not
    /*public boolean getNextRequired() {
        return currentPage * PAGE_NUMBER < maxSize;
    }*/
    //Returns current page number
    /*public Decimal getCurrentPageNumber() {
        return this.currentPage;
    }*/
    //action for next click
    /*public PageReference next() {
        if(maxSize > this.currentPage * PAGE_NUMBER) {
            this.currentPage = this.currentPage + 1;
        }
        return null;
    }*/
    //action for previous click
    /*public PageReference previous() {
        if(this.currentPage > 1)
            this.currentPage = this.currentPage - 1;
        return null;
        }
    }*/
}