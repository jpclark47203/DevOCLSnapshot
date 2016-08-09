/*
 * @Author - Sujila Nair
 * Version - 1 [03/17/2016]
*/
public class RulesnavController {
    public String UserName {get;set;}
    
    public RulesnavController(){
        UserName = UserInfo.getName();
    }

}