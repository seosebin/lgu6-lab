import numpy as np 
import streamlit as st 
import pandas as pd 
from surprise import Dataset, Reader, SVD # 추천 알고리즘
from surprise.model_selection import train_test_split
import surprise

#  버전 표시 
st.title("영화 추천 시스템")
# st.write(f"Surprise 버전 : {surprise.__version__}")

movies = pd.read_csv("data/ml-latest-small/movies.csv")
ratings = pd.read_csv("data/ml-latest-small/ratings.csv")
links = pd.read_csv("data/ml-latest-small/links.csv")
images = pd.read_csv("data/ml-latest-small/ml1m_images.csv").rename(
    columns={'item_id' : 'movieId', 'image' : 'image_url'}
)

# st.write(movies.head())
# st.write(ratings.head())
# st.write(links.head())
# st.write(images.head())

def train_recommendation_model():
    """
    프로세스 : 
    1. Reader 클래스 활용 사용자의 평점 범위 설정
    2. Dataset 객체 생성 및 데이터 가져오기
    3. 학습 데이터 분할 (80%) (20%)
    4. SVD 모델 학습 수행
    """
    reader = Reader(rating_scale=(0.5, 5.0))
    data = Dataset.load_from_df(ratings[['userId', 'movieId', 'rating']], reader)
    trainset, testset = train_test_split(data, test_size=0.2, random_state=42)

    # 모델 가져오기
    model = SVD()
    model.fit(trainset)

    return model 

model = train_recommendation_model()
st.write(model)
st.success("모델 학습 완료")

# 특정 사용자에게 영화를 추천하는 하나의 함수
def get_top_n_recommend(user_id, model, movies_df, n = 3):
    """
    특정 사용자에게 영화를 추천함
    Args:
        user_id (int) : 추천 받을 사용자의 ID
        model (SVD) : 학습된 SVD 모델 
        movies_df (pd.DataFrame) : 영화 정보가 담긴 데이터프레임
        n (int) : 추천할 영화의 개수 (기본값: 3)
    
    Returns:
        top_n_movies (pd.DataFrame) : 추천 영화 정보와 예측 평점이 포함된 데이터프레임
    """

    # 전체 영화 ID 목록 가져오기, 사용자가 이미 시청한 영화 ID 목록 추출
    # user_id 이 부분은 회원가입의 ID와 매핑 필요 고려
    movie_ids = movies_df['movieId'].unique() 
    watched_movies = ratings[ratings['userId'] == user_id]

    # 시청하지 않은 영화들에 대한 평점 예측
    predictions = [
        model.predict(user_id, movie_id) for movie_id in movie_ids if movie_id not in watched_movies
    ]

    # 예측 평점 기준으로 정렬하여 상위 N개 선택
    top_n = sorted(predictions, key=lambda x: x.est, reverse=True)[:n]

    # 추천 영화 정보를 데이터프레임으로 변환
    top_n_movies = pd.DataFrame({
        'movieId' : [pred.iid for pred in top_n], 
        'predicted_rating' : [pred.est for pred in top_n]
    })

    # 영화 상세 정보 병합 (최종 데이터, top_n_movies)
    top_n_movies = top_n_movies.merge(movies_df, on='movieId', how='inner')

    return top_n_movies

# Streamlit UI 구성 
if st.button("추천 영화 보기"):
    st.subheader("영화 추천 받기")
    user_id = st.number_input(
        "사용자 ID 입력하세요 (1-100)", 
        min_value=1, 
        max_value=100, 
        step=1 
    )

    # 추천 영화 목록 가져오기 
    top_movies = get_top_n_recommend(user_id, model, movies, n=10)
    
    # 각 추천 영화에 대해 정보 표시
    for idx, row in top_movies.iterrows():
        # 영화 포스터 이미지 URL 가져오기
        movie_image_row = images[images['movieId'] == row['movieId']]
        
        if not movie_image_row.empty:
            movie_image = movie_image_row['image_url'].values[0]
        else:
            st.warning(f"영화 ID {row['movieId']}의 이미지를 찾을 수 없습니다. 기본 이미지를 사용합니다.")
            movie_image = "https://via.placeholder.com/150"
        
        # 2열 레이아웃으로 영화 정보 표시
        col1, col2 = st.columns(2)
        with col1:
            st.write(f"영화 ID: {row['movieId']}")
            st.write(f"장르: {row['genres']}")
        with col2:
            st.image(
                movie_image, 
                caption=f"{row['title']} (예상 평점: {row['predicted_rating']:.1f})", 
                use_container_width=True
            )