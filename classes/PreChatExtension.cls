/**
 * An apex extension controller to get the current logged-in user information using user id.
 */
public class PreChatExtension
{
    public User oCurrentUser {get;set;}
    public PreChatExtension(ApexPages.StandardController controller){
        oCurrentUser = [Select Id, Name, Email from User where Id=: userinfo.getuserId()];
    }
}