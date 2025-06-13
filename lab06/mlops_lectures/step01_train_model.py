import mlflow.sklearn
import pandas as pd
import seaborn as sns
import mlflow
import mlflow.sklearn
from sklearn.linear_model import LinearRegression
from sklearn.model_selection import train_test_split
from sklearn.metrics import mean_squared_error

# AWS/GCP/Azure, 서버 설정 이후, 고정 IP 주소 할당
mlflow.set_tracking_uri('http://127.0.0.1:5000') # HTTP 기반 tracking

tips = sns.load_dataset('tips')
X = tips[['total_bill']]
y = tips['tip']

X_train, X_test, y_train, y_test = train_test_split(X, y, test_size=0.2, random_state=42)

mlflow.set_experiment('Tips-Regression-Exp')

with mlflow.start_run():
    model = LinearRegression()
    model.fit(X_train, y_train)

    preds = model.predict(X_test)
    mse = mean_squared_error(y_test, preds)

    # 해당 모델을 mlflow에 추가
    mlflow.log_param('model_type', 'LinearRegression')
    mlflow.log_metric('mse', mse)

    # 모델 저장
    mlflow.sklearn.log_model(model, name="model")