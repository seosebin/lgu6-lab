import streamlit as st
from surprise.dataset import DatasetAutoFolds
import pandas as pd 
from surprise import Reader, Dataset 
from surprise.model_selection import cross_validate
from surprise import SVD

# 로그인 상태 초기화
if 'logged_in' not in st.session_state: 
    st.session_state.logged_in = False 

# 로그인 함수
def login(user_id, password): 
    if password == '1234':
        st.session_state.logged_in = True
        st.session_state.user_id = user_id  # user_id를 세션에 저장
        return True
    return False 


# 로그인 UI
if not st.session_state.logged_in: 
    # 로그인 페이지
    st.title("영화 추천 시스템 로그인")
    # 업그레이드 : 실제 사용자와 ID/Password와 매칭 시키기
    user_id = st.text_input("사용자 ID") 
    password = st.text_input("비밀번호", type="password") 

    if st.button("로그인"):
        if login(user_id, password):
            st.success("로그인 성공!")
            st.rerun() 
        else:
            st.error("비밀번호 잘못됨!")
else:
    # 로그인 후 추천시스템이 동작하는 코드
    st.title("실제 영화 추천 시스템")
    user_id = int(st.session_state.user_id)
    # st.title(f"사용자 ID : {user_id} Hello!!")

    # 로그아웃 버튼 
    if st.button("로그아웃"):
        st.session_state.logged_in = False
        st.rerun()

    # 모델 로드 및 학습
    reader = Reader(line_format='user item rating timestamp', sep=',', rating_scale=(0.5, 5))
    data_folds = DatasetAutoFolds(ratings_file = 'data/ml-latest-small/ratings_noh.csv', reader=reader)
    trainset = data_folds.build_full_trainset()
    algo = SVD(n_epochs=20, n_factors=50, random_state=0)
    algo.fit(trainset)

    # 데이터 로드
    ratings = pd.read_csv('data/ml-latest-small/ratings.csv')
    movies = pd.read_csv('data/ml-latest-small/movies.csv')

    def get_seen_movies(ratings, movies, userId):
        seen = ratings[ratings['userId'] == userId][['movieId', 'rating']]
        seen = seen.merge(movies[['movieId', 'title']], on='movieId', how='left')
        seen = seen.rename(columns={'title': '영화제목', 'rating': '내 평점'})
        seen['사용자'] = f'사용자 {userId}'
        return seen[['사용자', '영화제목', '내 평점']]

    def get_unseen_movies(ratings, movies, userId):
        seen_movies = ratings[ratings['userId'] == userId]['movieId'].tolist()
        total_movies = movies['movieId'].tolist()
        unseen_movies = [movie for movie in total_movies if movie not in seen_movies]
        return unseen_movies

    userId = int(st.session_state.user_id)
    tab1, tab2 = st.tabs(['본 영화', '추천 영화(예측 평점)'])

    with tab1:
        seen_df = get_seen_movies(ratings, movies, userId)
        st.subheader(f'사용자 {userId}님이 본 영화 및 평점')
        if seen_df.empty:
            st.info('아직 평점을 남긴 영화가 없습니다.')
        else:
            st.dataframe(seen_df)

    with tab2:
        unseen_movies = get_unseen_movies(ratings, movies, userId)
        predictions = [algo.predict(str(userId), str(movieId)) for movieId in unseen_movies]
        pred_df = pd.DataFrame([{
            'movieId': int(pred.iid),
            '예측평점': round(pred.est, 2),
            '사용자': f'사용자 {userId}'
        } for pred in predictions])
        predictions_df = pred_df.merge(movies[['movieId', 'title']], on='movieId', how='left')
        predictions_df = predictions_df[['사용자', 'title', '예측평점']].rename(columns={'title': '영화제목'})
        predictions_df = predictions_df.sort_values(by='예측평점', ascending=False).reset_index(drop=True)
        st.subheader(f'사용자 {userId}님을 위한 추천 영화')
        st.dataframe(predictions_df.head(10))
