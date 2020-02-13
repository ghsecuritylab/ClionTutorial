#include "CppUTest/TestHarness.h"

/* ================= Important =================
 * Cソースコードのテストを行う場合には
 * includeをextern "C"{...} で囲むのを忘れない
 * ==============================================
 */
extern "C"
{
#include "Calc.h"
}

TEST_GROUP(calc) {
    // 各テストケース実行前処理
    TEST_SETUP() {
        printf("\nsetup\n");
    }

    // 各テストケース実行後処理
    TEST_TEARDOWN() {
        printf("\nteardown\n");
    }
};

TEST(calc, CheckAdd) {
    int ret = add(3, 4);
    CHECK_EQUAL(ret, 7);
}

TEST(calc, CheckSub) {
    int ret = sub(10, 4);
    CHECK_EQUAL(ret, 6);
}

TEST(calc, CheckMul) {
    int ret = mul(10, 4);
    CHECK_EQUAL(ret, 40);
}
