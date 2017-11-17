global class zObjectCustomSort implements Comparable {
public Zuora.zObject ozObject ;
    public zObjectCustomSort(Zuora.zObject ozObject)
    {
        this.ozObject=ozObject;            
    }
    global integer compareTo(Object compareTo)
    {
        zObjectCustomSort compareTozObject = (zObjectCustomSort)compareTo;
        Integer returnValue=0;
        DateTime dtCompareFrom = (DateTime)ozObject.getValue('CreatedDate');
        DateTime dtCompareTo = (DateTime)compareTozObject.ozObject.getValue('CreatedDate');        
        if( dtCompareFrom < dtCompareTo)
            returnValue=1;
        else if(dtCompareFrom>dtCompareTo)
            returnValue=-1;
        return returnValue;
    }
}