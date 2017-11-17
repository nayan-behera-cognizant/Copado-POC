public class restServiceForCancelPauseWrapper {

public class Account
{
}

public class Workflow
{
    public integer PreviousBCD { get; set; }
    public string ExecutionDate { get; set; }
    public string SubscriptionName { get; set; }
}

public class Amendment
{
    public string Id { get; set; }
}

public class Subscription
{
    public string Id { get; set; }
    public string AccountId { get; set; }
    public string PreviousSubscriptionId { get; set; }
}

public class RootObject
{
    public Account Account { get; set; }
    public Workflow Workflow { get; set; }
    public List<Amendment> Amendment { get; set; }
    public List<Subscription> Subscription { get; set; }
}
 }