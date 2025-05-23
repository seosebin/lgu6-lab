import streamlit as st
import pandas as pd
import plotly.express as px

# 데이터 로드
@st.cache_data(experimental_allow_widgets=True)
def load_data():
    return pd.read_csv('./data/iris.csv')

def main():
    if st.button('Reload Data'):
        st.cache_data.clear()
        st.rerun()
        
    st.title('Iris Dataset Visualization!!')
    
    # 데이터 로드
    df = load_data()
    
    # 기본 통계 정보
    st.subheader('Dataset Overview')
    st.write(df.describe())
    
    # 산점도
    st.subheader('Scatter Plot')
    x_axis = st.selectbox('X-axis', df.columns[:-1])
    y_axis = st.selectbox('Y-axis', df.columns[:-1])
    
    fig = px.scatter(df, x=x_axis, y=y_axis, color='species')
    st.plotly_chart(fig)

if __name__ == '__main__':
    main()
    