public class Integration_ODE_IRNSearch_JSON{
    public Integer id;  
    public String name{get;set;} //Mckinley Elementary School
    public String irn{get;set;}  //023705
    public String status{get;set;}   //Open
    public String type{get;set;}//Public School
    public String county{get;set;}   //Cuyahoga
    public String statusReason{get;set;} //
    public String subStatus{get;set;}    //
    public String subStatusReason{get;set;}  //
    public cls_contact contact{get;set;}
    public cls_address[] address{get;set;}
    class cls_contact {
        public cls_phone[] phone{get;set;}
        public cls_email[] email{get;set;}
    }
    class cls_phone {
        public String phnumber{get;set;}   //2165294257
        public String type{get;set;} //Office Phone Number
    }
    class cls_email {
        public String address{get;set;}  //qqq.google.com
        public String type{get;set;} //personal
    }
    class cls_address {
        public String address1{get;set;} //1351 W Clifton Blvd
        public String address2{get;set;} //
        public String city{get;set;} //Lakewood
        public String state{get;set;}    //OH
        public String zip{get;set;}  //44107
        public String zip4{get;set;} //3352
        public String county{get;set;}   //Cuyahoga
        public String addressType{get;set;}  //Physical Address
    }
    public static Integration_ODE_IRNSearch_JSON parse(String json){
        return (Integration_ODE_IRNSearch_JSON) System.JSON.deserialize(json, Integration_ODE_IRNSearch_JSON.class);
    }

}