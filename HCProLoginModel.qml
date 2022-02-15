pragma Singleton
import QtQuick 2.0

QtObject {
    id: "LoginModel"
    readonly property string userId : "pro-admin";
    readonly property string passkey : "cnsw-123";

    readonly property int USER_BASIC : 0 ;
    readonly property int USER_ADVANCED : 1;

    property int CURRENT_USER : USER_BASIC;

    readonly property int LOGIN_SUCCESS : 0;
    readonly property int LOGIN_FAIL_INVALID_USER : -1;
    readonly property int LOGIN_FAIL_INVALID_PASSKEY : -2;

    var advancedFeatures = false;

    signal userLoginChanged( pro : Boolean)

    function setUserType(user: int){
        CURRENT_USER = user;
    }

    function loginUser(userName : string, password : string) : int{
        if(userName === userId){
            if(password === passkey){
                advancedFeatures = true;
                 userLoginChanged(advancedFeatures);
                 console.log("Advanced user login succes : " + userName );
                return LOGIN_SUCCESS;
            }else{
                 console.log("Invalid password supplied" + password);
                return LOGIN_FAIL_INVALID_PASSKEY;
             }
        }else{
                console.log("Invalid user : " + userName);
                return LOGIN_FAIL_INVALID_USER;

         }
    }

     function logoutUser(){

         if(advancedFeatures){
             advancedFeatures = false;
             userLoginChanged(advancedFeatures);
             console.log("Advanced user loggedout!!");
         }
     }
}
