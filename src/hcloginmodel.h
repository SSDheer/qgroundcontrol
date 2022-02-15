#ifndef HCLOGINMODEL_H
#define HCLOGINMODEL_H

#include <QObject>
#include <qqml.h>

class HCLoginModel : public QObject
{
    Q_OBJECT


public:
    int currentUserType;

    enum loginStatus{
        LOGGED_OUT = 0,
        LOGIN_SUCCESS = 1,
        LOGIN_FAIL_INVALID_USER =2 ,
        LOGIN_FAIL_INVALID_PASSWORD =3,
    };

    Q_ENUM(loginStatus);
    Q_PROPERTY(bool isAdvanceUser READ isAdvancedUser NOTIFY userChanged);
    QML_ELEMENT


     QString USER_ID = "admin";
     QString PASSKEY = "cnsw-123";
     const int USER_BASIC = 0;
     const int USER_ADVANCED = 1;


     Q_INVOKABLE
     bool isAdvancedUser(){
        return currentUserType == HCLoginModel::USER_ADVANCED;
    }
     void setAdvancedUser(bool user){
         if(user){
             currentUserType = HCLoginModel::USER_ADVANCED;
         }else{
             currentUserType = HCLoginModel::USER_BASIC;
         }

     }
     Q_INVOKABLE
      int loginUser(QString user, QString password);

      Q_INVOKABLE
       void logoutUser();
static QObject* getInstance(QQmlEngine *engine, QJSEngine * scriptEngine);
       static HCLoginModel* mInstance;
 private:
       explicit HCLoginModel(QObject *parent = nullptr);



signals:
     void loginResult(int status);
     void userChanged();
     void logout();


};

#endif // HCLOGINMODEL_H
