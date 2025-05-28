import streamlit as st
import pandas as pd
import matplotlib as mpl
import matplotlib.pyplot as plt
import seaborn as sns
import matplotlib.font_manager as fm

# 한글폰트 설정
plt.rcParams['font.family'] = 'Malgun Gothic' 
plt.rcParams['axes.unicode_minus'] = False 
sns.set(font='Malgun Gothic', 
        rc={'axes.unicode_minus' : False}, 
        style='darkgrid')

# 페이지 설정
st.set_page_config(page_title="Matplotlib & Seaborn 튜토리얼", layout="wide") 
st.title("Matplotlib & Seaborn 튜토리얼") 

# 데이터셋 불러오기 
tips = sns.load_dataset('tips') 

# 데이터 미리보기 
st.subheader('데이터 미리보기')
st.dataframe(tips.head())

# 기본 막대 그래프, matplotlit + seaborn 
st.subheader("1. 기본 막대 그래프")

# 객체지향방식으로 차트 작성 하는 이유
# 그래프를 그리는 목적 : (예쁘게) 잘 나오려고
fig, ax = plt.subplots(figsize=(10, 6)) # matlpotlib - 시각화를 예쁘게 보여주는 역할

sns.barplot(data=tips, x='day', y='total_bill', ax=ax) # seaborn - 통계와 관련된 시각화

ax.set_title('요일별 평균 지불 금액') # matplotlib
ax.set_xlabel('요일') # matplotlib
ax.set_ylabel('평균 지불 금액($)') # matplotlib

# plt.show() ==> 이 문법은 주피터, 코랩에서 활용할 때 사용
st.pyplot(fig) # streamlit - 웹상에 띄어주는 용도

# 산점도
# x축, y축이 연속형 변수여야 함
st.subheader("2, 산점도")
fig1, ax1 = plt.subplots(figsize=(10, 6))

sns.barplot(data=tips, x='day', y='total_bill', ax=ax) 
# hue와 size라는 옵션 추가
sns.scatterplot(data=tips, x = 'total_bill', y = 'tip', hue='day', size='size', ax=ax1)
st.pyplot(fig1)

# 히트맵
st.subheader("3. 히트맵")

# 요일과 시간별 평균 팁 계산
pivot_df = tips.pivot_table(values='tip', index='day', columns='time', aggfunc='mean')
fig2, ax2 = plt.subplots(figsize=(10, 6))
sns.heatmap(pivot_df, annot=True, fmt='.2f', ax=ax2)
st.pyplot(fig2)

# 회귀선이 있는 산점도
st.subheader('4. 회귀선이 있는 산점도')
fig3, ax3 = plt.subplots(figsize=(10, 6))
sns.regplot(data=tips, x='total_bill', y='tip', scatter_kws={'alpha':0.5}, ax=ax3)
st.pyplot(fig3)

# ChatGPT 질문 던지기 팁 fig, ax = plt.subplots() 이런 방식으로 만드세요

st.subheader('5. 박스 플롯')
fig4, ax4 = plt.subplots(figsize=(8, 5))
sns.boxplot(x='day', y='total_bill', data=tips, ax=ax4)
ax.set_title('요일별 총 금액 분포')
st.pyplot(fig4)

st.subheader('6. 바이올린 플롯')
fig5, ax5 = plt.subplots(figsize=(8, 5))
sns.violinplot(x='day', y='tip', data=tips, ax=ax5)
ax.set_title('요일별 팁 분포')
st.pyplot(fig5)

st.subheader('7. 스웜 플롯')
fig6, ax6 = plt.subplots(figsize=(8, 5))
sns.swarmplot(x='day', y='total_bill', data=tips, ax=ax6)
ax.set_title('요일별 총 금액 분포 (Swarm)')
st.pyplot(fig6)

st.subheader('8. 파이 차트')
fig7, ax7 = plt.subplots()
gender_counts = tips['sex'].value_counts()
colors = ['skyblue' if gender == 'Male' else 'pink' for gender in gender_counts.index]
ax7.pie(gender_counts, labels=gender_counts.index, autopct='%1.1f%%', startangle=90, colors=colors)
ax7.set_title('성별 비율')
st.pyplot(fig7)

st.subheader('9. 히스토그램')
fig8, ax8 = plt.subplots(figsize=(8, 5))
ax8.hist(tips['total_bill'], bins=20, color='skyblue', edgecolor='black')
ax8.set_title('Total Bill Histogram')
ax8.set_xlabel('Total Bill')
ax8.set_ylabel('Count')
st.pyplot(fig8)