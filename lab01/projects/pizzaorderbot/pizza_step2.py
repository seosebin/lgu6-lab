
def main():
    menus = {
            '피자': ['페퍼로니 피자', '스테이크 피자', '시푸드 피자'],
            '토핑': ['햄', '페퍼로니', '트러플', '올리브', '새우'] 
    }
    prices = {
            '피자': [29000, 32000, 32000],
            '토핑': [500, 500, 800, 300, 800]
    }
    order = {'피자': [], '토핑': []}

    categories = ['피자', '토핑']
    i = 0
    current_category = categories[i]

    while True:
        print(f"\n{current_category}를 선택하세요. 수량 추가를 위해 여러번 선택 가능합니다.")

        for idx, item in enumerate(menus[current_category]):
            print(f"{idx+1}. {item} ({prices[current_category][idx]}원) ")
        
        choice = input("번호를 선택하고 Enter를 누르세요.(주문 완료는 f를 누르세요.) > ")

        if choice.isdigit():
            index = int(choice) - 1
            order[current_category].append( menus[current_category][index] )
            print(f"선택된 메뉴: {menus[current_category][index]}")
        elif choice == 'f':
            break
        else:
            print("잘못된 입력입니다. 다시 시도해주세요.")
        
        i += 1
        current_category = categories[i % 2]





main()
    