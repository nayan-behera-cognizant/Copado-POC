public class restServiceCalloutwrapper {

    public class Refund {
        public string Id { get; set; }
        public string AccountId { get; set; }
    }

    public class Account {
        public string LastInvoiceDate { get; set; }
    }

    public class Invoice {
        public double Amount { get; set; }
        public double Balance { get; set; }
        public string AccountId { get; set; }
        public string InvoiceDate { get; set; }
        public string InvoiceNumber { get; set; }
        public string Id { get; set; }
    }

    public class Workflow {
        public string RefundID { get; set; }
        public string ExecutionDate { get; set; }
        public string RefundReasonCode { get; set; }
    }

    public class Amendment {
        public string Id { get; set; }
        public string Type { get; set; }
        public double TotalDeltaMRR { get; set; }
        public double TotalDeltaTCV { get; set; }
    }

    public class InvoiceItem {
        public string Id { get; set; }
        public double ChargeAmount { get; set; }
        public string SubscriptionId { get; set; }
        public string SubscriptionNumber { get; set; }
    }

    public class Subscription {
        public string Id { get; set; }
        public string PreviousSubscriptionId { get; set; }
    }

    public class TaxationItem {
        public string Id { get; set; }
        public double TaxAmount { get; set; }
        public double ExemptAmount { get; set; }
        public string InvoiceItemId { get; set; }
    }

    public class InvoicePayment {
        public string Id { get; set; }
        public string Amount { get; set; }
        public string InvoiceId { get; set; }
        public string PaymentId { get; set; }
        public string RefundAmount { get; set; }
    }

    public class RefundInvoicePayment {
        public string InvoiceId { get; set; }
    }

    public class InvoiceItemAdjustment {
        public string Id { get; set; }
        public string Type { get; set; }
        public double Amount { get; set; }
        public string SourceId { get; set; }
        public string InvoiceId { get; set; }
        public string ReasonCode { get; set; }
        public string SourceType { get; set; }
        public string ReferenceId { get; set; }
        public string AdjustmentDate { get; set; }
        public string DeferredRevenueAccount { get; set; }
        public string RecognizedRevenueAccount { get; set; }
    }

    public class RootObject {
        public List<Refund> Refund { get; set; }
        public List<Account> Account { get; set; }
        public List<Invoice> Invoice { get; set; }
        public Workflow Workflow { get; set; }
        public Amendment Amendment { get; set; }
        public List<InvoiceItem> InvoiceItem { get; set; }
        public Subscription Subscription { get; set; }
        public List<TaxationItem> TaxationItem { get; set; }
        public List<InvoicePayment> InvoicePayments { get; set; }
        public List<RefundInvoicePayment> RefundInvoicePayment { get; set; }
        public List<InvoiceItemAdjustment> InvoiceItemAdjustment { get; set; }
        public String AccountId { get; set; }
    }
}