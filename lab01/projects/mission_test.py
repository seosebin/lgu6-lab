def mission1_test(f, x = (-0.5, 0.6, 1.2, 3.4, 1.0)):
    ret = f(x)
    
    if round(sum(ret), 3) == 3.49:
        print("Mission 1: PASS")
        return True
    else:
        print("Mission 1: FAIL")
        return False
    
def mission2_test(x, y):
        # x는 50행, 4열
        check_x1 = False
        if len(x) == 50:
            check_x1 = True
        
        check_x2 = True
        for sample in x:
            if len(sample) == 4:
                # 숫자 네개가 모두 float이어야지 통과
                if isinstance(sample[0], float) and isinstance(sample[1], float) and isinstance(sample[2], float) and isinstance(sample[3], float):
                    pass
                else:
                     check_x2 = False
            else:
                check_x2 = False
        
        # y는 길이 50
        check_y = False
        if len(y) == 50:
            check_y = True

        if check_x1 and check_x2 and check_y:
            print("Mission 2: PASS")
            return True
        else:
            print("Mission 2: FAIL")
            return False
        
def mission3_test(incorrect):
        if incorrect <= 3:
            print('Mission 3: PASS')
        else:
            print('Mission 3: FAIL')