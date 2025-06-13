import streamlit as st
import mlflow.sklearn
import pandas as pd

st.title("ML Flow Hello World")

mlflow.set_tracking_uri('http://localhost:5000')

run_id = '2b40fbb93d0c4116a5c62ba37397cf43'
model_uri = f"runs:/{run_id}/model"
model = mlflow.sklearn.load_model(model_uri)
st.write(model)

st.title("Tips 예측 앱")
st.write("Total Bill 금액에 따라 팁을 예측합니다.")

bill = st.number_input("Total Bill ($)", min_value=0.0, step=1.0)

if st.button("예측하기"):
    input_df = pd.DataFrame([[bill]], columns=["total_bill"])
    pred = model.predict(input_df)[0]
    st.success(f"예상 팁 금액은 ${pred:.2f} 입니다.")