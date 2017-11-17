/**
* @ Author : Megha Jain (Cognizant Technology Solutions)
* @ Date : 31/03/2017
* @ Description : Apex class handling the logic for pause REST services
* @ Modified BY : Megha Jain
* @ Modified Date : 25/07/2017
**/

@isTest
public class restServicePauseWrapperTest{
  
  
 // @ Description : Apex Method To test the wrppaer for the logic of FLOW 2: Cancel Pause
 
public static testMethod void  testCancelPauseWrapperNodes(){
        
        
        String jsonstring ='{\"Account\":{},'+
            '\"Workflow\":{\"PreviousBCD\":12,'+
            '           \"ExecutionDate\":\"2017-07-12\",'+
            '           \"SubscriptionName\":\"A-S00398431\"},'+
            '\"Amendment\":[{\"Id\":\"2c91a0f95d089216015d37f40ee47a6b\"}],'+
            '\"Subscription\":[{\"Id\":\"2c91a0f95d089216015d37f410017a70\",'+
            '               \"AccountId\":\"2c92c0f95774f27501577a7d88b378aa\",'+
            '               \"PreviousSubscriptionId\":\"2c91a0fa5d08a4d4015d37f13abd1120\"}]}';
        //Send Sample Email  
        
        Test.startTest();
       
         System.assert(jsonstring != null);
        // Parse JSON response to get all the field values.
        restServiceForCancelPauseWrapper.RootObject ro = (restServiceForCancelPauseWrapper.RootObject)JSON.deserialize(jsonstring ,restServiceForCancelPauseWrapper.RootObject.class);
        String accountId = ro.Subscription[0].AccountId;
        string idStr = ro.Subscription[0].Id ;
        String PreviousSubscriptionId = ro.Subscription[0].PreviousSubscriptionId ;
        String resumeDt =  ro.Workflow.ExecutionDate ;
        Integer PreviousBCD =  ro.Workflow.PreviousBCD ;
        String SubscriptionName =  ro.Workflow.SubscriptionName ;
        String idStrAmen=  ro.Amendment[0].Id ;
        
        
      
        Test.stopTest();   
    
          
        
      }
      
      /**

 @ Description : Apex Method To test the wrppaer for the logic of FLOW 7: Change Resume Date when NOT in Pause success

**/   
     
    public static testMethod void  testschedulePauseWrapper(){
        
        
        String jsonstring ='{'+
            '\"Account\":{},'+
            '\"Workflow\":{\"BCD\":\"13\",'+
            '           \"ResumeDate\":\"2017-08-13\",'+
            '           \"ExecutionDate\":\"2017-07-11\",'+
            '           \"SubscriptionName\":\"A-S00398375\"},'+
            '\"Amendment\":[{\"Id\":\"2c91a0f95d089216015d323555dc4e23\"},'+
            '           {\"Id\":\"2c91a0fb5d08b321015d3238d9f766a0\",'+
            '           \"Type\":\"ResumeSubscription\",'+
            '           \"TotalDeltaMRR\":0.0,'+
            '           \"TotalDeltaTCV\":0.0}],'+
            '\"Subscription\":[{\"Id\":\"2c91a0fb5d08b321015d3238da0066a5\",'+
            '               \"AccountId\":\"2c92c0f95774f27501577a7d88b378aa\",'+
            '               \"PreviousSubscriptionId\":\"2c91a0fa5d08a3bd015d32354edb3ea1\"}]}';
            
            
        
        Test.startTest();
        
         System.assert(jsonstring != null);
        // Parse JSON response to get all the field values.
        restSeriveForChngResumDtSchPauseWrapper.RootObject ro = (restSeriveForChngResumDtSchPauseWrapper.RootObject)JSON.deserialize(jsonstring ,restSeriveForChngResumDtSchPauseWrapper.RootObject.class);
        
        String accountId = ro.Subscription[0].AccountId;
        string idStr = ro.Subscription[0].Id ;
        String PreviousSubscriptionId = ro.Subscription[0].PreviousSubscriptionId ;
        
        String BCD =  ro.Workflow.BCD ;
        String resumeDt =  ro.Workflow.ResumeDate ;
        String ExecutionDate  =  ro.Workflow.ExecutionDate  ;
        String SubscriptionName =  ro.Workflow.SubscriptionName ;
        
        String idStrAmen=  ro.Amendment[0].Id ;
        String idStrdupAmen=  ro.Amendment[1].Id ;
        String Type=  ro.Amendment[1].Type ;
        double  TotalDeltaMRR=  ro.Amendment[1].TotalDeltaMRR ;
        double  TotalDeltaTCV=  ro.Amendment[1].TotalDeltaTCV ;
        
         
       
        Test.stopTest();   
    
          
        
      }
      
      /**

 @ Description : Apex Method To test the wrppaer for the logic of FLOW 6: Change Resume Date when in Pause success

**/   
      public static testMethod void  testInPauseWrapper(){
        
        
           String jsonstring='{\"Account\":{},'+
            '\"Workflow\":{\"BCD\":20,'+
            '           \"ResumeDate\":\"2017-07-20\",'+
            '           \"ExecutionDate\":\"2017-07-18\",'+
            '           \"SubscriptionName\":\"A-S00398528\"},'+
            '\"Amendment\":[{\"Id\":\"2c91a0f95d089216015d553083b40a75\"},'+
            '           {\"Id\":\"2c91a0fa5d08a4d4015d5532740a0783\",'+
            '           \"Type\":\"ResumeSubscription\",'+
            '           \"TotalDeltaMRR\":0.0,'+
            '           \"TotalDeltaTCV\":0.0}],'+
            '\"Subscription\":[{\"Id\":\"2c91a0fa5d08a4d4015d553274140788\",'+
            '               \"AccountId\":\"2c92c0f95774f27501577a7d88b378aa\",'+
            '               \"PreviousSubscriptionId\":\"2c91a0fb5d089283015d55307c463f6a\"}]}';
        
        Test.startTest();
       
        // Parse JSON response to get all the field values.
        restSeriveForChngResumDtInPauseWrapper.RootObject ro = (restSeriveForChngResumDtInPauseWrapper.RootObject)JSON.deserialize(jsonstring ,restSeriveForChngResumDtInPauseWrapper.RootObject.class);
        
        String accountId = ro.Subscription[0].AccountId;
        string idStr = ro.Subscription[0].Id ;
        String PreviousSubscriptionId = ro.Subscription[0].PreviousSubscriptionId ;
        
        Integer BCD =  ro.Workflow.BCD ;
        String resumeDt =  ro.Workflow.ResumeDate;
        String ExecutionDate  =  ro.Workflow.ExecutionDate  ;
        String SubscriptionName =  ro.Workflow.SubscriptionName ;
        
        String idStrAmen=  ro.Amendment[0].Id ;
        String idStrdupAmen=  ro.Amendment[1].Id ;
        String Type=  ro.Amendment[1].Type ;
        double  TotalDeltaMRR=  ro.Amendment[1].TotalDeltaMRR ;
        double  TotalDeltaTCV=  ro.Amendment[1].TotalDeltaTCV ;
        
         
       
        Test.stopTest();   
    
          
        
      } 
      
      
      public static testMethod void  testImmediatecanclWrapper(){
        

        
         String jsonstring ='{'+
            '\"Refund\":{\"Id\":\"2c91a0f95d089216015d5554c30f0c04\",'+
            '           \"Type\":\"Electronic\",'+
            '           \"Amount\":9.99,'+
            '           \"PaymentId\":\"2c91a0fa5cf24cb9015d5551522141b0\",'+
            '           \"ReasonCode\":\"Immediate Cancellation\"},'+
            '\"Account\":{},'+
            '\"Invoice\":[{\"Id\":\"2c91a0f95d089216015d5551a5b40bf7\"},'+
            '{       \"Amount\":9.99,'+
            '       \"Balance\":0.0,'+
            '       \"AccountId\":\"2c91a0fb59b56f45015a049813ef325e\",'+
            '       \"InvoiceDate\":\"2017-06-23\",'+
            '       \"InvoiceNumber\":\"INV02191878\"}],'+
            '\"Workflow\":{\"PaymentID\":\"2c91a0fa5cf24cb9015d5551522141b0\",'+
            '           \"CancelDate\":\"2017-07-18\",'+
            '           \"PreviousBCD\":23,'+
            '           \"ExecutionDate\":\"2017-07-18\",'+
            '           \"SubscriptionName\":\"A-S00398528\"},'+
            '\"Amendment\":{\"Id\":\"2c91a0f95d089216015d5551a4e30be2\",'+
            '           \"Type\":\"CancelSubscription\",'+
            '           \"TotalDeltaMRR\":0.0,'+
            '           \"TotalDeltaTCV\":0.0},'+
            '\"InvoiceItem\":[{\"Id\":\"2c91a0a95cf24d75015d554968a472ee\",'+
            '               \"ChargeAmount\":8.39,'+
            '               \"SubscriptionId\":\"2c91a0fa5d08a4d4015d552d8d7706de\",'+
            '               \"SubscriptionNumber\":\"A-S00398528\"}],'+
            '\"Subscription\":[{\"Id\":\"2c91a0f95d089216015d5551a4f30be7\",'+
            '               \"AccountId\":\"2c92c0f95774f27501577a7d88b378aa\",'+
            '               \"PreviousSubscriptionId\":\"2c91a0fa5d08a4d4015d55503d4b08e9\"}],'+
            '\"TaxationItem\":[{\"Id\":\"2c91a0a95cf24d75015d5549678b72ea\",'+
            '               \"TaxAmount\":1.6,'+
            '               \"ExemptAmount\":0.0,'+
            '               \"InvoiceItemId\":\"2c91a0a95cf24d75015d554968a472ee\"}],'+
            '\"InvoicePayment\":[{\"Amount\":9.99,'+
            '               \"InvoiceId\":\"2c91a0a95cf24d75015d554968a072ec\"}],'+
            '\"InvoicePayments\":[{\"Id\":\"2c91a0fa5cf24cb9015d5551522141b1\",'+
            '               \"Amount\":\"9.99\",'+
            '               \"InvoiceId\":\"2c91a0a95cf24d75015d554968a072ec\",'+
            '               \"PaymentId\":\"2c91a0fa5cf24cb9015d5551522141b0\",'+
            '               \"RefundAmount\":\"9.99\"}],'+
            '\"InvoiceItemAdjustment\":[{\"Id\":\"2c91a0fb5d08b321015d5554d1b97937\",'+
            '                           \"Type\":\"Credit\",'+
            '                           \"Amount\":1.6,'+
            '                           \"SourceId\":\"2c91a0a95cf24d75015d5549678b72ea\",'+
            '                           \"InvoiceId\":\"2c91a0a95cf24d75015d554968a072ec\",'+
            '                           \"ReasonCode\":\"Immediate Cancel\",'+
            '                           \"SourceType\":\"Tax\",'+
            '                           \"ReferenceId\":\"\",'+
            '                           \"AdjustmentDate\":\"2017-07-18\",'+
            '                           \"DeferredRevenueAccount\":\"\",'+
            '                           \"RecognizedRevenueAccount\":\"\"},'+
            '                           {\"Id\":\"2c91a0fb5d08b321015d5554d1c87939\",'+
            '                           \"Type\":\"Credit\",'+
            '                           \"Amount\":8.39,'+
            '                           \"SourceId\":\"2c91a0a95cf24d75015d554968a472ee\",'+
            '                           \"InvoiceId\":\"2c91a0a95cf24d75015d554968a072ec\",'+
            '                           \"ReasonCode\":\"Immediate Cancel\",'+
            '                           \"SourceType\":\"InvoiceDetail\",'+
            '                           \"ReferenceId\":\"\",'+
            '                           \"AdjustmentDate\":\"2017-07-18\",'+
            '                           \"DeferredRevenueAccount\":\"7074\",'+
            '                           \"RecognizedRevenueAccount\":\"1015\"}]}';
        
        Test.startTest();
        
              restSeriveForImmediateCancelatnWrapper.RootObject ro = (restSeriveForImmediateCancelatnWrapper.RootObject)JSON.deserialize(jsonstring ,restSeriveForImmediateCancelatnWrapper.RootObject.class);

       
        // Parse JSON response to get all the field values.
             string idRef = ro.Refund.Id;
             string Typec =  ro.Refund.Type;
             double Amounta = ro.Refund.Amount;
             string PaymentIda = ro.Refund.PaymentId;
             string ReasonCode = ro.Refund.ReasonCode;

             
             string IdInv     = ro.Invoice[0].Id;
             double Amountb    = ro.Invoice[0].Amount;
             double Balance   = ro.Invoice[0].Balance;
             string AccountIdb = ro.Invoice[0].AccountId;
             string InvoiceDate = ro.Invoice[0].InvoiceDate;
             string InvoiceNumber = ro.Invoice[0].InvoiceNumber;
         
        String accountIdc = ro.Subscription[0].AccountId;
        string idStr = ro.Subscription[0].Id ;
        String PreviousSubscriptionId = ro.Subscription[0].PreviousSubscriptionId ;
        
      
        String CancelDate =  ro.Workflow.CancelDate ;
        String ExecutionDate  =  ro.Workflow.ExecutionDate  ;
        String SubscriptionName =  ro.Workflow.SubscriptionName ;
        String PaymentID = ro.Workflow.PaymentID ;
	    double PreviousBCD =  ro.Workflow.PreviousBCD ;
        
        
        String idStrdupAmen=  ro.Amendment.Id ;
        String Typeb=  ro.Amendment.Type ;
        double  TotalDeltaMRR=  ro.Amendment.TotalDeltaMRR ;
        double  TotalDeltaTCV=  ro.Amendment.TotalDeltaTCV ;
        
        
         string Idteam = ro.InvoiceItem[0].id;
         double ChargeAmount = ro.InvoiceItem[0].ChargeAmount;
         string SubscriptionId = ro.InvoiceItem[0].SubscriptionId;
         string SubscriptionNumber = ro.InvoiceItem[0].SubscriptionNumber;
         
         string IdTaxationItem =  ro.TaxationItem[0].id;
         double TaxAmount =   ro.TaxationItem[0].TaxAmount;
         double ExemptAmount = ro.TaxationItem[0].ExemptAmount;
         string InvoiceItemId = ro.TaxationItem[0].InvoiceItemId;
         
            
        
        double Amountd = ro.InvoicePayment[0].Amount;
        string InvoiceId = ro.InvoicePayment[0].InvoiceId;
        
         string IdPay  = ro.InvoicePayments [0].Id;
         string Amounte  = ro.InvoicePayments [0].Amount;
         string InvoiceIde  = ro.InvoicePayments [0].InvoiceId;
         string PaymentIde  = ro.InvoicePayments [0].PaymentId;
         string RefundAmount = ro.InvoicePayments [0].RefundAmount;
        
        
         string IdItm =ro.InvoiceItemAdjustment[0].Id;
         string Typea =ro.InvoiceItemAdjustment[0].Type;
         double Amountf =ro.InvoiceItemAdjustment[0].Amount;
         string SourceId =ro.InvoiceItemAdjustment[0].SourceId;
         string InvoiceIdf =ro.InvoiceItemAdjustment[0].InvoiceId;
         string ReasonCodef =ro.InvoiceItemAdjustment[0].ReasonCode;
         string SourceType =ro.InvoiceItemAdjustment[0].SourceType;
         string ReferenceId =ro.InvoiceItemAdjustment[0].ReferenceId;
         string AdjustmentDate =ro.InvoiceItemAdjustment[0].AdjustmentDate;
         string DeferredRevenueAccount =ro.InvoiceItemAdjustment[0].DeferredRevenueAccount;
         string RecognizedRevenueAccount =ro.InvoiceItemAdjustment[0].RecognizedRevenueAccount;
            
         
       
        Test.stopTest();   
    
        
      } 
      
      
      /**
*
* @ Description : Test method to test StandardCancellationPause_FLOW_4
**/

public static testMethod void  testStandardCancellationPauseWrapper(){
        

        
        String jsonstring ='{"Account":{},'+
            '"Workflow":{"CancelDate":"2017-07-23",'+
            '           "PreviousBCD":23,'+
            '           "ExecutionDate":"2017-07-18",'+
            '           "SubscriptionName":"A-S00398528"},'+
            '"Amendment":[{"Id":"2c91a0fb5cf25476015d554a83246e68"},'+
            '           {"Id":"2c91a0fb5d089283015d554b002e404e",'+
            '           "Type":"CancelSubscription",'+
            '           "TotalDeltaMRR":0.0,'+
            '           "TotalDeltaTCV":0.0}],'+
            '"Subscription":[{"Id":"2c91a0fb5d089283015d554b003f4053",'+
            '               "PreviousSubscriptionId":"2c91a0fa5d08a4d4015d552d8d7706de"}]}';
        
        Test.startTest();
        
              restServiceForStandardCancelatnWrapper.RootObject ro = (restServiceForStandardCancelatnWrapper.RootObject)JSON.deserialize(jsonstring ,restServiceForStandardCancelatnWrapper.RootObject.class);

       
        // Parse JSON response to get all the field values.
        Integer PreviousBCD =  ro.Workflow.PreviousBCD ;
        String CancelDate =  ro.Workflow.CancelDate ;
        String ExecutionDate  =  ro.Workflow.ExecutionDate  ;
        String SubscriptionName =  ro.Workflow.SubscriptionName ;
        
        String idStrdupAmen=  ro.Amendment[0].Id ;
        String idStrdup =  ro.Amendment[0].Id ;
        String Typeb=  ro.Amendment[1].Type ;
        double  TotalDeltaMRR=  ro.Amendment[1].TotalDeltaMRR ;
        double  TotalDeltaTCV=  ro.Amendment[1].TotalDeltaTCV ;
        
        string idStr = ro.Subscription[0].Id ;
        String PreviousSubscriptionId = ro.Subscription[0].PreviousSubscriptionId ;
   
        Test.stopTest();   
    
         
      } 
      
      
      /**
*
* @ Description : Test method to test Setpause_FLOW_3
**/

public static testMethod void  testSetPauseWrapper(){
        

        
        String jsonstring ='{\"Account\":{},'+
            ''+
            '\"Workflow\":{\"BCD\":20,'+
            ''+
            '           \"ResumeDate\":\"2017-09-20\",'+
            ''+
            '          \"SuspendDate\":\"2017-08-11\",'+
            ''+
            '          \"ExecutionDate\":\"2017-07-11\",'+
            ''+
            '          \"SubscriptionName\":\"A-S00398356\"},'+
            ''+
            '          '+
            '\"Amendment\":[{\"Id\":\"2c91a0fa5cf24cb9015d31392bbf7e11\",'+
            ''+
            '             \"Type\":\"SuspendSubscription\",'+
            ''+
            '            \"TotalDeltaMRR\":0.0,'+
            ''+
            '            \"TotalDeltaTCV\":0.0},'+
            ''+
            '            {\"Id\":\"2c91a0fb5d089283015d3139342f1728\",'+
            ''+
            '            \"Type\":\"ResumeSubscription\",'+
            ''+
            '            \"TotalDeltaMRR\":0.0,'+
            '\"TotalDeltaTCV\":0.0}],'+
            ''+
            '\"Subscription\":[{\"Id\":\"2c91a0fb5d089283015d31393438172d\",'+
            ''+
            '                \"AccountId\":\"2c92c0f95774f27501577a7d88b378aa\",'+
            ''+
            '               \"PreviousSubscriptionId\":\"2c91a0fa5cf24cb9015d31392bc87e16\"}'+
            '               ]}';
        
        Test.startTest();
        
        restServiceForSetPauseWrapper.RootObject ro = (restServiceForSetPauseWrapper.RootObject)JSON.deserialize(jsonstring ,restServiceForSetPauseWrapper.RootObject.class);

       
        // Parse JSON response to get all the field values.
        Integer BCD =  ro.Workflow.BCD ;
        String ResumeDate  =  ro.Workflow.ResumeDate  ;
        String SuspendDate   =  ro.Workflow.SuspendDate   ;
        String ExecutionDate  =  ro.Workflow.ExecutionDate  ;
        String SubscriptionName   = ro.Workflow.SubscriptionName   ;
        
        String idStrdupAmen=  ro.Amendment[0].Id ;
        String idAmen=  ro.Amendment[1].Id ;
        String Typeb=  ro.Amendment[1].Type ;
        double  TotalDeltaMRR=  ro.Amendment[1].TotalDeltaMRR ;
        double  TotalDeltaTCV=  ro.Amendment[1].TotalDeltaTCV ;
        
        string idStr = ro.Subscription[0].Id ;
        string AccountId = ro.Subscription[0].AccountId ;
        String PreviousSubscriptionId = ro.Subscription[0].PreviousSubscriptionId ;
   
        Test.stopTest();   
    
         
      } 
      
      
      /**
*
* @ Description : Test method to test Setpause_FLOW_1
**/

public static testMethod void  testImmediateresumePauseWrapper(){
        
         String jsonstring='{'+
            '\"Account\":{},'+
            '\"Invoice\":{\"Id\":\"2c91a0f85d089f23015d555e44591bcf\"},'+
            '\"Payment\":{\"Id\":\"2c91a0f85d089f23015d555e449a1bdb\"},'+
            '\"Workflow\":{\"BCD\":18,'+
            '           \"ResumeDate\":\"2017-07-18\",'+
            '           \"ExecutionDate\":\"2017-07-18\",'+
            '           \"SubscriptionName\":\"A-S00398530\"},'+
            '\"Amendment\":[{\"Id\":\"2c91a0fb5cf25476015d555bdc4b6ebe\"},'+
            '           {\"Id\":\"2c91a0f85d089f23015d555e43781bba\",'+
            '\"Type\":\"ResumeSubscription\",'+
            '       \"TotalDeltaMRR\":0.0,'+
            '       \"TotalDeltaTCV\":0.0}],'+
            '\"Subscription\":[{\"Id\":\"2c91a0f85d089f23015d555e43811bbf\",'+
            '               \"AccountId\":\"2c92c0f95774f27501577a7d88b378aa\",'+
            '               \"PreviousSubscriptionId\":\"2c91a0f95d089216015d555bd52e0cb8\"}]}';

            
        Test.startTest();
        
            restServiceForImmediateResumeWrapper.RootObject ro = (restServiceForImmediateResumeWrapper.RootObject)JSON.deserialize(jsonstring , restServiceForImmediateResumeWrapper.RootObject.class);

       
        // Parse JSON response to get all the field values.
        
         string idInvoice = ro.Invoice.Id ;
         string idPayment = ro.Payment.Id ;
        
        
        Integer BCD =  ro.Workflow.BCD ;
        String ResumeDate  =  ro.Workflow.ResumeDate  ;
        String ExecutionDate  =  ro.Workflow.ExecutionDate  ;
        String SubscriptionName   = ro.Workflow.SubscriptionName   ;
        
        String idStrdupAmen=  ro.Amendment[0].Id ;
        String idAmen=  ro.Amendment[1].Id ;
        String Typeb=  ro.Amendment[1].Type ;
        double  TotalDeltaMRR=  ro.Amendment[1].TotalDeltaMRR ;
        double  TotalDeltaTCV=  ro.Amendment[1].TotalDeltaTCV ;
        
        string idStr = ro.Subscription[0].Id ;
        string AccountId = ro.Subscription[0].AccountId ;
        String PreviousSubscriptionId = ro.Subscription[0].PreviousSubscriptionId ;
   
        Test.stopTest();   
    
         
      }
      
      
      /**
*
* @ Description : Test method to test freeze Account Callout
**/

public static testMethod void  testFreezeAccountWrapper(){
        
         String jsonstring= '{\"Refund\":['+
        '{\"Id\":\"2c91a0fb5ccf56f3015ce4a1a2346eef\",\"AccountId\":\"2c91a0fb59b56f45015a049813ef325e\"}'+
        '],\"Account\":['+
        '{\"LastInvoiceDate\":\"2017-06-14\"}'+
        '],\"Invoice\":['+
        '{\"Amount\":9.99,\"Balance\":0.0,\"AccountId\":\"2c91a0fb59b56f45015a049813ef325e\",\"InvoiceDate\":\"2017-05-21\",\"InvoiceNumber\":\"INV01851675\"}'+
        ','+
        '{\"Id\":\"2c91a0fa5ccf4f89015ce4a1ba73383f\",\"Amount\":-2.26,\"Balance\":0.0,\"AccountId\":\"2c91a0fb59b56f45015a049813ef325e\",\"InvoiceDate\":\"2017-06-26\",\"InvoiceNumber\":\"INV01851676\"}'+
        '],\"Workflow\":'+
        '{\"RefundID\":\"2c91a0fb5ccf56f3015ce4a1a2346eef\",\"ExecutionDate\":\"2017-06-26\",\"RefundReasonCode\":\"Payment Reversal\"}'+
        ',\"Amendment\":'+
        '{\"Id\":\"2c91a0fa5ccf4f89015ce4a1b7f2382d\",\"Type\":\"CancelSubscription\",\"TotalDeltaMRR\":0.0,\"TotalDeltaTCV\":0.0}'+
        ',\"InvoiceItem\":['+
        '{\"Id\":\"2c91a0fa5ccf4f89015ce4a1ba763841\",\"ChargeAmount\":-1.9,\"SubscriptionId\":\"2c91a0fa5ccf4f89015ce4a1b8053832\",\"SubscriptionNumber\":\"A-S00398035\"}'+
        '],\"Subscription\":'+
        '{\"Id\":\"2c91a0fa5ccf4f89015ce4a1b8053832\",\"PreviousSubscriptionId\":\"2c91a0fb5ccf56f4015ce49f41a87a7c\"}'+
        ',\"TaxationItem\":['+
        '{\"Id\":\"2c91a0fa5ccf4f89015ce4a1ba66383d\",\"TaxAmount\":-0.36,\"ExemptAmount\":0.0,\"InvoiceItemId\":\"2c91a0fa5ccf4f89015ce4a1ba763841\"}'+
        '],\"InvoicePayments\":['+
        '{\"Id\":\"\",\"Amount\":\"\",\"InvoiceId\":\"\",\"PaymentId\":\"\",\"RefundAmount\":\"\"}'+
        '],\"RefundInvoicePayment\":['+
        '{\"InvoiceId\":\"2c91a0aa5ccf4329015ce4a076937ef8\"}'+
        '],\"InvoiceItemAdjustment\":['+
        '{\"Id\":\"2c91a0fb5ccf56f3015ce4a1c07f6f37\",\"Type\":\"Charge\",\"Amount\":1.9,\"SourceId\":\"2c91a0fa5ccf4f89015ce4a1ba763841\",\"InvoiceId\":\"2c91a0fa5ccf4f89015ce4a1ba73383f\",\"ReasonCode\":\"Standard Adjustment\",\"SourceType\":\"InvoiceDetail\",\"ReferenceId\":\"\",\"AdjustmentDate\":\"2017-06-26\",\"DeferredRevenueAccount\":\"7074\",\"RecognizedRevenueAccount\":\"1015\"}'+
        ','+
        '{\"Id\":\"2c91a0fb5ccf56f3015ce4a1c0916f3a\",\"Type\":\"Charge\",\"Amount\":0.36,\"SourceId\":\"2c91a0fa5ccf4f89015ce4a1ba66383d\",\"InvoiceId\":\"2c91a0fa5ccf4f89015ce4a1ba73383f\",\"ReasonCode\":\"Standard Adjustment\",\"SourceType\":\"Tax\",\"ReferenceId\":\"\",\"AdjustmentDate\":\"2017-06-26\",\"DeferredRevenueAccount\":\"\",\"RecognizedRevenueAccount\":\"\"}'+
        ']}';

            
        Test.startTest();
        
            restServiceCalloutwrapper.RootObject ro = (restServiceCalloutwrapper.RootObject)JSON.deserialize(jsonstring , restServiceCalloutwrapper.RootObject.class);

       
        // Parse JSON response to get all the field values.
        string idRef = ro.Refund[0].Id;
        string AccountId =  ro.Refund[0].AccountId;
        
        string LastInvoiceDate=  ro.Account[0].LastInvoiceDate;    

         
         double Amountb    = ro.Invoice[0].Amount;
         
         
             string IdInv     = ro.Invoice[1].Id;
             double AmountIn    = ro.Invoice[1].Amount;
             double Balance   = ro.Invoice[1].Balance;
             string AccountIdb = ro.Invoice[1].AccountId;
             string InvoiceDate = ro.Invoice[1].InvoiceDate;
             string InvoiceNumber = ro.Invoice[1].InvoiceNumber;
        
        
        
        String RefundReasonCode  =  ro.Workflow.RefundReasonCode  ;
        String ExecutionDate  =  ro.Workflow.ExecutionDate  ;
        String RefundID   = ro.Workflow.RefundID   ;
        
        String idStrdupAmen=  ro.Amendment.Id ;
        String Typeb=  ro.Amendment.Type ;
        double  TotalDeltaMRR=  ro.Amendment.TotalDeltaMRR ;
        double  TotalDeltaTCV=  ro.Amendment.TotalDeltaTCV ;
        
        string Idteam = ro.InvoiceItem[0].id;
         double ChargeAmount = ro.InvoiceItem[0].ChargeAmount;
         string SubscriptionId = ro.InvoiceItem[0].SubscriptionId;
         string SubscriptionNumber = ro.InvoiceItem[0].SubscriptionNumber;
        
        string idStr = ro.Subscription.Id ;
        String PreviousSubscriptionId = ro.Subscription.PreviousSubscriptionId ;
        
         string IdTaxationItem =  ro.TaxationItem[0].id;
         double TaxAmount =   ro.TaxationItem[0].TaxAmount;
         double ExemptAmount = ro.TaxationItem[0].ExemptAmount;
         string InvoiceItemId = ro.TaxationItem[0].InvoiceItemId;
         
         string IdPay  = ro.InvoicePayments[0].Id;
         string Amounte  = ro.InvoicePayments[0].Amount;
         string InvoiceIde  = ro.InvoicePayments[0].InvoiceId;
         string PaymentIde  = ro.InvoicePayments[0].PaymentId;
         string RefundAmount = ro.InvoicePayments[0].RefundAmount;
         
         string IdRefund  = ro.RefundInvoicePayment[0].InvoiceId ;
         
         string IdItm =ro.InvoiceItemAdjustment[0].Id;
         string Typea =ro.InvoiceItemAdjustment[0].Type;
         double Amountf =ro.InvoiceItemAdjustment[0].Amount;
         string SourceId =ro.InvoiceItemAdjustment[0].SourceId;
         string InvoiceIdf =ro.InvoiceItemAdjustment[0].InvoiceId;
         string ReasonCodef =ro.InvoiceItemAdjustment[0].ReasonCode;
         string SourceType =ro.InvoiceItemAdjustment[0].SourceType;
         string ReferenceId =ro.InvoiceItemAdjustment[0].ReferenceId;
         string AdjustmentDate =ro.InvoiceItemAdjustment[0].AdjustmentDate;
         string DeferredRevenueAccount =ro.InvoiceItemAdjustment[0].DeferredRevenueAccount;
         string RecognizedRevenueAccount =ro.InvoiceItemAdjustment[0].RecognizedRevenueAccount;
   
        Test.stopTest();   
    
         
      }   
     
      
    
  }