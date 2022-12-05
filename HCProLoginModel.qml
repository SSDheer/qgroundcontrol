pragma Singleton
import QtQuick 2.0

QtObject {
    id: "loginmodel"
    readonly property string userId : "pro-admin";
    readonly property string passkey : "cnsw-123";

    readonly property int user_basic : 0 ;
    readonly property int user_advanced : 1;

    property int current_user : user_basic;

    readonly property int login_success : 0;
    readonly property int login_fail_invalid_user : -1;
    readonly property int login_fail_invalid_passkey : -2;

    property bool advancedFeatures : false;

    signal userLoginChanged( pro : Boolean)

    function setUserType(user: int){
        current_user = user;
    }

    function loginUser(userName : string, password : string) : int{
        if(userName === userId){
            if(password === passkey){
                advancedFeatures = true;
                 userLoginChanged(advancedFeatures);
                 console.log("Advanced user login succes : " + userName );
                return login_success;
            }else{
                 console.log("Invalid password supplied" + password);
                return login_fail_invalid_passkey;
             }
        }else{
                console.log("Invalid user : " + userName);
                return login_fail_invalid_user;

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
