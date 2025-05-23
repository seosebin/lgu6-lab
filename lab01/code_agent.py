# pip install smallagents
# 이 코드는 cmd에서 huggingface-cli login
# 를 통해 access token을 입력하고 실행해야 함
# 로그 아웃을 위해선 huggingface-cli logout
# 한번 로그인 하면 다음 위치에 토큰이 저장되고 그 다음 부턴 자동 로그인
# C:\Users\metam\.cache\huggingface\stored_tokens

from smolagents import CodeAgent, DuckDuckGoSearchTool, HfApiModel, tool

@tool
def music_recommand_tool(mood: str) -> list[str]:
    """
    이 툴은 사용자가 파티 분위기(genre)를 입력하면 그 무드에 맞는 음악을 추천합니다.

    Args:
        mood: 사용자의 지금 분위기, `happy`, `sad`, `energetic` 가능함
    """
    mood_music_dict_kpop = {
        "happy": [
            "Dynamite - 방탄소년단", "Feel My Rhythm - 레드벨벳", "Butter - 방탄소년단",
            "Love Dive - 아이브", "꿍꿍이 (BBIBBI) - 아이유"
        ],
        "sad": [
            "밤편지 - 아이유", "TimeToLove(Feat.PaulKim) - 멜로망스", "술이 문제야 - 바이브",
            "Lonely - 2NE1", "한숨 - 이하이"
        ],
        "energetic": [
            "Next Level - 에스파", "깡 - 비", "God's Menu - 스트레이 키즈", "FANCY - 트와이스",
            "불타오르네 (FIRE) - 방탄소년단"
        ],
    }

    return mood_music_dict_kpop.get(
        mood,
        [
            "Celebrity - 아이유", "사건의 지평선 - 윤하", "Ditto - NewJeans", "봄날 - 방탄소년단",
            "어떻게 이별까지 사랑하겠어, 널 사랑하는 거지 - AKMU (악동뮤지션)"
        ]
    )

# type hint가 없으면 에러가 남
# smolagents._function_type_hints_utils.TypeHintParsingException: Argument a is missing a type hint in function my_mul
@tool
def my_mul(a: float, b: float) -> float:
    """
    이 툴은 나만의 독특한 곱하기, 두수의 곱에 두배를 반환합니다.

    Args:
        a: 곱할 수로 float 입니다.
        b: 곱할 수로 float 입니다.
    """
    return a * b * 2

print(music_recommand_tool.description)
print(music_recommand_tool.inputs)

# Qwen/Qwen2.5-Coder-32B-Instruct [default]
# meta-llama/Llama-3.3-70B-Instruct
# deepseek-ai/DeepSeek-R1-Distill-Qwen-32B
model_id = "Qwen/Qwen2.5-Coder-32B-Instruct" 

agent = CodeAgent(
    tools=[
        DuckDuckGoSearchTool(),
        music_recommand_tool,
        my_mul
    ], 
    model=HfApiModel(model_id)
)

response = agent.run("2 곱하기 10이 얼마지? 이 문제를 못풀어서 지금 우울해! 정답과 기분 전환용 음악 좀 추천해줘")
print(type(response), response)


