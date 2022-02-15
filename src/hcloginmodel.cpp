#include "hcloginmodel.h"
#include <QtDebug>

HCLoginModel *HCLoginModel::mInstance = nullptr;

int HCLoginModel::loginUser(const QString user,const QString password)
{
    if(USER_ID.compare(user) == 0){
        qDebug() << "user Id Set : "+ user  +" || compared with : USER_ID = " + USER_ID;
        if(PASSKEY.compare(password) == 0){
            setAdvancedUser(true);
            //emit loginResult(HCLoginModel::LOGIN_STATUS::LOGIN_SUCCESS);
            emit userChanged();
            qDebug() << "User logged in" << "  |  Now you are a advanced user!!";
            return LOGIN_SUCCESS;
        }else{
            return LOGIN_FAIL_INVALID_PASSWORD;
        }
    }else{
        return LOGIN_FAIL_INVALID_USER;
    }
}

void HCLoginModel::logoutUser()
{
    setAdvancedUser(false);
    //emit loginResult(HCLoginModel::loginStatus::LOGGED_OUT);
    qDebug() << "User logged out" << "  |  Now you are a basic user!!";
    emit userChanged();
}

QObject *HCLoginModel::getInstance(QQmlEngine *engine, QJSEngine *scriptEngine)
{
    Q_UNUSED(engine);
    Q_UNUSED(scriptEngine);
    if(mInstance == nullptr) { mInstance = new HCLoginModel();}
    return mInstance;
}

HCLoginModel::HCLoginModel(QObject *parent)
{

}


